"""Robot Framework keywords for intercepting browser-side DSC decryptions.

The library uses a BrowserLibrary JS extension (intercept_crypt_extension.js)
to install persistent hooks into the page's main execution context. The hooks
intercept XHR/fetch requests and crypto.subtle.decrypt calls, enabling live
capture and decryption of encrypted API payloads during test execution.

The hook must be installed before the UI action that triggers the encrypted
API response. All keyword calls share the same persistent page state.

Designed to be copied into the real TA repository. Requires an active
Robot Framework BrowserLibrary page.
"""

from __future__ import annotations

import base64
import fnmatch
import json
import re
import time
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


HOOK_SCRIPT = r"""
(element, options) => {
  const config = options || {};
  const matcher = config.matcher || '';
  const maxTextChars = config.maxTextChars || 250000;

  const state = window.__interceptCrypt || {
    installed: false,
    installedAt: new Date().toISOString(),
    matcher,
    maxTextChars,
    fetchEvents: [],
    xhrEvents: [],
    decryptEvents: [],
    errors: [],
    diagnostics: [],
    originals: {},
  };

  state.matcher = matcher;
  state.maxTextChars = maxTextChars;
  window.__interceptCrypt = state;

  const now = () => new Date().toISOString();
  const pushDiagnostic = (message, details) => {
    state.diagnostics.push({ ts: now(), message, details: details || null });
  };
  const truncate = (value) => {
    if (typeof value !== 'string') {
      return value;
    }
    if (value.length <= state.maxTextChars) {
      return value;
    }
    return value.slice(0, state.maxTextChars) + '...[truncated ' + (value.length - state.maxTextChars) + ' chars]';
  };
  const globToRegExp = (pattern) => {
    let expression = '^';
    for (let index = 0; index < pattern.length; index += 1) {
      const character = pattern[index];
      const next = pattern[index + 1];
      if (character === '*' && next === '*') {
        expression += '.*';
        index += 1;
      } else if (character === '*') {
        expression += '[^/]*';
      } else if (character === '?') {
        expression += '[^/]';
      } else if ('\\^$+?.()|{}[]'.includes(character)) {
        expression += '\\' + character;
      } else {
        expression += character;
      }
    }
    return new RegExp(expression + '$');
  };
  const parseSlashRegExp = (pattern) => {
    const match = /^\/(.*)\/([a-z]*)$/i.exec(pattern);
    return match ? new RegExp(match[1], match[2]) : null;
  };
  const matchesUrl = (url) => {
    if (!state.matcher) {
      return true;
    }
    const urlText = String(url);
    const regex = parseSlashRegExp(state.matcher);
    if (regex) {
      return regex.test(urlText);
    }
    if (state.matcher.includes('*') || state.matcher.includes('?')) {
      return globToRegExp(state.matcher).test(urlText);
    }
    return urlText.includes(state.matcher);
  };
  const arrayBufferToBase64 = (buffer) => {
    const bytes = new Uint8Array(buffer);
    let binary = '';
    for (const byte of bytes) {
      binary += String.fromCharCode(byte);
    }
    return btoa(binary);
  };
  const arrayBufferToUtf8 = (buffer) => {
    try {
      return new TextDecoder('utf-8', { fatal: false }).decode(buffer);
    } catch (error) {
      state.errors.push({ ts: now(), source: 'utf8-decode', message: String(error) });
      return '';
    }
  };
  const normalizedBuffer = (value) => {
    if (value instanceof ArrayBuffer) {
      return value;
    }
    if (ArrayBuffer.isView(value)) {
      return value.buffer.slice(value.byteOffset, value.byteOffset + value.byteLength);
    }
    return new ArrayBuffer(0);
  };
  const recordNetworkEvent = (target, payload) => {
    target.push({
      ts: now(),
      method: payload.method || 'GET',
      url: payload.url || '',
      status: payload.status,
      contentType: payload.contentType || null,
      bodyText: truncate(payload.bodyText || ''),
      source: payload.source || 'unknown',
    });
  };

  if (!state.installed) {
    state.installed = true;
    pushDiagnostic('install-start', {
      locationHref: window.location.href,
      hasCrypto: Boolean(window.crypto),
      hasSubtle: Boolean(window.crypto && window.crypto.subtle),
    });

    state.originals.fetch = window.fetch.bind(window);
    window.fetch = async (input, init) => {
      const response = await state.originals.fetch(input, init);
      const requestUrl = input instanceof Request ? input.url : String(input);
      const method = input instanceof Request ? input.method : (init && init.method) || 'GET';

      if (matchesUrl(requestUrl)) {
        response.clone().text().then((bodyText) => {
          recordNetworkEvent(state.fetchEvents, {
            method,
            url: requestUrl,
            status: response.status,
            contentType: response.headers.get('content-type'),
            bodyText,
            source: 'fetch',
          });
        }).catch((error) => {
          state.errors.push({ ts: now(), source: 'fetch-clone-text', url: requestUrl, message: String(error) });
        });
      }

      return response;
    };

    state.originals.xhrOpen = window.XMLHttpRequest && window.XMLHttpRequest.prototype.open;
    state.originals.xhrSend = window.XMLHttpRequest && window.XMLHttpRequest.prototype.send;
    if (state.originals.xhrOpen && state.originals.xhrSend) {
      window.XMLHttpRequest.prototype.open = function(method, url) {
        this.__interceptCrypt = {
          method: method || 'GET',
          url: String(url || ''),
        };
        return state.originals.xhrOpen.apply(this, arguments);
      };

      window.XMLHttpRequest.prototype.send = function() {
        const requestInfo = this.__interceptCrypt || { method: 'GET', url: '' };
        const onLoadEnd = () => {
          try {
            if (!matchesUrl(requestInfo.url)) {
              return;
            }
            const contentType = this.getResponseHeader && this.getResponseHeader('content-type');
            const responseText = typeof this.responseText === 'string' ? this.responseText : '';
            recordNetworkEvent(state.xhrEvents, {
              method: requestInfo.method,
              url: requestInfo.url,
              status: this.status,
              contentType,
              bodyText: responseText,
              source: 'xhr',
            });
          } catch (error) {
            state.errors.push({ ts: now(), source: 'xhr-loadend', url: requestInfo.url, message: String(error) });
          }
        };
        this.addEventListener('loadend', onLoadEnd, { once: true });
        return state.originals.xhrSend.apply(this, arguments);
      };
      pushDiagnostic('install-xhr-hooked', {
        hasOpen: true,
        hasSend: true,
      });
    } else {
      pushDiagnostic('install-xhr-missing', {
        hasOpen: Boolean(state.originals.xhrOpen),
        hasSend: Boolean(state.originals.xhrSend),
      });
    }

    const subtle = window.crypto && window.crypto.subtle;
    if (subtle && subtle.decrypt) {
      const subtlePrototype = Object.getPrototypeOf(subtle);
      const originalDecrypt = subtle.decrypt.bind(subtle);
      state.originals.decrypt = originalDecrypt;
      const wrappedDecrypt = async (algorithm, key, data) => {
        const result = await originalDecrypt(algorithm, key, data);
        const plaintext = normalizedBuffer(result);
        state.decryptEvents.push({
          ts: now(),
          algorithm: typeof algorithm === 'string' ? algorithm : algorithm.name,
          keyType: key.type,
          keyAlgorithm: key.algorithm && key.algorithm.name,
          cipherBytes: data && data.byteLength,
          plaintextBytes: plaintext.byteLength,
          plaintextBase64: arrayBufferToBase64(plaintext),
          plaintextUtf8: truncate(arrayBufferToUtf8(plaintext)),
        });
        return result;
      };
      subtle.decrypt = wrappedDecrypt;
      if (subtlePrototype && subtlePrototype.decrypt !== wrappedDecrypt) {
        try {
          subtlePrototype.decrypt = wrappedDecrypt;
        } catch (error) {
          state.errors.push({ ts: now(), source: 'install-prototype-decrypt', message: String(error) });
        }
      }
      pushDiagnostic('install-decrypt-hooked', {
        hasPrototype: Boolean(subtlePrototype),
        decryptType: typeof subtle.decrypt,
      });
    } else {
      state.errors.push({ ts: now(), source: 'install', message: 'window.crypto.subtle.decrypt is not available' });
    }
  }

  return {
    installed: state.installed,
    installedAt: state.installedAt,
    matcher: state.matcher,
    fetchEvents: state.fetchEvents.length,
    xhrEvents: state.xhrEvents.length,
    decryptEvents: state.decryptEvents.length,
    errors: state.errors,
    diagnostics: state.diagnostics,
  };
}
"""


STATE_SCRIPT = r"""
(element) => {
  const state = window.__interceptCrypt || {};
  return {
    installed: Boolean(state.installed),
    installedAt: state.installedAt || null,
    matcher: state.matcher || '',
    fetchEvents: state.fetchEvents || [],
    xhrEvents: state.xhrEvents || [],
    decryptEvents: state.decryptEvents || [],
    errors: state.errors || [],
    diagnostics: state.diagnostics || [],
  };
}
"""


CLEAR_SCRIPT = r"""
(element) => {
  const state = window.__interceptCrypt;
  if (!state) {
    return false;
  }
  state.fetchEvents = [];
  state.xhrEvents = [];
  state.decryptEvents = [];
  state.errors = [];
  return true;
}
"""


@dataclass(frozen=True)
class WaitConfig:
    matcher: str
    timeout_seconds: float
    expected_text: str | None


@library(scope="TEST")
class InterceptCryptLibrary:
    """Robot keywords for collecting decrypted DSC API payloads from the browser."""

    def __init__(self, script_selector: str = "body", max_text_chars: int = 250000) -> None:
      self.script_selector = script_selector
      self.max_text_chars = int(max_text_chars)
      self._js_extension_path = Path(__file__).with_name("intercept_crypt_extension.js")
      self._js_extension_loaded = False

    @keyword("Start Crypt Intercept")
    def start_crypt_intercept(self, matcher: str = "") -> dict[str, Any]:
        """Install the browser-side decrypt hook on the active BrowserLibrary page.

        Call this before clicking the UI control that triggers the encrypted API
      request. ``matcher`` is matched against fetch URLs.
        """
        return self._call_js_keyword(
          "startInterceptCrypt",
          options={
            "matcher": matcher,
            "maxTextChars": self.max_text_chars,
          },
        )

    @keyword("Clear Crypt Events")
    def clear_crypt_events(self) -> bool:
        """Clear collected fetch/decrypt events while keeping the hook installed."""
        return bool(self._call_js_keyword("clearCryptEvents"))

    @keyword("Get Crypt Events")
    def get_crypt_events(self) -> dict[str, Any]:
        """Return the current raw InterceptCrypt state from the browser."""
        return self._call_js_keyword("getCryptEvents")

    @keyword("Wait For Crypt Response")
    def wait_for_crypt_response(
        self,
        matcher: str = "",
        timeout: str = "30s",
        expected_text: str | None = None,
    ) -> dict[str, Any]:
        """Wait for a matching encrypted API response and decrypted plaintext.

        ``matcher`` follows the common BrowserLibrary shape for URL matching:
        empty string matches all, plain text matches as substring, glob patterns
        like ``**/api/data`` are supported, and slash regular expressions like
        ``/register-data/load-data/i`` are supported. If ``expected_text`` is
        provided, only plaintexts containing that value are considered a match.
        """
        config = WaitConfig(
            matcher=matcher,
            timeout_seconds=self._parse_timeout(timeout),
            expected_text=expected_text,
        )
        deadline = time.monotonic() + config.timeout_seconds
        last_state: dict[str, Any] = {}

        while time.monotonic() <= deadline:
            last_state = self._normalize_state(self.get_crypt_events())
            response = self._build_response(config, last_state)
            if response is not None:
                return response
            time.sleep(0.25)

        observed_urls = [event.get("url") for event in last_state.get("fetchEvents", [])]
        observed_urls.extend(event.get("url") for event in last_state.get("xhrEvents", []))
        raise AssertionError(
            "No decrypted InterceptCrypt response matched "
            f"matcher={matcher!r}, expected_text={expected_text!r}. "
          f"Installed: {last_state.get('installed')!r} at {last_state.get('installedAt')!r}. "
          f"Observed URLs: {observed_urls!r}. Errors: {last_state.get('errors', [])!r}. "
          f"Diagnostics: {last_state.get('diagnostics', [])!r}"
        )

    def _build_response(self, config: WaitConfig, state: dict[str, Any]) -> dict[str, Any] | None:
        network_events = [
            event
          for event in (
            self._event_list(state.get("fetchEvents", []))
            + self._event_list(state.get("xhrEvents", []))
          )
            if self._matches_url(config.matcher, str(event.get("url", "")))
        ]
        decrypt_events = self._matching_decrypt_events(
            self._event_list(state.get("decryptEvents", [])),
            config.expected_text,
        )
        if not decrypt_events:
            return None

        selected_fetch = network_events[-1] if network_events else {}
        selected_decrypt = decrypt_events[-1]
        plaintext_xml = self._plaintext_from_event(selected_decrypt)
        return {
            "matcher": config.matcher,
            "url": selected_fetch.get("url"),
            "method": selected_fetch.get("method"),
            "status": selected_fetch.get("status"),
            "content_type": selected_fetch.get("contentType"),
            "encrypted_response_body": selected_fetch.get("bodyText"),
            "algorithm": selected_decrypt.get("algorithm"),
            "key_type": selected_decrypt.get("keyType"),
            "key_algorithm": selected_decrypt.get("keyAlgorithm"),
            "plaintext_xml": plaintext_xml,
            "plaintext_json": self._xml_to_json(plaintext_xml),
            "decrypt_events": [self._normalize_decrypt_event(event) for event in decrypt_events],
            "errors": state.get("errors", []),
            "diagnostics": state.get("diagnostics", []),
        }

    def _matching_decrypt_events(self, events: list[dict[str, Any]], expected_text: str | None) -> list[dict[str, Any]]:
        if expected_text is None:
            return list(events)
        return [event for event in events if expected_text in self._plaintext_from_event(event)]

    def _normalize_decrypt_event(self, event: dict[str, Any]) -> dict[str, Any]:
        plaintext_xml = self._plaintext_from_event(event)
        return {
            "ts": event.get("ts"),
            "algorithm": event.get("algorithm"),
            "key_type": event.get("keyType"),
            "key_algorithm": event.get("keyAlgorithm"),
            "cipher_bytes": event.get("cipherBytes"),
            "plaintext_bytes": event.get("plaintextBytes"),
            "plaintext_xml": plaintext_xml,
            "plaintext_json": self._xml_to_json(plaintext_xml),
        }

    def _normalize_state(self, state: Any) -> dict[str, Any]:
        if isinstance(state, dict):
            return state
        if isinstance(state, str):
            stripped = state.strip()
            if not stripped:
                return {}
            try:
                parsed = json.loads(stripped)
            except json.JSONDecodeError:
                return {}
            return parsed if isinstance(parsed, dict) else {}
        return {}

    def _event_list(self, events: Any) -> list[dict[str, Any]]:
        if isinstance(events, str):
            stripped = events.strip()
            if not stripped:
                return []
            try:
                events = json.loads(stripped)
            except json.JSONDecodeError:
                return []

        if isinstance(events, dict):
            candidates = list(events.values())
        elif isinstance(events, (list, tuple)):
            candidates = list(events)
        else:
            return []

        return [event for event in candidates if isinstance(event, dict)]

    def _plaintext_from_event(self, event: dict[str, Any]) -> str:
        plaintext = event.get("plaintextUtf8")
        if isinstance(plaintext, str) and plaintext:
            return plaintext

        encoded = event.get("plaintextBase64")
        if not isinstance(encoded, str) or not encoded:
            return ""
        return base64.b64decode(encoded).decode("utf-8", errors="replace")

    def _xml_to_json(self, xml_text: str) -> dict[str, Any] | None:
        stripped = xml_text.strip()
        if not stripped.startswith("<"):
            return None

        try:
            root = ET.fromstring(stripped)
        except ET.ParseError:
            return None

        return self._element_to_dict(root)

    def _element_to_dict(self, element: ET.Element) -> dict[str, Any]:
        children = list(element)
        node: dict[str, Any] = {
            "tag": self._local_name(element.tag),
        }

        if element.attrib:
            node["attributes"] = {self._local_name(key): value for key, value in element.attrib.items()}

        text = (element.text or "").strip()
        if text:
            node["text"] = text

        if children:
            grouped: dict[str, Any] = {}
            for child in children:
                child_node = self._element_to_dict(child)
                child_tag = child_node["tag"]
                if child_tag in grouped:
                    if not isinstance(grouped[child_tag], list):
                        grouped[child_tag] = [grouped[child_tag]]
                    grouped[child_tag].append(child_node)
                else:
                    grouped[child_tag] = child_node
            node["children"] = grouped

        return node

    def _matches_url(self, matcher: str, url: str) -> bool:
        if not matcher:
            return True

        regex = self._slash_regex(matcher)
        if regex is not None:
            return regex.search(url) is not None

        if "*" in matcher or "?" in matcher:
            return fnmatch.fnmatchcase(url, matcher)

        return matcher in url

    def _slash_regex(self, matcher: str) -> re.Pattern[str] | None:
        match = re.fullmatch(r"/(.*)/([a-zA-Z]*)", matcher)
        if match is None:
            return None

        flags = 0
        if "i" in match.group(2):
            flags |= re.IGNORECASE
        return re.compile(match.group(1), flags)

    def _local_name(self, value: str) -> str:
        if "}" in value:
            return value.rsplit("}", 1)[1]
        if ":" in value:
            return value.rsplit(":", 1)[1]
        return value

    def _call_js_keyword(self, keyword_name: str, **arguments: Any) -> Any:
        builtin = BuiltIn()
        browser = builtin.get_library_instance("Browser")
        if not self._js_extension_loaded:
            browser.init_js_extension(str(self._js_extension_path))
            self._js_extension_loaded = True
        return browser.call_js_keyword(keyword_name, **arguments)

    def _parse_timeout(self, value: str) -> float:
        normalized = str(value).strip().lower().replace(" ", "")
        if normalized.endswith("ms"):
            return float(normalized[:-2]) / 1000
        if normalized.endswith("s"):
            return float(normalized[:-1])
        if normalized.endswith("min"):
            return float(normalized[:-3]) * 60
        return float(normalized)
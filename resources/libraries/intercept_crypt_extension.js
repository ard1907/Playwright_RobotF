function buildInstallFunction() {
  return ({ matcher, maxTextChars }) => {
    const effectiveMatcher = matcher || '';
    const effectiveMaxTextChars = Number.isFinite(maxTextChars) ? maxTextChars : 250000;
    const state = window.__interceptCrypt || {
      installed: false,
      installedAt: new Date().toISOString(),
      matcher: effectiveMatcher,
      maxTextChars: effectiveMaxTextChars,
      fetchEvents: [],
      xhrEvents: [],
      decryptEvents: [],
      errors: [],
      diagnostics: [],
      originals: {},
    };

    state.matcher = effectiveMatcher;
    state.maxTextChars = effectiveMaxTextChars;
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
      return `${value.slice(0, state.maxTextChars)}...[truncated ${value.length - state.maxTextChars} chars]`;
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
          expression += `\\${character}`;
        } else {
          expression += character;
        }
      }
      return new RegExp(`${expression}$`);
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
  };
}

async function startInterceptCrypt(options, page) {
  return page.evaluate(buildInstallFunction(), options || {});
}

async function clearCryptEvents(page) {
  return page.evaluate(() => {
    const state = window.__interceptCrypt;
    if (!state) {
      return false;
    }
    state.fetchEvents = [];
    state.xhrEvents = [];
    state.decryptEvents = [];
    state.errors = [];
    return true;
  });
}

async function getCryptEvents(page) {
  return page.evaluate(() => {
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
  });
}

exports.__esModule = true;
exports.startInterceptCrypt = startInterceptCrypt;
exports.clearCryptEvents = clearCryptEvents;
exports.getCryptEvents = getCryptEvents;
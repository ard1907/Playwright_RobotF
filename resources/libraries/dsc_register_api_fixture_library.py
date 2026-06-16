"""
dsc_register_api_fixture_library.py
=====================================
Robot Framework library for loading, writing, and querying register card
API response JSON fixture files.

Supports a First-Run + Verification pattern for API-response-based register card
testing (parallel to the YAML-based pattern in dsc_register_fixture_library.py):

  • First-run-api mode  : captures the live 'Persönliche Daten anfragen' API
                          response body and writes it to a JSON fixture file
                          (test_data/registers/<tag>.json).

  • Verification mode  : loads the stored JSON fixture and compares the current
                         live API response against the reference body, skipping
                         keys that are known to be volatile across sessions.

Keyword mapping (underscore → space):
  api_fixture_exists              → Api Fixture Exists
  load_api_response_fixture       → Load Api Response Fixture
  is_api_fixture_completed        → Is Api Fixture Completed
  get_api_fixture_register_name   → Get Api Fixture Register Name
  get_api_fixture_register_tag    → Get Api Fixture Register Tag
  get_api_response_body           → Get Api Response Body
  get_api_response_status         → Get Api Response Status
  get_comparison_skip_keys        → Get Comparison Skip Keys
    is_decrypted_api_fixture        → Is Decrypted Api Fixture
  parse_api_response_body_bytes   → Parse Api Response Body Bytes
  build_api_first_run_fixture     → Build Api First Run Fixture
    build_decrypted_api_first_run_fixture → Build Decrypted Api First Run Fixture
    build_decrypted_api_raw_fixture → Build Decrypted Api Raw Fixture
  write_api_fixture               → Write Api Fixture
  compare_api_response_bodies     → Compare Api Response Bodies
"""

import ast
import json
import pathlib
import xml.etree.ElementTree as ET
from datetime import datetime


class dsc_register_api_fixture_library:
    """Robot Framework library for register card API response JSON fixture management."""

    ROBOT_LIBRARY_SCOPE = "SUITE"

    # Keys that are typically volatile across sessions and should be ignored
    # during body comparison (session tokens, timestamps, request IDs, etc.)
    _VOLATILE_KEYS = frozenset({
        "token",
        "access_token",
        "accesstoken",
        "accessToken",
        "registeraccessjwt",
        "register_access_jwt",
        "registerAccessJWT",
        "sessionid",
        "session_id",
        "sessionId",
        "requestid",
        "request_id",
        "requestId",
        "timestamp",
        "created_at",
        "createdat",
        "createdAt",
        "updated_at",
        "updatedat",
        "updatedAt",
        "expiry",
        "expires",
        "expiresat",
        "expiresAt",
        "nonce",
        "iat",
        "exp",
        "jti",
        "sub",
        "nbf",
        "correlationid",
        "correlation_id",
        "correlationId",
        "traceid",
        "trace_id",
        "traceId",
    })

    _VOLATILE_FIELD_LABELS = frozenset({
        "nachrichtenuuid",
        "erstellungszeitpunkt",
    })

    # ── Existence and Loading ──────────────────────────────────────────────────

    def api_fixture_exists(self, fixture_path: str) -> bool:
        """Return True if the API response fixture JSON file exists, False otherwise."""
        return pathlib.Path(fixture_path).exists()

    def load_api_response_fixture(self, fixture_path: str) -> dict:
        """
        Load a register card API response fixture JSON file and return its content.

        Raises FileNotFoundError if the file does not exist; the error message
        includes the first-run command to generate the fixture.
        """
        path = pathlib.Path(fixture_path)
        if not path.exists():
            raise FileNotFoundError(
                f"API response fixture not found: {fixture_path}\n"
                "Run the first-run-api test to generate it:\n"
                "  robotcode --profile default --profile first-run-api robot "
                '--by-longname "Ui.Ts 05B Register Cards Generic"'
            )
        with open(path, encoding="utf-8") as fh:
            return json.load(fh)

    # ── Accessors ──────────────────────────────────────────────────────────────

    def is_api_fixture_completed(self, fixture: dict) -> bool:
        """Return True if the fixture was successfully populated by a first-run-api."""
        return bool(fixture.get("first_run", {}).get("completed", False))

    def get_api_fixture_register_name(self, fixture: dict) -> str:
        """Return the register card name (h3 heading text) from the API fixture."""
        return fixture.get("register", {}).get("name", "")

    def get_api_fixture_register_tag(self, fixture: dict) -> str:
        """Return the short tag string (e.g. 'bva') from the API fixture."""
        return fixture.get("register", {}).get("tag", "")

    def get_api_response_body(self, fixture: dict) -> dict:
        """Return the stored comparison body from the fixture."""
        api_response = fixture.get("api_response", {})
        return api_response.get("comparison_body", api_response.get("body", {}))

    def get_api_response_status(self, fixture: dict) -> int:
        """Return the stored HTTP response status code from the fixture."""
        return int(fixture.get("api_response", {}).get("status", 0))

    def get_comparison_skip_keys(self, fixture: dict) -> list:
        """
        Return the list of extra skip keys from the fixture's comparison section.

        Returns an empty list when not configured so callers always receive a list.
        """
        return fixture.get("comparison", {}).get("skip_keys", [])

    def is_decrypted_api_fixture(self, fixture: dict) -> bool:
        """Return True when the fixture uses the decrypted XML payload format."""
        return fixture.get("api_response", {}).get("format") == "decrypted_xml"

    # ── Parsing ────────────────────────────────────────────────────────────────

    def parse_api_response_body_bytes(self, body_bytes) -> dict:
        """
        Parse a Browser Library response body (bytes or string) as JSON.

        If parsing fails the raw string is stored under the key '_raw' in the
        returned dict; callers can check for this key to detect parse failures.
        Never raises an exception.
        """
        if body_bytes is None:
            return {}
        if isinstance(body_bytes, (bytes, bytearray)):
            body_str = body_bytes.decode("utf-8", errors="replace")
        else:
            body_str = str(body_bytes)
        # Strip BOM if present
        body_str = body_str.lstrip("\ufeff").strip()
        try:
            return json.loads(body_str)
        except (json.JSONDecodeError, ValueError):
            pass

        # Browser/Playwright response payloads may occasionally surface as a
        # Python-style literal string with single quotes instead of strict JSON.
        if body_str.startswith(("{", "[", "(", "'")):
            try:
                return ast.literal_eval(body_str)
            except (ValueError, SyntaxError):
                pass

        return {"_raw": body_str}

    # ── Building and Writing (First-Run) ───────────────────────────────────────

    def build_api_first_run_fixture(
        self,
        register_name: str,
        register_tag: str,
        response_status,
        response_url: str,
        body_bytes,
        existing_fixture: dict = None,
    ) -> dict:
        """
        Build a complete API fixture dict from a captured live API response.

                Arguments:
                    register_name    – exact h3 text of the register card
                    register_tag     – short identifier (e.g. 'bva')
                    response_status  – HTTP status code (int or string)
                    response_url     – URL of the API endpoint that returned the data
                    body_bytes       – raw response body (bytes or string from Browser Library)
                    existing_fixture – if provided, the 'comparison' section
                                       is preserved
        """
        body = self.parse_api_response_body_bytes(body_bytes)
        comparison_body = self._normalize_for_comparison(body)

        # Preserve comparison config from an existing fixture when available
        default_comparison = {
            "skip_keys": [],
            "strict": False,
        }
        comparison = (
            existing_fixture.get("comparison", default_comparison)
            if existing_fixture
            else default_comparison
        )

        return {
            "register": {
                "name": str(register_name),
                "tag": str(register_tag),
            },
            "first_run": {
                "completed": True,
                "captured_at": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                "phase": "personal_data_request",
            },
            "api_response": {
                "status": int(response_status),
                "url": str(response_url),
                "body": body,
                "comparison_body": comparison_body,
            },
            "comparison": comparison,
        }

    def build_decrypted_api_first_run_fixture(
        self,
        register_name: str,
        register_tag: str,
        response_status,
        response_url: str,
        plaintext_json,
        raw_fixture_path: str,
        existing_fixture: dict = None,
    ) -> dict:
        """Build the primary fixture from the decrypted register payload."""
        comparison_body = self._normalize_for_comparison(plaintext_json)

        default_comparison = {
            "skip_keys": [],
            "strict": False,
        }
        comparison = (
            existing_fixture.get("comparison", default_comparison)
            if existing_fixture
            else default_comparison
        )

        return {
            "register": {
                "name": str(register_name),
                "tag": str(register_tag),
            },
            "first_run": {
                "completed": True,
                "captured_at": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                "phase": "personal_data_request",
            },
            "api_response": {
                "format": "decrypted_xml",
                "status": int(response_status),
                "url": str(response_url),
                "body": plaintext_json,
                "comparison_body": comparison_body,
                "raw_fixture_path": str(raw_fixture_path),
            },
            "comparison": comparison,
        }

    def build_decrypted_api_raw_fixture(
        self,
        register_name: str,
        register_tag: str,
        response_status,
        response_url: str,
        encrypted_response_body,
        plaintext_xml: str,
        plaintext_json,
        algorithm: str = "",
        key_type: str = "",
        key_algorithm: str = "",
        decrypt_events=None,
        errors=None,
    ) -> dict:
        """Build the companion raw fixture with the decrypted XML kept verbatim."""
        return {
            "register": {
                "name": str(register_name),
                "tag": str(register_tag),
            },
            "first_run": {
                "completed": True,
                "captured_at": datetime.now().strftime("%Y-%m-%dT%H:%M:%S"),
                "phase": "personal_data_request",
            },
            "api_response": {
                "format": "decrypted_xml_raw",
                "status": int(response_status),
                "url": str(response_url),
                "algorithm": str(algorithm or ""),
                "key_type": str(key_type or ""),
                "key_algorithm": str(key_algorithm or ""),
                "encrypted_response_body": encrypted_response_body,
                "plaintext_xml": str(plaintext_xml or ""),
                "plaintext_json": plaintext_json,
                "decrypt_events": list(decrypt_events or []),
                "errors": list(errors or []),
            },
        }

    def write_api_fixture(self, fixture_path: str, fixture_data: dict) -> None:
        """
        Write a register API fixture dict to the given JSON file.

        Creates parent directories if they do not exist.
        Unicode characters (German umlauts, etc.) are written as-is.
        """
        path = pathlib.Path(fixture_path)
        path.parent.mkdir(parents=True, exist_ok=True)
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(fixture_data, fh, ensure_ascii=False, indent=2)

    # ── Comparison ─────────────────────────────────────────────────────────────

    def compare_api_response_bodies(
        self,
        reference_body,
        current_body,
        extra_skip_keys=None,
    ) -> list:
        """
        Compare two API response body dicts and return a list of difference strings.

        Skips keys known to be volatile (session tokens, timestamps, etc.) and any
        additional keys provided in extra_skip_keys.  Returns an empty list when
        the bodies are considered equivalent.

        Arguments:
          reference_body  – the stored (expected) body from the JSON fixture
          current_body    – the current live API response body
          extra_skip_keys – additional key names to skip during comparison
                            (list, set, or None)
        """
        skip = set(self._VOLATILE_KEYS)
        if extra_skip_keys:
            for k in extra_skip_keys:
                k_str = str(k)
                skip.add(k_str)
                skip.add(k_str.lower())

        normalized_reference = self._normalize_for_comparison(reference_body)
        normalized_current = self._normalize_for_comparison(current_body)

        differences: list = []
        self._compare_recursive(
            normalized_reference,
            normalized_current,
            [],
            differences,
            skip,
        )
        return differences

    # ── Internal Helpers ───────────────────────────────────────────────────────

    def _is_volatile_key(self, key: str, skip_set: set) -> bool:
        key_str = str(key)
        return key_str in skip_set or key_str.lower() in skip_set

    def _normalize_for_comparison(self, value):
        """Return a stable comparison structure for API responses.

        `register-inhalts-data` currently returns encrypted XML inside the JSON
        response body. The ciphertext changes between runs, so the raw payload
        cannot be compared directly. This method preserves the raw response in
        the fixture while deriving a stable comparison view from the response
        envelope and XML metadata only.
        """
        if isinstance(value, dict):
            volatile_field = self._normalize_volatile_labeled_field(value)
            if volatile_field is not None:
                return volatile_field
            return {k: self._normalize_for_comparison(v) for k, v in value.items()}
        if isinstance(value, list):
            return [self._normalize_for_comparison(item) for item in value]
        if isinstance(value, str):
            stripped = value.strip()
            if stripped.startswith("<") and (
                "EncryptedData" in stripped
                or "CipherValue" in stripped
                or "EncryptionMethod" in stripped
            ):
                xml_summary = self._summarize_encrypted_xml(stripped)
                if xml_summary:
                    return xml_summary
        return value

    def _normalize_volatile_labeled_field(self, value: dict):
        children = value.get("children")
        if not isinstance(children, dict):
            return None

        description = self._extract_nested_label_text(children.get("inhaltsdatenBeschreibung"))
        label_key = self._normalize_label_key(description)
        if label_key not in self._VOLATILE_FIELD_LABELS:
            return None

        normalized = {k: self._normalize_for_comparison(v) for k, v in value.items()}
        normalized_children = normalized.get("children")
        if not isinstance(normalized_children, dict):
            return normalized

        content_node = normalized_children.get("inhalt")
        if isinstance(content_node, dict) and "text" in content_node:
            updated_content = dict(content_node)
            updated_content["text"] = f"<volatile:{label_key}>"
            normalized_children = dict(normalized_children)
            normalized_children["inhalt"] = updated_content
            normalized["children"] = normalized_children

        return normalized

    def _extract_nested_label_text(self, value):
        if not isinstance(value, dict):
            return ""

        children = value.get("children")
        if not isinstance(children, dict):
            return ""

        label = children.get("label")
        if not isinstance(label, dict):
            return ""

        text = label.get("text")
        return text if isinstance(text, str) else ""

    def _normalize_label_key(self, value: str) -> str:
        return "".join(character.lower() for character in str(value) if character.isalnum())

    def _summarize_encrypted_xml(self, xml_text: str):
        """Summarize encrypted XML into stable metadata for comparison."""
        try:
            root = ET.fromstring(xml_text)
        except ET.ParseError:
            return {"_kind": "xml_parse_failed"}

        encrypted_data = root.find(".//{http://www.w3.org/2001/04/xmlenc#}EncryptedData")
        method_node = root.find(".//{http://www.w3.org/2001/04/xmlenc#}EncryptionMethod")
        encryption_method = method_node.attrib.get("Algorithm", "") if method_node is not None else ""
        encrypted_key_count = len(root.findall(".//{http://www.w3.org/2001/04/xmlenc#}EncryptedKey"))
        cipher_value_node = root.find(".//{http://www.w3.org/2001/04/xmlenc#}CipherValue")
        cipher_value = None
        if cipher_value_node is not None and cipher_value_node.text:
            cipher_value = cipher_value_node.text.strip()

        return {
            "_kind": "encrypted_xml_envelope",
            "root_tag": self._strip_namespace(root.tag),
            "version": root.attrib.get("version", ""),
            "message_type": root.attrib.get("nachrichtentyp", ""),
            "has_encrypted_data": encrypted_data is not None,
            "encryption_algorithm": encryption_method or "",
            "encrypted_key_count": encrypted_key_count,
            "cipher_value_present": bool(cipher_value),
            "cipher_value_length": len(cipher_value or ""),
        }

    def _strip_namespace(self, tag: str) -> str:
        if "}" in tag:
            return tag.split("}", 1)[1]
        return tag

    def _compare_recursive(
        self,
        ref,
        cur,
        path: list,
        diffs: list,
        skip_set: set,
        max_diffs: int = 30,
    ) -> None:
        if len(diffs) >= max_diffs:
            return

        if isinstance(ref, dict) and isinstance(cur, dict):
            for k, v in ref.items():
                if self._is_volatile_key(str(k), skip_set):
                    continue
                cur_path = path + [str(k)]
                if k not in cur:
                    diffs.append(
                        f"Missing key '{'.'.join(cur_path)}' in current response"
                    )
                else:
                    self._compare_recursive(
                        v, cur[k], cur_path, diffs, skip_set, max_diffs
                    )

        elif isinstance(ref, list) and isinstance(cur, list):
            if len(ref) != len(cur):
                path_str = ".".join(path) if path else "(root)"
                diffs.append(
                    f"List length differs at '{path_str}': "
                    f"expected {len(ref)}, got {len(cur)}"
                )
            else:
                for i, (r_item, c_item) in enumerate(zip(ref, cur)):
                    self._compare_recursive(
                        r_item, c_item, path + [str(i)], diffs, skip_set, max_diffs
                    )

        else:
            if ref != cur:
                path_str = ".".join(path) if path else "(root)"
                diffs.append(
                    f"Value differs at '{path_str}': expected '{ref}', got '{cur}'"
                )

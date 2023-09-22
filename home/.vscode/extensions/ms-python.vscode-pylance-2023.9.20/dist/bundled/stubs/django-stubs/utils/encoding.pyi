from typing import Any, overload

from django.utils.functional import Promise

class DjangoUnicodeDecodeError(UnicodeDecodeError):
    obj: bytes = ...
    def __init__(self, obj: bytes, *args: Any) -> None: ...

def smart_text(
    s: Any, encoding: str = ..., strings_only: bool = ..., errors: str = ...
) -> Any: ...
def is_protected_type(obj: Any) -> bool: ...
def force_text(
    s: Any, encoding: str = ..., strings_only: bool = ..., errors: str = ...
) -> Any: ...
def force_bytes(
    s: Any, encoding: str = ..., strings_only: bool = ..., errors: str = ...
) -> Any: ...

smart_str = smart_text
force_str = force_text

@overload
def iri_to_uri(iri: None) -> None: ...
@overload
def iri_to_uri(iri: str | Promise) -> str: ...
@overload
def uri_to_iri(iri: None) -> None: ...
@overload
def uri_to_iri(iri: str) -> str: ...
def escape_uri_path(path: str) -> str: ...
def repercent_broken_unicode(path: bytes) -> bytes: ...
@overload
def filepath_to_uri(path: None) -> None: ...
@overload
def filepath_to_uri(path: str) -> str: ...
def get_system_encoding() -> str: ...

DEFAULT_LOCALE_ENCODING: Any

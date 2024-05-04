from typing import Protocol, assert_never, runtime_checkable
import json as stdlib_json


type _Primitive = str | int | float | bool | None
type Json = _Primitive | tuple[Json, ...] | frozenset[tuple[_Primitive, Json]]


def stringify(json: Json) -> str:
    match json:
        case str() | bool() | int() | float() | None:
            return stdlib_json.dumps(json)
        case tuple(items):
            items = ",".join(map(stringify, items))
            return "[" + items + "]"
        case frozenset(entires):
            entires = ",".join(f"{stringify(k)}:{stringify(v)}" for k, v in entires)
            return "{" + entires + "}"
        case unreachable:
            assert_never(unreachable)


def validate(json: Json):
    match json:
        case str() | int() | float() | bool() | None:
            pass
        case tuple(items):
            all(map(validate, items))
        case frozenset(entries):
            keys = set(map(lambda e: e[0], entries))
            if len(keys) != len(entries):
                raise ValueError("Duplicate keys", entries)
            all(map(lambda e: validate(e[0]) and validate(e[1]), entries))
        case unreachable:
            assert_never(unreachable)


@runtime_checkable
class ToJson(Protocol):
    def to_json(self) -> Json: ...


type JsonLike = Json | ToJson | list[JsonLike] | tuple[JsonLike, ...] | dict[_Primitive, JsonLike]


def from_like(obj: JsonLike) -> Json:
    match obj:
        case str() | int() | float() | bool() | None | frozenset():
            return obj
        case list(items) | tuple(items):
            return tuple(from_like(item) for item in items)
        case dict(items):
            return frozenset((k, from_like(v)) for k, v in items.items())
        case ToJson():
            return obj.to_json()
        case unreachable:
            assert_never(unreachable)

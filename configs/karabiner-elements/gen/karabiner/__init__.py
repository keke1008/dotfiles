from typing import Iterable, Literal, TypedDict, Unpack, overload


from . import json
from .condition import Application, ConditionSet, ConditionSetLike, Variable
from .to_event import ToEvent, ToEventEntry, ToEventEntryLike
from .key import ModifiedKey
from .karabiner import ConditionalWrapper, Karabiner


def mod(*modifiers: str, optional: str | Iterable[str] | None = None):
    def wrapper(key_code: str):
        opt = None if optional is None else frozenset(optional)
        return ModifiedKey(key_code, frozenset(modifiers), opt)

    return wrapper


type _Wrapped[T] = T | ConditionalWrapper[T]


def _wrapped[T](value: _Wrapped[T], cond: ConditionSet) -> ConditionalWrapper[T]:
    if isinstance(value, ConditionalWrapper):
        return ConditionalWrapper(value.value, cond.merge(value.condition))
    return ConditionalWrapper(value, cond)


def when(*conditions: ConditionSetLike):
    cond = ConditionSet.from_likes(conditions)

    @overload
    def wrapper[T](c1: _Wrapped[T]) -> ConditionalWrapper[T]: ...

    @overload
    def wrapper[T](c1: _Wrapped[T], c2: _Wrapped[T], *cs: _Wrapped[T]) -> ConditionalWrapper[tuple[T, ...]]: ...

    def wrapper(c1, c2=None, *cs):
        if c2 is None:
            return _wrapped(c1, cond)
        return (_wrapped(c, cond) for c in (c1, c2, *cs))

    return wrapper


class _MouseKeyOption(TypedDict, total=False):
    x: int | float
    y: int | float
    vertical_wheel: int | float
    horizontal_wheel: int | float
    speed_multiplier: int | float


def mouse_key(**kwargs: Unpack[_MouseKeyOption]):
    options: json.JsonLike = dict(**kwargs)  # type: ignore
    return ToEventEntry(json.from_like({"mouse_key": options}))


def pointing_button(button: str):
    return ToEventEntry(json.from_like({"pointing_button": button}))


type StickyOperation = Literal["on", "off", "toggle"]


def sticky_modifier(**spec: StickyOperation):
    return [ToEventEntry(json.from_like({"sticky_modifier": {key: op}})) for key, op in spec.items()]


def to_if_alone(*entries: ToEventEntryLike):
    return ToEvent("to_if_alone", list(map(ToEventEntry.from_like, entries)))


def to_after_key_up(*entries: ToEventEntryLike):
    return ToEvent("to_after_key_up", list(map(ToEventEntry.from_like, entries)))


def var(name: str) -> Variable:
    return Variable(name)


def apps(*apps: str):
    return Application(frozenset(apps))

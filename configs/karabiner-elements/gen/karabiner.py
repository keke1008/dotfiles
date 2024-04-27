from collections import defaultdict
from dataclasses import dataclass
from typing import Iterable

type JsonPrimitive = bool | int | float | str
type Json = JsonPrimitive | dict[JsonPrimitive, Json] | list[Json] | None


@dataclass(frozen=True)
class ModifiedKey:
    key_code: str
    modifiers: frozenset[str]
    optional: frozenset[str] | None = None


def mod(*modifiers: str, optional: str | Iterable[str] | None = None):
    def wrapper(key_code: str):
        opt = frozenset(optional) if optional else None
        return ModifiedKey(key_code, frozenset(modifiers), opt)

    return wrapper


type FromLike = str | ModifiedKey | From


@dataclass(frozen=True)
class From:
    key_code: str
    mandatory_modifiers: frozenset[str]
    optional_modifiers: frozenset[str] | None

    @staticmethod
    def from_like(value: FromLike):
        if isinstance(value, str):
            value = ModifiedKey(value, frozenset())
        if isinstance(value, ModifiedKey):
            value = From(value.key_code, value.modifiers, value.optional)
        return value

    def to_json(self) -> Json:
        return {
            "key_code": self.key_code,
            "modifiers": {
                "mandatory": list(self.mandatory_modifiers),
                "optional": (
                    list(self.optional_modifiers)
                    if self.optional_modifiers
                    else ["any"]
                ),
            },
        }


type ToEntryLike = str | ModifiedKey | ToEntry


@dataclass
class ToEntry:
    entry: Json

    def to_json(self) -> Json:
        return self.entry

    @staticmethod
    def from_like(entry: ToEntryLike) -> "ToEntry":
        if isinstance(entry, str):
            return ToEntry({"key_code": entry})
        if isinstance(entry, ModifiedKey):
            return ToEntry(
                {"key_code": entry.key_code, "modifiers": list(entry.modifiers)}
            )
        return entry


def set_variable(name: str, value: bool | int | str):
    return ToEntry({"set_variable": {"name": name, "value": value}})


def mouse_key(**values: int | float):
    return ToEntry({"mouse_key": dict(**values)})


def pointing_button(button: str):
    return ToEntry({"pointing_button": button})


class To:
    name: str
    entries: list[ToEntry]

    def __init__(self, name: str, entries: Iterable[ToEntryLike]):
        self.name = name
        self.entries = [ToEntry.from_like(entry) for entry in entries]


def to_after_key_up(*entries: ToEntryLike):
    return To("to_after_key_up", entries)


def to_if_alone(*entries: ToEntryLike):
    return To("to_if_alone", entries)


@dataclass(frozen=True)
class Variable:
    name: str
    inversed: bool = False

    @staticmethod
    def ENABLED() -> bool:
        return True

    @staticmethod
    def DISABLED() -> bool:
        return False

    def __invert__(self):
        return Variable(self.name, not self.inversed)

    def to_json(self) -> Json:
        return {
            "name": self.name,
            "type": "variable_if",
            "value": self.DISABLED() if self.inversed else self.ENABLED(),
        }


type ConditionLike = Variable | Iterable[Variable]


@dataclass(frozen=True)
class Condition:
    variables: frozenset[Variable]

    def to_json(self) -> Json:
        return [variable.to_json() for variable in self.variables]

    @staticmethod
    def from_like(value: ConditionLike):
        if isinstance(value, Variable):
            value = [value]
        return Condition(frozenset(value))


type ToLike = ToEntryLike | To | list[ToEntryLike | To]


class Karabiner:
    _description: str
    _manipulators: defaultdict[tuple[From, Condition], defaultdict[str, list[ToEntry]]]

    def __init__(self, description: str):
        self._description = description
        self._manipulators = defaultdict(lambda: defaultdict(list))

    def register(self, condition: ConditionLike, manipulators: dict[FromLike, ToLike]):
        conditions = Condition.from_like(condition)

        for from_like, to_like in manipulators.items():
            from_ = From.from_like(from_like)
            manipulator = self._manipulators[from_, conditions]
            if not isinstance(to_like, list):
                to_like = [to_like]

            for to_ in to_like if isinstance(to_like, list) else [to_like]:
                if not isinstance(to_, To):
                    to_ = To("to", [to_])
                manipulator[to_.name].extend(to_.entries)

    def var(self, name: str, *key_codes: str) -> Variable:
        self.register(
            condition=(),
            manipulators={
                key_code: [
                    set_variable(name, Variable.ENABLED()),
                    to_after_key_up(set_variable(name, Variable.DISABLED())),
                ]
                for key_code in key_codes
            },
        )

        return Variable(name)

    def to_json(self) -> Json:
        return {
            "description": self._description,
            "manipulators": [
                {
                    "type": "basic",
                    "conditions": condition.to_json(),
                    "from": from_.to_json(),
                    **{
                        name: [to.to_json() for to in entries]
                        for name, entries in to.items()
                    },
                }
                for (from_, condition), to in self._manipulators.items()
            ],
        }

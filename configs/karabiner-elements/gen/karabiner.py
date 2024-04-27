from dataclasses import dataclass

type JsonPrimitive = int | float | str
type Json = JsonPrimitive | dict[JsonPrimitive, Json] | list[Json] | tuple[
    Json, ...
] | None
type JsonDict = dict[JsonPrimitive, Json]


@dataclass(frozen=True)
class Variable:
    name: str
    inversed: bool = False

    def __invert__(self):
        return Variable(self.name, not self.inversed)

    def to_condition(self) -> JsonDict:
        return {
            "name": self.name,
            "type": "variable_if",
            "value": 0 if self.inversed else 1,
        }


@dataclass(frozen=True)
class ModifiedKey:
    key_code: str
    modifiers: tuple[str, ...]


def mod(*modifiers: str):
    def wrapper(key_code: str):
        return ModifiedKey(key_code, modifiers)

    return wrapper


type FromLike = str | ModifiedKey | From


@dataclass(frozen=True)
class From:
    key_code: str
    mandatory_modifiers: tuple[str, ...]
    optional_modifiers: tuple[str, ...] | None

    @staticmethod
    def from_like(value: FromLike):
        if isinstance(value, str):
            value = ModifiedKey(value, ())
        if isinstance(value, ModifiedKey):
            value = From(value.key_code, value.modifiers, None)
        return value

    def to_json(self) -> Json:
        opt: Json = self.optional_modifiers if self.optional_modifiers else ["any"]
        return {
            "key_code": self.key_code,
            "modifiers": {
                "mandatory": self.mandatory_modifiers,
                "optional": opt,
            },
        }


type ToEntryLike = str | ModifiedKey | ToEntry


@dataclass
class ToEntry:
    entry: JsonDict

    def to_json(self) -> Json:
        return self.entry

    @staticmethod
    def from_like(entry: ToEntryLike) -> "ToEntry":
        if isinstance(entry, str):
            return ToEntry({"key_code": entry})
        if isinstance(entry, ModifiedKey):
            return ToEntry({"key_code": entry.key_code, "modifiers": entry.modifiers})
        return entry


def set_variable(name: str, value: int | float):
    return ToEntry({"set_variable": {"name": name, "value": value}})


def mouse_key(**values: int | float):
    return ToEntry({"mouse_key": dict(**values)})


def pointing_button(button: str):
    return ToEntry({"pointing_button": button})


type ToLike = ToEntryLike | To


@dataclass
class To:
    name: str
    entries: list[ToEntry]

    def __init__(self, name: str, entries: list[ToEntryLike]):
        self.name = name
        self.entries = [ToEntry.from_like(entry) for entry in entries]

    @staticmethod
    def from_like(value: ToLike) -> "To":
        if isinstance(value, To):
            return value
        return To("to", [ToEntry.from_like(value)])


def to(*entries: ToEntryLike):
    return To("to", list(entries))


def to_after_key_up(*entries: ToEntryLike):
    return To("to_after_key_up", list(entries))


def to_if_alone(*entries: ToEntryLike):
    return To("to_if_alone", list(entries))


class Manipulator:
    _from: From
    _to: To
    _conditions: list[Variable]

    def __init__(self, from_: FromLike, to: ToLike, conditions: list[Variable]):
        self._from = From.from_like(from_)
        self._to = To.from_like(to)
        self._conditions = conditions

    def to_json(self) -> Json:
        return {
            "type": "basic",
            "from": self._from.to_json(),
            "conditions": [cond.to_condition() for cond in self._conditions],
            self._to.name: [entry.to_json() for entry in self._to.entries],
        }


class Karabiner:
    _description: str
    _manipulators: list[Manipulator]

    def __init__(self, description: str):
        self._description = description
        self._variables = {}
        self._manipulators = []

    def var(self, name: str, *key_codes: str) -> Variable:
        for key_code in key_codes:
            self._manipulators.extend(
                (
                    Manipulator(
                        conditions=[],
                        from_=key_code,
                        to=set_variable(name, 1),
                    ),
                    Manipulator(
                        conditions=[],
                        from_=key_code,
                        to=to_after_key_up(set_variable(name, 0)),
                    ),
                )
            )

        return Variable(name)

    def register(self, variables: list[Variable], manipulator: dict[FromLike, ToLike]):
        for key_code, to in manipulator.items():
            self._manipulators.append(Manipulator(key_code, to, variables))

    def to_json(self) -> Json:
        return {
            "description": self._description,
            "manipulators": [
                manipulator.to_json() for manipulator in self._manipulators
            ],
        }

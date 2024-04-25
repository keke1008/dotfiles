from dataclasses import dataclass

type JsonPrimitive = int | float | str
type Json = int | float | str | dict[JsonPrimitive, Json] | list[Json] | None
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


type ToEntryLike = str | ToEntry


@dataclass
class ToEntry:
    entry: JsonDict

    def to_json(self) -> Json:
        return self.entry

    @staticmethod
    def from_like(entry: ToEntryLike):
        if isinstance(entry, str):
            return ToEntry({"key_code": entry})
        return entry


def mod(*modifiers: str):
    def wrapper(key_code: str):
        return ToEntry({"key_code": key_code, "modifiers": list(modifiers)})

    return wrapper


def set_variable(name: str, value: int | float):
    return ToEntry({"set_variable": {"name": name, "value": value}})


def mouse_key(**values: int | float):
    return ToEntry({"mouse_key": dict(**values)})


def pointing_button(button: str):
    return ToEntry({"pointing_button": button})


type ToLike = str | ToEntry | To


@dataclass
class To:
    name: str
    entries: list[ToEntry]

    def __init__(self, name: str, entries: list[ToEntryLike]):
        self.name = name
        self.entries = [ToEntry.from_like(entry) for entry in entries]

    @staticmethod
    def from_like(value: ToLike):
        if isinstance(value, To):
            return value
        return To("to", [ToEntry.from_like(value)])


class Manipulator:
    from_key_code: str
    to: To
    conditions: list[Variable]

    def __init__(
        self, from_key_code: str, to: str | ToEntry | To, conditions: list[Variable]
    ):
        self.from_key_code = from_key_code
        self.to = To.from_like(to)
        self.conditions = conditions

    def to_json(self) -> Json:
        return {
            "type": "basic",
            "from": {"key_code": self.from_key_code},
            "conditions": [cond.to_condition() for cond in self.conditions],
            self.to.name: [entry.to_json() for entry in self.to.entries],
        }


def to(*entries: ToEntryLike):
    return To("to", list(entries))


def to_after_key_up(*entries: ToEntryLike):
    return To("to_after_key_up", list(entries))


def to_if_alone(*entries: ToEntryLike):
    return To("to_if_alone", list(entries))


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
                        from_key_code=key_code,
                        to=set_variable(name, 1),
                    ),
                    Manipulator(
                        conditions=[],
                        from_key_code=key_code,
                        to=to_after_key_up(set_variable(name, 0)),
                    ),
                )
            )

        return Variable(name)

    def register(
        self, variables: list[Variable], manipulator: dict[str, str | ToEntry | To]
    ):
        for key_code, to in manipulator.items():
            self._manipulators.append(Manipulator(key_code, to, variables))

    def to_json(self) -> Json:
        return {
            "description": self._description,
            "manipulators": [
                manipulator.to_json() for manipulator in self._manipulators
            ],
        }

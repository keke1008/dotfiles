from dataclasses import dataclass
from typing import Iterable
from . import json


type VariableType = str | int | bool


@dataclass(frozen=True)
class VariableCondition:
    variable: "Variable"
    value: VariableType
    invert: bool

    def to_json(self) -> json.Json:
        return json.from_like(
            {
                "type": "variable_if" if not self.invert else "variable_unless",
                "name": self.variable.name,
                "value": self.value,
            }
        )


@dataclass(frozen=True)
class SetVariable:
    name: str
    value: VariableType


@dataclass(frozen=True)
class Variable:
    name: str

    def set(self, value: VariableType) -> SetVariable:
        return SetVariable(self.name, value)

    def equals(self, value: VariableType) -> VariableCondition:
        return VariableCondition(self, value, False)

    def not_equals(self, value: VariableType) -> VariableCondition:
        return VariableCondition(self, value, True)


@dataclass(frozen=True)
class FrontmostApplicationCondition:
    bundle_identifiers: frozenset[str]
    invert: bool

    def to_json(self) -> json.Json:
        return json.from_like(
            {
                "type": "frontmost_application_if" if not self.invert else "frontmost_application_unless",
                "bundle_identifiers": [*self.bundle_identifiers],
            }
        )


@dataclass(frozen=True)
class Application:
    identifiers: frozenset[str]

    def is_frontmost(self) -> FrontmostApplicationCondition:
        return FrontmostApplicationCondition(frozenset(self.identifiers), False)

    def is_not_frontmost(self) -> FrontmostApplicationCondition:
        return FrontmostApplicationCondition(frozenset(self.identifiers), True)


type ConditionVariant = VariableCondition | FrontmostApplicationCondition
type ConditionSetLike = ConditionVariant | ConditionSet | list[ConditionVariant | ConditionSet]


@dataclass(frozen=True)
class ConditionSet:
    conditions: frozenset[ConditionVariant] = frozenset()

    @staticmethod
    def from_like(like: ConditionSetLike) -> "ConditionSet":
        if not isinstance(like, list):
            like = [like]
        c = (l for ls in like for l in (ls.conditions if isinstance(ls, ConditionSet) else (ls,)))
        return ConditionSet(frozenset(c))

    @staticmethod
    def from_likes(likes: Iterable[ConditionSetLike]) -> "ConditionSet":
        conds = (ConditionSet.from_like(like).conditions for like in likes)
        return ConditionSet(frozenset(*(conds)))

    def to_json(self) -> json.Json:
        return json.from_like([*self.conditions])

    def merge(self, other: "ConditionSet") -> "ConditionSet":
        return ConditionSet(self.conditions | other.conditions)

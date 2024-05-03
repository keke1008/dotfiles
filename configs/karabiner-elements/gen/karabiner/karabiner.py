from collections import defaultdict
from dataclasses import dataclass

from . import json
from .to_event import ToEvent, ToEventEntry, ToEventLike, ToEventName
from .condition import ConditionSet, ConditionSetLike
from .from_event import FromEvent, FromEventLike


@dataclass(frozen=True)
class ConditionalWrapper[T]:
    value: T
    condition: ConditionSet = ConditionSet()


type FromClause = ConditionalWrapper[FromEvent]
type FromClauseLike = FromEventLike | ConditionalWrapper[FromEventLike] | FromClause


def _into_from_clause(like: FromClauseLike) -> FromClause:
    if not isinstance(like, ConditionalWrapper):
        like = ConditionalWrapper(FromEvent.from_like(like))
    return ConditionalWrapper(FromEvent.from_like(like.value), like.condition)


type ToClause = list[ConditionalWrapper[ToEvent]]
type ToClauseEntryLike = ToEventLike | ConditionalWrapper[ToEventLike]
type ToClauseLike = ToClauseEntryLike | list[ToClauseLike]


def _into_to_clause(like: ToClauseLike) -> ToClause:
    if not isinstance(like, list):
        if not isinstance(like, ConditionalWrapper):
            like = ConditionalWrapper(like)
        return [ConditionalWrapper(ToEvent.from_like(like.value), like.condition)]
    return [c for cs in (_into_to_clause(l) for l in like) for c in cs]


class Karabiner:
    _description: str
    _manipulators: defaultdict[tuple[FromEvent, ConditionSet], defaultdict[ToEventName, list[ToEventEntry]]]

    def __init__(self, description: str) -> None:
        self._description = description
        self._manipulators = defaultdict(lambda: defaultdict(list))

    def register(self, manipulators: dict[FromClauseLike, ToClauseLike], conditions: ConditionSetLike = []):
        conditions = ConditionSet.from_like(conditions)
        for from_clause, to_clause in manipulators.items():
            from_clause = _into_from_clause(from_clause)
            to_clause = _into_to_clause(to_clause)
            cond = conditions.merge(from_clause.condition)
            for to in to_clause:
                manipulator = self._manipulators[from_clause.value, cond.merge(to.condition)]
                manipulator[to.value.name].extend(to.value.entries)

    def to_json(self) -> str:
        out = json.from_like(
            {
                "description": self._description,
                "manipulators": [
                    {
                        "type": "basic",
                        "conditions": cond,
                        "from": from_event,
                        **{name: [*entries] for name, entries in to_event.items()},
                    }
                    for (from_event, cond), to_event in self._manipulators.items()
                ],
            }
        )

        json.validate(out)
        return json.stringify(out)

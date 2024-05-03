from dataclasses import dataclass

from karabiner.condition import SetVariable

from .key import ModifiedKey, ModifiedKeyLike
from . import json

type ToEventEntryLike = ModifiedKeyLike | SetVariable | ToEventEntry


@dataclass(frozen=True)
class ToEventEntry:
    entry: json.Json

    @staticmethod
    def from_like(entry: ToEventEntryLike) -> "ToEventEntry":
        if isinstance(entry, ToEventEntry):
            return entry
        elif isinstance(entry, SetVariable):
            return ToEventEntry(json.from_like({"set_variable": {"name": entry.name, "value": entry.value}}))
        else:
            m = ModifiedKey.from_like(entry)
            j = json.from_like({"key_code": m.key_code, "modifiers": list(m.modifiers)})
            return ToEventEntry(j)

    def to_json(self) -> json.Json:
        return self.entry


type ToEventName = str

type ToEventLike = ToEventEntryLike | ToEvent


@dataclass
class ToEvent:
    name: ToEventName
    entries: list[ToEventEntry]

    @staticmethod
    def from_like(like: ToEventLike) -> "ToEvent":
        if isinstance(like, ToEvent):
            return like
        return ToEvent("to", [ToEventEntry.from_like(like)])

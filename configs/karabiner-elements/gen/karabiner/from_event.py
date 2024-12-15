from dataclasses import dataclass

from .key import KeyCode, ModifiedKeyLike, ModifiedKey
from . import json


type FromKeyCodeLike = FromKeyCode | ModifiedKeyLike


@dataclass(frozen=True)
class FromKeyCode:
    key_code: KeyCode
    mandatory_modifiers: frozenset[KeyCode]
    optional_modifiers: frozenset[KeyCode] | None

    @staticmethod
    def from_like(value: FromKeyCodeLike) -> "FromKeyCode":
        if isinstance(value, FromKeyCode):
            return value
        else:
            key = ModifiedKey.from_like(value)
            return FromKeyCode(key.key_code, key.modifiers, key.optional)

    def to_json(self) -> json.Json:
        return json.from_like(
            {
                "key_code": self.key_code,
                "modifiers": {
                    "mandatory": [*self.mandatory_modifiers],
                    "optional": ([*self.optional_modifiers] if self.optional_modifiers is not None else ["any"]),
                },
            }
        )


type FromEventLike = FromEvent | FromKeyCodeLike


@dataclass(frozen=True)
class FromEvent:
    event: FromKeyCode

    @staticmethod
    def from_like(value: FromEventLike) -> "FromEvent":
        if isinstance(value, FromEvent):
            return value
        else:
            return FromEvent(FromKeyCode.from_like(value))

    def to_json(self) -> json.Json:
        return self.event.to_json()

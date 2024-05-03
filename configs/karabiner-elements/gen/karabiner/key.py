from dataclasses import dataclass

type KeyCodeLike = str | int | KeyCode
type KeyCode = str | int

type ModifiedKeyLike = KeyCodeLike | ModifiedKey


@dataclass(frozen=True)
class ModifiedKey:
    key_code: KeyCode
    modifiers: frozenset[KeyCode]
    optional: frozenset[KeyCode] | None = None

    @staticmethod
    def from_like(value: ModifiedKeyLike) -> "ModifiedKey":
        if isinstance(value, ModifiedKey):
            return value
        else:
            return ModifiedKey(value, frozenset(), None)

from karabiner import (
    Karabiner,
    apps,
    mod,
    mouse_key,
    pointing_button,
    to_after_key_up,
    to_if_alone,
    var,
    when,
)
from karabiner.condition import Variable


def make_sync(variable: Variable):
    return [variable.set(True), to_after_key_up(variable.set(False))]


def main():
    k = Karabiner("My Config")

    k.register(
        {
            mod(optional=())("international1"): ("international3"),
        },
    )

    rmod = var("rmod")
    rmod_sync = make_sync(rmod)
    k.register({"lang1": rmod_sync, "japanese_pc_xfer": rmod_sync})
    terminal = apps(r"^com\.github\.wez\.wezterm$")
    k.register(
        conditions=rmod.equals(True),
        manipulators={
            "j": "left_arrow",
            "k": "down_arrow",
            "l": "up_arrow",
            "semicolon": "right_arrow",
            when(terminal.is_not_frontmost())("g"): mod("command")("left_arrow"),
            when(terminal.is_not_frontmost())("h"): mod("command")("right_arrow"),
            when(terminal.is_frontmost())("g"): "home",
            when(terminal.is_frontmost())("h"): "end",
            "v": "page_up",
            "n": "page_down",
            "s": mod("option", "control")("spacebar"),
            "i": "delete_or_backspace",
            "d": mod("fn")("delete_or_backspace"),
            "r": "return_or_enter",
            "t": "tab",
            "e": "escape",
            "b": ["f10", "return_or_enter", mod("option", "control")("spacebar")],
        },
    )

    lmod = var("lmod")
    lmod_sync = make_sync(lmod)
    k.register({"japanese_eisuu": lmod_sync, "japanese_pc_nfer": lmod_sync})
    k.register(
        conditions=[lmod.equals(True)],
        manipulators={
            "r": pointing_button("button1"),
            "u": pointing_button("button2"),
            "i": mouse_key(vertical_wheel=50),
            "o": mouse_key(vertical_wheel=-50),
            "h": mouse_key(x=-1500),
            "j": mouse_key(y=1500),
            "k": mouse_key(y=-1500),
            "l": mouse_key(x=1500),
            "w": mouse_key(speed_multiplier=3),
            "e": mouse_key(speed_multiplier=0.2),
        },
    )

    space = var("space")
    space_sync = make_sync(space)
    k.register({"spacebar": [space_sync, to_if_alone("spacebar")]})
    k.register(
        conditions=space.equals(True),
        manipulators={
            "a": "1",
            "s": "2",
            "d": "3",
            "f": "4",
            "g": "5",
            "h": "6",
            "j": "7",
            "k": "8",
            "l": "9",
            "semicolon": "0",
            "quote": "hyphen",
            "backslash": "equal_sign",
            "close_bracket": "international3",
        },
    )

    print(k.to_json())


if __name__ == "__main__":
    main()

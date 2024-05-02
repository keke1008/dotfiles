import json
from karabiner import Karabiner, mod, mouse_key, pointing_button, to_if_alone


def main():
    k = Karabiner("My Config")

    k.register(
        condition=(),
        manipulators={
            mod(optional=())("international1"): ("international3"),
        },
    )

    rmod = k.var("rmod", "lang1", "japanese_pc_xfer")
    k.register(
        condition=rmod,
        manipulators={
            "j": "left_arrow",
            "k": "down_arrow",
            "l": "up_arrow",
            "semicolon": "right_arrow",
            "g": mod("command")("left_arrow"),
            "h": mod("command")("right_arrow"),
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

    lmod = k.var("lmod", "japanese_eisuu", "japanese_pc_nfer")
    k.register(
        condition=lmod,
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

    k.register(
        condition=(),
        manipulators={
            "spacebar": to_if_alone("spacebar"),
        },
    )
    space = k.var("space", "spacebar")
    k.register(
        condition=space,
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

    print(json.dumps(k.to_json()))


if __name__ == "__main__":
    main()

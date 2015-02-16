; Included io.m4 dnl
define(`PORT_NUMPAD', 0) dnl
define(`PORT_NUMERIC_DISPLAY', 1) dnl
define(`PORT_SYMBOL_UP', 2) dnl
define(`PORT_SYMBOL_DOWN', 3) dnl
define(`PORT_SYMBOL_LEFT', 4) dnl
define(`PORT_SYMBOL_RIGHT', 5) dnl
define(`PORT_SYMBOL_QUESTION', 6) dnl
define(`PORT_SYMBOL_BANG', 7) dnl
define(`PORT_RANDOM_NUMBER_GENERATOR', 8) dnl
define(`PORT_GAMEPAD', 9) dnl
define(`PORT_KEYBOARD', 10) dnl
dnl
define(`STATE_OFF', 0) dnl
define(`STATE_ON', 1) dnl
dnl
dnl Flushes the Numpad buffer, resetting it for next use
define(`NUMPAD_FLUSH', `out 100000, PORT_NUMPAD') dnl
dnl Flushes the Gamepad buffer, resetting it for next use
define(`GAMEPAD_FLUSH', `out 0, PORT_GAMEPAD') dnl
dnl Flushes the Keyboard buffer, resetting it for next use
define(`KEYBOARD_FLUSH', `out 0, PORT_KEYBOARD') dnl
dnl
dnl Sets the Numeric Display to $1
define(`SetNumericDisplay', `out $1, PORT_NUMERIC_DISPLAY') dnl
dnl Sets the symbol specified by $1 to the state specified by $2
define(`SetSymbolState', `out $2, $1') dnl

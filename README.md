"# corne_config" 


# to install vial on mechboard helidox crkbd

```
make git-submodule
qmk setup
python3 util/vial_generate_keyboard_uid.py
```
copy id to config.h
```
#pragma once

#define VIAL_KEYBOARD_UID {0x96, 0xD4, 0x2D, 0x71, 0x2B, 0x3B, 0xFC, 0x4B}
#define VIAL_UNLOCK_COMBO_ROWS {0, 0}
#define VIAL_UNLOCK_COMBO_COLS {0, 1}

```
then put kb in bootmode [esc] while plugging in power

```
qmk flash -kb crkbd -km vial -e CONVERT_TO=rp2040_ce
```

open vial or https://vial.rocks/

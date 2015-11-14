#!/bin/bash

# stty -F /dev/ttyS0  1200
stty -F /dev/ttyS0 2400

# printf "\x0d\x31\x31" >/dev/ttyS0

# printf "\x1b\x54\x00\x03\x00\x0c" >/dev/ttyS0
# dd if=ALLIENS.KCC bs=128 skip=1 status=noxfer  2> /dev/null  >/dev/ttyS0

printf "\x1b\x54\x00\x02\x80\x3f" >/dev/ttyS0
dd if=DIGGER.KCC bs=128 skip=1 status=noxfer  2> /dev/null  >/dev/ttyS0

# printf "\x1b\x54\x00\x02\x80\x50" >/dev/ttyS0
# dd if=DIGGER-4.KCC bs=128 skip=1 status=noxfer  2> /dev/null  >/dev/ttyS0

# printf "\x1b\x54\x00\x02\x00\x05" >/dev/ttyS0
# dd if=LIFE.KCC bs=128 skip=1 status=noxfer  2> /dev/null  >/dev/ttyS0

# printf "\x1BH\x55\x00\xF0" >/dev/ttyS0

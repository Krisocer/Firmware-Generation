#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
firmware="${project_root}/firmware/led_blink/build/Debug/led_blink.elf"
programmer="${HOME}/.local/share/stm32cube/bundles/programmer/2.23.0/bin/STM32_Programmer_CLI"

if [[ ! -f "${firmware}" ]]; then
  echo "Build first: bash scripts/build_blink.sh" >&2
  exit 1
fi

# This script targets the ST-LINK on the board used for this baseline.
"${programmer}" -c port=SWD sn=066CFF484851897767052720 freq=1000 \
  -w "${firmware}" -v -g 0x08000000

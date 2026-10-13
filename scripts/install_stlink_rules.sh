#!/usr/bin/env bash
set -euo pipefail

# Install ST's bundled rule for this board's ST-LINK/V2.1 USB interface.
rule_source="${HOME}/.local/share/stm32cube/bundles/stlink-gdbserver/7.14.0+st.2/bin/49-stlinkv2-1.rules"
if [[ ! -f "${rule_source}" ]]; then
  echo "Missing ST-LINK rule: ${rule_source}" >&2
  exit 1
fi

sudo install -m 0644 "${rule_source}" /etc/udev/rules.d/49-stlinkv2-1.rules
sudo udevadm control --reload-rules
echo "ST-LINK rule installed. Unplug and reconnect the board's ST-LINK USB cable."

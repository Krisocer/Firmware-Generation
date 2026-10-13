#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
bundle_root="${HOME}/.local/share/stm32cube/bundles"

# Use the installed ST bundle versions for this course project's baseline.
export PATH="${bundle_root}/gnu-tools-for-stm32/14.3.1+st.2/bin:${bundle_root}/ninja/1.13.2+st.1/bin:${PATH}"
cmake_bin="${bundle_root}/cmake/4.4.0+st.1/bin/cmake"

cd "${project_root}/firmware/led_blink"
"${cmake_bin}" --preset Debug
"${cmake_bin}" --build --preset Debug

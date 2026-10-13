# Firmware Generation

**AI-Assisted Embedded Firmware Generation and Verification**

ECE 2195 course project: a verified LED Blink baseline for **STM32L476G-DISCO**.

The M1 implementation combines a CubeMX-generated STM32 project, AI-assisted application edits, scripted compilation/programming, and manual board checks. Automated LLM invocation, static requirement checking, and code-repair orchestration are planned next steps.

## Contents

```text
firmware/led_blink/   CubeMX configuration, application, HAL/CMSIS, CMake files
scripts/             Build, program/start, and one-time Linux USB setup
logs/bringup/        Original failed configuration and successful build/flash logs
docs/                Code guide and evidence notes
```

The original vendor license files remain under `firmware/led_blink/Drivers/`. Local build outputs, IDE metadata, and presentation/report files are excluded from version control.

## Hardware and application

- Target MCU: STM32L476VGT6; onboard ST-LINK/V2.1 via SWD.
- Green user LED LD5: PE8.
- Application: toggle PE8 and call `HAL_Delay(500)` in the main loop.
- Nominal behavior: approximately 500 ms on, 500 ms off.
- Initialization: internal MSI clock, SysTick time base, GPIO push-pull output.

CubeMX generated initialization and project support. The AI assistant added the Blink loop and helper scripts; the student confirmed physical LED and reset behavior.

## Reproduce the baseline

The scripts use the ST bundles installed below `$HOME/.local/share/stm32cube/bundles`:

| Component | Recorded version |
| --- | --- |
| Ubuntu | 24.04 |
| CubeMX | 6.18.1 |
| STM32 VS Code extension | 3.11.0 |
| STM32CubeL4 | 1.18.2 |
| ARM GCC bundle | 14.3.1+st.2 |
| CMake bundle | 4.4.0+st.1 |
| Ninja bundle | 1.13.2+st.1 |
| CubeProgrammer | 2.23.0 |
| ST-LINK GDB server bundle | 7.14.0+st.2 |

Install these tools using ST's extension/bundle manager, or adapt the script paths to the tools on your machine. The programming script selects the original board's ST-LINK serial number; change `sn=` when using another board.

From the repository root:

```bash
bash scripts/build_blink.sh
bash scripts/flash_blink.sh
```

For first-time Linux ST-LINK setup, run `bash scripts/install_stlink_rules.sh` and reconnect the ST-LINK USB cable. This step installs the official bundled udev rule using sudo.

Build before programming after every source change. The build script generates `firmware/led_blink/build/Debug/led_blink.elf`; the programming script downloads it, performs readback verification, and starts the application. Existing logs were captured during bring-up; the scripts currently print new output to the terminal.

## Recorded preliminary results

| Check / measurement | Recorded result |
| --- | --- |
| Debug build | Exit 0; 23 build steps; ELF generated |
| Linker Flash allocation | 6152 B / 1 MiB (0.59%) |
| Linker RAM1 allocation | 1584 B / 96 KiB (1.61%) |
| Linker RAM2 allocation | 0 B |
| Download and readback | Successful |
| Single download duration | 431 ms |
| Single readback duration | 95 ms |
| LED blinking and B1 Reset | Manually confirmed |

The memory values describe linked allocations, and the durations come from one programmer operation. The failed `configure.log` records the initial missing-GCC-path issue, which was resolved before the successful build. This is one interactively developed baseline; it does not provide a prompt-comparison success rate or an automated requirement-check result.

For the code-reading order and evidence interpretation, see [the Chinese code guide](docs/CODE_GUIDE_ZH.md).

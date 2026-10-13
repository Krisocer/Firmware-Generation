# M1 代码导览

当前流程：CubeMX 生成工程 → AI 辅助添加应用逻辑 → 命令行编译 → ST-LINK 下载与读回校验 → 人工确认运行。

## 建议阅读顺序

1. [main.c](../firmware/led_blink/Core/Src/main.c)：从 `HAL_Init()`、`SystemClock_Config()`、`MX_GPIO_Init()` 读到主循环。应用新增代码只有 PE8 翻转与 500 ms 等待两行。
2. [build_blink.sh](../scripts/build_blink.sh)：在电脑上设置 GCC/Ninja 路径，再执行 CMake Configure 和 Build，生成 ELF。
3. [flash_blink.sh](../scripts/flash_blink.sh)：检查 ELF 存在，通过 SWD 连接指定 ST-LINK，下载、读回校验并启动。修改代码后先 build 再 flash；换板时修改 `sn=`。
4. [build.log](../logs/bringup/build.log)：成功编译与链接的证据，包含 Flash/RAM 分配数据。
5. [flash.log](../logs/bringup/flash.log)：成功下载、读回校验与启动的证据，包含单次操作时间。

`firmware/` 中的代码运行在 MCU 上；`scripts/` 中的 shell 脚本运行在电脑上。

## 谁完成了什么

CubeMX 自动生成初始化代码、驱动、启动文件和链接/CMake 支持。AI 助手添加 Blink 主循环、构建/烧录/权限脚本，并执行工具保存日志。用户完成 CubeMX GUI 配置、sudo 权限安装，以及板上 LED 与 B1 Reset 观察。

## 验证范围

- 编译成功：当前工程能生成可链接的固件。
- Flash 读回校验成功：编程后的内容与固件图像一致。
- 人工观察：当前 LD5 闪烁，Reset 后能重新运行。
- 链接 RAM 占用不是运行时峰值；视觉观察不是仪器计时。

[configure.log](../logs/bringup/configure.log) 是最初 GCC 未在 PATH 中的环境失败记录，后续通过构建脚本显式指定路径解决。它不计为 LLM 的修正次数。

目前源码集成与 LLM 交互是人工/聊天式操作；自动 LLM 调用、静态需求检查、限次反馈循环及 prompt 对比实验尚未实现。

## 开发注意事项

- `led_blink.ioc` 保存 CubeMX 的实际配置。
- 编辑 `main.c` 时保留 USER CODE 区域，便于重新生成工程。
- `Drivers/` 的第三方许可证随源码保留。
- Build 产物未上传；先安装对应 ST 工具，再按 README 构建。
- 原始日志保留其本机路径和 ST-LINK 标识，用于说明已记录的具体运行环境。
- 构建和烧录脚本输出至终端，尚未自动管理每次实验日志。

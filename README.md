# stm32f4_template

* 工欲善其事，必先利其器，由于我电脑性能和个人使用习惯问题，我只喜欢在ubuntu下开发一些诸如android app和mcu application的工作，所以stm32f4在ubuntu下的开发环境我需要好好整理

* 关于stm32开发环境的配置
	* IDE: eclipse + GNU ARM plugin + AC6 systembench + openocd
	* none-IDE: Makefile + st-util + arm-none-eabi-gdb

* 我先在eclipse下新建一个可以正常工作的工程，所以本repo可以在eclipse下进行开发
* 同时我参考其他repo编写了Makefile，在不更改原有代码结构的情况下，可以make产生bin文件
* 我所追求的也是这样一种结构

* 关于调试，st-util可以建立debug server，端口4242
* arm-none-eabi-gdb的.gdbinit内容如下：

```bash
echo Executing GDB with .gdbinit to connect to OpenOCD.\n
echo .gdbinit is a hidden file. Press Ctrl-H in the current working directory to see it.\n
# Connect to OpenOCD
target extended-remote localhost:4242
# Reset the target and call its init script
monitor reset init
# Halt the target. The init script should halt the target, but just in case
monitor halt

```

* 则需要debug的话，只要arm-none-eabi-gdb main.elf即可
	* 一些调试的小tips
	* b 83  -- line number
	* b main -- function name
	* c	-- continue
	* jump main -- 跳回main重新执行，debug mcu肯定和软件有不一样的地方，r重新执行有些bug，采用jump来规避


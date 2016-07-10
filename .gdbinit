echo Executing GDB with .gdbinit to connect to OpenOCD. 

echo .gdbinit is a hidden file.
 echo Press Ctrl-H in the current working directory to see it. 

# Connect to OpenOCD
target extended-remote localhost:4242
# Reset the target and call its init script
monitor reset init
# Halt the target. The init script should halt the target, but just in case
monitor halt
b main
jump main

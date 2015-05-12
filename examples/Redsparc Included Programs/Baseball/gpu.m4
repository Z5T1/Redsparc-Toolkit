; Included gpu.m4 dnl
define(`PORT_GPU_EXECUTE', 16) dnl
define(`PORT_GPU_COMMAND', 17) dnl
define(`PORT_GPU_X1', 18) dnl
define(`PORT_GPU_Y1', 19) dnl
define(`PORT_GPU_X2', 20) dnl
define(`PORT_GPU_Y2', 21) dnl
define(`PORT_GPU_COLOR', 22) dnl
define(`PORT_GPU_BUFFER', 23) dnl
define(`PORT_GPU_REGISTER', 24) dnl
define(`PORT_GPU_STATUS', 25) dnl
dnl
define(`GPU_STATUS_FREE', 0) dnl
define(`GPU_STATUS_BUSY', 1) dnl
dnl
define(`GPU_CMD_RESET', 0) dnl
define(`GPU_CMD_COPY_BUFFER', 1) dnl
define(`GPU_CMD_SET_PIXEL', 2) dnl
define(`GPU_CMD_FILL', 3) dnl
define(`GPU_CMD_BORDER', 4) dnl
define(`GPU_CMD_LARGE_PRINTCHAR', 64) dnl
define(`GPU_CMD_LARGE_PRINTSTRING', 65) dnl
define(`GPU_CMD_SMALL_PRINTCHAR', 80) dnl
define(`GPU_CMD_SMALL_PRINTSTRING', 81) dnl
dnl
dnl Tells the GPU to execute the current command
define(`GPU_Execute', `out 1, PORT_GPU_EXECUTE') dnl
dnl
dnl Sets the GPU command to $1
define(`GPU_SetCommand', `out $1, PORT_GPU_COMMAND') dnl
dnl
dnl Sets the X1 coordinate of the GPU to $1
define(`GPU_SetX1', `out $1, PORT_GPU_X1') dnl
dnl
dnl Sets the Y1 coordinate of the GPU to $1
define(`GPU_SetY1', `out $1, PORT_GPU_Y1') dnl
dnl
dnl Sets the X2 coordinate of the GPU to $1
define(`GPU_SetX2', `out $1, PORT_GPU_X2') dnl
dnl
dnl Sets the Y2 coordinate of the GPU to $1
define(`GPU_SetY2', `out $1, PORT_GPU_Y2') dnl
dnl
dnl Sets the GPU color to $1
define(`GPU_SetColor', `out $1, PORT_GPU_COLOR') dnl
dnl
dnl Sets the GPU working buffer to $1
define(`GPU_SetWorkingBuffer', `out $1, PORT_GPU_BUFFER') dnl
dnl
dnl Sets the GPU register to $1
define(`GPU_SetRegister', `out $1, PORT_GPU_REGISTER') dnl
dnl
dnl Saves the GPU register value to the CPU register specified by $1
define(`GPU_GetRegisterValue', `in $1, PORT_GPU_REGISTER') dnl
dnl
dnl Saves the GPU status to the CPU register specified by $1
define(`GPU_GetStatus', `in $1, PORT_GPU_STATUS') dnl

;; 由实模式进入保护模式
[BITS 16]   ;编译成16位指令
[ORG 0X7C00]
    cli     ;关闭中断，保证引导程序在执行时不被打扰
    xor ax, ax
    mov ds, ax

    lgdt[GDTR_Value]    ;加载GDTR:将GDT基址及大小装入GDTR=limit(16)+base(32)
    mov eax, CR0
    or eax, 1           ;设置eax的第0位：PE位
    mov CR0, eax        ;设置PE位，执行之后进入保护模式
    jmp 08h:GoIntoProtectMode   ;080:跳过GDT第一个段空段（00h-07h），即08h
[BITS 32]
GoIntoProtectMode:  ;因为要进入保护模式，所以对DS,CS,ES,SS,FS,GS重写
    mov ax, 10h     ;10h:GDT(00h-07h):空，GDT(10h-17h)数据段
    mov ds, ax
    mov ss, ax      ;堆栈段与数据相同
    mov esp, 090000h 
    ;保护模式下不能直接使用BIOS中断，显示要是向显存缓存里直接写入
    ;显存位于:0xA0000--0xbffff,帧缓冲位于0xb8000处
    ;字符2个字节:字节1代表ASCII，字节2属性:前景色/背景色/闪烁
    mov byte [ds:0B8000h], 'I'
    mov byte [ds:0B8001h], 1ah
    mov byte [ds:0B8002h], 'S'
    mov byte [ds:0B8003h], 9bh
    mov byte [ds:0B8004h], '1'
    mov byte [ds:0B8005h], 1ch
    mov byte [ds:0B8006h], '8'
    mov byte [ds:0B8007h], 9dh
    mov byte [ds:0B8008h], '!'
    mov byte [ds:0B8009h], 1eh
STOP:
    jmp STOP

GDT:        ;填写GDT，1个空段，1个代码段，1个数据段
GDT_Null:       ;填写GDT中的NULL段描述符，Intel保留的区域，用零填充    
    DD 0        ;共64位的0
    DD 0 

GDT_Code:       ;填写GDT中的代码段描述符
    DW 0ffffh       ;填写limit(15-0),共16位1
    DW 0            ;基地址为0
    DB 0            ;十六位的低八位：仍是基址，填0
    DB 10011010B    ;十六位的高八位：低到高：A,R/W,ED/C,E,S,DPL,设置PE位，执行之后进入保护模式
    DB 11001111B    ;十六位的低八位：思维偏移，AV,0,D,G
    DB 0            ;十六位的高八位：基址，全置0

%line 1+1 calc.s
[section .rodata]
 overflowMsg: db "Error: Operand Stack Overflow",10,0
 underflowMsg: db "Error: Insufficient Number of Arguments on Stack",10,0
 format_string: db "%d", 10, 0
 hexa_format: db "%X",0
 string_format: db "%s",0
 mynew_line: db "",10,0

[section .data]
 size: dd 0
 capacity: dd 5
[section .bss]
 stack: resd 1
 stackBase: resd 1
 buff: resb 81
 X: resd 1
 Y: resd 1
 Z: resd 1
 x: resd 1
 y: resd 1
 z: resd 1

%line 190+1 calc.s
[section .text]
[sectalign 16]
%line 191+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 192+1 calc.s
[global main]
[extern printf]
[extern fprintf]
[extern fflush]
[extern malloc]
[extern calloc]
[extern free]
[extern gets]
[extern getchar]
[extern fgets]
[extern printStack]
main:

 mov eax, [esp+4]
 cmp eax, 1
 jg update_stack_size
 jmp init_stack
 update_stack_size:
 mov eax, [esp+8]
 mov ecx, [eax+4]

%line 212+0 calc.s
 mov eax, ecx
 ..@17.looop:
 cmp byte [eax], 0
 je ..@17.endofstring
 inc eax
 jmp ..@17.looop
 ..@17.endofstring:
 sub eax , ecx
 and eax, 1
%line 213+1 calc.s
 cmp eax, 1
 je odd
 jmp even
 odd:
 mov eax, 0
%line 217+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@19.itA_F
 sub eax, 0x30
 jmp ..@19.it0_9
 ..@19.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@19.it0_9:
%line 218+1 calc.s
 jmp updateCapacity
 even:
 mov eax, 0
%line 220+0 calc.s
 mov al, [ecx]
 cmp eax, 0x41
 jge ..@21.itA_F
 sub eax, 0x30
 jmp ..@21.it0_9
 ..@21.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@21.it0_9:
 mov ebx, 0
 mov bl, [ecx+1]
 cmp ebx, 0x41
 jge ..@22.itA_F
 sub ebx, 0x30
 jmp ..@22.it0_9
 ..@22.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@22.it0_9:
 shl eax, 4
 add eax, ebx
%line 221+1 calc.s
 updateCapacity:
 mov [capacity], eax
 push dword [capacity]
%line 223+0 calc.s
 push format_string
 call printf
%line 224+1 calc.s
 init_stack:
 push dword 4
 push dword [capacity]
 call calloc
 mov [stack], eax
 sub dword[stack], 4
 mov [stackBase], eax


 main_loop:
 pushad
%line 234+0 calc.s
 push buff
 call gets
 add esp, 4
 popad
%line 235+1 calc.s
 call parseCommand
 jmp main_loop
myexit:
 push ebx
%line 238+0 calc.s
 push ecx
 push edx
 push dword [stackBase]
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 239+1 calc.s
 mov ebx, 0
 mov eax, 1
 int 0x80

Ed_Edd_n_Eddy:
 push ebp
 mov ebp, esp
 mov eax, [size]
 cmp eax, 2
 jl underflow

%line 249+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 250+1 calc.s
 mov [X], dword eax
 mov [x], dword eax
 sub dword [size], 1
%line 252+0 calc.s
 sub byte [stack], 4
%line 253+1 calc.s

%line 253+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 254+1 calc.s
 mov [Y], dword eax
 mov [y], dword eax
 mov ecx, 0



 mov edx, [x]
 add edx, [y]
 cmp edx, 0
 je Addend
 x1:
 cmp dword [x], 0
 je y1
 mov edx, [x]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
 y1:
 cmp dword [y], 0
 je z1
 mov edx, [y]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
 z1:
 push ebx
%line 283+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 284+1 calc.s
 mov [eax], byte cl
 mov [eax+1], dword 0



 mov [Z], eax
 mov [z], eax
 shr ecx, 8
 Addloop:


 mov edx, [x]
 add edx, [y]
 cmp edx, 0
 je Addend

 x2:
 cmp dword [x], 0
 je y2
 mov edx, [x]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
 y2:
 cmp dword [y], 0
 je z2
 mov edx, [y]
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
 z2:
 push ebx
%line 319+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 320+1 calc.s
 mov [eax], byte cl
 mov [eax+1], dword 0





 mov edx, [z]
 mov [edx+1], eax
 mov [z], eax
 shr ecx, 8
 jmp Addloop

 Addend:
 cmp ecx, 0
 je Addendend
 push ebx
%line 336+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 337+1 calc.s
 mov [eax], byte cl
 mov [eax+1], dword 0
 mov edx, [z]
 mov [edx+1], dword eax
 Addendend:
 mov edx, dword [Z]
 mov [stack], dword edx
 mov esp, ebp
 pop ebp
 ret

posh:
 push ebp
 mov ebp, esp

 mov eax, [size]
 cmp eax , [capacity]
 je overflow
 add dword [size],1
%line 355+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 356+1 calc.s
 mov edx, buff
 b2:

%line 358+0 calc.s
 mov eax, buff
 ..@33.looop:
 cmp byte [eax], 0
 je ..@33.endofstring
 inc eax
 jmp ..@33.looop
 ..@33.endofstring:
 sub eax , buff
 and eax, 1
%line 359+1 calc.s
 cmp eax,0
 je evenlength
 oddlength:
 mov eax, 0
%line 362+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@35.itA_F
 sub eax, 0x30
 jmp ..@35.it0_9
 ..@35.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@35.it0_9:
%line 363+1 calc.s
 mov ecx, eax


%line 365+0 calc.s
 push ebx
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [eax], byte ecx
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 366+1 calc.s
 add edx, 1
 b3:
 evenlength:
 cmp byte [edx], 0
 je end_posh
 mov eax, 0
%line 371+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@39.itA_F
 sub eax, 0x30
 jmp ..@39.it0_9
 ..@39.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@39.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@40.itA_F
 sub ebx, 0x30
 jmp ..@40.it0_9
 ..@40.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@40.it0_9:
 shl eax, 4
 add eax, ebx
%line 372+1 calc.s
 mov ecx, eax


%line 374+0 calc.s
 push ebx
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [eax], byte ecx
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 375+1 calc.s
 add edx, 2
 jmp evenlength
 end_posh:
 mov esp, ebp
 pop ebp
 ret
 overflow:
 pushad
%line 382+0 calc.s
 push dword overflowMsg
 push string_format
 call printf
 add esp, 8
 popad
%line 383+1 calc.s
 jmp main_loop

poop:
 push ebp
 mov ebp, esp
 mov eax, [size]
 cmp eax, 0
 je underflow

%line 391+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 392+1 calc.s
 pushad
 push eax
 call printNumList
 add esp, 4
 popad
 push ebx
%line 397+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 398+1 calc.s
 sub dword [size], 1
%line 398+0 calc.s
 sub byte [stack], 4
%line 399+1 calc.s
 mov esp, ebp
 pop ebp
 pushad
%line 401+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 402+1 calc.s
 ret

 underflow:
 pushad
%line 405+0 calc.s
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
%line 406+1 calc.s
 mov esp, ebp
 pop ebp
 ret

printNumList:
 push ebp
 mov ebp, esp
 mov eax, [ebp+8]
 cmp eax, 0
 je .end
 mov ebx , dword[eax+1]
 pushad
 push ebx
 call printNumList
 add esp, 4
 popad
 mov ebx, 0
 mov bl , byte [eax]
 pushad
%line 424+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 425+1 calc.s
 mov eax, dword [eax+1]
 push ebx
%line 426+0 calc.s
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 427+1 calc.s
 .end:
 mov esp, ebp
 pop ebp
 ret

parseCommand:
 push ebp
 mov ebp, esp
 mov eax, 0
 mov al, byte [buff]
 cmp eax ,0x70
 je user_wants_to_poop
 cmp eax, 0x71
 je myexit
 cmp eax, 0x73
 je PrintStack
 cmp eax, 43
 je Ed

 Posh:
 call posh
 jmp end_p


 Ed:
 call Ed_Edd_n_Eddy
 jmp end_p
 PrintStack:
 pushad
%line 455+0 calc.s
 push dword [capacity]
 push dword [stackBase]
 call printStack
 add esp, 8
 popad
%line 456+1 calc.s
 jmp end_p
 user_wants_to_poop:
 call poop
 jmp end_p
 end_p:
 mov esp, ebp
 pop ebx
 ret



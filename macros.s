%line 1+1 calc.s
[section .rodata]
 overflowMsg: db "Error: Operand Stack Overflow",10,0
 underflowMsg: db "Error: Insufficient Number of Arguments on Stack",10,0
 format_string: db "%d", 10, 0
 hexa_format: db "%X",0
 string_format: db "%s",0
 mynew_line: db "",10,0
 calc: db "calc: ", 0

[section .data]
 size: dd 0
 capacity: dd 5
 opCounter: dd 0
 debugFlag: db 0
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

%line 267+1 calc.s



[section .text]
[sectalign 16]
%line 271+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 272+1 calc.s
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
[extern debug]
main:

 mov eax, [esp+4]
 cmp eax, 1
 jg .update_stack_size
 jmp .init_stack
 .update_stack_size:
 mov eax, [esp+8]
 mov ecx, [eax+4]

%line 292+0 calc.s
 mov eax, ecx
 ..@17.looop:
 cmp byte [eax], 0
 je ..@17.endofstring
 inc eax
 jmp ..@17.looop
 ..@17.endofstring:
 sub eax , ecx
 and eax, 1
%line 293+1 calc.s
 cmp eax, 1
 je .odd
 jmp .even
 .odd:
 mov eax, 0
%line 297+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@19.itA_F
 sub eax, 0x30
 jmp ..@19.it0_9
 ..@19.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@19.it0_9:
%line 298+1 calc.s
 jmp .updateCapacity
 .even:
 mov eax, 0
%line 300+0 calc.s
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
%line 301+1 calc.s
 .updateCapacity:
 mov [capacity], eax
 pushad
%line 303+0 calc.s
 push dword [capacity]
 push format_string
 call printf
 add esp, 8
 popad
%line 304+1 calc.s
 .init_stack:
 pushad
 push dword 4
 push dword [capacity]
 call calloc
 add esp, 8
 mov [stack], eax
 sub dword[stack], 4
 mov [stackBase], eax
 popad

 mov edx, [esp+4]

 cmp edx, 2
 jle .noDebug
 mov edx, [esp+8]
 mov edx, [edx+8]
 mov ecx, 0
 mov cx, word [edx]


 cmp cx, 0x642D
 jne .noDebug
 inc byte [debugFlag]

 .noDebug:


 call myCalc
 pushad
%line 333+0 calc.s
 push dword eax
 push hexa_format
 call printf
 add esp, 8
 popad
%line 334+1 calc.s
 pushad
%line 334+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 335+1 calc.s
 call myexit

myCalc:
 push ebp
%line 338+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 339+1 calc.s
 .main_loop:
 pushad
%line 340+0 calc.s
 push dword calc
 push string_format
 call printf
 add esp, 8
 popad
%line 341+1 calc.s
 pushad
%line 341+0 calc.s
 push buff
 call gets
 add esp, 4
 popad
%line 342+1 calc.s
 call parseCommand
 cmp eax, 0x71
 jne .main_loop
 .endMyCalc:
 mov eax, dword [opCounter]
 dec eax
 add esp, 0
%line 348+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 349+1 calc.s
myexit:
 mov eax, [stackBase]
 .freeLoop:
 cmp eax, dword [stack]
 jg .end
 mov ebx, dword [eax]
 pushad
%line 355+0 calc.s
 push ebx
 call freeList
 add esp, 4
 popad
%line 356+1 calc.s
 add eax, 4
 jmp .freeLoop
 .end:

%line 359+0 calc.s
 push ebx
 push ecx
 push edx
 push dword [stackBase]
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 360+1 calc.s
 mov eax, 1
 mov ebx, 0
 int 0x80

Ed_Edd_n_Eddy:
 push ebp
%line 365+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 366+1 calc.s


%line 367+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@33.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@33.notUnderFlow:
%line 368+1 calc.s

%line 368+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
 mov [X], dword eax
 mov [x], dword eax
 mov eax, [stack]
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4


 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [Y], dword ebx
 mov [y], dword ebx
%line 369+1 calc.s
 mov ecx, 0

 mov edx, [x]
%line 371+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 372+1 calc.s
 .x1:
 cmp dword [x], 0
 je .y1
 mov edx, [x]
%line 375+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 376+1 calc.s
 .y1:
 cmp dword [y], 0
 je .z1
 mov edx, [y]
%line 379+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 380+1 calc.s
 .z1:
 push ebx
%line 381+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 382+1 calc.s
 mov [Z], dword eax
 mov [z], dword eax

 .loop:
 mov edx, [x]
%line 386+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 387+1 calc.s
 .x2:
 cmp dword [x], 0
 je .y2
 mov edx, [x]
%line 390+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 391+1 calc.s
 .y2:
 cmp dword [y], 0
 je .z2
 mov edx, [y]
%line 394+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 395+1 calc.s
 .z2:
 push ebx
%line 396+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 397+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 mov [z], dword eax
 jmp .loop

 .beforeEnd:
 cmp ecx, 0
 je .end
 push ebx
%line 405+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 406+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 .end:
 mov edx, dword [Z]
 mov ecx, dword [stack]
 mov [ecx], dword edx
 mov eax, [X]
 pushad
%line 413+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 414+1 calc.s
 mov eax, [Y]
 pushad
%line 415+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 416+1 calc.s

 add esp, 0
%line 417+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 418+1 calc.s

posh:
 push ebp
%line 420+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 421+1 calc.s

 mov eax, [size]
%line 422+0 calc.s
 cmp eax, [capacity]
 jl ..@56.notOverFlow
 pushad
 push dword overflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@56.notOverFlow:
%line 423+1 calc.s
 add dword [size],1
%line 423+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 424+1 calc.s

 mov edx, buff
%line 425+0 calc.s
 ..@60.cleanLoop:
 cmp byte [edx], 0x30
 je ..@60.isZero
 cmp byte [edx], 0
 je ..@60.isNull

 jmp ..@60.endclean
 ..@60.isZero:
 inc edx
 jmp ..@60.cleanLoop
 ..@60.isNull:
 dec edx
 jmp ..@60.endclean
 ..@60.endclean:
%line 426+1 calc.s

%line 426+0 calc.s
 mov eax, edx
 ..@61.looop:
 cmp byte [eax], 0
 je ..@61.endofstring
 inc eax
 jmp ..@61.looop
 ..@61.endofstring:
 sub eax , edx
 and eax, 1
%line 427+1 calc.s
 cmp eax,0
 je .evenlength
 .oddlength:
 mov eax, 0
%line 430+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@63.itA_F
 sub eax, 0x30
 jmp ..@63.it0_9
 ..@63.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@63.it0_9:
%line 431+1 calc.s
 mov ecx, eax


%line 433+0 calc.s
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
 mov [eax], byte cl
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 434+1 calc.s
 add edx, 1
 .evenlength:
 cmp byte [edx], 0
 je .end
 mov eax, 0
%line 438+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@67.itA_F
 sub eax, 0x30
 jmp ..@67.it0_9
 ..@67.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@67.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@68.itA_F
 sub ebx, 0x30
 jmp ..@68.it0_9
 ..@68.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@68.it0_9:
 shl eax, 4
 add eax, ebx
%line 439+1 calc.s
 mov ecx, eax


%line 441+0 calc.s
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
 mov [eax], byte cl
 mov [eax+1], dword ebx
 mov ebx, dword [stack]
 mov [ebx], dword eax
%line 442+1 calc.s
 add edx, 2
 jmp .evenlength

 .end:

%line 446+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 447+1 calc.s


 cmp byte [debugFlag], 0
%line 449+0 calc.s
 je ..@72.noDebug
 pushad
 push eax
 call printNumList
 add esp, 4
 popad
 pushad
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
 ..@72.noDebug:
%line 450+1 calc.s
 add esp, 0
%line 450+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 451+1 calc.s

poop:
 push ebp
 mov ebp, esp


%line 456+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@75.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@75.notUnderFlow:
%line 457+1 calc.s

%line 457+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 458+1 calc.s
 pushad
 push eax
 call printNumList
 add esp, 4
 popad

%line 463+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 464+1 calc.s


 mov eax, [stack]
%line 466+0 calc.s
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4
%line 467+1 calc.s
 .end:
 mov esp, ebp
 pop ebp
 pushad
%line 470+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 471+1 calc.s
 ret


printNumList:
 push ebp
%line 475+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 476+1 calc.s

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
%line 488+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 489+1 calc.s
 mov eax, dword [eax+1]

%line 490+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 491+1 calc.s
 .end:
 add esp, 0
%line 492+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 493+1 calc.s

duplicate:
 push ebp
%line 495+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 496+1 calc.s


%line 497+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@87.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@87.notUnderFlow:
%line 498+1 calc.s
 mov eax, [size]
%line 498+0 calc.s
 cmp eax, [capacity]
 jl ..@90.notOverFlow
 pushad
 push dword overflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@90.notOverFlow:
%line 499+1 calc.s


%line 500+0 calc.s

 mov edx, dword [stack]
 mov edx, dword [edx]
%line 501+1 calc.s
 mov [x], dword edx
 add dword [size],1
%line 502+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 503+1 calc.s
 push ebx
%line 503+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 504+1 calc.s
 mov [z], dword eax
 mov ebx, dword [stack]
 mov [ebx], dword eax


 mov cl, byte [edx]
 mov [eax], byte cl
 mov [eax+1], dword 0

 mov ebx, eax





 .loop:

 mov edx, dword [edx+1]


 cmp dword edx, 0
 je .end


 push ebx
%line 528+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 529+1 calc.s
 mov [ebx+1], dword eax
 mov ebx, dword eax
 mov cl, byte [edx]
 mov [ebx], byte cl
 mov [ebx+1], dword 0

 jmp .loop

 .end:
 add esp, 0
%line 538+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 539+1 calc.s

myAnd:
 push ebp
%line 541+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 542+1 calc.s


%line 543+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@99.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@99.notUnderFlow:
%line 544+1 calc.s

%line 544+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
 mov [X], dword eax
 mov [x], dword eax
 mov eax, [stack]
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4


 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [Y], dword ebx
 mov [y], dword ebx
%line 545+1 calc.s




 .loop:
 cmp eax, 0
 je .end
 cmp ebx, 0
 je .end

 mov eax, [x]
 mov al, byte [eax]
 mov ebx, [y]
 mov cl, byte [ebx]
 and cl, al
 mov [ebx], cl

 mov ebx, [y]
%line 562+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 563+1 calc.s

 jmp .loop

 .end:
 mov eax, [X]
 pushad
%line 568+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 569+1 calc.s
 mov eax, ebx
 pushad
%line 570+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 571+1 calc.s





 .leadloop:

%line 577+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 578+1 calc.s
 mov [y], dword eax
 cmp dword [eax+1], 0
 je .oneLink
 mov eax, dword [eax+1]
 .Zloop:
 mov ebx, dword [eax+1]
 cmp ebx, 0
 je .checkIfZero
 mov [y], dword eax
 mov eax, ebx
 jmp .Zloop
 .checkIfZero:
 cmp byte [eax], 0
 je .removeLink
 add esp, 0
%line 592+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 593+1 calc.s
 .removeLink:

%line 594+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 595+1 calc.s
 mov eax, [y]
 mov dword [eax+1], 0
 jmp .leadloop

 .oneLink:
 add esp, 0
%line 600+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 601+1 calc.s

myOr:
 push ebp
%line 603+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 604+1 calc.s


%line 605+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@114.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@114.notUnderFlow:
%line 606+1 calc.s

%line 606+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
 mov [X], dword eax
 mov [x], dword eax
 mov eax, [stack]
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4


 mov ebx, dword [stack]
 mov ebx, dword [ebx]
 mov [Y], dword ebx
 mov [y], dword ebx
%line 607+1 calc.s




 .loop:
 mov edx, [x]
%line 612+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 613+1 calc.s
 cmp eax, 0
 je .freeX
 cmp ebx, 0
 je .movXtoY

 mov eax, [x]
 mov al, byte [eax]
 mov ebx, [y]
 mov cl, byte [ebx]
 or cl, al
 mov [ebx], cl

 mov ebx, [y]
%line 625+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 626+1 calc.s

 jmp .loop

 .movXtoY:
 mov eax, [x]
 mov eax, dword [eax+1]
 mov ebx, [y]
 mov dword [ebx+1], dword eax
 .freeX:
 mov eax, [X]
 pushad
%line 636+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 637+1 calc.s
 .beforeEnd:
 .end:
 add esp, 0
%line 639+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 640+1 calc.s

myN:


%line 643+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@125.notUnderFlow
 pushad
 push dword underflowMsg
 push string_format
 call printf
 add esp, 8
 popad
 add esp, 0
 mov esp, ebp
 pop ebp
 ret
 ..@125.notUnderFlow:
%line 644+1 calc.s
 mov ecx, 0

%line 645+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 646+1 calc.s
 mov [x], dword eax
 mov [X], dword eax
 mov ebx, dword [eax+1]
 .countLoop:
 cmp ebx, 0
 je .checkOneTwo
 add ecx, 2
 mov eax, dword [eax+1]
 mov ebx, dword [eax+1]
 jmp .countLoop

 .checkOneTwo:
 cmp byte [eax], 0xF
 jle .One
 add ecx, 1

 .One:
 add ecx, 1

 mov edx, [X]
 pushad
%line 666+0 calc.s
 push edx
 call freeList
 add esp, 4
 popad
%line 667+1 calc.s
 mov eax, [stack]
%line 667+0 calc.s
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4
%line 668+1 calc.s

 add dword [size],1
%line 669+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 670+1 calc.s
 push ebx
%line 670+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 671+1 calc.s
 mov edx, eax
 mov ebx, dword [stack]
 mov [ebx], dword eax
 .pushLoop:
 cmp ecx, 0
 je .end
 push ebx
%line 677+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
 mov [eax], byte cl
 mov [eax+1], dword 0
 shr ecx, 8
%line 678+1 calc.s
 mov [edx+1], dword eax
 mov edx, eax
 jmp .pushLoop

 .end:
 add esp, 0
%line 683+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 684+1 calc.s

parseCommand:
 push ebp
%line 686+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 687+1 calc.s
 inc dword [opCounter]
 mov eax, 0
 mov al, byte [buff]

 cmp eax ,0x70
 je user_wants_to_poop
 cmp eax, 0x71
 je end_p
 cmp eax, 0x73
 je debugAc
 cmp eax, 43
 je Ed
 cmp eax, 0x64
 je duplicate_fun
 cmp eax, 0x26
 je and_meow
 cmp eax, 0x7C
 je or_meow
 cmp eax, 0x6E
 je n

 Posh:
 dec dword [opCounter]
 pushad
 call posh
 popad
 jmp end_p
 Ed:
 pushad
 call Ed_Edd_n_Eddy
 popad
 jmp end_p
 debugAc:
 pushad
 pushad
%line 721+0 calc.s
 push dword [size]
 push dword [capacity]
 push dword [stackBase]
 push dword [stack]
 call debug
 add esp, 16
 popad
%line 722+1 calc.s
 popad
 jmp end_p
 user_wants_to_poop:
 pushad
 call poop
 popad
 jmp end_p
 duplicate_fun:
 pushad
 call duplicate
 popad
 jmp end_p
 and_meow:
 pushad
 call myAnd
 popad
 jmp end_p
 or_meow:
 pushad
 call myOr
 popad
 jmp end_p
 n:
 pushad
 call myN
 popad
 jmp end_p


 end_p:
 mov esp, ebp
 pop ebp
 ret

freeList:
 push ebp
%line 757+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 758+1 calc.s

 mov eax, [ebp+8]
 cmp eax, 0
 je .end
 mov ebx , dword [eax+1]
 cmp ebx, 0
 je .release

 pushad
%line 766+0 calc.s
 push ebx
 call freeList
 add esp, 4
 popad
%line 767+1 calc.s

 .release:

%line 769+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 770+1 calc.s

 .end:
 add esp, 0
%line 772+0 calc.s
 mov esp, ebp
 pop ebp
 ret

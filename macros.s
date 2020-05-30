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
 opCounter: dd 0
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

%line 251+1 calc.s


[section .text]
[sectalign 16]
%line 254+0 calc.s
times (((16) - (($-$$) % (16))) % (16)) nop
%line 255+1 calc.s
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

%line 275+0 calc.s
 mov eax, ecx
 ..@17.looop:
 cmp byte [eax], 0
 je ..@17.endofstring
 inc eax
 jmp ..@17.looop
 ..@17.endofstring:
 sub eax , ecx
 and eax, 1
%line 276+1 calc.s
 cmp eax, 1
 je .odd
 jmp .even
 .odd:
 mov eax, 0
%line 280+0 calc.s
 mov al, byte [ecx]
 cmp eax, 0x41
 jge ..@19.itA_F
 sub eax, 0x30
 jmp ..@19.it0_9
 ..@19.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@19.it0_9:
%line 281+1 calc.s
 jmp .updateCapacity
 .even:
 mov eax, 0
%line 283+0 calc.s
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
%line 284+1 calc.s
 .updateCapacity:
 mov [capacity], eax
 push dword [capacity]
%line 286+0 calc.s
 push format_string
 call printf
%line 287+1 calc.s
 .init_stack:
 push dword 4
 push dword [capacity]
 call calloc
 mov [stack], eax
 sub dword[stack], 4
 mov [stackBase], eax

 call myCalc
 pushad
%line 296+0 calc.s
 push dword eax
 push hexa_format
 call printf
 add esp, 8
 popad
%line 297+1 calc.s
 pushad
%line 297+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 298+1 calc.s
 call myexit

myCalc:
 push ebp
%line 301+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 302+1 calc.s
 .main_loop:
 pushad
%line 303+0 calc.s
 push buff
 call gets
 add esp, 4
 popad
%line 304+1 calc.s
 call parseCommand
 cmp eax, 0x71
 jne .main_loop
 .endMyCalc:
 mov eax, dword [opCounter]
 dec eax
 add esp, 0
%line 310+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 311+1 calc.s
myexit:
 mov eax, [stackBase]
 .freeLoop:
 cmp eax, dword [stack]
 jg .end
 mov ebx, dword [eax]
 pushad
%line 317+0 calc.s
 push ebx
 call freeList
 add esp, 4
 popad
%line 318+1 calc.s
 add eax, 4
 jmp .freeLoop
 .end:

%line 321+0 calc.s
 push ebx
 push ecx
 push edx
 push dword [stackBase]
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 322+1 calc.s
 mov eax, 1
 mov ebx, 0
 int 0x80

Ed_Edd_n_Eddy:
 push ebp
%line 327+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 328+1 calc.s


%line 329+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@32.notUnderFlow
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
 ..@32.notUnderFlow:
%line 330+1 calc.s

%line 330+0 calc.s

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
%line 331+1 calc.s
 mov ecx, 0

 mov edx, [x]
%line 333+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 334+1 calc.s
 .x1:
 cmp dword [x], 0
 je .y1
 mov edx, [x]
%line 337+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 338+1 calc.s
 .y1:
 cmp dword [y], 0
 je .z1
 mov edx, [y]
%line 341+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 342+1 calc.s
 .z1:
 push ebx
%line 343+0 calc.s
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
%line 344+1 calc.s
 mov [Z], dword eax
 mov [z], dword eax

 .loop:
 mov edx, [x]
%line 348+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 349+1 calc.s
 .x2:
 cmp dword [x], 0
 je .y2
 mov edx, [x]
%line 352+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [x], edx
%line 353+1 calc.s
 .y2:
 cmp dword [y], 0
 je .z2
 mov edx, [y]
%line 356+0 calc.s
 mov ebx, 0
 add bl, byte [edx]
 add ecx, ebx
 mov edx, dword [edx+1]
 mov [y], edx
%line 357+1 calc.s
 .z2:
 push ebx
%line 358+0 calc.s
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
%line 359+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 mov [z], dword eax
 jmp .loop

 .beforeEnd:
 cmp ecx, 0
 je .end
 push ebx
%line 367+0 calc.s
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
%line 368+1 calc.s
 mov edx, dword [z]
 mov [edx+1], dword eax
 .end:
 mov edx, dword [Z]
 mov ecx, dword [stack]
 mov [ecx], dword edx
 mov eax, [X]
 pushad
%line 375+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 376+1 calc.s
 mov eax, [Y]
 pushad
%line 377+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 378+1 calc.s

 add esp, 0
%line 379+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 380+1 calc.s

posh:
 push ebp
%line 382+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 383+1 calc.s

 mov eax, [size]
%line 384+0 calc.s
 cmp eax, [capacity]
 jl ..@55.notOverFlow
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
 ..@55.notOverFlow:
%line 385+1 calc.s
 add dword [size],1
%line 385+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 386+1 calc.s

 mov edx, buff
%line 387+0 calc.s
 ..@59.cleanLoop:
 cmp byte [edx], 0x30
 je ..@59.isZero
 cmp byte [edx], 0
 je ..@59.isNull

 jmp ..@59.endclean
 ..@59.isZero:
 inc edx
 jmp ..@59.cleanLoop
 ..@59.isNull:
 dec edx
 jmp ..@59.endclean
 ..@59.endclean:
%line 388+1 calc.s

%line 388+0 calc.s
 mov eax, edx
 ..@60.looop:
 cmp byte [eax], 0
 je ..@60.endofstring
 inc eax
 jmp ..@60.looop
 ..@60.endofstring:
 sub eax , edx
 and eax, 1
%line 389+1 calc.s
 cmp eax,0
 je .evenlength
 .oddlength:
 mov eax, 0
%line 392+0 calc.s
 mov al, byte [edx]
 cmp eax, 0x41
 jge ..@62.itA_F
 sub eax, 0x30
 jmp ..@62.it0_9
 ..@62.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@62.it0_9:
%line 393+1 calc.s
 mov ecx, eax


%line 395+0 calc.s
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
%line 396+1 calc.s
 add edx, 1
 .evenlength:
 cmp byte [edx], 0
 je .end
 mov eax, 0
%line 400+0 calc.s
 mov al, [edx]
 cmp eax, 0x41
 jge ..@66.itA_F
 sub eax, 0x30
 jmp ..@66.it0_9
 ..@66.itA_F:
 sub eax, 0x41
 add eax, 10
 ..@66.it0_9:
 mov ebx, 0
 mov bl, [edx+1]
 cmp ebx, 0x41
 jge ..@67.itA_F
 sub ebx, 0x30
 jmp ..@67.it0_9
 ..@67.itA_F:
 sub ebx, 0x41
 add ebx, 10
 ..@67.it0_9:
 shl eax, 4
 add eax, ebx
%line 401+1 calc.s
 mov ecx, eax


%line 403+0 calc.s
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
%line 404+1 calc.s
 add edx, 2
 jmp .evenlength
 .end:
 add esp, 0
%line 407+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 408+1 calc.s

poop:
 push ebp
 mov ebp, esp


%line 413+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@71.notUnderFlow
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
 ..@71.notUnderFlow:
%line 414+1 calc.s

%line 414+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 415+1 calc.s
 pushad
 push eax
 call printNumList
 add esp, 4
 popad

%line 420+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 421+1 calc.s


 mov eax, [stack]
%line 423+0 calc.s
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4
%line 424+1 calc.s
 .end:
 mov esp, ebp
 pop ebp
 pushad
%line 427+0 calc.s
 push dword mynew_line
 push string_format
 call printf
 add esp, 8
 popad
%line 428+1 calc.s
 ret


printNumList:
 push ebp
%line 432+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 433+1 calc.s

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
%line 445+0 calc.s
 push dword ebx
 push hexa_format
 call printf
 add esp, 8
 popad
%line 446+1 calc.s
 mov eax, dword [eax+1]

%line 447+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 448+1 calc.s
 .end:
 add esp, 0
%line 449+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 450+1 calc.s

duplicate:
 push ebp
%line 452+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 453+1 calc.s


%line 454+0 calc.s
 mov eax, [size]
 cmp eax, 1
 jge ..@83.notUnderFlow
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
 ..@83.notUnderFlow:
%line 455+1 calc.s
 mov eax, [size]
%line 455+0 calc.s
 cmp eax, [capacity]
 jl ..@86.notOverFlow
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
 ..@86.notOverFlow:
%line 456+1 calc.s


%line 457+0 calc.s

 mov edx, dword [stack]
 mov edx, dword [edx]
%line 458+1 calc.s
 mov [x], dword edx
 add dword [size],1
%line 459+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 460+1 calc.s
 push ebx
%line 460+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 461+1 calc.s
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
%line 485+0 calc.s
 push ecx
 push edx
 push dword 5
 call malloc
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 486+1 calc.s
 mov [ebx+1], dword eax
 mov ebx, dword eax
 mov cl, byte [edx]
 mov [ebx], byte cl
 mov [ebx+1], dword 0

 jmp .loop

 .end:
 add esp, 0
%line 495+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 496+1 calc.s

myAnd:
 push ebp
%line 498+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 499+1 calc.s


%line 500+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@95.notUnderFlow
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
 ..@95.notUnderFlow:
%line 501+1 calc.s

%line 501+0 calc.s

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
%line 502+1 calc.s




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
%line 519+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 520+1 calc.s

 jmp .loop

 .end:
 mov eax, [X]
 pushad
%line 525+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 526+1 calc.s
 mov eax, ebx
 pushad
%line 527+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 528+1 calc.s
 add esp, 0
%line 528+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 529+1 calc.s

myOr:
 push ebp
%line 531+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 532+1 calc.s


%line 533+0 calc.s
 mov eax, [size]
 cmp eax, 2
 jge ..@107.notUnderFlow
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
 ..@107.notUnderFlow:
%line 534+1 calc.s

%line 534+0 calc.s

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
%line 535+1 calc.s




 .loop:
 mov edx, [x]
%line 540+0 calc.s
 add edx, [y]
 cmp edx, 0
 je .beforeEnd
%line 541+1 calc.s
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
%line 553+0 calc.s
 mov ebx, dword [ebx+1]
 mov [y], dword ebx
 mov eax, [x]
 mov eax, dword [eax+1]
 mov [x], dword eax
%line 554+1 calc.s

 jmp .loop

 .movXtoY:
 mov eax, [x]
 mov eax, dword [eax+1]
 mov ebx, [y]
 mov dword [ebx+1], dword eax
 .freeX:
 mov eax, [X]
 pushad
%line 564+0 calc.s
 push eax
 call freeList
 add esp, 4
 popad
%line 565+1 calc.s
 .beforeEnd:
 .end:
 add esp, 0
%line 567+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 568+1 calc.s

myN:

 mov ecx, 0

%line 572+0 calc.s

 mov eax, dword [stack]
 mov eax, dword [eax]
%line 573+1 calc.s

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
%line 594+0 calc.s
 push edx
 call freeList
 add esp, 4
 popad
%line 595+1 calc.s
 mov eax, [stack]
%line 595+0 calc.s
 mov [eax], dword 0
 sub dword [size], 1
 sub byte [stack], 4
%line 596+1 calc.s

 add dword [size],1
%line 597+0 calc.s
 add byte [stack], 4
 mov eax, [stack]
 mov dword [eax], dword 0
%line 598+1 calc.s
 push ebx
%line 598+0 calc.s
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
%line 599+1 calc.s
 mov edx, eax
 mov ebx, dword [stack]
 mov [ebx], dword eax
 .pushLoop:
 cmp ecx, 0
 je .end
 push ebx
%line 605+0 calc.s
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
%line 606+1 calc.s
 mov [edx+1], dword eax
 mov edx, eax
 jmp .pushLoop

 .end:
 add esp, 0
%line 611+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 612+1 calc.s

parseCommand:
 push ebp
%line 614+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 615+1 calc.s
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
%line 649+0 calc.s
 push dword [size]
 push dword [capacity]
 push dword [stackBase]
 push dword [stack]
 call debug
 add esp, 16
 popad
%line 650+1 calc.s
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
%line 685+0 calc.s
 mov ebp, esp
 sub esp, 0
%line 686+1 calc.s

 mov eax, [ebp+8]
 cmp eax, 0
 je .end
 mov ebx , dword [eax+1]
 cmp ebx, 0
 je .release

 pushad
%line 694+0 calc.s
 push ebx
 call freeList
 add esp, 4
 popad
%line 695+1 calc.s

 .release:

%line 697+0 calc.s
 push ebx
 push ecx
 push edx
 push dword eax
 call free
 add esp, 4
 pop edx
 pop ecx
 pop ebx
%line 698+1 calc.s

 .end:
 add esp, 0
%line 700+0 calc.s
 mov esp, ebp
 pop ebp
 ret
%line 701+1 calc.s


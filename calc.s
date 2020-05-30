section	.rodata ;constats
    overflowMsg: db "Error: Operand Stack Overflow",10,0
    underflowMsg: db "Error: Insufficient Number of Arguments on Stack",10,0
    format_string: db "%d", 10, 0	; format string
    hexa_format: db "%X",0
    string_format: db "%s",0
    mynew_line: db "",10,0

section .data           ; inisiliazed vars
    size: dd 0
    capacity: dd 5    
    opCounter: dd 0
section .bss            ; uninitilaized vars
    stack: resd 1       ; dynamic stack pointer
    stackBase: resd 1   ; pointer to head of stack
    buff: resb 81
    X: resd 1
    Y: resd 1
    Z: resd 1
    x: resd 1
    y: resd 1
    z: resd 1
    
%define EXIT_SUCCESS 0
%define SIGEXIT 1
%define _0 0x30
%define _A 0x41
%macro printNumber 1
    push dword %1
    push format_string
    call printf
%endmacro
%macro printHexDigit 1
    pushad              
    push dword %1
    push hexa_format
    call printf
    add esp, 8
    popad
%endmacro
%macro printString 1
    pushad              
    push dword %1
    push string_format
    call printf
    add esp, 8
    popad
%endmacro
%macro asciiToHex 1
    cmp %1, _A
	jge %%itA_F
	sub %1, _0 ; 
	jmp %%it0_9
	%%itA_F:
	sub %1, _A ; %1 - 'A'
    add %1, 10
	%%it0_9:
%endmacro
%macro parseOneChar 1
    mov eax, 0
    mov al, byte [%1]
    asciiToHex eax
%endmacro
%macro parseTwochars 1
    mov eax, 0
    mov al, [%1]
    asciiToHex eax
    mov ebx, 0
    mov bl, [%1+1]
    asciiToHex ebx
    shl eax, 4
    add eax, ebx
%endmacro
%macro checkLengthPairty 1
    ;if odd eax==1, if even eax ==0
    mov eax, %1
    %%looop:
    cmp byte [eax], 0 
    je %%endofstring 
    inc eax
    jmp %%looop
    %%endofstring:
    sub eax , %1
    and eax, 1 
%endmacro
%macro myMalloc 1
    push ebx
    push ecx
    push edx              
    push dword %1
    call malloc
    add esp, 4
    pop edx
    pop ecx
    pop ebx
%endmacro
%macro myFree 1
    ; arg has to be eax
    push ebx
    push ecx
    push edx              
    push dword %1
    call free
    add esp, 4
    pop edx
    pop ecx
    pop ebx
%endmacro
%macro myGets 1
    pushad              
    push %1
    call gets
    add esp, 4
    popad
%endmacro
%macro debug 0
    pushad
    push dword [size]
    push dword [capacity]              
    push dword [stackBase]
    push dword [stack]
    call debug
    add esp, 16
    popad
%endmacro
%macro pushNewLink 1
    ; %1 data
    myMalloc 5                 ; eax will point to new-link
    mov ebx, dword [stack]      ; pointer to pointer head of linked list
    mov ebx, dword [ebx]        ; pointer to head linked list
    mov [eax], byte %1          ; new-link.data <- %1 (byte)
    mov [eax+1], dword ebx      ; new-link.next <- old head
    mov ebx, dword [stack]      ; pointer to pointer head of linked list
    mov [ebx], dword eax        ; head <- new-link
%endmacro
%macro incStack 0
    add dword [size],1
    add byte [stack], 4         ; move top pointer
    mov eax, [stack]
    mov dword [eax], dword 0    ; init as null pointer
%endmacro
%macro decStack 0
    mov eax, [stack]
    mov [eax], dword 0          ; null in [[stack]]
    sub dword [size], 1
    sub byte [stack], 4         ; move top pointer
%endmacro
%macro getHeadOfNum 1
        ;;%1 can be only a register
        ;;%1 <- head
    mov %1, dword [stack]       ; pointer to pointer head of linked list
    mov %1, dword [%1]          ; pointer to head linked list
%endmacro
%macro startFunc 1
    push ebp
    mov ebp, esp
    sub esp, %1
%endmacro
%macro endFunc 1
    add esp, %1
    mov esp, ebp
    pop ebp
    ret
%endmacro
%macro checkUnderflow 1 
    ;%1 is number of rands needed
    mov eax, [size]         ; check if size allow duplication
    cmp eax, %1              ; size ?= 0
    jge %%notUnderFlow
    printString underflowMsg
    endFunc 0
    %%notUnderFlow:
%endmacro
%macro checkOverflow 0
    mov eax, [size]
    cmp eax,  [capacity]    ; size ?= capacity
    jl %%notOverFlow
    printString overflowMsg
    endFunc 0
    %%notOverFlow:
%endmacro
%macro startLoop 0
    mov edx, [x]            ; edx <- pointer to link  
    add edx, [y]            ; edx <- pointer to xl + pointer to yl
    cmp edx, 0              ; x & y ? != 0
    je .beforeEnd              ; end of addition (both null_ptr)
%endmacro
%macro xTreatment 0
    mov edx, [x]            ; edx <- pointer to xl
    mov ebx, 0              ; preper ebx
    add bl, byte [edx]      ; bl <- xl.value
    add ecx, ebx            ; c <- c + xl.value
    mov edx, dword [edx+1]  ; edx <- xl.next
    mov [x], edx            ; x <- edx (=xl.next)
%endmacro
%macro yTreatment 0
    mov edx, [y]            ; edx <- yl
    mov ebx, 0
    add bl, byte [edx]      ; c <- c + yl.value
    add ecx, ebx            ; c <- c + yl.value
    mov edx, dword [edx+1]  ; edx <- yl.next
    mov [y], edx            ; y <- edx (=yl.next)
%endmacro
%macro creatNewLinkForZ 0
    myMalloc 5              ; allocate new link for Z
    mov [eax], byte cl      ; link value <- 8 lsb of carry
    mov [eax+1], dword 0    ; link pointr <- null
    shr ecx, 8              ; decrease carry by 8 bits
%endmacro
%macro first_2_nums_in_Xx_Yy 0
    getHeadOfNum eax        ; eax <- pointer to first number in stack
    mov [X], dword eax      ; X <- pointer to first num
    mov [x], dword eax      ; x <- pointer to first num
    decStack                ; move 'stack' pointer to second num, decreas size
    getHeadOfNum ebx        ; eax <- pointer to first (=second) number in stack
    mov [Y], dword ebx      ; Y <- pointer to second num
    mov [y], dword ebx      ; y <- pointer to second num
%endmacro
%macro x_y_forward 0
    mov ebx, [y]
    mov ebx, dword [ebx+1]      ; y++
    mov [y], dword ebx
    mov eax, [x]                
    mov eax, dword [eax+1]      ; x++
    mov [x], dword eax
%endmacro
%macro myfreeList 1
    pushad
    push %1
    call freeList
    add esp, 4 
    popad
%endmacro
%macro cleanLeadingZerosAndPutHeadInEDX 0
    mov edx, buff
    %%cleanLoop:
        cmp byte [edx], 0x30 ; [edx] ?= '0'
        je %%isZero
        cmp byte [edx], 0 
        je %%isNull
        ;is a digit
        jmp %%endclean
        %%isZero:
            inc edx
            jmp %%cleanLoop
        %%isNull:
            dec edx
            jmp %%endclean
    %%endclean:
%endmacro


section .text
  align 16
  global main
  extern printf
  extern fprintf 
  extern fflush
  extern malloc 
  extern calloc 
  extern free 
  extern gets 
  extern getchar 
  extern fgets 
  extern debug
main:
    ; #####  INITIALIZING OPERAND STACK  #######
    mov eax, [esp+4]            ; argc
    cmp eax, 1                  ; cheack if argc >1
    jg .update_stack_size        ; if argc>1 -> argv[1] = stacksize
    jmp .init_stack          
    .update_stack_size:
        mov eax, [esp+8]        ; put argv pointer in eax
        mov ecx, [eax+4]        ; put argv[1] in ecx
        checkLengthPairty ecx   ; chack if number length is odd, return value in eax
        cmp eax, 1              
        je .odd                  ; if odd
        jmp .even                ; else even
    .odd:
        parseOneChar ecx        ; returned value in eax
        jmp .updateCapacity      
    .even:
        parseTwochars ecx       ; returned value in eax
    .updateCapacity:
        mov [capacity], eax     ; [capasity] <- eax = (decimal) capacity
        printNumber [capacity]
    .init_stack:
        push dword 4            ; calloc first arg
        push dword [capacity]   ; calloc second arg
        call calloc             ; allocate memory for opetand stack. eax <- stack pointer
        mov [stack], eax       ; pointer to end of stack
        sub dword[stack], 4
        mov [stackBase], eax

    call myCalc
    printHexDigit eax
    printString mynew_line
    call myexit

myCalc:
    startFunc 0
    .main_loop:
            myGets buff 
            call parseCommand
            cmp eax, 0x71 ;is eax ?!= 'q'
            jne .main_loop
    .endMyCalc:
        mov eax, dword [opCounter]
        dec eax ;we counted 'q' as well, so... you know
    endFunc 0   
myexit:
    mov eax, [stackBase]                  ; index = 1
    .freeLoop:        
        cmp eax, dword [stack]
        jg .end
        mov ebx, dword [eax]
        myfreeList ebx
        add eax, 4
        jmp .freeLoop
    .end:
    myFree [stackBase]          ; free operand stack
    mov eax,  SIGEXIT           ; call exit sys_call
    mov ebx, EXIT_SUCCESS       ; exit msg - seccess
    int 0x80 

Ed_Edd_n_Eddy:              ; addition
    startFunc 0

    checkUnderflow 2        ; end if size < 2
    first_2_nums_in_Xx_Yy
    mov ecx, 0              ; ecx <- int carry
   
    startLoop               ; end if both null_ptr
    .x1:
        cmp dword [x], 0        ; is x null_ptr?
        je .y1                  ; if yes jump to check y
        xTreatment
    .y1:
        cmp dword [y], 0        ; is y null_ptr?
        je .z1                  ; if yes jump to z
        yTreatment
    .z1:
        creatNewLinkForZ
        mov [Z], dword eax      ; update Z <- first link address
        mov [z], dword eax      ; z <- first link address
    
    .loop:
        startLoop
        .x2:
            cmp dword [x], 0         ; is x null_ptr?
            je .y2                   ; if yes jump to check y
            xTreatment               ; treat x macro
        .y2:
            cmp dword [y], 0         ; is y null_ptr?
            je .z2                   ; if yes jump to z
            yTreatment               ; treat y macro
        .z2:
            creatNewLinkForZ
            mov edx, dword [z]        ; edx <- current link
            mov [edx+1], dword eax    ; l.next <- new-link
            mov [z], dword eax        ; z <- first link address
    jmp .loop

    .beforeEnd:
        cmp ecx, 0              ; if carry 0
        je .end                 ; no need another link
        creatNewLinkForZ        ; else, create 1 more link
        mov edx, dword [z]      ; edx <- curr link            
        mov [edx+1], dword eax  ; l.next <- new link
    .end:
        mov edx, dword [Z]          ; edx <- first link of new number
        mov ecx, dword [stack]      ; ecx <- location  of new number
        mov [ecx], dword edx        ; [[stack]] <- first link of new num
        mov eax, [X]                ; free X
        myfreeList eax
        mov eax, [Y]                ; free Y
        myfreeList eax
        
    endFunc 0

posh:
    startFunc 0           

    checkOverflow           ; end if stack is full
    incStack                ; else, size++
    ; mov edx, buff           ; we gonna mess with this pointer
    cleanLeadingZerosAndPutHeadInEDX
    checkLengthPairty edx  ; returned value in eax
    cmp eax,0               ; if buff size is even
    je .evenlength
    .oddlength:
        parseOneChar edx    ; returned value in eax
        mov ecx, eax        ; ecx <- data (becuase next macro mess with eax)
        ; printHexDigit ecx   ; 
        pushNewLink cl
        add edx, 1 
    .evenlength:
        cmp byte [edx], 0
        je  .end
        parseTwochars edx
        mov ecx, eax        ; ecx <- data (becuase next macro mess with eax)
        ; printHexDigit ecx
        pushNewLink cl
        add edx, 2
        jmp .evenlength
    .end:
        endFunc 0

poop:
    push ebp
    mov ebp, esp
    
    checkUnderflow 1    ; end if there is less than 1 num
    getHeadOfNum eax
    pushad
    push eax            ; push first link
    call printNumList   ; recursize function
    add esp, 4          ; pop to void
    popad
    myFree eax
    ; mov eax, [stack]
    ; mov [eax], dword 0   ;nullinh [stack]
    decStack
    .end:
    mov esp, ebp    
    pop ebp
    printString mynew_line
    ret
    

printNumList:
    startFunc 0

    mov eax, [ebp+8]        ;get link* l (given parameter)
    cmp eax, 0              ;if (l == null_ptr)
    je .end                 ;jmp to end
    mov ebx , dword[eax+1]  ;else ebx<-l.next
    pushad                  ;backup registers
    push ebx                ;argument of recursive call
    call printNumList       ;recursive call
    add esp, 4              ;pop to void
    popad
    mov ebx, 0              ;importent
    mov bl , byte [eax]     ;ebx <- l.value
    printHexDigit ebx
    mov eax, dword [eax+1]        ;eax<-l.next
    myFree eax
    .end:
    endFunc 0

duplicate:
    startFunc 0
    
    checkUnderflow 1        ; ened if there is less than 1 num
    checkOverflow

    getHeadOfNum edx        ; pointer to first num link in edx
    mov [x], dword edx      ; pionter to first num link in x
    incStack                ; stack++ size++
    myMalloc 5              ; creat new link
    mov [z], dword eax      ; z holds new link address
    mov ebx, dword [stack]  ; ebx <- [stack]
    mov [ebx], dword eax    ; [[stack]] <- new link address

    ; copy xlink data
    mov cl, byte [edx]     ; ebx <- xl data 
    mov [eax], byte cl     ; zl data <- xl data
    mov [eax+1], dword 0   ; zl points to null

    mov ebx, eax          ; in loop ebx holds z !

    ; eax = the created new link
    ; ebx = the previeus link
    ; cl = data in origin link
    ; edx = the origin link
    .loop:
    ; x++
    mov edx, dword [edx+1]  ; edx([x]) <- pointer to next link
    
    ; end ?
    cmp dword edx, 0        ; edx holds poiner to next link
    je .end                  ; if pointer to null, finish

    ; create new link
    myMalloc 5              ; create new link for z, return in eax
    mov [ebx+1], dword eax  ; ecx holds z, z.next <- eax
    mov ebx, dword eax      ; z <- next link
    mov cl, byte [edx]     ; ebx <- xl data 
    mov [ebx], byte cl     ; zl data <- xl data
    mov [ebx+1], dword 0    ; zl.next <- 0

    jmp .loop

    .end:
    endFunc 0

myAnd:
    startFunc 0

    checkUnderflow 2
    first_2_nums_in_Xx_Yy

    ; eax = xl
    ; ebx = yl
    ; cl = and(bl&al) result 
    .loop:
        cmp eax, 0          ; end if x is null
        je .end
        cmp ebx, 0          ; end if y is null
        je .end

        mov eax, [x]                 
        mov al, byte [eax]     ; eax <- x data
        mov ebx, [y]
        mov cl, byte [ebx]     ; ecx <- y data
        and cl, al             ; cl <- cl & al
        mov [ebx], cl          ; update y data to be cl

        x_y_forward

        jmp .loop

    .end:
        mov eax, [X]        ; free whole X
        myfreeList eax
        mov eax, ebx        ; free rest of y if needed
        myfreeList eax
    endFunc 0

myOr:
    startFunc 0

    checkUnderflow 2
    first_2_nums_in_Xx_Yy
    
    ; eax = xl
    ; ebx = yl
    ; cl = and(bl|al) result 
    .loop:
        startLoop               ; end if both null
        cmp eax, 0              ; if x reached to null
        je .freeX
        cmp ebx, 0              ; if y reached to null
        je .movXtoY             ; mov x tail to y and free x

        mov eax, [x]                 
        mov al, byte [eax]     ; eax <- x data
        mov ebx, [y]
        mov cl, byte [ebx]     ; ecx <- y data
        or cl, al              ; cl <- cl & al
        mov [ebx], cl          ; update y data to be cl

        x_y_forward

        jmp .loop

    .movXtoY:
        mov eax, [x]                 
        mov eax, dword [eax+1]          ; eax <- x.next
        mov ebx, [y]
        mov dword [ebx+1], dword eax    ; y.next <- x.next
    .freeX:
        mov eax, [X]        ; free whole X
        myfreeList eax
    .beforeEnd:
    .end:
    endFunc 0

myN:
    ; ecx is the counter
    mov ecx, 0
    mov eax, dword [stack]      ; pointer to first link
    mov [x], dword eax          ; pointer to first link in [x]
    mov [X], dword eax          ; also in [X], inorder to free later?
    mov ebx, dword [eax+1]      ; ebx <- pionter to next link
    .countLoop:
        cmp ebx, 0              ; if l.next is null
        je .checkOneTwo         ; check the last number
        add ecx, 2              ; add two to counter
        mov eax, dword [eax+1]  ; l <- l.next
        mov ebx, dword [eax+1]  ; ebx <- l.next
        jmp .countLoop

    .checkOneTwo:
        cmp byte [eax], 0xF
        jle .One
        add ecx, 1

    .One:
        add ecx, 1
    
    mov edx, [X]
    myfreeList edx
    decStack
    
    incStack
    creatNewLinkForZ
    mov edx, eax
    mov ebx, dword [stack]
    mov [ebx], dword eax            ; [[stack]] <- new link
    .pushLoop:
        cmp ecx, 0       ; no more links needed
        je .end
        creatNewLinkForZ
        mov [edx+1], dword eax
        mov edx, eax
        jmp .pushLoop

    .end:
    endFunc 0

parseCommand:
    startFunc 0
    inc dword [opCounter]
    mov eax, 0
    mov al, byte [buff] ;eax <- (char)buff[0]
    
    cmp eax ,0x70       ;'p'
    je user_wants_to_poop
    cmp eax, 0x71       ;'q'
    je end_p
    cmp eax, 0x73       ;'s'
    je debugAc
    cmp eax, 43         ;'+'
    je Ed
    cmp eax, 0x64       ;'d'
    je duplicate_fun
    cmp eax, 0x26       ;'&'
    je and_meow
    cmp eax, 0x7C       ;'|'
    je or_meow
    cmp eax, 0x6E       ;'n'
    je n
    
    Posh:
    dec dword [opCounter] ;lo yafe aval ofe
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
    debug
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
    startFunc 0
    
    mov eax, [ebp+8]         ; get link* l (given parameter)
    cmp eax, 0
    je .end
    mov ebx , dword [eax+1]  ; ebx <- l.next
    cmp ebx, 0               ; if l.next == nptr
    je .release              ; release l

    myfreeList ebx

    .release:
    myFree eax

    .end:
    endFunc 0


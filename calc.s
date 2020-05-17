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
    sub dword [size], 1
    sub byte [stack], 4         ;move top pointer
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
%macro loopContent 0
    mov edx, [x]
    add edx, [y]
    cmp edx, 0      ;x&y ?!= 0
    je .end
        %%x:
        cmp dword [x], 0    ;is x null_ptr?
        je %%y             ;if yes jump to y
        mov edx, [x]        ;edx<- l
        mov ebx, 0
        add bl, byte [edx] ;bl <- l.value
        add ecx, ebx ;c <- c + l.value
        mov edx, dword [edx+1]    ;x <- l.next
        mov [x], edx
        %%y:
        cmp dword [y], 0    ;is y null_ptr?
        je %%z             ;if yes jump to z
        mov edx, [y]        ;edx<- l
        mov ebx, 0
        add bl, byte [edx] ;c <- c + l.value
        add ecx, ebx ;c <- c + l.value
        mov edx, dword [edx+1]  ;y <- l.next
        mov [y], edx
        %%z:
        myMalloc 5
        mov ebx, 0
        add bl, byte [edx] ;c <- c + l.value
        mov [eax], byte cl
        mov [eax+1], dword 0 

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
    jg update_stack_size        ; if argc>1 -> argv[1] = stacksize
    jmp init_stack          
    update_stack_size:
        mov eax, [esp+8]        ; put argv pointer in eax
        mov ecx, [eax+4]        ; put argv[1] in ecx
        checkLengthPairty ecx   ; chack if number length is odd, return value in eax
        cmp eax, 1              
        je odd                  ; if odd
        jmp even                ; else even
    odd:
        parseOneChar ecx        ; returned value in eax
        jmp updateCapacity      
    even:
        parseTwochars ecx       ; returned value in eax
    updateCapacity:
        mov [capacity], eax     ; [capasity] <- eax = (decimal) capacity
        printNumber [capacity]
    init_stack:
        push dword 4            ; calloc first arg
        push dword [capacity]   ; calloc second arg
        call calloc             ; allocate memory for opetand stack. eax <- stack pointer
        mov [stack], eax       ; pointer to end of stack
        sub dword[stack], 4
        mov [stackBase], eax
    
    ; #####  MAIN LOOP  #####
    main_loop:
        myGets buff 
        call parseCommand
        jmp main_loop
myexit:
    myFree [stackBase]          ; free operand stack
    mov eax,  SIGEXIT           ; call exit sys_call
    mov ebx, EXIT_SUCCESS       ; exit msg - seccess
    int 0x80 

Ed_Edd_n_Eddy:              ; addition
    startFunc 0
    mov eax, [size]         ; eax <- curr stack size
    cmp eax, 2              ; if eax < 2
    jl underflow            ; return underflow
    getHeadOfNum eax        ; eax <- pointer to first number in stack
    mov [X], dword eax      ; X <- pointer to first num
    mov [x], dword eax      ; x <- pointer to first num
    decStack                ; move 'stack' pointer to second num, decreas size
    getHeadOfNum eax        ; eax <- pointer to first (=second) number in stack
    mov [Y], dword eax      ; Y <- pointer to second num
    mov [y], dword eax      ; y <- pointer to second num
    mov ecx, 0              ; ecx <- int carry
   
    mov edx, [x]            ; edx <- pointer to link  
    add edx, [y]            ; edx <- pointer to xl + pointer to yl
    cmp edx, 0              ; x & y ? != 0
    je .Addend               ; end of addition (both null_ptr)
    .x1:
        cmp dword [x], 0        ; is x null_ptr?
        je .y1                   ; if yes jump to check y
        mov edx, [x]            ; edx <- pointer to xl
        mov ebx, 0              ; preper ebx
        add bl, byte [edx]      ; bl <- xl.value
        add ecx, ebx            ; c <- c + xl.value
        mov edx, dword [edx+1]  ; edx <- xl.next
        mov [x], edx            ; x <- edx (=xl.next)
    .y1:
        cmp dword [y], 0        ; is y null_ptr?
        je .z1                   ; if yes jump to z
        mov edx, [y]            ; edx <- yl
        mov ebx, 0
        add bl, byte [edx]      ; c <- c + yl.value
        add ecx, ebx            ; c <- c + yl.value
        mov edx, dword [edx+1]  ; edx <- yl.next
        mov [y], edx            ; y <- edx (=yl.next)
    .z1:
        myMalloc 5              ; allocate new link for Z
        mov [eax], byte cl      ; link value <- 8 lsb of carry
        mov [eax+1], dword 0    ; link pointr <- null

        mov [Z], eax       ; update Z <- first link address
        mov [z], eax       ; z <- first link address
        shr ecx, 8         ; decrease carry by 8 bits


    .Addloop:
        mov edx, [x]
        add edx, [y]
        cmp edx, 0      ;x&y ?!= 0
        je .Addend

    .x2:
        cmp dword [x], 0    ;is x null_ptr?
        je .y2             ;if yes jump to y
        mov edx, [x]        ;edx<- l
        mov ebx, 0
        add bl, byte [edx] ;bl <- l.value
        add ecx, ebx ;c <- c + l.value
        mov edx, dword [edx+1]    ;x <- l.next
        mov [x], edx
    .y2:
        cmp dword [y], 0    ;is y null_ptr?
        je .z2             ;if yes jump to z
        mov edx, [y]        ;edx<- l
        mov ebx, 0
        add bl, byte [edx] ;c <- c + l.value
        add ecx, ebx ;c <- c + l.value
        mov edx, dword [edx+1]  ;y <- l.next
        mov [y], edx
    .z2:
        myMalloc 5
        mov [eax], byte cl
        mov [eax+1], dword 0 

    mov edx, [z]
    mov [edx+1], eax    ;l.next<- new-link
    mov [z], eax        ;z <- l.next
    shr ecx, 8
    jmp .Addloop

    .Addend:
    cmp ecx, 0
    je .Addendend
    myMalloc 5
    mov [eax], byte cl
    mov [eax+1], dword 0
    mov edx, [z]
    mov [edx+1], dword eax
    .Addendend:
        mov edx, dword [Z]
        mov ecx, dword [stack]
        mov [ecx], dword edx
        endFunc 0

posh:
    startFunc 0           

    mov eax, [size]         ; put size in eax
    cmp eax , [capacity]    ; size ?= capacity
    je overflow             ; if stack if full
    incStack                ; else, size++
    mov edx, buff           ; we gonna mess with this pointer
    b2:
    checkLengthPairty buff  ; returned value in eax
    cmp eax,0               ; if buff size is even
    je evenlength
    oddlength:
        parseOneChar edx    ; returned value in eax
        mov ecx, eax        ; ecx <- data (becuase next macro mess with eax)
        ; printHexDigit ecx   ; 
        pushNewLink cl
        add edx, 1 
        b3:
    evenlength:
        cmp byte [edx], 0
        je  end_posh
        parseTwochars edx
        mov ecx, eax        ; ecx <- data (becuase next macro mess with eax)
        ; printHexDigit ecx
        pushNewLink cl
        add edx, 2
        jmp evenlength
    end_posh:
        mov esp, ebp
        pop ebp
        ret
    overflow:
        printString overflowMsg
        jmp main_loop

poop:
    push ebp
    mov ebp, esp
    mov eax, [size]
    cmp eax, 0          ;size ?= 0
    je underflow
    getHeadOfNum eax
    pushad
    push eax            ; push first link
    call printNumList   ; recursize function
    add esp, 4          ; pop to void
    popad
    myFree eax
    mov eax, [stack]
    mov [eax], dword 0   ;nullinh [stack]
    decStack
    mov esp, ebp    
    pop ebp
    printString mynew_line
    ret
    
underflow:
    printString underflowMsg
    endFunc 0

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
    
    mov eax, [size]         ; check if size allow duplication
    cmp eax, 0              ; size ?= 0
    je underflow            ; nothing to duplicat
    cmp eax,  [capacity]    ; size ?= capacity
    je overflow             ; stack if full

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



    .end:
    endFunc 0

parseCommand:
    startFunc 0
    
    mov eax, 0
    mov al, byte [buff] ;eax <- (char)buff[0]
    
    cmp eax ,0x70       ;'p'
    je user_wants_to_poop
    cmp eax, 0x71       ;'q'
    je myexit
    cmp eax, 0x73       ;'s'
    je debugAc
    cmp eax, 43         ;'+'
    je Ed
    cmp eax, 0x64       ;'d'
    je duplicate_fun
    cmp eax, 0x26       ;'&'
    je and_meow
    
    Posh:
    call posh
    jmp end_p
    Ed:
    call Ed_Edd_n_Eddy
    jmp end_p
    debugAc:
    debug
    jmp end_p
    user_wants_to_poop:
    call poop
    jmp end_p
    duplicate_fun:
    call duplicate
    jmp end_p
    and_meow:
    call myAnd
    jmp end_p
    end_p:
    mov esp, ebp
    pop ebp
    ret



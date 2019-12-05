%include "includes/io.inc"

extern getAST
extern freeAST
extern printf 

section .data
    format: db "%d", 0
    
section .bss
    ; La aceasta adresa, scheletul stocheaza radacina arborelui
    root: resd 1

section .text 
    global main

atoi: 
    push ebp 
    mov ebp, esp 
    
    ; clean up the registers 
    xor eax, eax        ; return value  
    xor ebx, ebx        ; store one byte 
    
    mov edi, [ebp + 8]   
    
    mov ecx, 1          ; default sign
    
compute: 
    mov bl, byte[edi]   ; get a char      
    
    cmp bl, 0           ; check for NULL
    je done 
    
    
    cmp bl, '+'         ; check for sign 
    je condition
    
    cmp bl, '-'         
    jne condition 
    
    mov ecx, -1         ; update the sign 
    
    inc edi 
    jmp compute 
    
condition: 
    ;checks wether digit is in [0, 9] interval
    cmp bl, '0' 
    jl done             ; if not then return current value 
                        ; and exit
    cmp bl, '9' 
    jg done 
    
    sub bl, 48         ; turn into integer 
                       ; ascii for 0 is 48
    
    imul eax, 10       ; add digit to result
    add eax, ebx 
    
    inc edi         
    jmp compute
    
done: 
    imul eax, ecx      
    
    leave 
    ret

 polish: 
    push ebp
    mov ebp, esp 
    
    mov eax, [ebp + 8]          ; struct Node* node
    
    mov ebx, [eax + 4]          ; left child  
    mov ecx, [eax + 8]          ; right child
    
    or ebx, ecx                 ; zero only when both 
                                ; children do not exist
    jz is_leaf
    
    xor ebx, ebx                ; clean ebx
    mov eax, [eax]              ; get node->data 
    mov bl, byte[eax]           ; get the sign char
    
    push ebx                    ; save the sign 
    
    mov eax, [ebp + 8]          ; get left child 
    mov ebx, [eax + 4] 
    
    push ebx                    ; recursive call for left child
    call polish
    
    add esp, 4                  ; free the parameters
    
    push eax                    ; save the result  
            
    mov eax, [ebp + 8]          ; get right child         
    mov ebx, [eax + 8]          ; repeat
    
    push ebx 
    call polish 
    
    add esp, 4
    
    pop ebx                     ; left result 
    
    xchg eax, ebx                 
    
    pop ecx                     ; get the operation from stack   
    
    ; a rough translation of a switch instruction 
    cmp cl, '*'                 ; case '*' 
    jne plus
     
    imul eax, ebx
    jmp return 
    
plus:
    cmp cl, '+'                 ; case '+' 
    jne minus
    
    add eax, ebx
    jmp return 

minus:   
    cmp cl, '-'                 ; case '-' 
    jne divide 
    
    sub eax, ebx
    jmp return 
    
divide:         
    cmp cl, '/'                 ; case '/' 
    jne unspecified             ; default case returns 1 
    
    cdq 
    idiv ebx 
    jmp return
        
is_leaf:      
    mov ebx, [eax] 
    push ebx  
    call atoi 
    add esp, 4
    jmp return
    
unspecified:                    ; error code 1 
    mov eax, 1
    
return: 
    leave 
    ret 
   
   
main:
    mov ebp, esp; for correct debugging
    ; NU MODIFICATI
    push ebp
    mov ebp, esp
    
    ; Se citeste arborele si se scrie la adresa indicata mai sus
    call getAST
    mov [root], eax
    
    ; Implementati rezolvarea aici:
    ; Sorry, due to modularity reasons I can't do that 
    ; using a funcion call is more elegant 
    
     push dword[root]  
     call polish 
     
     push eax 
     push format 
     call printf  
    ; NU MODIFICATI
    ; Se elibereaza memoria alocata pentru arbore
    push dword [root]
    call freeAST
    
    xor eax, eax
    leave
    ret
 

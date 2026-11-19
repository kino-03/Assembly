EXTERN printf : PROC
EXTERN scanf  : PROC
EXTERN ExitProcess : PROC

.DATA
    msg1    DB "First number: ", 0
    msg2    DB "Second number: ", 0
    fmt_in  DB "%lld", 0
    
    msg_add DB 10, "[+] ADD -> AX: %04X  BX: %04X  CX: %04X  DX: %04X", 10, 0
    msg_sub DB "[-] SUB -> AX: %04X  BX: %04X  CX: %04X  DX: %04X", 10, 0
    msg_mul DB "[*] MUL -> AX: %04X  BX: %04X  CX: %04X  DX: %04X", 10, 0
    msg_div DB "[/] DIV -> AX: %04X  BX: %04X  CX: %04X  DX: %04X", 10, 0

    num1    QWORD 0
    num2    QWORD 0

.CODE
main PROC
    SUB RSP, 28H            ; Shadow space(32B) + 16바이트 스택 정렬(8B)

    ; 1. 첫 번째 숫자 입력
    LEA RCX, msg1
    CALL printf
    LEA RCX, fmt_in
    LEA RDX, num1
    CALL scanf

    ; 2. 두 번째 숫자 입력
    LEA RCX, msg2
    CALL printf
    LEA RCX, fmt_in
    LEA RDX, num2
    CALL scanf

    ; ================= 1. 덧셈 (ADD) =================
    MOV RAX, num1
    MOV RBX, num2
    MOV RCX, 0
    MOV RDX, 0
    ADD AX, BX              ; AX = num1 + num2
    LEA RCX, msg_add
    CALL PRINT_REGS

    ; ================= 2. 뺄셈 (SUB) =================
    MOV RAX, num1
    MOV RBX, num2
    MOV RCX, 0
    MOV RDX, 0
    SUB AX, BX              ; AX = num1 - num2
    LEA RCX, msg_sub
    CALL PRINT_REGS

    ; ================= 3. 곱셈 (MUL) =================
    MOV RAX, num1
    MOV RBX, num2
    MOV RCX, 0
    MOV RDX, 0
    MUL BX                  ; DX:AX = AX * BX
    LEA RCX, msg_mul
    CALL PRINT_REGS

    ; ================= 4. 나눗셈 (DIV) =================
    MOV RAX, num1
    MOV RBX, num2
    MOV RCX, 0
    MOV RDX, 0              ; 나눗셈 전 DX 초기화 필수
    DIV BX                  ; AX = 몫, DX = 나머지
    LEA RCX, msg_div
    CALL PRINT_REGS

    ; 종료
    XOR ECX, ECX
    CALL ExitProcess
main ENDP

; ---------------------------------------------------------
; RCX에 포맷 문자열 주소를 받은 상태에서 AX, BX, CX, DX 출력
; ---------------------------------------------------------
PRINT_REGS PROC
    PUSH RBP
    MOV RBP, RSP
    SUB RSP, 30H            ; 인자 5개 전달을 위한 스택 공간 (32B + 16B)

    ; 원본 DX 값을 먼저 백업하여 5번째 인자([RSP+20H])로 배치
    MOVZX R10, DX
    MOV QWORD PTR [RSP+20H], R10

    ; printf(fmt, AX, BX, CX, DX) 나머지 인자 세팅
    MOVZX RDX, AX           ; 2번째 인자: AX
    MOVZX R8,  BX           ; 3번째 인자: BX
    MOVZX R9,  CX           ; 4번째 인자: CX
    CALL printf

    ADD RSP, 30H
    POP RBP
    RET
PRINT_REGS ENDP

END
format PE console
entry start

include '%include%\win32a.inc'

section '.data' data readable writeable
    prompt       db 'Enter integer %d: ', 0
    input_format db '%d', 0
    result_format db 13, 10, 'Average: %.2f', 13, 10, 0
    error_message db 13, 10, 'Invalid input. Please enter an integer.', 13, 10, 0

    count        dd 5
    input_number dd 0
    total        dq 0
    average      dq 0.0

section '.text' code readable executable
start:
    ; EBP: high 32 bits of signed 64-bit sum
    ; EDI: low 32 bits of signed 64-bit sum
    ; ESI: input index (1 through 5)
    xor ebp, ebp
    xor edi, edi
    mov esi, 1

read_loop:
    cinvoke printf, prompt, esi
    cinvoke fflush, 0
    cinvoke scanf, input_format, input_number

    cmp eax, 1
    jne invalid_input

    ; Sign-extend the new integer and add it to the 64-bit sum.
    mov eax, [input_number]
    cdq
    add edi, eax
    adc ebp, edx

    inc esi
    cmp esi, 6
    jl read_loop

    ; Convert the signed 64-bit sum to floating point, then divide by 5.
    mov dword [total], edi
    mov dword [total + 4], ebp
    fild qword [total]
    fidiv dword [count]
    fstp qword [average]

    ; A 32-bit cdecl vararg double occupies two 32-bit stack slots.
    ; Supply the low word first, then the high word in the argument list.
    cinvoke printf, result_format, dword [average], dword [average + 4]
    invoke ExitProcess, 0

invalid_input:
    cinvoke printf, error_message
    invoke ExitProcess, 1

section '.idata' import data readable writeable
    library kernel32, 'kernel32.dll', \
            msvcrt, 'msvcrt.dll'

    import kernel32, \
           ExitProcess, 'ExitProcess'

    import msvcrt, \
           printf, 'printf', \
           scanf, 'scanf', \
           fflush, 'fflush'

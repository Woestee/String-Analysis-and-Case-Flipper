; Alexander Woeste

INCLUDE Irvine32.inc

.data
inputString     BYTE 100 DUP(0)
outputString    BYTE 100 DUP(0)
wordCount       DWORD ?
vowelCount      DWORD ?
wordCountMsg    BYTE "The number of words in the input string is: ", 0
vowelMsg        BYTE "The number of vowels in the input string is: ", 0
vowelTable      BYTE "aeiouAEIOU", 0

.code
main PROC
    mov edx, OFFSET inputString     ; Read input string
    mov ecx, SIZEOF inputString
    call ReadString

    mov eax, 0      ; Count number of words
    mov esi, OFFSET inputString

countWordsLoop:
    cmp byte ptr [esi], 0
    je endCountWords
    cmp byte ptr [esi], ' '
    je spaceFound
    inc esi
    jmp countWordsLoop

spaceFound:
    inc eax
    inc esi
    jmp countWordsLoop

endCountWords:
    inc eax     ; Save word count
    mov wordCount, eax

    mov esi, OFFSET inputString     ; Flip case of each character
    mov edi, OFFSET outputString

caseFlipLoop:
    mov al, [esi]
    cmp al, 0
    je endCaseFlipLoop
    cmp al, 'a'
    jl notLowerCase
    cmp al, 'z'
    jg notLowerCase
    sub al, 32      ; Convert lowercase to uppercase
    jmp copyChar

notLowerCase:
    cmp al, 'A'
    jl notUpperCase
    cmp al, 'Z'
    jg notUpperCase
    add al, 32      ; Convert uppercase to lowercase

copyChar:
    mov [edi], al
    inc esi
    inc edi
    jmp caseFlipLoop

notUpperCase:
    mov [edi], al
    inc esi
    inc edi
    jmp caseFlipLoop

endCaseFlipLoop:
    mov byte ptr [edi], 0       ; Null terminate output string

    mov edx, OFFSET wordCountMsg        ; Display results
    call WriteString

    mov eax, wordCount      ; Display number of words
    call WriteDec
    call Crlf

    mov edx, OFFSET outputString        ; Display flipped cases of string
    call WriteString
    call Crlf

    mov eax, 0      ; Count and display number of vowels
    mov vowelCount, eax     ; Reset vowel count
    mov esi, OFFSET inputString

countVowelsLoop:
    mov al, [esi]
    cmp al, 0
    je endCountVowels
    call CheckVowel
    add eax, vowelCount     ; Add the result to the current count
    mov vowelCount, eax     ; Save the updated count
    inc esi
    jmp countVowelsLoop

endCountVowels:
    mov edx, OFFSET vowelMsg        ; Display message
    call WriteString

    mov eax, vowelCount     ; Display number of vowels (Can't get to work)
    call WriteDec
    call Crlf

    exit        ; Exit program

CheckVowel PROC
    movzx eax, al       ; Check if character is vowel
    push esi       ; Preserve the original value of esi
    mov esi, OFFSET vowelTable
checkLoop:
    cmp al, [esi]
    je isVowel
    inc esi
    cmp byte ptr [esi], 0
    jne checkLoop
    jmp notVowel

isVowel:
    inc eax
    jmp doneChecking

notVowel:
    jmp doneChecking

doneChecking:
    pop esi        ; Restore the original value of esi
    ret
CheckVowel ENDP

main ENDP
END main

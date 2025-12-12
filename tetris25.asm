; ==============================================================================
; PROJETO FINAL: JOGO TETRIS DE RESISTÊNCIA - PROCESSADOR ICMC
; ==============================================================================
; Descrição: Jogo de empilhar peças. O objetivo é distribuir as peças 
; lateralmente para demorar o máximo possível até atingir o topo.
; Teclas: 'a' (Esquerda), 'd' (Direita).
; ==============================================================================

jmp Main

; --- VARIÁVEIS GLOBAIS ---
Peca_Posicao_X:      var #1  ; Coluna lógica (0-19)
Peca_Posicao_Y:      var #1  ; Linha (0-29)
Endereco_Memoria_Peca: var #1 ; Endereço do formato da peça (T, I, O, L)
ID_Cor_Peca:         var #1  ; Cor da peça
Timer_Gravidade:     var #1  ; Delay da queda
Velocidade_Jogo:     var #1  ; Velocidade da queda
Semente_Aleatoria:   var #1  ; Para gerar peças aleatórias


; --- DEFINIÇÃO DAS PEÇAS (MATRIZES 4x4) ---
Formato_Peca_T: string "0100111000000000"
Formato_Peca_I: string "0100010001000100"
Formato_Peca_O: string "0000011001100000"
Formato_Peca_L: string "0100010001100000"

; --- MAPA DO JOGO (MEMÓRIA DE STRING) ---
; '9' = Parede, '0' = Vazio. O jogo modifica essas strings em tempo real.
Linha_01 : string "9990000000000000000000000000000000000999"
Linha_02 : string "9000000000000000000000000000000000000009"
Linha_03 : string "9000000000000000000000000000000000000009"
Linha_04 : string "9000000000000000000000000000000000000009"
Linha_05 : string "9000000000000000000000000000000000000009"
Linha_06 : string "9000000000000000000000000000000000000009"
Linha_07 : string "9000000000000000000000000000000000000009"
Linha_08 : string "9000000000000000000000000000000000000009"
Linha_09 : string "9000000000000000000000000000000000000009"
Linha_10 : string "9000000000000000000000000000000000000009"
Linha_11 : string "9000000000000000000000000000000000000009"
Linha_12 : string "9000000000000000000000000000000000000009"
Linha_13 : string "9000000000000000000000000000000000000009"
Linha_14 : string "9000000000000000000000000000000000000009"
Linha_15 : string "9000000000000000000000000000000000000009"
Linha_16 : string "9000000000000000000000000000000000000009"
Linha_17 : string "9000000000000000000000000000000000000009"
Linha_18 : string "9000000000000000000000000000000000000009"
Linha_19 : string "9000000000000000000000000000000000000009"
Linha_20 : string "9000000000000000000000000000000000000009"
Linha_21 : string "9000000000000000000000000000000000000009"
Linha_22 : string "9000000000000000000000000000000000000009"
Linha_23 : string "9000000000000000000000000000000000000009"
Linha_24 : string "9000000000000000000000000000000000000009"
Linha_25 : string "9000000000000000000000000000000000000009"
Linha_26 : string "9000000000000000000000000000000000000009"
Linha_27 : string "9000000000000000000000000000000000000009"
Linha_28 : string "9000000000000000000000000000000000000009"
Linha_29 : string "9000000000000000000000000000000000000009"
Linha_30 : string "9999999999999999999999999999999999999999"

; --- MENSAGENS UI ---
Mensagem_Posicao_Tela: var #1        
Mensagem_Cor:          var #1        
Mensagem_Endereco_Str: var #1   

Texto_BoasVindas: string "Bem-vindo(a) ao Tetris de Resistencia"
Texto_Start:      string "PRESSIONE ENTER PARA COMECAR"
Texto_GameOver_1: string "Faltou dedo para espalhar tanto bloco..."
Texto_GameOver_2: string "Pressione ENTER para tentar de novo"


; MAIN
Main:
    loadn r0, #10          ; Define dificuldade (menor = mais rapido)
    store Velocidade_Jogo, r0

    call Limpar_Tela_Video ; Pinta a tela toda de preto

    ; Tela Inicial
    loadn r0, #561          ; Posição calculada para centralizar na linha    
    loadn r1, #Texto_BoasVindas   
    loadn r2, #2304         ; Cor Vermelha
    store Mensagem_Posicao_Tela, r0
    store Mensagem_Endereco_Str, r1
    store Mensagem_Cor, r2     
    call Mostrar_Mensagem_Texto
    
    loadn r0, #646          
    loadn r1, #Texto_Start
    loadn r2, #3072         ; Cor Azul
    store Mensagem_Posicao_Tela, r0
    store Mensagem_Endereco_Str, r1
    store Mensagem_Cor, r2
    call Mostrar_Mensagem_Texto

    call Aguardar_Tecla_Enter    
    call Limpar_Tela_Video
    call Desenhar_Cenario_Completo    
    
    call Gerar_Nova_Peca     ; Escolhe uma peça aleatória e põe no topo 
    call Desenhar_Peca_Atual    

; LOOP PRINCIPAL
Loop_Principal_Jogo:
    call Atraso_Do_Jogo            ; Gasta tempo (CPU Delay) para controlar FPS
    call Verificar_Entrada_Teclado ; Verifica se jogou apertou 'A' ou 'D'
    call Aplicar_Gravidade         ; Verifica se hora de descer a peça
    jmp Loop_Principal_Jogo        ; Repete tudo

; LOGICA DO JOGO
Atraso_Do_Jogo:
    push r0
    push r1
    loadn r0, #30000  ; Ajuste aqui para mudar a velocidade geral
Loop_Delay_Interno:
    dec r0
    loadn r1, #0
    cmp r0, r1
    jne Loop_Delay_Interno
    pop r1
    pop r0
    rts

Verificar_Entrada_Teclado:
    push r0
    push r1
    push r2
    
    inchar r0              
    loadn r1, #255 ; 255 significa "nenhuma tecla pressionada"
    cmp r0, r1             
    jeq Fim_Input
    
    loadn r1, #'a'
    cmp r0, r1
    jeq Move_Esq
    
    loadn r1, #'d'
    cmp r0, r1
    jeq Move_Dir
    
    jmp Fim_Input

Move_Esq:
    call Apagar_Peca_Atual         
    load r2, Peca_Posicao_X
    dec r2                         
    store Peca_Posicao_X, r2
    
    call Verificar_Colisao         
    loadn r1, #1
    cmp r0, r1
    jeq Desfaz_Esq           
    
    call Desenhar_Peca_Atual       
    jmp Fim_Input

Desfaz_Esq:
    load r2, Peca_Posicao_X
    inc r2                    ; Devolve X para posição original      
    store Peca_Posicao_X, r2
    call Desenhar_Peca_Atual       
    jmp Fim_Input

Move_Dir:
    call Apagar_Peca_Atual
    load r2, Peca_Posicao_X
    inc r2                         
    store Peca_Posicao_X, r2
    
    call Verificar_Colisao
    loadn r1, #1
    cmp r0, r1
    jeq Desfaz_Dir
    
    call Desenhar_Peca_Atual
    jmp Fim_Input

Desfaz_Dir:
    load r2, Peca_Posicao_X
    dec r2                   ; Devolve X para posição original     
    store Peca_Posicao_X, r2
    call Desenhar_Peca_Atual
    jmp Fim_Input

Fim_Input:
    pop r2
    pop r1
    pop r0
    rts

Aplicar_Gravidade:
    push r0
    push r1
    push r2
    
    load r0, Timer_Gravidade
    load r1, Velocidade_Jogo
    inc r0
    store Timer_Gravidade, r0
    
    cmp r0, r1
    jle Fim_Gravidade      
    
    loadn r0, #0
    store Timer_Gravidade, r0
    
    call Apagar_Peca_Atual
    load r1, Peca_Posicao_Y
    inc r1
    store Peca_Posicao_Y, r1       
    
    call Verificar_Colisao
    loadn r2, #1
    cmp r0, r2
    jeq Colisao_Chao          ; Se bateu embaixo, a peça pousou
    
    call Desenhar_Peca_Atual  ; Se livre, desenha mais abaixo
    jmp Fim_Gravidade

Colisao_Chao:
    load r1, Peca_Posicao_Y
    dec r1                 
    store Peca_Posicao_Y, r1
    
    call Desenhar_Peca_Atual       
    call Fixar_Peca_No_Cenario     
    call Gerar_Nova_Peca           
    call Desenhar_Peca_Atual
    
Fim_Gravidade:
    pop r2
    pop r1
    pop r0
    rts

Gerar_Nova_Peca:
    push r0
    push r1
    
    loadn r0, #7        ; X Inicial
    store Peca_Posicao_X, r0
    loadn r0, #1        ; Y Inicial (Topo)
    store Peca_Posicao_Y, r0
    loadn r0, #0
    store Timer_Gravidade, r0
    
    ; RNG Simples
    load r0, Semente_Aleatoria
    loadn r1, #5
    mul r0, r0, r1      
    loadn r1, #7
    add r0, r0, r1      
    store Semente_Aleatoria, r0
    loadn r1, #4
    mod r0, r0, r1      
    
    loadn r1, #0
    cmp r0, r1
    jeq Set_T
    loadn r1, #1
    cmp r0, r1
    jeq Set_I
    loadn r1, #2
    cmp r0, r1
    jeq Set_O
    jmp Set_L

Set_T:
    loadn r1, #Formato_Peca_T
    store Endereco_Memoria_Peca, r1
    loadn r1, #'1'
    store ID_Cor_Peca, r1
    jmp Check_GameOver
Set_I:
    loadn r1, #Formato_Peca_I
    store Endereco_Memoria_Peca, r1
    loadn r1, #'2'
    store ID_Cor_Peca, r1
    jmp Check_GameOver
Set_O:
    loadn r1, #Formato_Peca_O
    store Endereco_Memoria_Peca, r1
    loadn r1, #'3'
    store ID_Cor_Peca, r1
    jmp Check_GameOver
Set_L:
    loadn r1, #Formato_Peca_L
    store Endereco_Memoria_Peca, r1
    loadn r1, #'4'
    store ID_Cor_Peca, r1

Check_GameOver:
    call Verificar_Colisao
    loadn r1, #1
    cmp r0, r1
    jeq Executar_Game_Over ; Se a peça nascer colidindo, perdeu
    
    pop r1
    pop r0
    rts

Verificar_Colisao:
    push r1 ; Endereço da peça
    push r2 ; Contador (0 a 15)
    push r3 ; Valor lido da memória
    push r4 ; Coordenada Y Relativa
    push r5 ; Coordenada X Relativa
    push r6 ; Posição calculada no mapa6 
    
    load r1, Endereco_Memoria_Peca
    loadn r2, #0
Loop_Col:
    loadn r4, #16
    cmp r2, r4
    jeq Sem_Col ; Se checou os 16 blocos e passou, não há colisão
    
    loadi r3, r1 ; Lê o bloco da peça ("0" ou "1")
    loadn r4, #'1'
    cmp r3, r4
    jne Prox_Col ; Se for "0" (vazio na peça), não precisa checar colisão
    
    loadn r4, #4
    div r4, r2, r4      ; Y Rel
    loadn r5, #4
    mod r5, r2, r5      ; X Rel
    
    load r6, Peca_Posicao_Y
    add r4, r4, r6
    load r6, Peca_Posicao_X
    add r5, r5, r6
    
    loadn r3, #29
    cmp r4, r3
    jgr Tem_Col
    jeq Tem_Col
    
    ; Calcula indice na string: (X * 2) + 3
    loadn r3, #2
    mul r5, r5, r3
    loadn r3, #3
    add r5, r5, r3
    
    call Ler_Caractere_Do_Mapa
    loadn r3, #'0'
    cmp r6, r3
    jne Tem_Col    
    
    inc r5
    call Ler_Caractere_Do_Mapa
    loadn r3, #'0'
    cmp r6, r3
    jne Tem_Col

Prox_Col:
    inc r1
    inc r2
    jmp Loop_Col

Tem_Col:
    loadn r0, #1
    jmp Fim_Col
Sem_Col:
    loadn r0, #0
Fim_Col:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    rts

Fixar_Peca_No_Cenario:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    push r6
    
    load r1, Endereco_Memoria_Peca
    loadn r2, #0
Loop_Fix:
    loadn r4, #16
    cmp r2, r4
    jeq Fim_Fix
    
    loadi r3, r1
    loadn r4, #'1'
    cmp r3, r4
    jne Prox_Fix
    
    loadn r4, #4
    div r4, r2, r4
    loadn r5, #4
    mod r5, r2, r5
    load r6, Peca_Posicao_Y
    add r4, r4, r6
    load r6, Peca_Posicao_X
    add r5, r5, r6
    
    loadn r3, #2
    mul r5, r5, r3
    loadn r3, #3
    add r5, r5, r3
    
    load r3, ID_Cor_Peca
    call Escrever_Caractere_No_Mapa    
    inc r5
    call Escrever_Caractere_No_Mapa    

Prox_Fix:
    inc r1
    inc r2
    jmp Loop_Fix
Fim_Fix:
    pop r6
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; FUNCOES DE SUPORTE E GRAFICOS
Ler_Caractere_Do_Mapa:
    ; R4 = Linha (Y), R5 = Coluna Offset
    ; Retorna R6 = Char
    push r0
    push r1
    loadn r1, #Linha_01
    loadn r0, #41      ; Tamanho da linha na memória (40 chars + terminador)
    push r4
    dec r4             ; Ajuste de índice (Linha 1 vira 0)
    mul r0, r0, r4     ; Offset Y = Linha * 41
    pop r4
    add r1, r1, r0     ; Endereço Base + Offset Y
    add r1, r1, r5     ; + Offset X
    loadi r6, r1       ; Lê memória
    pop r1
    pop r0
    rts

Escrever_Caractere_No_Mapa:
    ; R4 = Linha, R5 = Coluna Offset, R3 = Char a escrever
    push r0
    push r1
    loadn r1, #Linha_01
    loadn r0, #41
    push r4
    dec r4
    mul r0, r0, r4
    pop r4
    add r1, r1, r0
    add r1, r1, r5
    storei r1, r3
    pop r1
    pop r0
    rts

Desenhar_Cenario_Completo:
    push r0
    push r1
    push r4
    loadn r1, #0        ; Endereço de Vídeo Inicial (0)
    loadn r0, #Linha_01 ; Ponteiro para primeira linha
    loadn r4, #40       ; Limite da primeira linha
    call Print_L
    loadn r0, #Linha_02
    loadn r4, #80
    call Print_L
    loadn r0, #Linha_03
    loadn r4, #120
    call Print_L
    loadn r0, #Linha_04
    loadn r4, #160
    call Print_L
    loadn r0, #Linha_05
    loadn r4, #200
    call Print_L
    loadn r0, #Linha_06
    loadn r4, #240
    call Print_L
    loadn r0, #Linha_07
    loadn r4, #280
    call Print_L
    loadn r0, #Linha_08
    loadn r4, #320
    call Print_L
    loadn r0, #Linha_09
    loadn r4, #360
    call Print_L
    loadn r0, #Linha_10
    loadn r4, #400
    call Print_L
    loadn r0, #Linha_11
    loadn r4, #440
    call Print_L
    loadn r0, #Linha_12
    loadn r4, #480
    call Print_L
    loadn r0, #Linha_13
    loadn r4, #520
    call Print_L
    loadn r0, #Linha_14
    loadn r4, #560
    call Print_L
    loadn r0, #Linha_15
    loadn r4, #600
    call Print_L
    loadn r0, #Linha_16
    loadn r4, #640
    call Print_L
    loadn r0, #Linha_17
    loadn r4, #680
    call Print_L
    loadn r0, #Linha_18
    loadn r4, #720
    call Print_L
    loadn r0, #Linha_19
    loadn r4, #760
    call Print_L
    loadn r0, #Linha_20
    loadn r4, #800
    call Print_L
    loadn r0, #Linha_21
    loadn r4, #840
    call Print_L
    loadn r0, #Linha_22
    loadn r4, #880
    call Print_L
    loadn r0, #Linha_23
    loadn r4, #920
    call Print_L
    loadn r0, #Linha_24
    loadn r4, #960
    call Print_L
    loadn r0, #Linha_25
    loadn r4, #1000
    call Print_L
    loadn r0, #Linha_26
    loadn r4, #1040
    call Print_L
    loadn r0, #Linha_27
    loadn r4, #1080
    call Print_L
    loadn r0, #Linha_28
    loadn r4, #1120
    call Print_L
    loadn r0, #Linha_29
    loadn r4, #1160
    call Print_L
    loadn r0, #Linha_30
    loadn r4, #1200
    call Print_L
    pop r4
    pop r1
    pop r0
    rts

Print_L:
    push r5
    push r3
    push r6
    push r7
    push r2
Loop_P_L:
    cmp r1, r4
    jeq Fim_P_L
    
    loadi r3, r0      ; Lê caractere da string
    loadn r5, #125    ; Código visual do bloco sólido    
    
    loadn r2, #'0'
    cmp r3, r2
    jeq P_C0
    loadn r2, #'9'
    cmp r3, r2
    jeq P_C9
    loadn r2, #'1'
    cmp r3, r2
    jeq P_C1
    loadn r2, #'2'
    cmp r3, r2
    jeq P_C2
    loadn r2, #'3'
    cmp r3, r2
    jeq P_C3
    loadn r2, #'4'
    cmp r3, r2
    jeq P_C4
    jmp P_Next

P_C0: loadn r7, #0
      loadn r5, #' '  ; Se for 0, imprime espaço vazio
      jmp P_Out
P_C1: loadn r7, #2304 ; Vermelho
      jmp P_Out
P_C2: loadn r7, #512  ; Verde
      jmp P_Out
P_C3: loadn r7, #3072 ; Azul
      jmp P_Out
P_C4: loadn r7, #2816 ; Amarelo
      jmp P_Out
P_C9: loadn r7, #2048 ; Cinza (Parede)
      jmp P_Out

P_Out:
    add r6, r5, r7
    outchar r6, r1
P_Next:
    inc r1
    inc r0
    jmp Loop_P_L
Fim_P_L:
    pop r2
    pop r7
    pop r6
    pop r3
    pop r5
    rts

Desenhar_Peca_Atual:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    
    load r1, Endereco_Memoria_Peca
    loadn r2, #0
Loop_Drw:
    loadn r4, #16
    cmp r2, r4
    jeq Fim_Drw
    
    loadi r3, r1
    loadn r4, #'1'
    cmp r3, r4
    jne Prox_Drw
    
    loadn r4, #4
    div r4, r2, r4      
    loadn r5, #4
    mod r5, r2, r5      
    load r0, Peca_Posicao_Y
    add r4, r4, r0
    load r0, Peca_Posicao_X
    add r5, r5, r0
    
    loadn r3, #2
    mul r5, r5, r3
    loadn r3, #3
    add r5, r5, r3
    
    loadn r3, #40
    mul r3, r3, r4
    add r3, r3, r5
    
    load r5, ID_Cor_Peca
    loadn r0, #'1'
    cmp r5, r0
    jeq C_V
    loadn r0, #'2'
    cmp r5, r0
    jeq C_G
    loadn r0, #'3'
    cmp r5, r0
    jeq C_B
    loadn r0, #'4'
    cmp r5, r0
    jeq C_Y
C_V: loadn r0, #2304 
     jmp Prt
C_G: loadn r0, #512  
     jmp Prt
C_B: loadn r0, #3072 
     jmp Prt
C_Y: loadn r0, #2816 

Prt:
    loadn r4, #125 
    add r4, r4, r0
    outchar r4, r3 
    inc r3
    outchar r4, r3 

Prox_Drw:
    inc r1
    inc r2
    jmp Loop_Drw
Fim_Drw:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

Apagar_Peca_Atual:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    
    load r1, Endereco_Memoria_Peca
    loadn r2, #0
Loop_Ers:
    loadn r4, #16
    cmp r2, r4
    jeq Fim_Ers
    
    loadi r3, r1
    loadn r4, #'1'
    cmp r3, r4
    jne Prox_Ers
    
    loadn r4, #4
    div r4, r2, r4
    loadn r5, #4
    mod r5, r2, r5
    load r0, Peca_Posicao_Y
    add r4, r4, r0
    load r0, Peca_Posicao_X
    add r5, r5, r0
    
    loadn r3, #2
    mul r5, r5, r3
    loadn r3, #3
    add r5, r5, r3
    
    loadn r3, #40
    mul r3, r3, r4
    add r3, r3, r5
    
    loadn r4, #' '
    outchar r4, r3
    inc r3
    outchar r4, r3
    
Prox_Ers:
    inc r1
    inc r2
    jmp Loop_Ers
Fim_Ers:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

Limpar_Tela_Video:
    push r0
    push r1
    loadn r0, #0
    loadn r1, #1200
Loop_Clr:
    loadn r2, #' '
    outchar r2, r0
    inc r0
    cmp r0, r1
    jne Loop_Clr
    pop r1
    pop r0
    rts

Aguardar_Tecla_Enter:
    push r0
    push r1
    push r2
    loadn r1, #0 
Loop_Wait:
    inc r1         
    inchar r0
    loadn r2, #13
    cmp r0, r2
    jne Loop_Wait
    store Semente_Aleatoria, r1 
    pop r2
    pop r1
    pop r0
    rts

Mostrar_Mensagem_Texto:
    push r0
    push r1
    push r2
    push r3
    push r4
    push r5
    load r0, Mensagem_Posicao_Tela
    load r1, Mensagem_Endereco_Str
    load r2, Mensagem_Cor
Loop_Msg:
    loadi r3, r1
    loadn r5, #0
    cmp r3, r5
    jeq Fim_Msg
    add r4, r3, r2
    outchar r4, r0
    inc r0
    inc r1
    jmp Loop_Msg
Fim_Msg:
    pop r5
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts

; FUNCOES DE REINICIALIZACAO
Executar_Game_Over:
    ; Limpa a tela para tirar o "lixo" do jogo
    call Limpar_Tela_Video
    
    ; --- LINHA 1: O Motivo da Derrota ---
    loadn r0, #480          
    loadn r1, #Texto_GameOver_1
    loadn r2, #2304         ; Cor Vermelha (Erro)
    
    store Mensagem_Posicao_Tela, r0
    store Mensagem_Endereco_Str, r1
    store Mensagem_Cor, r2
    call Mostrar_Mensagem_Texto
    
    ; --- LINHA 2: Instrução para Reiniciar ---
    loadn r0, #562
    loadn r1, #Texto_GameOver_2
    loadn r2, #3072         ; Cor Azul (Informacao)
    
    store Mensagem_Posicao_Tela, r0
    store Mensagem_Endereco_Str, r1
    store Mensagem_Cor, r2
    call Mostrar_Mensagem_Texto
    
    call Aguardar_Tecla_Enter ; Espera o Enter do usuario
    
    call Limpar_Memoria_Mapa ; Limpa a memoria do mapa 
     
    jmp Main ; Volta para o Main

Limpar_Memoria_Mapa:
    ; Reseta as strings Linha_01 ate Linha_29 para o estado "900...009"
    push r0
    push r1
    push r2
    push r3
    push r4
    
    loadn r0, #0    ; R0 = Contador de Linhas (0 a 28)
    loadn r1, #29   ; Total de linhas jogaveis
    
Loop_Reset_Linha:
    cmp r0, r1
    jeq Fim_Reset_Mapa
    
    ; Calcula endereco da linha: Endereco = Linha_01 + (Contador * 41)
    loadn r2, #Linha_01
    loadn r3, #41
    mul r3, r3, r0
    add r2, r2, r3  ; R2 agora aponta para o inicio da linha
    
    ; Pula os '999' iniciais (indices 0, 1, 2)
    loadn r3, #3
    add r2, r2, r3 
    
    ; Preenche 34 zeros (o meio do campo)
    loadn r3, #0   ; Contador de colunas
    loadn r4, #34  ; Largura jogavel
Loop_Zeros:
    cmp r3, r4
    jeq Prox_Linha_Reset
    loadn r5, #'0'
    storei r2, r5
    inc r2
    inc r3
    jmp Loop_Zeros
    
Prox_Linha_Reset:
    inc r0
    jmp Loop_Reset_Linha

Fim_Reset_Mapa:
    pop r4
    pop r3
    pop r2
    pop r1
    pop r0
    rts
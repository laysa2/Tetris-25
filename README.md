# 🎮 Tetris de Resistência - Processador ICMC

Este projeto contém a implementação do jogo **Tetris de Resistência**, desenvolvido inteiramente em linguagem **Assembly** para a arquitetura do Processador ICMC. O projeto foi realizado como parte da avaliação da disciplina de **Organização e Arquitetura de Computadores**.

## 🧑‍💻 Integrantes do Grupo
* Giovana
* Laysa Almeida Oliveira
* Luiz

## 📹 Vídeo Explicativo
> **[INSIRA O LINK DO YOUTUBE OU GOOGLE DRIVE AQUI]**
>
> *Neste vídeo, explicamos qual é a ideia por trás do jogo.
---

## 🧱 Sobre o Jogo
O projeto é uma variação do clássico Tetris, focada na mecânica de **Resistência** (estilo *Stacker*). Diferente do jogo original, o objetivo aqui não é limpar linhas, mas sim testar a habilidade do jogador em organizar e espalhar as peças lateralmente para evitar que a pilha atinja o teto o mais rápido possível.

### Funcionalidades Implementadas:
* **Física e Colisão:** Detecção precisa de colisão entre peças em movimento, blocos fixos e as paredes do cenário.
* **Gravidade Automática:** As peças caem em velocidade constante controlada por um *timer* de delay baseado em ciclos de clock.
* **Movimentação Lateral:** Controle para esquerda (`A`) e direita (`D`).
* **Game Over "Stack Overflow":** Quando a pilha atinge o limite superior, o jogo detecta a derrota e exibe uma mensagem de erro temática.
* **Sistema de Reinício:** Permite reiniciar o jogo pressionando `ENTER` sem a necessidade de resetar o simulador, limpando dinamicamente a memória do mapa.
---

## ⚙️ Detalhes Técnicos e Lógica de Implementação
Para implementar este jogo no Processador ICMC, utilizamos estratégias de manipulação de memória e lógica de baixo nível:

### 1. Mapeamento de Memória (VRAM Virtual)
O cenário do jogo é gerenciado através de **Strings na Memória RAM**, funcionando como uma memória de vídeo virtual.
* O mapa é composto por strings (`Linha_01` a `Linha_30`), onde cada linha possui 40 caracteres.
* Usamos o caractere `'9'` para representar as paredes laterais indestrutíveis e `'0'` para o espaço vazio.
* A renderização varre essas strings e atualiza o vídeo apenas com as cores correspondentes, separando a lógica (números) da visualização (pixels).

### 2. Renderização de Largura Dupla
Para garantir que as peças tivessem uma proporção visual agradável (quadrada) na tela do terminal, adotamos uma conversão de coordenadas:
* **Lógica:** O jogo calcula a posição em uma grade lógica de 10 colunas.
* **Visual:** Na hora de desenhar, multiplicamos a coordenada X por 2 e desenhamos dois caracteres lado a lado.
* **Fórmula:** `Posicao_Video = Offset_Margem + (Posicao_Logica * 2)`

### 3. Geração de Aleatoriedade (RNG)
Como o processador não possui um relógio de tempo real (RTC) acessível via instrução direta, criamos um **Gerador Linear Congruente** baseado na interação humana:
* Durante a tela de título ("Pressione Enter"), um contador (`r1`) é incrementado continuamente em *loop*.
* O valor exato do contador no momento em que o usuário pressiona a tecla se torna a `Seed` (Semente).
* **Fórmula:** `Semente = (Semente * 5) + 7`. Isso garante peças variadas (T, I, O, L) a cada partida de forma imprevisível.

### 4. Limpeza Dinâmica de Memória (Memset)
* Para permitir o reinício do jogo, implementamos uma função dedicada (`Limpar_Memoria_Mapa`) que percorre todos os endereços de memória referentes ao mapa. Ela reescreve o caractere `'0'` (vazio) nas áreas jogáveis das linhas 1 a 29, removendo os "restos" das peças da partida anterior, agindo como um *garbage collector* manual.
---

## ⌨️ Controles

| Tecla | Ação |
| :---: | :--- |
| **A** | Mover peça para a **Esquerda** |
| **D** | Mover peça para a **Direita** |
| **ENTER** | Iniciar Jogo / Reiniciar após Game Over |
---

## ▶️ Como Rodar o Projeto

### Pré-requisitos
* **Simulador do Processador ICMC**.
* **Montador (Assembler)** para converter o código `.asm` em binário `.mif`.

### Passo a Passo
1.  Clone este repositório ou baixe os arquivos.
2.  Abra o arquivo `Tetris.asm` (ou o nome do arquivo principal) no Montador.
3.  Gere o arquivo `.mif` (Memory Initialization File).
    * *Nota: O arquivo .mif contém as instruções de máquina e os dados hexadecimais.*
4.  Carregue o arquivo `.mif` no Simulador do Processador ICMC.
5.  Execute a simulação.
---

# 🎮 Tetris de Resistência - Processador ICMC

Este projeto contém a implementação do jogo **Tetris de Resistência**, desenvolvido inteiramente em linguagem **Assembly** para a arquitetura do Processador ICMC. O projeto foi realizado como parte da avaliação da disciplina de **Organização e Arquitetura de Computadores**.

## 🧑‍💻 Integrantes do Grupo
* Giovana Rafaela Marmo de Almeida 
* Laysa Almeida Oliveira
* Luiz Eduardo Reis Tavares Silva

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
## ⚙️ Detalhes Técnicos

* **Mapeamento de Memória:** O cenário é gerenciado por strings na memória (`Linha_01` a `Linha_30`), funcionando como um buffer de vídeo onde '9' são paredes e '0' espaços vazios. O jogo não "enxerga" pixels. A cada quadro, o processador lê esse mapa e decide qual cor pintar na tela.
* **Renderização de Largura Dupla:** Como os caracteres do terminal são finos e altos, uma peça normal ficaria "esmagada". Para corrigir isso, usamos uma lógica de multiplicação: o jogo calcula a posição em uma grade de 10 colunas, mas desenha na tela multiplicando a posição por 2. Assim, cada bloco ocupa dois espaços (`[]`), formando um quadrado perfeito.
* **RNG (Aleatoriedade):** Sem um relógio real (RTC), implementamos um *Gerador Linear Congruente*. Um contador de alta frequência captura o momento exato do input do usuário para gerar a semente aleatória (`Seed`). O processador ICMC não possui um relógio interno para sortear números. Nossa solução foi usar a "imprevisibilidade humana": enquanto a tela de título aguarda, um contador roda em velocidade máxima. O milissegundo exato em que você aperta `ENTER` captura esse número e o usa numa fórmula matemática (`x5 + 7`) para definir a ordem das próximas peças.
* **Limpeza de Memória (Hot Restart):** Criamos uma rotina estilo *memset* que varre os endereços de memória do mapa e reseta os bytes jogáveis para '0', permitindo reiniciar o jogo sem recarregar o simulador.
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

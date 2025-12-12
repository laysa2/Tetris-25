# 🎮 Tetris de Resistência - Processador ICMC

Este projeto contém a implementação do jogo **Tetris de Resistência**, desenvolvido inteiramente em linguagem **Assembly** para a arquitetura do Processador ICMC. O projeto foi realizado como parte da avaliação da disciplina de **Organização e Arquitetura de Computadores**.
<img width="800" height="134" alt="image" src="https://github.com/user-attachments/assets/6ae50cad-91b1-4ed4-8c29-db1f2acd3db1" />

## 🧑‍💻 Integrantes do Grupo
* Giovana Rafaela Marmo de Almeida 
* Laysa Almeida Oliveira
* Luiz Eduardo Reis Tavares Silva

## 📹 Vídeo Explicativo
> **https://drive.google.com/file/d/1a2XffLL_Avvys_fL9JNvQsd_9lw-hFhM/view?usp=drive_link**
>
> Neste vídeo, explicamos qual é a ideia por trás do jogo.
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

## ▶️ Como Rodar o Jogo
1. Abra o Sublime Text (sublime_text.exe)
2. Carregue o arquivo tetris25.asm
3. Execute o programa pressionando F7, depois SHIFT + HOME
4. Na tela inicial, pressione ENTER para começar o jogo
---

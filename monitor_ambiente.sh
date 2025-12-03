#!/bin/bash

# a linha de cima é para identificar o interpretador de comandos. 

echo "========================================"
echo " SCRIPT DE MONITORAMENTO"
echo "========================================"

# -----------------------------
# MISSAO 1: DIRETORIO
# -----------------------------

echo ""
# pula uma linha
echo "Missão 1: Verificar diretório"

# aqui eu pergunto qual diretorio a pessoa quer ver
# o 'read' guarda o que a pessoa digita dentro de uma variável
#“-n” faz o eco não pular linha.
echo -n "Digite o diretório que você quer verificar: "
read DIRETORIO

# o '-d' verifica se o que foi digitado é um diretório msm
if [ ! -d "$DIRETORIO" ]; then
    echo "[ERRO] O diretório não existe!"
    exit 1
fi

#1 = erro.
echo "Diretório existe!"

# agora vou ver se o usuário consegue ler, escrever e entrar nele
#  -r -w -x serviam pra isso
#&& = “e também”
# x = posso entrar
if [ -r "$DIRETORIO" ] && [ -w "$DIRETORIO" ] && [ -x "$DIRETORIO" ]; then
    echo "[OK] O usuário consegue fazer tudo no diretório (ler, escrever e entrar)"
else
    echo "[AVISO] Você NÃO tem todas as permissões aqui...!"
fi

#“Se eu posso ler, escrever e entrar nesse diretório…”

# -----------------------------
# MISSAO 2: RECURSOS DO DISCO
# -----------------------------

echo ""
echo "Missão 2: Verificar o uso do disco"

USO=$(df / | awk 'NR==2 {print $5}')

#df / = “fala quanto a pasta principal está cheia”
#awk 'NR==2 {print $5}' = pega a linha 2, coluna 5, que é tipo “43%”
#Tudo isso é guardado no chamada USO.

USO_NUM=$(echo $USO | tr -d '%')
#“Tira o símbolo de % para virar só número.”

echo "Uso do disco na / está em: $USO"

# agora eu faço aquelas comparações chiques com if
if [ $USO_NUM -gt 90 ]; then
    echo "[CRÍTICO] "
elif [ $USO_NUM -gt 70 ]; then
    echo "[ALERTA] "
else
    echo "[OK] "
fi
#fim do if.

# -----------------------------
# MISSAO 3: PROCESSOS
# -----------------------------

echo ""
echo "Missão 3: Ver processos do usuário"

# ps -u USER mostra os processos do usuário
# wc -l conta quantas linhas tem (processos + 1 do cabeçalho)
#ps -u $USER = “lista os programas que você está usando”
#wc -l = “conta quantos tem”
PROC=$(ps -u $USER | wc -l)
PROC=$((PROC - 1))

#Tira 1 porque a lista tem 1 linha a mais (o cabeçalho).

echo "Você está rodando $PROC processos agora!"

echo ""
echo "Top 5 processos que mais usam memória:"

# aqui eu pego os processos ordenados por memória
# head -n 5 pega só os primeiros 5
# awk é só pra deixar mais bonitinho
ps -u $USER -o pid,%mem,comm --sort=-%mem | head -n 6 | tail -n 5 | awk '{print "PID:",$1," | MEM:",$2,"% | CMD:",$3}'

#ps -u $USER -o pid,%mem,comm
#→ pede para mostrar só:
#PID
#Memória
#Nome do comando

#--sort=-%mem
#→ ordena do maior para o menor consumo de memória

# head -n 6
#→ pega as 6 primeiras linhas (1 é cabeçalho)


# tail -n 5
#→ tira a primeira, ficam só 5 processos


# awk '{print ... }'
#→ só deixa bonitinho na tela



echo ""
echo "Final do relatório!"


#  chmod +x monitor_ambiente.sh (permissão para roda)
#  ./monitor_ambiente.sh (execute)
#  /home (escolhe um diretório) 

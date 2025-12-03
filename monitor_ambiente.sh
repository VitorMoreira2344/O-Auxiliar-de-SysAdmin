#!/bin/bash

# a linha de cima é para identificar o interpretador de comandos. 

echo "========================================"
echo " SCRIPT DE MONITORAMENTO"
echo "========================================"

# -----------------------------
# MISSAO 1: DIRETORIO
# -----------------------------

echo ""
echo "Missão 1: Verificar diretório"

# aqui eu pergunto qual diretorio a pessoa quer ver
# o 'read' guarda o que a pessoa digita dentro de uma variável
echo -n "Digite o diretório que você quer verificar: "
read DIRETORIO

# o '-d' verifica se o que foi digitado é um diretório msm
if [ ! -d "$DIRETORIO" ]; then
    echo "[ERRO] O diretório não existe!"
    exit 1
fi

echo "Diretório existe!"

# agora vou ver se o usuário consegue ler, escrever e entrar nele
#  -r -w -x serviam pra isso
if [ -r "$DIRETORIO" ] && [ -w "$DIRETORIO" ] && [ -x "$DIRETORIO" ]; then
    echo "[OK] O usuário consegue fazer tudo no diretório (ler, escrever e entrar)"
else
    echo "[AVISO] Você NÃO tem todas as permissões aqui...!"
fi


# -----------------------------
# MISSAO 2: RECURSOS DO DISCO
# -----------------------------

echo ""
echo "Missão 2: Verificar o uso do disco"

USO=$(df / | awk 'NR==2 {print $5}')

USO_NUM=$(echo $USO | tr -d '%')

echo "Uso do disco na / está em: $USO"

# agora eu faço aquelas comparações chiques com if
if [ $USO_NUM -gt 90 ]; then
    echo "[CRÍTICO] "
elif [ $USO_NUM -gt 70 ]; then
    echo "[ALERTA] "
else
    echo "[OK] "
fi


# -----------------------------
# MISSAO 3: PROCESSOS
# -----------------------------

echo ""
echo "Missão 3: Ver processos do usuário"

# ps -u USER mostra os processos do usuário
# wc -l conta quantas linhas tem (processos + 1 do cabeçalho)
PROC=$(ps -u $USER | wc -l)
PROC=$((PROC - 1))

echo "Você está rodando $PROC processos agora!"

echo ""
echo "Top 5 processos que mais usam memória:"

# aqui eu pego os processos ordenados por memória
# head -n 5 pega só os primeiros 5
# awk é só pra deixar mais bonitinho
ps -u $USER -o pid,%mem,comm --sort=-%mem | head -n 6 | tail -n 5 | awk '{print "PID:",$1," | MEM:",$2,"% | CMD:",$3}'

echo ""
echo "Final do relatório!"


#  chmod +x monitor_ambiente.sh (permissão para roda)
#  ./monitor_ambiente.sh (execute)
#  /home (escolhe um diretório) 
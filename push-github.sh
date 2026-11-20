#!/usr/bin/env bash
# Execute este script no seu terminal (nao dentro do agente) para enviar o projeto ao GitHub.
# Ele inicia o ssh-agent, desbloqueia a chave e faz o push.

set -e

cd "/home/gabriel/Área de trabalho/devops"

echo "=== Iniciando ssh-agent ==="
eval "$(ssh-agent -s)"

echo "=== Adicionando a chave (digite a passphrase quando pedir) ==="
ssh-add ~/.ssh/id_ed25519

echo "=== Testando conexao com o GitHub ==="
ssh -o StrictHostKeyChecking=accept-new -T git@github.com || true

echo "=== Enviando o projeto ==="
git push -u origin main

echo "=== Concluido! Verifique o repositorio no GitHub. ==="

#!/usr/bin/env bash
# Cria o projeto e gera um token no SonarQube.
# Execute dentro da VM "sonarqube": vagrant ssh sonarqube
#
# Observacao: se a senha padrao admin/admin ja tiver sido alterada,
# troque as credenciais abaixo.

set -e

SONAR_URL="${SONAR_URL:-http://localhost:9000}"
SONAR_USER="${SONAR_USER:-admin}"
SONAR_PASS="${SONAR_PASS:-admin}"
PROJECT_KEY="${PROJECT_KEY:-app-exemplo}"
PROJECT_NAME="${PROJECT_NAME:-app-exemplo}"
TOKEN_NAME="${TOKEN_NAME:-token-app-exemplo}"

echo "Aguardando o SonarQube ficar disponivel em $SONAR_URL ..."
until curl -s "$SONAR_URL/api/system/status" | grep -q '"status":"UP"'; do
  sleep 5
done
echo "SonarQube disponivel."

echo "Criando o projeto $PROJECT_KEY ..."
curl -s -u "$SONAR_USER:$SONAR_PASS" -X POST "$SONAR_URL/api/projects/create" \
  --data-urlencode "name=$PROJECT_NAME" \
  --data-urlencode "project=$PROJECT_KEY" || true

echo "Gerando token $TOKEN_NAME ..."
RESPONSE=$(curl -s -u "$SONAR_USER:$SONAR_PASS" -X POST "$SONAR_URL/api/user_tokens/generate" \
  --data-urlencode "name=$TOKEN_NAME")
TOKEN=$(echo "$RESPONSE" | sed -n 's/.*"token":"\([^"]*\)".*/\1/p')

if [ -n "$TOKEN" ]; then
  echo "TOKEN gerado: $TOKEN"
  echo "$TOKEN" > /home/vagrant/sonar_token.txt
  chmod 600 /home/vagrant/sonar_token.txt
  echo "Token salvo em /home/vagrant/sonar_token.txt"
else
  echo "Nao foi possivel gerar o token. Resposta:"
  echo "$RESPONSE"
fi

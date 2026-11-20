#!/usr/bin/env bash
# Executa a analise estatica do app-exemplo usando o sonar-scanner em container.
# Uso: SONAR_TOKEN=seu_token ./analisar.sh
# Execute este script dentro da VM "sonarqube" (vagrant ssh sonarqube).

set -e

if [ -z "$SONAR_TOKEN" ]; then
  echo "Defina a variavel SONAR_TOKEN antes de executar."
  echo "Exemplo: SONAR_TOKEN=xxxxx ./analisar.sh"
  exit 1
fi

sudo podman run --rm --network host \
  -v /vagrant/app-exemplo:/usr/src \
  -w /usr/src \
  docker.io/sonarsource/sonar-scanner-cli:latest \
  -Dsonar.projectKey=app-exemplo \
  -Dsonar.projectName=app-exemplo \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login="$SONAR_TOKEN"

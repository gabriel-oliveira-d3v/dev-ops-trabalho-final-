#!/usr/bin/env bash
# Mostra a senha inicial do Jenkins.
# Execute dentro da VM "jenkins": vagrant ssh jenkins

sudo podman exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

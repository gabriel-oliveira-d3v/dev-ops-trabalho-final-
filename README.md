# lab-jenkins-app

Aplicação Node.js usada no laboratório de Jenkins e SonarQube da disciplina de
Fundamentos de DevOps.

## Execução local

```bash
npm install
npm start
curl http://localhost:3000/health
```

## Testes

```bash
npm test
```

## Pipeline

O `Jenkinsfile` executa as etapas:

1. **Checkout** — obtém o código do repositório Git;
2. **Build** — instala dependências e valida a sintaxe;
3. **Test** — executa os testes com `node:test`;
4. **SonarQube** — executa o `sonar-scanner` com o token cadastrado no Jenkins;
5. **Deploy** — copia a aplicação para `deploy@192.168.1.3:/opt/nodeapp` e
   reinicia o serviço `nodeapp`;
6. **Verify** — consulta `http://192.168.1.3:3000/health`.

O arquivo `src/legacy.js` contém exemplos intencionais de más práticas para a
análise estática. Ele não é usado pela aplicação em execução.

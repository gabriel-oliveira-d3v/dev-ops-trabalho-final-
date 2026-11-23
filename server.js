const http = require('node:http');

function createServer() {
  return http.createServer((req, res) => {
    res.setHeader('Content-Type', 'application/json');

    if (req.url === '/health') {
      res.end(JSON.stringify({
        status: 'ok',
        servidor: 'app01'
      }));
      return;
    }

    res.end(JSON.stringify({
      mensagem: 'Aplicacao DevOps funcionando!',
      servidor: 'app01'
    }));
  });
}

if (require.main === module) {
  const port = process.env.PORT || 3000;

  createServer().listen(port, '0.0.0.0', () => {
    console.log(`Servidor iniciado na porta ${port}`);
  });
}

module.exports = { createServer };

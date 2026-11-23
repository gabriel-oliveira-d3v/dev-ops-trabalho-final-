const test = require('node:test');
const assert = require('node:assert');
const { createServer } = require('../server');

test('GET /health responde com status ok', async () => {
  const server = createServer();

  await new Promise((resolve) => {
    server.listen(0, '127.0.0.1', resolve);
  });

  const { port } = server.address();
  const response = await fetch(`http://127.0.0.1:${port}/health`);
  const body = await response.json();

  assert.strictEqual(response.status, 200);
  assert.strictEqual(body.status, 'ok');
  assert.strictEqual(body.servidor, 'app01');

  await new Promise((resolve) => server.close(resolve));
});

// ==========================================================
// ARQUIVO DE EXEMPLO PARA A ANALISE DO SONARQUBE
//
// Este modulo NAO e usado pela aplicacao em producao.
// Ele existe apenas para demonstrar, no laboratorio, como
// o SonarQube aponta mas praticas de seguranca e qualidade:
// - credencial fixa no codigo;
// - uso de eval;
// - comparacao com == em vez de ===;
// - concatenacao de SQL (risco de injecao);
// - catch vazio.
// ==========================================================

const senhaAdmin = 'admin123';
const usuarioAdmin = 'admin';

function executarCodigo(entrada) {
  return eval(entrada);
}

function comparar(a, b) {
  if (a == b) {
    return true;
  }

  return false;
}

function buscarUsuario(id) {
  const query = 'SELECT * FROM usuarios WHERE id = ' + id;
  return query;
}

function ignorarErro() {
  try {
    executarCodigo('1 + 1');
  } catch (erro) {
    // catch vazio de proposito
  }
}

module.exports = {
  senhaAdmin,
  usuarioAdmin,
  executarCodigo,
  comparar,
  buscarUsuario,
  ignorarErro
};

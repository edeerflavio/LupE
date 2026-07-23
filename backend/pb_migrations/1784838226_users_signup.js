/// <reference path="../pb_data/types.d.ts" />

// Libera o cadastro da conta da família (signup) e mantém login por senha.
// Numa VPS pessoal isso é aceitável (o endereço é privado). Se quiser fechar
// depois de criar a conta, altere createRule para null no painel do PocketBase.
migrate((app) => {
  const users = app.findCollectionByNameOrId("users");
  users.createRule = "";
  return app.save(users);
}, (app) => {
  const users = app.findCollectionByNameOrId("users");
  users.createRule = null;
  return app.save(users);
})

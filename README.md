# Pizzaria — pedidos e persistência offline-first

## Identificação

- **Temática do aplicativo:** Pizzaria (gestão de pedidos por mesa)
- **Estudante:** preencher com o nome completo
- **Link da API publicada:** preencher após publicação no Render ou serviço equivalente
- **Descrição:** aplicativo Flutter para cadastrar e listar pedidos da pizzaria. Os dados são armazenados em SQLite; quando a API está disponível, também são enviados ao PostgreSQL. Pedidos criados sem conexão ficam pendentes para sincronização manual.

## Aplicativo Flutter

O app usa `lib/database` para SQLite, `lib/services` para HTTP e `lib/repository` para coordenar as fontes de dados. A lista mostra o estado da nuvem de cada pedido. O botão de sincronização no topo envia os pendentes; puxar a lista para baixo tenta atualizar a partir da API.

Configure a URL da API ao executar/buildar:

```sh
flutter run --dart-define=API_BASE_URL=https://SUA-API.onrender.com
```

O endereço padrão é intencionalmente inválido. Assim, sem configuração o app continua permitindo cadastros locais, que ficam pendentes.

## API e PostgreSQL

Flutter e API estão no mesmo repositório, organizados por responsabilidade:

```text
/
├── lib/                 # Aplicativo Flutter
├── android/             # Plataformas do Flutter
├── ios/
├── web/
├── render.yaml          # Blueprint de publicação da API e do PostgreSQL
└── api/                 # API Node.js + Express
    ├── src/server.js
    └── package.json
```

A API fica em `api/` e expõe:

| Método | Rota | Ação |
| --- | --- | --- |
| `GET` | `/health` | Verifica disponibilidade |
| `GET` | `/pedidos` | Lista pedidos |
| `POST` | `/pedidos` | Cadastra pedido (`{"valor":58.90,"numero_mesa":1}`) |

Para rodar localmente, configure `DATABASE_URL` e `PGSSL` conforme `api/.env.example`, então execute `npm install` e `npm start` dentro de `api/`. A tabela `pedidos` é criada automaticamente ao iniciar. Para publicar, conecte este repositório no Render como um **Blueprint**: o arquivo `render.yaml` configura o Web Service e o PostgreSQL e liga `DATABASE_URL` ao banco. Confira o plano antes de confirmar a criação.

## Entrega

- Repositório Flutter/API: preencher com o link Git acessível ao professor.
- API publicada: preencher após deploy.
- Vídeo de demonstração (máximo de 5 minutos): gravar cadastro online, cadastro offline pendente e sincronização posterior. O vídeo deve ser entregue junto à tarefa no Teams.
- Se o repositório for privado, adicionar `@adrianoprof` como colaborador.

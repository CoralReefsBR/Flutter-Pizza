# Pizzaria — pedidos e persistência offline-first

## Identificação

- **Temática do aplicativo:** Pizzaria (gestão de pedidos por mesa)
- **Estudante:** André Coral Rodrigues
- **Link da API publicada:** https://flutter-pizza-api.onrender.com
- **Descrição:** aplicativo Flutter para cadastrar e listar pedidos da pizzaria. Os dados são armazenados em SQLite; quando a API está disponível, também são enviados ao PostgreSQL. Pedidos criados sem conexão ficam pendentes para sincronização manual.

## Aplicativo Flutter

O app usa `lib/database` para SQLite, `lib/services` para HTTP e `lib/repository` para coordenar as fontes de dados. A lista mostra o estado da nuvem de cada pedido. O botão de sincronização no topo envia os pendentes; puxar a lista para baixo tenta atualizar a partir da API.


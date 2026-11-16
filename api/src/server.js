require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: process.env.PGSSL === 'true' ? { rejectUnauthorized: false } : undefined,
});
app.use(cors());
app.use(express.json());

app.get('/health', (_req, res) => res.json({ status: 'ok' }));
app.get('/pedidos', async (_req, res) => {
  try {
    const { rows } = await pool.query('SELECT id, valor, numero_mesa FROM pedidos ORDER BY id DESC');
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ erro: 'Não foi possível listar os pedidos.' });
  }
});
app.post('/pedidos', async (req, res) => {
  const valor = Number(req.body?.valor);
  const numeroMesa = Number(req.body?.numero_mesa ?? req.body?.numeroMesa);
  if (!Number.isFinite(valor) || valor <= 0 || !Number.isInteger(numeroMesa) || numeroMesa <= 0) {
    return res.status(400).json({ erro: 'Informe valor e número de mesa válidos.' });
  }
  try {
    const { rows } = await pool.query(
      'INSERT INTO pedidos (valor, numero_mesa) VALUES ($1, $2) RETURNING id, valor, numero_mesa',
      [valor, numeroMesa],
    );
    res.status(201).json(rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ erro: 'Não foi possível cadastrar o pedido.' });
  }
});

const port = Number(process.env.PORT || 3000);
pool.query(`CREATE TABLE IF NOT EXISTS pedidos (
  id BIGSERIAL PRIMARY KEY,
  valor NUMERIC(10, 2) NOT NULL CHECK (valor > 0),
  numero_mesa INTEGER NOT NULL CHECK (numero_mesa > 0),
  criado_em TIMESTAMPTZ NOT NULL DEFAULT NOW()
)`).then(() => {
  app.listen(port, () => console.log(`API de pedidos ouvindo na porta ${port}`));
}).catch((error) => {
  console.error('Falha ao preparar PostgreSQL:', error);
  process.exit(1);
});

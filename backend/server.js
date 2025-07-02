require('dotenv').config();
const express = require('express');
const app = express();
const cors = require('cors');
const bodyParser = require('body-parser');
const mysql = require('mysql2/promise');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const nodemailer = require('nodemailer');

app.use(cors());
app.use(bodyParser.json());

const db = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'pisouser',
  password: process.env.DB_PASS || 'pisopass123',
  database: process.env.DB_NAME || 'pisowifi'
});

// Health check
app.get('/api/health', (req, res) => res.send('OK'));

// --- VOUCHER ROUTES ---
app.post('/api/voucher/create', async (req, res) => {
  const { count, minutes } = req.body;
  let codes = [];
  for (let i = 0; i < count; i++) {
    let code = Math.random().toString(36).substr(2, 8).toUpperCase();
    codes.push([code, minutes, 1, null, null]);
  }
  await db.query(
    'INSERT INTO vouchers (code, minutes, status, used_at, paused_at) VALUES ?',
    [codes]
  );
  res.json({ created: codes.map(c => c[0]) });
});

app.post('/api/voucher/redeem', async (req, res) => {
  const { code, mac } = req.body;
  const [rows] = await db.query(
    'SELECT * FROM vouchers WHERE code = ? AND status = 1',
    [code]
  );
  if (!rows.length) return res.status(400).json({ error: 'Invalid/Used voucher' });
  await db.query(
    'UPDATE vouchers SET status = 2, used_at = NOW(), mac = ? WHERE code = ?',
    [mac, code]
  );
  res.json({ ok: true, minutes: rows[0].minutes });
});

// --- AUTH, ADMIN, USERS, PAYMENT OMITTED FOR DEMO ---

// Start server
app.listen(8080, () => console.log('PisoWiFi backend running on :8080'));

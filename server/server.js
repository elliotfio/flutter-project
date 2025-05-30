import express from 'express';
import bodyParser from 'body-parser';
import { readFileSync, writeFileSync, existsSync } from 'fs';
import crypto from 'crypto';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(bodyParser.json());

// === Fonctions de chiffrement ===
const SECRET = '12345678901234567890123456789012';
const IV = Buffer.alloc(16, 0);

const encrypt = (text) => {
  const cipher = crypto.createCipheriv('aes-256-cbc', SECRET, IV);
  let encrypted = cipher.update(text, 'utf8', 'base64');
  encrypted += cipher.final('base64');
  return encrypted;
};

const decrypt = (encrypted) => {
  const decipher = crypto.createDecipheriv('aes-256-cbc', SECRET, IV);
  let decrypted = decipher.update(encrypted, 'base64', 'utf8');
  decrypted += decipher.final('utf8');
  return decrypted;
};

// === Gestion des utilisateurs ===
const USERS_FILE = './users.json.enc';

const getUsers = () => {
  if (!existsSync(USERS_FILE)) return [];
  const encryptedData = readFileSync(USERS_FILE, 'utf8');
  const decrypted = decrypt(encryptedData);
  return JSON.parse(decrypted);
};

const saveUsers = (users) => {
  const json = JSON.stringify(users, null, 2);
  const encrypted = encrypt(json);
  writeFileSync(USERS_FILE, encrypted, 'utf8');
};

// === Routes d'authentification ===
app.post('/register', (req, res) => {
  const { username, password, name } = req.body;
  if (!username || !password || !name) {
    return res.status(400).json({ error: 'Champs manquants' });
  }

  const users = getUsers();
  if (users.find((u) => u.username === username)) {
    return res.status(400).json({ error: 'Utilisateur déjà existant' });
  }

  users.push({ username, password, name });
  saveUsers(users);

  res.json({ success: true });
});

app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const users = getUsers();
  const user = users.find((u) => u.username === username && u.password === password);

  if (!user) return res.status(401).json({ error: 'Identifiants invalides' });

  res.json({ success: true, name: user.name });
});

// === Routes de gestion des administrateurs ===
app.get('/admins', (req, res) => {
  const users = getUsers();
  const safeUsers = users.map(({ password, ...user }) => user);
  res.json(safeUsers);
});

app.post('/admins', (req, res) => {
  const { username, password, name } = req.body;
  if (!username || !password || !name) {
    return res.status(400).json({ error: 'Champs manquants' });
  }

  const users = getUsers();
  if (users.find((u) => u.username === username)) {
    return res.status(400).json({ error: 'Utilisateur déjà existant' });
  }

  users.push({ username, password, name });
  saveUsers(users);

  res.status(201).json({ success: true });
});

app.delete('/admins/:username', (req, res) => {
  const { username } = req.params;
  let users = getUsers();
  const initialLength = users.length;
  users = users.filter(u => u.username !== username);
  
  if (users.length === initialLength) {
    return res.status(404).json({ error: 'Utilisateur non trouvé' });
  }

  saveUsers(users);
  res.json({ success: true });
});

app.listen(3001, () => console.log('Serveur lancé sur http://localhost:3001'));

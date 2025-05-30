import express from 'express';
import bodyParser from 'body-parser';
import { readFileSync, writeFileSync, existsSync } from 'fs';
import crypto from 'crypto';
import cors from 'cors';

const app = express();
app.use(cors());
app.use(bodyParser.json());

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

const FILE_PATH = './users.json.enc';

const getUsers = () => {
  if (!existsSync(FILE_PATH)) return [];
  const encryptedData = readFileSync(FILE_PATH, 'utf8');
  const decrypted = decrypt(encryptedData);
  return JSON.parse(decrypted);
};

const saveUsers = (users) => {
  const json = JSON.stringify(users, null, 2);
  const encrypted = encrypt(json);
  writeFileSync(FILE_PATH, encrypted, 'utf8');
};

// === Register ===
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

// === Login ===
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const users = getUsers();
  const user = users.find((u) => u.username === username && u.password === password);

  if (!user) return res.status(401).json({ error: 'Identifiants invalides' });

  res.json({ success: true, name: user.name });
});

app.listen(3001, () => console.log('Serveur auth lancé sur http://localhost:3001'));

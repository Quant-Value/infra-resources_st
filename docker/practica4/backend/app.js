const express = require('express');
const mongoose = require('mongoose');
const app = express();
const port = 3000;

// Conectar a MongoDB
const mongoURI = process.env.MONGO_URI || 'mongodb://localhost:27017/mydatabase';
mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Conectado a MongoDB'))
  .catch((err) => console.log('Error al conectar a MongoDB:', err));

app.get('/', (req, res) => {
  res.send('¡Hola desde el Backend!');
});

app.listen(port, () => {
  console.log(`Servidor Backend escuchando en http://localhost:${port}`);
});

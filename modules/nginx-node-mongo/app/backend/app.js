// Requerimos las dependencias necesarias
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors'); 
// Creamos una instancia de Express
const app = express();
app.use(cors(/*{origin: ['http://frontend-container:80', 'http://localhost:3000']}*/));
// Definimos el puerto en el que el servidor escuchará
const PORT = 5000;

// Conexión a la base de datos MongoDB
mongoose.connect('mongodb://mongo:27017/myapp', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('Conectado a MongoDB'))
  .catch(err => console.log('Error de conexión a MongoDB:', err));

// Ruta base
app.get('/', (req, res) => {
  res.send('API en funcionamiento 🚀');
});

// Iniciamos el servidor en el puerto 5000
app.listen(PORT, () => {
  console.log(`Servidor corriendo en el puerto ${PORT}`);
});

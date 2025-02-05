const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const path = require('path'); // Para manejar las rutas de los archivos

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Ruta principal
app.get('/', (req, res) => {
  console.log('He recibido /')
  res.send('Chat app is running!');
});

// Ruta para el "tesoro" que sirve el archivo index.html
app.get('/treasure/', (req, res) => {
  console.log('He recibido treasure')
  res.sendFile(path.join(__dirname, 'index.html'));  // Correcta concatenación de la ruta
});



// Iniciar el servidor en todas las interfaces de red
server.listen(3000, () => {
  console.log('Chat app listening on port 3000');
});



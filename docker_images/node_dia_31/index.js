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

/*app.get('/treasure/',(req,res) =>{
  res.send('Mensaje de prueba')
});*/

// Iniciar el servidor en todas las interfaces de red
server.listen(3000, () => {
  console.log('Chat app listening on port 3000');
});

// Configuración de WebSockets (Socket.io)
io.on('connection', (socket) => {
  console.log('A user connected');
  
  socket.on('chat message', (msg) => {
    io.emit('chat message', msg);  // Emitir el mensaje a todos los clientes
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Para loggear todas las conexiones de WebSocket, puedes agregar un logger:
io.on('connection', (socket) => {
  // Loggea cada vez que un cliente se conecta
  console.log(`New WebSocket connection: ${socket.id}`);

  socket.on('disconnect', () => {
    // Loggea cada vez que un cliente se desconecta
    console.log(`WebSocket disconnected: ${socket.id}`);
  });
});



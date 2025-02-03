const express = require('express');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(express.static('public'));

app.get('/', (req, res) => {
  res.send('Chat app is running!');
});

app.get('/treasure', (req, res) => {
  res.sendFile(__dirname + 'index.html');
});

server.listen(3000, () => {
  console.log('Chat app listening on port 3000');
});

io.on('connection', (socket) => {
  console.log('A user connected');
  
  socket.on('chat message', (msg) => {
    io.emit('chat message', msg);  // Emitir el mensaje a todos los clientes
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});



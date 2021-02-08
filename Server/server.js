const { measureMemory } = require('vm');

var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io')(http);

http.listen(3000, function(){
  console.log('Listening on *:3000');
});

io.sockets.on('connection', function(socket){
  // Welcome new user
  socket.emit('Client port', 'Welcome to the demo version of the chat!');

  // Say to all except the user
  socket.broadcast.emit('Client port', 'A user has joined the chat just now');

  // When client disconnects say to all users
  socket.on('disconnect', function(){
    io.emit('Client port', 'A user has just disconnected');
  });

  socket.on('Server Event', function(data) {
      console.log(data);
      io.sockets.emit('Client port', {msg: 'Hi iOS client!'});
  });

  // Server gets the new message sent by client
  socket.on('chatMessage', function(message){
    console.log(message);
  });

});
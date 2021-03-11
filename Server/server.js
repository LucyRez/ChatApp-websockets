const { measureMemory } = require('vm');

var MongoClient = require('mongodb').MongoClient;
var url = "mongodb://localhost:27017/mydb";
var mergeJSON = require("merge-json") ;
var app = require('express')();
var http = require('http').createServer(app);
var io = require('socket.io')(http);

http.listen(3000, function(){
  console.log('Listening on *:3000');
});

MongoClient.connect(url, function(err, db) {
  if (err) throw err;
  console.log("Database created!");
  

  io.sockets.on('connection', function(socket){

    var chat = db.db('chat');
    collection = chat.collection('messageHistory');

    chat.collection('messageHistory').find({}).toArray(function(err,res){
      if(err) throw err;
      console.log(res);
      socket.emit('messageHistory', res);
    });

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

      let clientMessage = JSON.parse(message);

      var dateTime = JSON.stringify({date:(new Date()).toISOString()});
      var dateJSON = JSON.parse(dateTime);
  
      var result = mergeJSON.merge(clientMessage,dateJSON);
      console.log(result);
      chat.collection('messageHistory').insertOne(result,function(){
        
      });

      io.emit('newMessage', result);

      // chat.collection('messageHistory').find({}).toArray(function(err,res){
      //   if(err) throw err;
      //   console.log(res);
      //   io.emit('newMessage', res);
      // });

    });

    socket.on('clear', function(data){
      chat.remove({}, function(){

      });
    });
  
  });

});


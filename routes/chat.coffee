
module.exports = (app) ->
  io = require('socket.io').listen app
  app.get '/chat', (req, res, next) ->
    res.render 'chat'

  chats = []
  users = {}
    
  io.sockets.on 'connection', (socket) ->
    console.log "new connection #{socket.id}"
    console.log chats

    socket.on 'disconnect', ->
      console.log socket.username, 'disconnected'
      socket.broadcast.emit 'userLeft', socket.username, socket.id
      delete users[socket.id]
      

    socket.on 'addUser', (username) =>
      #console.log users
      #if users.indexOf socket.id >= 0
      #  console.log users[socket.id], 'is back'
      #else if ! username?
      if ! username?
        socket.emit 'loginFailed'
      else
        console.log users
        #if users.indexOf(username) >= 0 #username already exists
        #  d = new Date()
        #  username += d.getTime()

        console.log username, 'joined the chat'
        users[socket.id] = username
        socket.username = username
          
        socket.broadcast.emit 'newUser', 
          username: username
          id: socket.id
          #chats: chats.slice(-5)
        socket.emit 'newUserSession', 
          username: username
          users: users
          chats: chats.slice(-5)
      
    socket.on 'addChat', (data) ->
      chats.push data
      console.log data
      socket.emit 'newChat', data
      socket.broadcast.emit 'newChat', data
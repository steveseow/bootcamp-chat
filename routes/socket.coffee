
module.exports = (app) ->
  io = require('socket.io').listen app
  app.get '/socket', (req, res, next) ->
    res.render 'socket'

  io.sockets.on 'connection', (socket) ->
    socket.emit 'news', {title: 'hello world', body: 'sockets for days'}
    socket.on 'my other event', (data) ->
      console.log socket.id, data
    socket.on 'click', (target) ->
      console.log target, 'clicked'
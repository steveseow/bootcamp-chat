socket = io.connect 'http://localhost:51306'
socket.on 'connect', ->
  socket.emit 'addUser', prompt 'Give us a name, old boy'

socket.on 'newUser', (data)->
  $('#users').append $("<li>#{data.username}</li>")

socket.on 'chat', (data) ->
  console.log 'new chat', data
  
$ ->
  $('#news').bind 'click', (e) ->
    console.log 'click!', $(e.target).attr('id')
    socket.emit 'click', $(e.target).attr('id')

window.Chat = {}

socket = io.connect 'http://localhost:51306'
socket.on 'news', (data) ->
  console.log data
  $('#news').html JSON.stringify data
  socket.emit 'my other event', my: data

socket.on 'connect', ->
  socket.emit 'addUser', prompt 'Give us a name, old boy'

socket.on 'newUserSession', (data)->
  Chat.username = data.username
  data.chats.forEach (chat) ->
    addChat chat
  for id,user of data.users
    addUser user, id

socket.on 'userLeft', (username, id) ->
  $("#User#{id}").remove()
  addChat
    username: 'SERVER'
    text: "-- #{username} left"


socket.on 'newUser', (data)->
  addUser data.username, data.id
  addChat
    username: 'SERVER'
    text: "-- #{data.username} joined"


socket.on 'loginFailed', ->
  alert 'Failed to sign up, please try again'

addUser = (user, id) ->
  $('#users').append $("<li id='User#{id}'>#{user}</li>")
  

socket.on 'newChat', (chat) ->
  addChat chat

addChat = (chat) ->
  $('#chats').append $("<li><span class='user'>#{chat.username}</span><span class='text'>#{chat.text}</span></li>")

$ ->
  $('#chatInput').bind 'submit', (e) ->
    e.preventDefault()
    socket.emit 'addChat', 
      username: Chat.username
      text: $('#chatInput input').val()
    $('#chatInput input').val('')
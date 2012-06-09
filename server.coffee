express = require("express")
#routes = require("./routes")

app = module.exports = express.createServer()

app.configure ->
  app.use require("connect-assets")()

  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.set "view options",
    req: {}
    title: 'Bootcamp Project'
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use require("stylus").middleware(src: __dirname + "/public")
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", (req, res, next) ->
  res.send 'hello, world'

#require('./routes/socket')(app)
require('./routes/chat')(app)

PORT = process.env.PORT ? 51306
app.listen PORT , ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
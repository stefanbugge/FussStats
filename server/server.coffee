express = require('express')
path = require 'path'
passport = require('passport')

session = require('express-session')
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

config = require './server/config'
access = require './server/access/access'
users = require './server/routes/users'
User = require './server/models/user'

mongoose = require 'mongoose'
mongoose.connect config.db

db = mongoose.connection
db.on 'error', console.error.bind console, 'connection error:'
db.once 'open', (callback) ->
  console.log 'YAY'

app = express()

app.use(cookieParser())
app.use(bodyParser.json())
app.use(session(
  resave: true,
  saveUninitialized: true,
  secret: 'uwotm8'
))
app.use(passport.initialize())
app.use(passport.session())
app.use('/api', users)
app.use(express.static(__dirname + '/public'))

ensureAuthenticated = (req, res, next) ->
  console.log 'authenticated', req.isAuthenticated()
  if req.isAuthenticated()
    return next()
  res.redirect '/auth/google'

app.get '/', (req, res) ->
  res.sendFile(path.resolve 'public/index.html')

app.get '/login', (req, res) ->
  res.send 'login', req.user

app.get '/test', ensureAuthenticated, (req, res) ->
  res.send "Cool! you're already authenticated"

app.get '/auth/google', passport.authenticate('google', { scope: ['https://www.googleapis.com/auth/plus.login', 'https://www.googleapis.com/auth/plus.profile.emails.read'] }), (reg, res) ->

app.get '/auth/google/callback', passport.authenticate('google', { failureRedirect: '/login' }), (req, res) ->
  res.redirect('/')

app.get '/logout', (req, res) ->
  req.logout();
  res.redirect('/')

server = app.listen(3000, ->
  host = server.address().address
  port = server.address().port
  console.log 'Example app listening at http://%s:%s', host, port
)


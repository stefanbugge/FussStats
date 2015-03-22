express = require('express')
path = require 'path'
passport = require('passport')
GoogleStrategy = require('passport-google-oauth').OAuth2Strategy
session = require('express-session')
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'

app = express()

app.use(cookieParser());
app.use(bodyParser.json());
app.use(session(
  resave: true,
  saveUninitialized: true,
  secret: 'uwotm8'
))
app.use(passport.initialize())
app.use(passport.session())

# Passport session setup.
#   To support persistent login sessions, Passport needs to be able to
#   serialize users into and deserialize users out of the session.  Typically,
#   this will be as simple as storing the user ID when serializing, and finding
#   the user by ID when deserializing.  However, since this example does not
#   have a database of user records, the complete Google profile is
#   serialized and deserialized.
passport.serializeUser (user, done) ->
  console.log 'serializing ' + user.displayName
  done null, user
passport.deserializeUser (obj, done) ->
  console.log 'deserializing ' + obj.displayName
  done null, obj

app.use(express.static(__dirname + '/public'))

GOOGLE_CLIENT_ID = "610402469663-f2beohjv3944dh8llfeit3t1uf52oklt.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET = "Iwir25tflV5vGDZMrnIVBFT1"

passport.use new GoogleStrategy({
    clientID: GOOGLE_CLIENT_ID
    clientSecret: GOOGLE_CLIENT_SECRET
    callbackURL: 'http://localhost:3000/auth/google/callback'
  }, (accessToken, refreshToken, profile, done) ->
    console.log "accessToken", accessToken
    console.log "refreshToken", refreshToken
    console.log "profile", profile
    done(null, profile)
)

# Simple route middleware to ensure user is authenticated.
#   Use this route middleware on any resource that needs to be protected.  If
#   the request is authenticated (typically via a persistent login session),
#   the request will proceed.  Otherwise, the user will be redirected to the
#   login page.
ensureAuthenticated = (req, res, next) ->
  console.log 'authenticated', req.isAuthenticated()
  if req.isAuthenticated()
    return next()
  res.redirect '/login'

app.get '/', (req, res) ->
  console.log 'user', req.user
  res.sendFile(path.resolve 'public/index.html')

app.get '/login', (req, res) ->
  res.send 'login', req.user

app.get '/test', ensureAuthenticated, (req, res) ->
  res.send 'test'

app.get '/auth/google', passport.authenticate('google', { scope: 'https://www.googleapis.com/auth/plus.login' }), (reg, res) ->

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


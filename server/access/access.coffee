GoogleStrategy = require('passport-google-oauth').OAuth2Strategy
passport = require('passport')
mongoose = require 'mongoose'

config = require '../config'
User = require '../models/user'


passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  User.findOne { _id: id }, (err, user) ->
    done err, user

passport.use new GoogleStrategy({
    clientID: config.google.clientID
    clientSecret: config.google.clientSecret
    callbackURL: config.google.callbackURL
  }, (accessToken, refreshToken, profile, done) ->

    User.findOne { 'google.id': profile.id }, (err, user) ->
      if user
        console.log 'found user', user
        return done(err, user)
      user = new User(
        name:     profile.displayName
        email:    profile.emails[0].value
        username: profile.emails[0].value
        google:   profile._json
        roles:    [ 'authenticated' ]
      )
      user.save (err) ->
        if err
          console.error err
        console.log 'NEW user', user
        done err, user
)
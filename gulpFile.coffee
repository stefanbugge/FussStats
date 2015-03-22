'use strict'
gulp       = require 'gulp'
clean      = require 'gulp-clean'

Client = require './buildscripts/client.coffee'
Server = require './buildscripts/server.coffee'

gulp.task 'client-watch', ->
  Client.build(true)

gulp.task 'client-build', ->
  Client.build()

gulp.task 'server-watch', ->
  Server.build(true)

gulp.task 'server-build', ->
  Server.build()

# define the browserify-watch as dependencies for this task
gulp.task 'watch', ->
  console.log "watching app"
  Server.build(true)
  Client.build(true)
  # Start live reload server
  #livereload.listen 35729

gulp.task 'build', ->
  console.log "building app"
  Server.build()
  Client.build()



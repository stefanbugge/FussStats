gulp = require('gulp')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
sourcemaps = require('gulp-sourcemaps')
del = require('del')
path = require 'path'

paths =
  server: './server/server.coffee'
  scripts: [
    './server/**/*.coffee'
    "!./server/server.coffee"
    '!./server/vendor/**/*.coffee'
  ]
  dist: './dist/server'

gulp.task 'clean', (cb) ->
  del [ paths.dist, '!./dist/public' ], cb

scripts = ->
  gulp.src(paths.scripts)
    .pipe(sourcemaps.init())
    .pipe(coffee())
#    .pipe(uglify())
#    .pipe(concat('all.min.js'))
    .pipe(sourcemaps.write())
    .pipe gulp.dest(paths.dist)

server = ->
  gulp.src(paths.server)
  .pipe(coffee())
  .pipe gulp.dest(path.join paths.dist, '..')

gulp.task 'scripts', scripts
gulp.task 'move-server', server

module.exports =
  build: (watch) ->
    console.log "server:#{if watch then 'watch' else 'build'}"
    scripts()
    server()
    if watch
      gulp.watch paths.scripts, [ 'scripts']
      gulp.watch paths.server, ['move-server']


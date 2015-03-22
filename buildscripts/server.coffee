gulp = require('gulp')
coffee = require('gulp-coffee')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
sourcemaps = require('gulp-sourcemaps')
del = require('del')

paths =
  scripts: [
    './server/**/*.coffee'
    '!./server/vendor/**/*.coffee'
  ]
  dist: './dist'

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

gulp.task 'scripts', scripts

module.exports =
  build: (watch) ->
    console.log "server:#{if watch then 'watch' else 'build'}"
    scripts()
    if watch
      gulp.watch paths.scripts, [ 'scripts' ]


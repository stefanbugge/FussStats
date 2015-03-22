gulp       = require 'gulp'
browserify = require 'browserify'
watchify   = require 'watchify'
source     = require 'vinyl-source-stream'
sass       = require 'gulp-ruby-sass'
notify     = require "gulp-notify"
del        = require 'del'

dist = "./dist/public"
config =
  dist:
    js: "#{dist}/js"
    css: "#{dist}/css"
    resources: "#{dist}"
  sassPath: './resources/sass'
  bowerDir: './bower_components'

gulp.task 'clean', (cb) ->
  del [ paths.dist ], cb

browserifyShare = (watch) ->

  b = browserify(
    entries: ['./resources/js/main.coffee']
    extensions: ['.coffee', '.js']
  )
  .transform 'coffeeify'
  #.transform 'uglifyify'

  if watch
    # if watch is enable, wrap this bundle inside watchify
    b = watchify(b)
    b.on 'update', ->
      bundleShare b
      return

  #b.add './resources/js/main.js'
  bundleShare b
  return

bundleShare = (b) ->
  b.bundle()
  .pipe(source('app.js'))
  .pipe(gulp.dest(config.dist.js))
  return

notifyError = notify.onError("<%= error.toString() %>\n<%= error.stack %>")
error = (args...) ->
  notifyError(args...)
  @emit('end')

css = ->
  sass('./resources/sass',
      #style: 'compressed'
    loadPath: [
      './resources/sass'
      config.bowerDir + '/bootstrap-sass-official/assets/stylesheets/bootstrap'
    ]
  )
  .on 'error', notify.onError (error) ->
    'Error: ' + error.message
  .pipe gulp.dest(config.dist.css)

gulp.task 'css', css

resources = ->
  gulp.src([
    "./resources/**/*.html"
    "./resources/views/**/*.ejs"
  ])
  .pipe gulp.dest(config.dist.resources)

gulp.task 'resources', resources

module.exports =
  build: (watch) ->
    browserifyShare(watch)
    if watch
      gulp.watch [config.sassPath + '/**/*.scss', './resources/**/*.html', "./resources/views/**/*.ejs"], [ 'css', 'resources' ]
    else
      css()
      resources()

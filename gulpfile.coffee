del = require 'del'
gulp = require 'gulp'
clean = require 'gulp-clean'
coffee = require 'gulp-coffee'
stylus = require 'gulp-stylus'

task = (name, src, pipes..., dest) ->
  gulp.task name, ->
    g = gulp.src src
    g = g.pipe pipe for pipe in pipes
    g.pipe gulp.dest dest

task 'coffee',
  'src/*.coffee',
  coffee(bare: true),
  'bin/'

task 'stylus',
  'src/*.styl',
  stylus(),
  'bin'

task 'js',
  'src/*.js*',
  'bin'

gulp.task 'default', ['coffee', 'stylus', 'js']

gulp.task 'clean', ->
  del 'bin/'

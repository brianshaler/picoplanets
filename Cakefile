# Cakefile to document, compile, join and minify CoffeeScript files for
# client side apps. Just edit the config object literal.
#
# -jrmoran

fs = require 'fs'
{exec, spawn} = require 'child_process'

project = 'default'

# order of files in `inFiles` is important
config =
  srcDir: 'src'
  outDir: 'lib'
  inFiles: 
    default: [ 'mass', 'planet', 'sun', 'player', 'galaxy', 'level', 'chrome', 'game' ],
    editor: [ 'editor/planet', 'editor/player', 'editor']
  outFile: 
    default: 'game',
    editor: 'editor'

xoutJS = "#{config.outDir}/#{config.outFile}"
xstrFiles = ("#{config.srcDir}/#{file}.coffee" for file in config.inFiles).join ' '

outFile = (key) ->
  key = if key? then key else "default"
  "#{config.outDir}/#{config.outFile[key]}"

inFiles = (key) ->
  key = if key? then key else "default"
  ("#{config.srcDir}/#{file}.coffee" for file in config.inFiles[key]).join ' '

# deal with errors from child processes
exerr = (err, sout, serr)->
  process.stdout.write err if err
  process.stdout.write sout if sout
  process.stdout.write serr if serr

task 'doc', 'generate documentation for *.coffee files', ->
  exec "docco #{config.srcDir}/*.coffee", exerr

# this will keep the non-minified compiled and joined file updated as files in
# `inFile` change.
task 'watch', 'watch and compile changes in source dir', ->
  _outFile = outFile(project)
  _inFiles = inFiles(project)
  watch = exec "coffee -j #{_outFile}.js -cw #{_inFiles}"
  watch.stdout.on 'data', (data)-> process.stdout.write data

task 'build', 'join and compile *.coffee files', ->
  _outFile = outFile(project)
  _inFiles = inFiles(project)
  exec "coffee -j #{_outFile}.js -c #{_inFiles}", exerr

task 'build:editor', 'join and compile editor *.coffee files', ->
  project = 'editor'
  invoke 'build'

# watch files and run tests automatically
task 'watch:test', 'watch and run tests', ->
  console.log 'watching...'

  whenChanged = (filename, fun)->
    fs.watchFile filename, (curr, prev)->
      fun() if curr.mtime > prev.mtime

  for f in config.inFiles
    whenChanged "#{f}.coffee", ->
      console.log "===== TEST #{new Date().toLocaleString()} ====="
      invoke 'test'
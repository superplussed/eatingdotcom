'use strict';

LIVERELOAD_PORT = 35729
SERVER_PORT = 9000
OFFLINE_MODE = false

_ = require('underscore')
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  includes = grunt.file.readYAML('includes.yaml')
  secret = grunt.file.readYAML('secret.yaml')

  scssFiles = _.map(includes.dev.scss, (file) -> "#{file}.scss")
  coffeeFiles = _.map(includes.dev.coffee, (file) -> "src/scripts/#{file}.coffee")
  devScssFiles = _.map(includes.dev.scss, (file) -> "styles/#{file}")
  devCoffeeFiles = _.map(includes.dev.coffee, (file) ->  "scripts/#{file}")
  componentCssFiles = _.map(includes.components.css, (file) -> "#{file}.css")
  componentJsFiles = _.map(includes.components.js, (file) -> "#{file}.js")

  if OFFLINE_MODE
    remoteOrLocalCdnCss = includes.localCdn.css
    remoteOrLocalCdnJs = includes.localCdn.js
  else
    remoteOrLocalCdnCss = includes.cdn.css
    remoteOrLocalCdnJs = includes.cdn.js

  devCssFiles = _.compact [].concat(remoteOrLocalCdnCss, includes.vendor.css, includes.components.css, devScssFiles)
  devJsFiles = _.compact [].concat(remoteOrLocalCdnJs, includes.vendor.js, includes.components.js, devCoffeeFiles)
  prodCssFiles = _.compact [].concat(includes.cdn.css, includes.prod.css)
  prodJsFiles = _.compact [].concat(includes.cdn.js, includes.prod.js)

  
  grunt.initConfig
    includes: includes
    secret: grunt.file.readYAML('secret.yaml')

    connect:
      options:
        port: SERVER_PORT
        hostname: "localhost"
      dev:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, "dev")]
      prod:
        options:
          keepalive: true
          middleware: (connect) ->
            [mountFolder(connect, "prod")]

    clean:
      dev: ["dev"]
      prod: ["prod", ".tmp"]
      tmp: [".tmp"]

    invalidate_cloudfront:
      options:
        key: '<%= secret.aws.key %>'
        secret: '<%= secret.aws.secret %>'
        distribution: 'E33PAAQVYGWOBE'
      production:
        files: [
          expand: true
          cwd: "./prod"
          src: ["**/*"]
          filter: 'isFile'
          dest: ''
        ]

    s3:
      options:
        accessKeyId: '<%= secret.aws.key %>'
        secretAccessKey: '<%= secret.aws.secret %>'
        bucket: '<%= secret.aws.bucket %>'
      deploy:
        cwd: 'prod/'
        src: '**'

    sass:
      dev:
        files: [
          expand: true
          cwd: "src/styles"
          src: scssFiles
          dest: "dev/styles"
          ext: ".css"
        ]
      prod:
        files: [
          expand: true,
          cwd: 'src/styles'
          src: scssFiles
          dest: '.tmp/styles'
          ext: '.css'
        ]

    cssmin:
      prod:
        files:
          'prod/app.min.css': ['.tmp/styles/app.min.css']

    ngmin:
      prod:
        src: ['.tmp/scripts/app.min.js']
        dest: '.tmp/scripts/app.min.js'

    # imagemin:
    #   prod:
    #     expand: true
    #     cwd: ".tmp"
    #     src: ["images/*"]
    #     dest: "prod/"

    uglify:
      prod:
        options:
          compress: true
          mangle: false
        files:
          'prod/app.min.js': ['.tmp/scripts/app.min.js']


    coffee:
      dev:
        # options:
        #   sourceMap: true
        files: [
          expand: true
          cwd: "src/scripts"
          src: ["**/*.coffee"]
          dest: "dev/scripts"
          ext: ".js"
        ]
      prod:
        options:
          join: true
          bare: true
        files: [
          '.tmp/scripts/app.js': coffeeFiles
        ]

    copy:
      prod:
        files: [
          expand: true
          cwd: "src/"
          src: ["*.ico", "*.txt"]
          dest: "prod/"
        ,
          expand: true
          flatten: true
          cwd: 'src/'
          src: componentCssFiles
          dest: '.tmp/styles/'
        ,
          expand: true
          flatten: true
          cwd: 'src/'
          src: componentJsFiles
          dest: '.tmp/scripts/'
        ,
          expand: true
          cwd: "src/components/fancybox/source"
          src: ["*.gif", "*.png"]
          dest: "prod/images/"
        ,
          expand: true
          cwd: "src/images/"
          src: ["*"]
          dest: "prod/images/"
        ]
      dev:
        files: [
          expand: true
          cwd: 'src/vendor'
          src: ['**/*']
          dest: 'dev/vendor'
        ,
          expand: true
          cwd: 'src/components'
          src: ['**/*']
          dest: 'dev/components'
        ,
          expand: true
          cwd: "src/"
          src: ["*.ico", "*.txt"]
          dest: "dev/"
        ,
          expand: true
          cwd: "src/images/"
          src: ["*"]
          dest: "dev/images/"
        ]

    # not dynamically getting waypoint scripts
    concat:
      prod:
        files:
          '.tmp/styles/app.min.css': ['.tmp/styles/*.css']
          '.tmp/scripts/app.min.js': ['.tmp/scripts/*.js']

    jade:
      options:
        pretty: true
      dev:
        options:
          data:
            cssFiles: devCssFiles
            jsFiles: devJsFiles
        files: [
          expand: true
          cwd: "src"
          src: ["templates/work.site.jade"]
          dest: "dev"
          ext: ".site.html"
        ,
          expand: true
          cwd: "src"
          src: ["templates/**/*.jade", "!templates/work.site.jade"]
          dest: "dev"
          ext: ".html"
        ,
          cwd: "src"
          dest: "dev"
          expand: true
          src: ["*.jade"]
          ext: ".html"
        ]
      prod:
        options:
          data:
            cssFiles: prodCssFiles
            jsFiles: prodJsFiles
        files: [
          cwd: "src"
          src: ["templates/**/*.jade", "!templates/work.site.jade"]
          dest: ".tmp"
          expand: true,
          ext: ".html"
        ,
          expand: true
          cwd: "src"
          src: ["templates/work.site.jade"]
          dest: ".tmp"
          ext: ".site.html"
        ,
          cwd: "src"
          dest: "prod"
          expand: true
          src: ["*.jade"]
          ext: ".html"
        ]

    ngtemplates:
      prod:
        options:
          module: 'App'
        files: [
          cwd: '.tmp/',
          src: ['templates/**/*.html', 'templates/*.html'],
          dest: '.tmp/scripts/templates.js'
        ]

    open:
      server:
        path: "http://localhost:#{SERVER_PORT}"

    watch:
      js:
        files: "src/scripts/vendor/*.js"
        tasks: ["copy:dev:js"]
      sass:
        files: "src/styles/{,*/}*.{scss,sass}"
        tasks: ["newer:sass:dev"]
      images:
        files: "src/images/*"
        tasks: ["copy:dev:images"]
      jade:
        files: ["src/**/*.jade"]
        tasks: ["newer:jade:dev"]
      coffee:
        files: ["src/scripts/**/*.coffee"]
        tasks: ["newer:coffee:dev"]
      livereload:
        options:
          livereload: LIVERELOAD_PORT
        files: [
          "dev/index.html",
          "dev/templates/**/*.html",
          "dev/styles/*.css",
          "dev/scripts/{,*/}*.js",
          "dev/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]

  pkg: grunt.file.readJSON('package.json')

  require( 'matchdep' ).filterDev('grunt-*').forEach( grunt.loadNpmTasks );

  grunt.registerTask "default", [
    "clean:dev",
    "jade:dev",
    "sass:dev",
    "coffee:dev",
    "copy:dev",
    "connect:dev",
    "open",
    "watch"
  ]

  grunt.registerTask "deploy", [
    "prod",
    "invalidate_cloudfront",
    "s3"
  ]

  grunt.registerTask "view-prod", [
    "prod",
    "open"
    "connect:prod"
  ]

  grunt.registerTask "prod", [
    "clean:prod",
    "copy:prod",
    "jade:prod",
    "coffee:prod",
    "ngtemplates",
    "sass:prod",
    "concat:prod",
    "cssmin:prod",
    "ngmin:prod",
    "uglify:prod"
  ]
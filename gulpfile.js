var gulp = require('gulp'),
  open = require("gulp-open"),
  util = require('gulp-util'),
  concat = require('gulp-concat'),
  sass = require('gulp-sass'),
  jade = require('gulp-jade'),
  coffee = require('gulp-coffee'),
  inject = require('gulp-inject'),
  clean = require('gulp-clean'),
  refresh = require('gulp-livereload'),
  lr = require('tiny-lr'),
  order = require("gulp-order"),
  minifyCSS = require('gulp-minify-css'),
  embedlr = require('gulp-embedlr'),
  open = require("gulp-open"),
  yaml = require('js-yaml'),
  es = require('event-stream'),
  fs = require('fs'),
  runSequence = require('run-sequence');
  server = lr();

var secret = yaml.load(fs.readFileSync(__dirname + '/secret.yaml', 'utf8'));
var bowerIncludes = yaml.load(fs.readFileSync(__dirname + '/bower-includes.yaml', 'utf8'));

var paths = {
  dev: 'dev',
  source: {
    coffee: ['src/scripts/**/*.coffee'],
    sass: ['src/styles/**/*.sass'],
    jade: ['src/**/*.jade'],
    static: ['src/favicon.ico', 'src/robots.txt', 'src/images']
  }
};

function startExpress(dir) {
  var express = require('express');
  var app = express();
  app.use(express.static(__dirname + '/' + dir));
  app.listen(4000);
}

gulp.task('clean', function() {
  return gulp.src('dev', {read: false})
    .pipe(clean({force: true}));
})

gulp.task('coffee', function() {
  return gulp.src(paths.source.coffee)
    .pipe(coffee())
    .pipe(gulp.dest('dev/scripts'))
})

gulp.task('concat-js', function() {
  return gulp.src(bowerIncludes["js"])
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest('dev/scripts'))
})

gulp.task('concat-css', function() {
  return gulp.src(bowerIncludes["css"])
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('dev/styles'))
})

gulp.task('inject-js', function() {
  return gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/scripts/vendor.js'), {
      ignorePath: paths.dev,
      addRootSlash: false,
      starttag: '<!-- inject:vendor:{{ext}} -->'
    }))
    .pipe(inject(gulp.src(['dev/scripts/**/*.js', '!dev/scripts/vendor.js']), {
      ignorePath: paths.dev,
      addRootSlash: false,
      starttag: '<!-- inject:{{ext}} -->'
    }))
    .pipe(gulp.dest("./dev"));
})


gulp.task('sass', function() {
  return gulp.src('src/styles/**/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('dev/styles'))
})

gulp.task('inject-css', function() {
  return gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/styles/vendor.css'), {
      ignorePath: paths.dev,
      addRootSlash: false,
      starttag: '<!-- inject:vendor:{{ext}} -->'
    }))
    .pipe(inject(gulp.src('dev/**/*.css'), {
      ignorePath: paths.dev,
      addRootSlash: false,
      starttag: '<!-- inject:{{ext}} -->'
    }))
    .pipe(gulp.dest(paths.dev));
})

gulp.task('jade', function() {
  return gulp.src(paths.source.jade)
    .pipe(jade())
    .pipe(embedlr())
    .pipe(gulp.dest(paths.dev))
})

gulp.task('copy', function() {
  return gulp.src(paths.source.static)
    .pipe(gulp.dest(paths.dev))
})

gulp.task('lr-server', function() {
  server.listen(35729, function(err) {
    if(err) return console.log(err);
  });
})

gulp.task('watch', function() {
  gulp.watch(paths.source.coffee, ['coffee']);
  gulp.watch(paths.source.jade, ['jade']);
  gulp.watch(paths.source.sass, ['sass']);
})

gulp.task('build', function(callback) {
  runSequence(
    'clean',
    ['copy', 'jade', 'coffee', 'concat-js', 'sass', 'concat-css'],
    'inject-js',
    'inject-css',
    callback
  );
});

gulp.task('default', function() {
  startExpress('dev');
  gulp.run('build');
  gulp.run('watch');
})
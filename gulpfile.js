var gulp = require('gulp');
var open = require("gulp-open");
var util = require('gulp-util');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var jade = require('gulp-jade');
var coffee = require('gulp-coffee');
var inject = require('gulp-inject');
var clean = require('gulp-clean');
var refresh = require('gulp-livereload');
var lr = require('tiny-lr');
var minifyCSS = require('gulp-minify-css');
var embedlr = require('gulp-embedlr');
var open = require("gulp-open");
var yaml = require('js-yaml');
var fs = require('fs');
var server = lr();

var secret = yaml.load(fs.readFileSync(__dirname + '/secret.yaml', 'utf8'));
var bowerIncludes = yaml.load(fs.readFileSync(__dirname + '/bower-includes.yaml', 'utf8'));

function startExpress(dir) {
  var express = require('express');
  var app = express();
  app.use(express.static(__dirname + '/' + dir));
  app.listen(4000);
}

var includes = open("./bower-includes.yml");

gulp.task('clean', function() {
  gulp.src('dev', {read: false})
    .pipe(clean({force: true}));
});

gulp.task('coffee', function() {
  gulp.src(['src/scripts/**/*.coffee'])
    .pipe(coffee())
    .pipe(gulp.dest('dev/scripts'))
    .pipe(refresh(server))
})

gulp.task('concat-js', function() {
  gulp.src(bowerIncludes["js"])
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest('dev/scripts/'))
})

gulp.task('inject-js', function() {
  gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/**/*.js'), {
      ignorePath: '/dev/',
      addRootSlash: false
    }))
    .pipe(gulp.dest("./dev"));
})

gulp.task('sass', function() {
  gulp.src(['src/styles/**/*.scss'])
    .pipe(sass())
    .pipe(gulp.dest('dev/styles'))
    .pipe(refresh(server))  
})

gulp.task('inject-css', function() {
  gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/**/*.css'), {
      ignorePath: '/dev/',
      addRootSlash: false
    }))
    .pipe(gulp.dest("./dev"));
})

gulp.task('jade', function() {
  gulp.src(["src/**/*.jade", "!src/components/"])
    .pipe(jade())
    .pipe(embedlr())
    .pipe(gulp.dest('dev/'))
    .pipe(refresh(server));
})

gulp.task('copy', function() {
  gulp.src(['src/favicon.ico', 'src/robots.txt'])
    .pipe(gulp.dest('dev/'))
    .pipe(refresh(server))
  gulp.src('src/images/*')
    .pipe(gulp.dest('dev/images/'))
    .pipe(refresh(server))
})

gulp.task('lr-server', function() {
  server.listen(35729, function(err) {
    if(err) return console.log(err);
  });
})

gulp.task('build-js', ['coffee', 'concat-js', 'inject-js']);
gulp.task('build-css', ['sass', 'concat-css', 'inject-css']);
gulp.task('build', ['jade', 'build-js', 'build-css']);

gulp.task('default', function() {
  // startExpress('dev');

  // gulp.run('copy', 'build');

  // gulp.watch('app/src/**', function(event) {
  //   gulp.run('scripts');
  // })

  // gulp.watch('app/css/**', function(event) {
  //   gulp.run('styles');
  // })

  // gulp.watch('app/**/*.html', function(event) {
  //   gulp.run('html');
  // })
})
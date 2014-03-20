var gulp = require('gulp');
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
var bower = require('gulp-bower');
var server = lr();

function startExpress(dir) {
  var express = require('express');
  var app = express();
  app.use(express.static(__dirname + '/' + dir));
  app.listen(4000);
}

gulp.task('clean', function() {
  gulp.src('dev', {read: false})
    .pipe(clean({force: true}));
});

gulp.task('bower', function() {
  bower()
    .pipe(gulp.dest('dev/lib'))
});

gulp.task('build-js', function() {
  gulp.src(['src/scripts/**/*.coffee'])
    .pipe(coffee())
    .pipe(gulp.dest('dev/scripts'))
    .pipe(refresh(server))

  gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/**/*.js'), {
      ignorePath: '/dev/',
      addRootSlash: false
    }))
    .pipe(gulp.dest("./dev"));
})

gulp.task('build-css', function() {
  gulp.src(['src/styles/**/*.scss'])
    .pipe(sass())
    .pipe(gulp.dest('dev/styles'))
    .pipe(refresh(server))

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

// "dev/lib/lodash/dist/lodash.min.js",
// "dev/lib/jquery/jquery.min.js",
// "dev/lib/fancybox/source/jquery.fancybox.pack.js",
// "dev/lib/angular/angular.min.js",
// "dev/lib/angular-ui-router/release/angular-ui-router.js",
// "dev/lib/zoomerang/zoomerang.js",

gulp.task('build', ['jade', 'build-js', 'build-css']);

gulp.task('default', function() {
  startExpress('dev');

  gulp.run('copy', 'build');

  gulp.watch('app/src/**', function(event) {
    gulp.run('scripts');
  })

  gulp.watch('app/css/**', function(event) {
    gulp.run('styles');
  })

  gulp.watch('app/**/*.html', function(event) {
    gulp.run('html');
  })
})
var gulp = require('gulp');
var browserify = require('gulp-browserify');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var jade = require('gulp-jade');
var coffee = require('gulp-coffee');
var inject = require('gulp-inject');
var refresh = require('gulp-livereload');
var lr = require('tiny-lr');
var server = lr();
var minifyCSS = require('gulp-minify-css');
var embedlr = require('gulp-embedlr');
var open = require("gulp-open");

gulp.task('scripts', function() {
  gulp.src(['src/scripts/**/*.coffee'])
    .pipe(coffee())
    .pipe(gulp.dest('dev/scripts'))
    .pipe(refresh(server))
})

gulp.task('styles', function() {
  gulp.src(['src/styles/*.scss'])
    .pipe(sass())
    // .pipe(minifyCSS())
    .pipe(gulp.dest('dev/styles'))
    .pipe(refresh(server))
})

gulp.task('copy', function() {
  gulp.src([
    "src/components/fancybox/source/jquery.fancybox.css",
    "src/components/font-awesome/css/font-awesome.min.css",
    "src/components/normalize-css/normalize.css"
  ])
    .pipe(gulp.dest('dev/styles/vendor/'))
    .pipe(refresh(server))
  gulp.src([
    "components/lodash/dist/lodash.min",
    "components/jquery/jquery.min",
    "components/fancybox/source/jquery.fancybox.pack",
    "components/angular/angular.min",
    "components/angular-ui-router/release/angular-ui-router",
    "components/zoomerang/zoomerang"
  ])
    .pipe(gulp.dest('dev/scripts/vendor/'))
    .pipe(refresh(server))
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

gulp.task('markup', function() {
  gulp.src(["src/**/*.jade", "!src/components/"])
    .pipe(jade())
    .pipe(embedlr())
    .pipe(gulp.dest('dev/'))
    .pipe(refresh(server));
})

gulp.task('inject', function() {
  gulp.src('./dev/index.html')
    .pipe(inject(gulp.src([
      "dev/styles/vendor/**/*.css",
      "dev/styles/**/*.css",
      "dev/scripts/vendor/**/*.js",
      "dev/scripts/**/*.js"
    ], {read: false}))) 
    .pipe(gulp.dest("./dev"));
})

gulp.task('default', function() {
  gulp.run('lr-server', 'scripts', 'styles', 'markup', 'copy', 'inject');

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
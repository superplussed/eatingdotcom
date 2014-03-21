var app, base, concat, connect, directory, gulp, gutil, hostname, http, lr, open, path, refresh, sass, server, imagemin, cache, minifyCSS, clean;

var args = require('yargs').argv;
var gulp = require('gulp');
var gutil = require('gulp-util');
var concat = require('gulp-concat');
var inject = require('gulp-inject');
var sass = require('gulp-sass');
var jade = require('gulp-jade');
var refresh = require('gulp-livereload');
var open = require('gulp-open');
var connect = require('connect');
var http = require('http');
var path = require('path');
var lr = require('tiny-lr');
var imagemin = require('gulp-imagemin');
var cache = require('gulp-cache');
var minifyCSS = require('gulp-minify-css');
var clean = require('gulp-clean');
var coffee = require('gulp-coffee');
var embedlr = require('gulp-embedlr');
var gulpIf = require('gulp-if');

var isProduction = args.type === 'production';

if (isProduction) {
  destFolder = "dev"
} else {
  destFolder = "prod"
}

var server = lr();

gulp.task('webserver', function() {
  var port = 3000;
  hostname = null;
  base = path.resolve('dev');
  directory = path.resolve('dev');
  app = connect().use(connect["static"](base)).use(connect.directory(directory));
  http.createServer(app).listen(port, hostname);
});

gulp.task('livereload', function() {
  server.listen(35729, function(err) {
    if (err != null) {
      return console.log(err);
    }
  });
});

gulp.task('images', function() {
  gulp.src(['src/images/*.jpg', 'src/images/*.png'])
    .pipe(gulpIf(isProduction, imagemin({ optimizationLevel: 5, progressive: true, interlaced: true })))
    .pipe(gulp.dest('dev/images'));
  gulp.src('src/images/*.svg')
    .pipe(gulp.dest('dev/images'));
});

gulp.task('scripts', function() { 
  return gulp.src('src/scripts/**/*.coffee')
    .pipe(coffee())
    .pipe(gulpIf(isProduction, concat('app.js')))
    .on('error', gutil.log)
    .pipe(gulp.dest('dev/scripts'))
    .pipe(gulp.src('dev/index.html'))
    .pipe(inject(gulp.src(['dev/scripts/**/*.js', '!dev/scripts/vendor.js']), {
      ignorePath: "/dev",
      addRootSlash: false,
      starttag: '<!-- inject:{{ext}} -->'
    }))
    .pipe(gulp.dest("./dev"))
    .pipe(refresh(server));
});


gulp.task('styles', function() {
  return gulp.src('src/styles/**/*.scss')
    .pipe(sass())
    .on('error', gutil.log)
    .pipe(gulpIf(isProduction, concat('app.css')))
    .pipe(gulp.dest('dev/styles'))
    .pipe(gulp.src('dev/index.html'))
    .pipe(inject(gulp.src(['dev/styles/**/*.css', '!dev/styles/vendor.css']), {
      ignorePath: "/dev",
      addRootSlash: false,
      starttag: '<!-- inject:{{ext}} -->'
    }))
    .pipe(gulp.dest("./dev"))
    .pipe(refresh(server));
});

gulp.task('markup', function() {
  return gulp.src('src/**/*.jade')
    .on('error', gutil.log)
    .pipe(jade())
    .pipe(embedlr())
    .pipe(gulp.dest('dev'))
    .pipe(refresh(server));
});

gulp.task('clean', function() {
  return gulp.src(['dev/*'], {read: false})
    .pipe(clean());
});

gulp.task("default", ["clean", "webserver", "livereload", "images", "scripts", "styles", "markup"], function() {
  gulp.watch('src/scripts/**/*', ['scripts']);
  gulp.watch('src/styles/**/*', ['styles']);
  gulp.watch('src/*.html', ['html']);
  gulp.src("dev/index.html")
    .pipe(open("", {url: "http://0.0.0.0:3000"}));

})


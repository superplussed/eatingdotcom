// src: ['templates/**/*.html', 'templates/*.html'],
// dest: '.tmp/scripts/templates.js'

var args = require('yargs').argv,
  gulp = require('gulp'),
  gutil = require('gulp-util'),
  concat = require('gulp-concat'),
  inject = require('gulp-inject'),
  sass = require('gulp-sass'),
  jade = require('gulp-jade'),
  refresh = require('gulp-livereload'),
  open = require('gulp-open'),
  connect = require('connect'),
  http = require('http'),
  path = require('path'),
  lr = require('tiny-lr'),
  merge = require('merge'),
  imagemin = require('gulp-imagemin'),
  cache = require('gulp-cache'),
  minifyCSS = require('gulp-minify-css'),
  clean = require('gulp-clean'),
  coffee = require('gulp-coffee'),
  embedlr = require('gulp-embedlr'),
  gulpIf = require('gulp-if'),
  yaml = require('js-yaml'),
  fs = require('fs'),
  templateCache = require('gulp-angular-templatecache');

var isProduction = args.type === 'production';
var secret = yaml.load(fs.readFileSync(__dirname + '/secret.yaml', 'utf8'));
var bowerIncludes = yaml.load(fs.readFileSync(__dirname + '/bower-includes.yaml', 'utf8'));
var server = lr();

var injectVars = {
  ignorePath: "dev/",
  addRootSlash: false
}

if (isProduction) {
  var destFolder = "dev"
} else {
  var destFolder = "prod"
}

gulp.task('webserver', function() {
  var port = 3000;
  var hostname = null;
  var base = path.resolve('dev');
  var directory = path.resolve('dev');
  var app = connect().use(connect["static"](base)).use(connect.directory(directory));
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

gulp.task('bower-styles', function(cb) {
  return gulp.src(bowerIncludes["css"])
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('dev/styles'))
})

gulp.task('bower-scripts', function(cb) {
  return gulp.src(bowerIncludes["js"])
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest('dev/scripts'))
})

gulp.task('styles', function() {
  return gulp.src('src/styles/**/*.scss')
    .pipe(sass())
    .on('error', gutil.log)
    .pipe(concat('app.css'))
    .pipe(gulp.dest('dev/styles'))
    .pipe(refresh(server));
});

gulp.task('scripts', function() { 
  return gulp.src('src/scripts/**/*.coffee')
    .pipe(coffee())
    .pipe(concat('app.js'))
    .on('error', gutil.log)
    .pipe(gulp.dest('dev/scripts'))
    .pipe(refresh(server));
});

gulp.task('markup', function() {
  return gulp.src('src/*.jade')
    .pipe(jade())
    .pipe(gulp.dest('dev'))
    .pipe(refresh(server));
});

gulp.task('templates', function () {
  return gulp.src(['src/templates/*.jade', 'src/templates/**/*.jade'])
    .pipe(jade())
    .pipe(gulp.dest('src/templates/'))
    .pipe(gulp.src(['src/templates/*.html', 'src/templates/**/*.html']))
    .pipe(templateCache())
    .pipe(gulp.dest('dev/scripts'));
});

gulp.task('templates-clean', ['templates-compile'], function() {
  return gulp.src(['src/templates/**/*.html'], {read: false})
    .pipe(clean());
})

// gulp.task('templates', ['templates-compile', 'templates-clean']);

gulp.task('clean', function() {
  return gulp.src(['dev/*'], {read: false})
    .pipe(clean());
});

gulp.task('default', ['clean', 'webserver', 'livereload', 'markup', 'templates', 'images', 'bower-scripts', 'bower-styles', 'scripts', 'styles'], function() {
  gulp.watch('src/scripts/**/*', ['scripts']);
  gulp.watch('src/styles/**/*', ['styles']);
  gulp.watch('src/**/*.jade', ['markup']);
  gulp.src("dev/index.html")
    .pipe(open("", {url: "http://0.0.0.0:3000"}));
})
  
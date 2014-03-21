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
  imagemin = require('gulp-imagemin'),
  cache = require('gulp-cache'),
  minifyCSS = require('gulp-minify-css'),
  clean = require('gulp-clean'),
  coffee = require('gulp-coffee'),
  embedlr = require('gulp-embedlr'),
  gulpIf = require('gulp-if'),
  yaml = require('js-yaml'),
  fs = require('fs'),
  runSequence = require('run-sequence');

var isProduction = args.type === 'production';
var secret = yaml.load(fs.readFileSync(__dirname + '/secret.yaml', 'utf8'));
var bowerIncludes = yaml.load(fs.readFileSync(__dirname + '/bower-includes.yaml', 'utf8'));
var server = lr();

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

gulp.task('bower-styles-collect', function(cb) {
  return gulp.src(bowerIncludes["css"])
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('dev/styles'))
})

gulp.task("bower-styles-inject", ['bower-styles-collect'], function() {
  return gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/styles/vendor.css'), {
      ignorePath: '/dev',
      addRootSlash: false,
      starttag: '<!-- inject:vendor:css -->'
    }))
    .pipe(gulp.dest("./dev"))
})

gulp.task('bower-scripts-collect', function(cb) {
  return gulp.src(bowerIncludes["js"])
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest('dev/scripts'))
})

gulp.task("bower-scripts-inject", ['bower-scripts-collect'], function() {
  return gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/scripts/vendor.js'), {
      ignorePath: '/dev',
      addRootSlash: false,
      starttag: '<!-- inject:vendor:js -->'
    }))
    .pipe(gulp.dest("./dev"))
})

gulp.task('styles-collect', function() {
  return gulp.src('src/styles/**/*.scss')
    .pipe(sass())
    .on('error', gutil.log)
    .pipe(gulpIf(isProduction, concat('app.css')))
    .pipe(gulp.dest('dev/styles'))
    .pipe(refresh(server));
});

gulp.task('styles-inject', function() {
  return gulp.src('dev/index.html')
    .pipe(inject(gulp.src(['dev/styles/**/*.css', '!dev/styles/vendor.css']), {
      ignorePath: "/dev",
      addRootSlash: false,
      starttag: '<!-- inject:{{ext}} -->'
    }))
    .pipe(gulp.dest("./dev"))
})

gulp.task('scripts-collect', function() { 
  return gulp.src('src/scripts/**/*.coffee')
    .pipe(coffee())
    .pipe(gulpIf(isProduction, concat('app.js')))
    .on('error', gutil.log)
    .pipe(gulp.dest('dev/scripts'))
    .pipe(refresh(server));
});

gulp.task('scripts-inject', function() {
  return gulp.src('dev/index.html')
    .pipe(inject(gulp.src(['dev/scripts/**/*.js', '!dev/scripts/vendor.js']), {
      ignorePath: "/dev",
      addRootSlash: false,
      starttag: '<!-- inject:{{ext}} -->'
    }))
    .pipe(gulp.dest("./dev"))
})

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

gulp.task('open', function() {
  return gulp.src("dev/index.html")
    .pipe(open("", {url: "http://0.0.0.0:3000"}));
});

gulp.task('watch', function() {
  gulp.watch('src/scripts/**/*.coffee', ['scripts']);
  gulp.watch('src/styles/**/*.scss', ['styles']);
  gulp.watch('src/**/*.jade', ['jade']);
});

gulp.task('bower-styles', function(callback) {
  runSequence('bower-styles-collect', 'bower-styles-inject', callback);
})

gulp.task('bower-scripts', function(callback) {
  runSequence('bower-scripts-collect', 'bower-scripts-inject', callback);
})

gulp.task('styles', function(callback) {
  runSequence('styles-collect', 'styles-inject', callback);
})

gulp.task('scripts', function(callback) {
  runSequence('scripts-collect', 'scripts-inject', callback);
})

gulp.task("default", function(callback) {
  runSequence('clean', 'markup', 'styles', 'scripts', 'bower-styles', 'bower-scripts', callback);
})
  
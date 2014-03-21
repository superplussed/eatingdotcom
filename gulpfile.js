var gulp = require('gulp'),
  open = require("gulp-open"),
  util = require('gulp-util'),
  concat = require('gulp-concat'),
  sass = require('gulp-sass'),
  jade = require('gulp-jade'),
  coffee = require('gulp-coffee'),
  inject = require('gulp-inject'),
  clean = require('gulp-clean'),
  livereload = require('gulp-livereload'),
  lr = require('tiny-lr'),
  order = require("gulp-order"),
  minifyCSS = require('gulp-minify-css'),
  open = require("gulp-open"),
  yaml = require('js-yaml'),
  es = require('event-stream'),
  fs = require('fs'),
  runSequence = require('run-sequence');

var server = lr();
var secret = yaml.load(fs.readFileSync(__dirname + '/secret.yaml', 'utf8'));
var bowerIncludes = yaml.load(fs.readFileSync(__dirname + '/bower-includes.yaml', 'utf8'));

var paths = {
  source: {
    coffee: ['src/scripts/**/*.coffee'],
    sass: ['src/styles/**/*.sass'],
    jade: ['src/**/*.jade']
  }
};

var injectOptions = {
  ignorePath: "dev/",
  addRootSlash: false
}


gulp.task('webserver', function() {
  var port = 3000;
  hostname = null;
  base = path.resolve('app');
  directory = path.resolve('app');
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

gulp.task('clean', function() {
  return gulp.src('dev', {read: false})
    .pipe(clean({force: true}));
})

gulp.task('styles', function() {
  return gulp.src(paths.source.coffee)
    .pipe(coffee())
    .pipe(gulp.dest('dev/scripts'))
    .pipe(inject(gulp.src('dev/**/*.css'), 
      injectOptions.merge({starttag: '<!-- inject:{{ext}} -->'})
    ))
})

gulp.task('scripts', function() {
  return gulp.src(paths.source.coffee)
    .pipe(coffee())
    .pipe(gulp.dest('dev/scripts'))
    .pipe(inject(gulp.src(['dev/scripts/**/*.js', '!dev/scripts/vendor.js']), 
      injectOptions.merge({starttag: '<!-- inject:{{ext}} -->'})
    ))
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
    .pipe(inject(gulp.src('dev/scripts/vendor.js'), 
      injectOptions.merge({starttag: '<!-- inject:vendor:{{ext}} -->'})
    ))
    .pipe(gulp.dest("./dev"));
})

gulp.task('concat-css', function() {
  return gulp.src(bowerIncludes["css"])
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('dev/styles'))
    .pipe(inject(gulp.src('dev/styles/vendor.css'), 
      injectOptions.merge({starttag: '<!-- inject:vendor:{{ext}} -->'})
    ))
    .pipe(gulp.dest("./dev"));
})

// gulp.task('inject', function() {
//   var options = {
//     ignorePath: "dev/",
//     addRootSlash: false
//   }
//   return gulp.src('dev/index.html')
//     .pipe(inject(gulp.src('dev/scripts/vendor.js'), 
//       options.merge({starttag: '<!-- inject:vendor:{{ext}} -->'})
//     ))
//     .pipe(inject(gulp.src(['dev/scripts/**/*.js', '!dev/scripts/vendor.js']), 
//       options.merge({starttag: '<!-- inject:{{ext}} -->'})
//     ))
//     .pipe(inject(gulp.src('dev/styles/vendor.css'), 
//       options.merge({starttag: '<!-- inject:vendor:{{ext}} -->'})
//     ))
//     .pipe(inject(gulp.src('dev/**/*.css'), 
//       options.merge({starttag: '<!-- inject:{{ext}} -->'})
//     ))
//     .pipe(gulp.dest("./dev"));
// })


gulp.task('sass', function() {
  return gulp.src('src/styles/**/*.scss')
    .pipe(sass())
    .pipe(gulp.dest('dev/styles'))
})

gulp.task('jade', function() {
  return gulp.src(paths.source.jade)
    .pipe(jade())
    .pipe(gulp.dest("dev/"))
})

gulp.task('copy', function() {
  gulp.src(['src/favicon.ico', 'src/robots.txt'])
    .pipe(gulp.dest("dev/"))
  gulp.src(['src/images/**/*'])
    .pipe(gulp.dest("dev/images/"))
})

gulp.task('build', function(callback) {
  runSequence('clean', ['copy', 'jade', 'coffee', 'concat-js', 'sass', 'concat-css'], 'inject', callback);
});

gulp.task('compile-html', function(callback) {
  runSequence('jade', 'inject', callback);
})

gulp.task('default', ['webserver', 'livereload', 'compile-html', 'scripts', 'styles'], function() {
  gulp.watch(paths.source.coffee, ['scripts']);
  gulp.watch(paths.source.sass, ['styles']);
});


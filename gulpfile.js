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
  server = lr();

var secret = yaml.load(fs.readFileSync(__dirname + '/secret.yaml', 'utf8'));
var bowerIncludes = yaml.load(fs.readFileSync(__dirname + '/bower-includes.yaml', 'utf8'));

function startExpress(dir) {
  var express = require('express');
  var app = express();
  app.use(express.static(__dirname + '/' + dir));
  app.listen(4000);
}

gulp.task('clean', function() {
  gulp.src('dev', {read: false})
    .pipe(clean({force: true}));
})

gulp.task('coffee', function() {
  gulp.src(['src/scripts/**/*.coffee'])
    .pipe(coffee())
    .pipe(gulp.dest('dev/scripts'))
    .pipe(refresh(server))
})

gulp.task('concat-js', function() {
  gulp.src(bowerIncludes["js"])
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest('dev/vendor'))
})

gulp.task('concat-css', function() {
  gulp.src(bowerIncludes["css"])
    .pipe(concat('vendor.css'))
    .pipe(gulp.dest('dev/vendor'))
})

gulp.task('inject-js', function() {
  gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/vendor/vendor.js'), {
      ignorePath: '/dev/',
      addRootSlash: false,
      starttag: '<!-- inject:vendor:{{ext}} -->'
    }))
    .pipe(inject(gulp.src('dev/**/*.js'), {
      ignorePath: '/dev/',
      addRootSlash: false,
      starttag: '<!-- inject:{{ext}} -->'
    }))
    .pipe(gulp.dest("./dev"));
})

// gulp.task('inject-js', function() {
//   gulp.src('dev/index.html')
//     .pipe(inject('dev/vendor/vendor.js', {
//       ignorePath: '/dev/',
//       addRootSlash: false
//       // starttag: '<!-- inject:vendor:js -->'
//     }))
//     // .pipe(inject('dev/scripts/**/*.js', {
//     //   ignorePath: '/dev/',
//     //   addRootSlash: false
//     // }))
//     .pipe(gulp.dest("./dev"));
// })

gulp.task('sass', function() {
  gulp.src(['src/styles/**/*.scss'])
    .pipe(sass())
    .pipe(gulp.dest('dev/styles'))
    .pipe(refresh(server))  
})

gulp.task('inject-css', function() {
  gulp.src('dev/index.html')
    .pipe(inject(gulp.src('dev/styles/vendor.css'), {
      ignorePath: '/dev/',
      addRootSlash: false
    }))
    .pipe(inject(gulp.src('dev/**/*.css'), {
      ignorePath: '/dev/',
      addRootSlash: false
    }))
    .pipe(gulp.dest("dev"));
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
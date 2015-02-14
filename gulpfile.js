/* jshint node:true */
notifier = require("node-notifier")
// generated on 2015-01-17 using generator-gulp-webapp 0.2.0
var gulp = require('gulp');
var $ = require('gulp-load-plugins')();
var browserify = require('browserify');
var source = require('vinyl-source-stream');
fs = require("fs")
_ = require("lodash")

notify = function(err){
  notifier.notify({
    'title': 'Coffeescript error',
    'message': err.toString(),
    'sound': true
  });
  $.util.log(err); 
  this.emit("end") 
}

gulp.task('coffeescript', function () {
  return gulp.src(['app/**/*.coffee', 'test/**/*.coffee'])
    .pipe($.coffee().on('error', notify))
    .pipe(gulp.dest('.tmp'));
});

gulp.task('browserify', ['coffeescript'], function() {
  return browserify('./.tmp/scripts/main', {debug: true})
      .bundle().on('error', notify)
      //Pass desired output filename to vinyl-source-stream
      .pipe(source('bundle.js'))
      // Start piping stream to tasks!
      .pipe(gulp.dest('./.tmp/scripts'));
});

gulp.task('spec-browserify', ['coffeescript'], function() {
  base = __dirname + '/.tmp/spec'
  files = fs.readdirSync(base)
  streams = _(files).filter(function(filename){
    return filename.match(/.*_specs\.js/)
  }).map(function(filename){
    console.log(base + "/" + filename)
    return fs.createReadStream(base + "/" + filename);
  })
  .value()

  return browserify(streams, {debug: true})
      .bundle().on('error', notify)
      //Pass desired output filename to vinyl-source-stream
      .pipe(source('spec-bundle.js'))
      // Start piping stream to tasks!
      .pipe(gulp.dest('./.tmp/spec'));
});

gulp.task('test', ['scripts'], function(){
  return gulp.src(".tmp/spec/**/*.js")
    .pipe($.jasmine())
});

gulp.task('scripts', ['coffeescript', 'browserify', 'spec-browserify'])
gulp.task('spec-scripts', ['coffeescript', 'spec-browserify'])

gulp.task('styles', function () {
  return gulp.src('app/styles/main.css')
    .pipe($.autoprefixer({browsers: ['last 1 version']}))
    .pipe(gulp.dest('.tmp/styles'));
});

gulp.task('jshint', function () {
  return gulp.src('app/scripts/**/*.js')
    .pipe($.jshint())
    .pipe($.jshint.reporter('jshint-stylish'))
    .pipe($.jshint.reporter('fail'));
});

gulp.task('html', ['styles', 'scripts'], function () {
  var assets = $.useref.assets({searchPath: '{.tmp,app}'});

  return gulp.src('app/*.html')
    .pipe(assets)
    .pipe($.if('*.js', $.uglify()))
    .pipe($.if('*.css', $.csso()))
    .pipe(assets.restore())
    .pipe($.useref())
    .pipe($.if('*.html', $.minifyHtml({conditionals: true, loose: true})))
    .pipe(gulp.dest('dist'));
});

gulp.task('images', function () {
  return gulp.src('app/images/**/*')
    .pipe($.cache($.imagemin({
      progressive: true,
      interlaced: true
    })))
    .pipe(gulp.dest('dist/images'));
});

gulp.task('fonts', function () {
  return gulp.src(require('main-bower-files')().concat('app/fonts/**/*'))
    .pipe($.filter('**/*.{eot,svg,ttf,woff}'))
    .pipe($.flatten())
    .pipe(gulp.dest('dist/fonts'));
});

gulp.task('extras', function () {
  return gulp.src([
    'app/*.*',
    '!app/*.html',
    'node_modules/apache-server-configs/dist/.htaccess'
  ], {
    dot: true
  }).pipe(gulp.dest('dist'));
});

gulp.task('clean', require('del').bind(null, ['.tmp', 'dist']));

gulp.task('connect', ['styles', 'scripts', 'fonts'], function () {
  var serveStatic = require('serve-static');
  var serveIndex = require('serve-index');
  var app = require('connect')()
    .use(require('connect-livereload')({port: 35729}))
    .use(serveStatic('.tmp'))
    .use(serveStatic('app'))
    .use('/test', serveStatic('test'))
    // paths to bower_components should be relative to the current file
    // e.g. in app/index.html you should use ../bower_components
    .use('/bower_components', serveStatic('bower_components'))
    .use(serveIndex('app'))
    .use('/test', serveIndex('test'));

  require('http').createServer(app)
    .listen(9000)
    .on('listening', function () {
      console.log('Started connect web server on http://localhost:9000');
    });
});

gulp.task('serve', ['connect', 'watch'], function () {
  require('opn')('http://localhost:9000');
});

// inject bower components
gulp.task('wiredep', function () {
  var wiredep = require('wiredep').stream;

  gulp.src('app/*.html')
    .pipe(wiredep())
    .pipe(gulp.dest('app'));
});

gulp.task('watch', ['connect'], function () {
  $.livereload.listen();

  // watch for changes
  gulp.watch([
    'app/*.html',
    '.tmp/styles/**/*.css',
    '.tmp/scripts/bundle.js',
    'app/scripts/**/*.js',
    'app/images/**/*',
  ]).on('change', $.livereload.changed);

  gulp.watch('app/styles/**/*.css', ['styles']);
  gulp.watch('app/scripts/**/*.coffee', ['scripts']);
  gulp.watch('test/spec/**/*.coffee', ['spec-scripts']);
  gulp.watch('bower.json', ['wiredep']);
});

gulp.task('build', ['jshint', 'html', 'images', 'fonts', 'extras'], function () {
  return gulp.src('dist/**/*').pipe($.size({title: 'build', gzip: true}));
});

gulp.task('default', ['clean'], function () {
  gulp.start('build');
});


var gulp = require('gulp');
var sys = require('sys')
var exec = require('child_process').exec;

gulp.task('default', function() {
    var watch = gulp.watch('**', function(event) {
        var dir = event.path.replace("/home/ubuntu/workspace/",'');
        dir = dir.substr(0, dir.lastIndexOf("/")+ 1);
        exec("bash ftp.sh "+ dir + " up", puts); 
    });
});

function puts(error, stdout, stderr) { 
    sys.puts(stdout) 
}

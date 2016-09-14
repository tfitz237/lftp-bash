var gulp = require('gulp');
var sys = require('sys')
var exec = require('child_process').exec;

var localfolder = "/home/ubuntu/workspace/";


gulp.task('default', function() {
    var watch = gulp.watch('**', function(event) {
        var dir = event.path.replace(localfolder,'');
        dir = dir.substr(0, dir.lastIndexOf("/")+ 1);
        exec("bash ftp.sh "+ dir + " -u", puts); 
    });
});

gulp.task('sync-delete', function() {
    var watch = gulp.watch('**', function(event) {
        var dir = event.path.replace(localfolder,'');
        dir = dir.substr(0, dir.lastIndexOf("/")+ 1);
        exec("bash ftp.sh "+ dir + " -u --delete", puts); 
    });
});

function puts(error, stdout, stderr) { 
    sys.puts(stdout) 
}

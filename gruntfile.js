module.exports = function (grunt) {

    grunt.initConfig({
        uncss: {
            dist: {
                files: [
                    { src: 'index.html', dest: 'cleancss/tidy.css' }
                ]
            }
        },
        cssmin: {
            dist: {
                files: [
                    { src: 'cleancss/tidy.css', dest: 'cleancss/tidy.css' }
                ]
            }
        }
    });

    // Load the plugins
    grunt.loadNpmTasks('grunt-uncss');
    grunt.loadNpmTasks('grunt-contrib-cssmin');

    // Default tasks.
    grunt.registerTask('default', ['uncss', 'cssmin']);

};
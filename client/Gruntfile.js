module.exports = function(grunt) {

	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		less: {
			dist: {
				options: {
					cleancss: true,
					ieCompat: true
				},
				files: {
					"dist/app.css": "src/css/app.less"
				} 
			}
		},
		uglify: {
			dist: {
				files: {
					'dist/app.js': [
						'src/js/app.js'
					]
				}
			}
		},
		watch: {
			css: {
				files: "src/css/*.less",
				tasks: ['less']
			},
			js: {
				files: "src/js/**/*.js",
				tasks: ['uglify'] 
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-connect');

	grunt.registerTask('compile', ['less', 'uglify']);
	grunt.registerTask('default', ['compile', 'watch']);
};

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
					"dist/assets/app.css": "src/css/app.less"
				} 
			}
		},
		uglify: {
			dist: {
				files: {
					'dist/assets/app.js': [
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
		},
		connect: {
			assetsServer: {
				options: {
					port: 2000,
					hostname: '*',
					base: 'dist',
					keepalive: true,
					debug: true
				}
			},
			htmlServer: {
				options: {
					port: 3000,
					hostname: '*',
					base: 'html',
					keepalive: true,
					debug: true
				}
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-uglify');
	grunt.loadNpmTasks('grunt-contrib-watch');
	grunt.loadNpmTasks('grunt-contrib-connect');

	grunt.registerTask('compile', ['less', 'uglify']);
	grunt.registerTask('dev', ['compile', 'watch']);
	grunt.registerTask('serve', ['connect']);
	grunt.registerTask('default', ['dev']);

};

Gem::Specification.new do |x|
	x.name = "nexpose-magic"
	x.version = "0.0.1"
	x.authors = ["Matthew Spah"]
	x.date = %q{2014-03-04}
	x.description = 'Nexpose-magic - Nexpose adminstration CLI tool'
	x.summary = x.description
	x.email = 'spahmatthew@gmail.com'
	x.files = ['README', 'lib/config.yml']
	x.bindir = 'bin'
	x.executables = ['nexpose-magic.rb']
	x.add_dependency('nexpose')
end

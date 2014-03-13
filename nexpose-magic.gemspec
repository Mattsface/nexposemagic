Gem::Specification.new do |x|
	x.name = "nexpose-magic"
	x.version = "0.0.1"
	x.authors = ["Matthew Spah"]
	x.date = %q{2014-03-04}
	x.description = 'Nexpose-magic - Nexpose adminstration CLI tool'
	x.summary = x.description
	x.email = 'spahmatthew@gmail.com'
	x.files = ['README', 'lib/nexpose-magic.rb', 'nexposemagic.rspec']
	x.bindir = 'bin'
	x.executables = ['nexmagic.rb']
	x.add_development_dependency('nexpose')
	x.add_development_dependency("table_print")
end
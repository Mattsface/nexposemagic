Gem::Specification.new do |x|
	x.name = "nexpose-magic"
	x.version = "0.0.3"
	x.authors = ["Matthew Spah"]
	x.date = %q{2014-03-13}
	x.description = 'Nexpose-magic - Nexpose adminstration CLI tool'
	x.summary = x.description
	x.licenses = ["MIT"]
	x.email = 'spahmatthew@gmail.com'
	x.files = ['README', 'lib/nexpose-magic.rb', 'nexposemagic.rspec']
	x.bindir = 'bin'
	x.executables = ['nexmagic.rb']
	x.add_dependency('nexpose')
	x.add_dependency("table_print")
end

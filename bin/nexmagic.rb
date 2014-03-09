#!/usr/bin/env ruby
require 'nexpose-magic'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: nexpose-magic.rb -c [console] [options]"

  opts.separator ""
  opts.separator "Specific options:"

  opts.on('-i', "--ip <IP ADDRESS>", "Nexpose Console IP") do |i|
    options[:ip] = i
  end

  opts.on('-u', "--user <User>", "Nexpose Console User") do |u|
    options[:user] = u
  end

  opts.on('-p', "--password <Password>", "Nexpose Console Password") do |p|
    options[:password] = p
  end

  opts.on("-e", "--engine <Engine ID>", "Display Scan Engine Information") do |e|
    options[:scan_engine] = e
  end

  opts.on("-s", "--site <site ID>", "Display Site Information") do |s|
    options[:site] = s
  end

  opts.on("-v", "--vscans", "Display currently running Nexpose vulnerability scans") do |v|
    options[:scans] = v
  end

  opts.on("-l", "--list [sites] [engines]", "Display tabled list of all Nexpose Sites, or Scan Engines present on a console") do |l|
    options[:list] = l 
  end

  opts.on_tail("-h", "--help", "Show help message") do
    puts opts
    exit
  end
end.parse!

nexpose = NexposeMagic.new(options)
nexpose.connect

if not options[:scan_engine].nil?
  nexpose.populate_engine(options[:scan_engine])
  nexpose.display_engine
elsif not options[:site].nil?
  nexpose.populate_site(options[:site])
  nexpose.display_site
elsif not options[:list].nil?
  nexpose.list(options[:list])
elsif not options[:scans].nil?
  nexpose.display_scans
end

nexpose.logout








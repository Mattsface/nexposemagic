#!/usr/bin/env ruby
require 'nexpose-magic'
require 'optparse'
require 'nexpose'
require 'table_print'
include Nexpose

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

  opts.on('-t', "--port <Port Number>", "Nexpose Port Number") do |t|
    options[:port] = t
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

begin
  nsc = Connection.new(options[:ip], options[:user], options[:password]) if options[:port].nil?
  nsc = Connection.new(options[:ip], options[:user], options[:password], port = options[:port]) if options[:port]
  nsc.login
rescue => e 
  raise e
end  

nexpose = NexposeMagic.new

if not options[:scan_engine].nil?
  nexpose.engine = Engine.load(nsc, options[:scan_engine]) 
  nexpose.populate_engine.each { |x| puts x }

elsif not options[:site].nil?
  nexpose.site = Site.load(nsc, options[:site])
  nexpose.populate_site.each {|x| puts x }

elsif not options[:list].nil?
  case options[:list]
    when "engines"
      nexpose.engines = nsc.list_engines
      nexpose.list_engines
    when "sites"
      nexpose.sites = nsc.list_sites
      nexpose.list_sites
    else
      puts "You gave an invalid list argument"
  end

elsif not options[:scans].nil?
  nexpose.scans = nsc.scan_activity
  nexpose.populate_scans.each { |x| puts x }
end

nsc.logout




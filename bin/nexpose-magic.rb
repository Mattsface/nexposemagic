#!/usr/bin/env ruby

# dependency:
# gem install nexpose
require 'optparse'
require 'nexpose'
require 'yaml'
require 'table_print'
include Nexpose

class NexposeMagic

  def initialize(console)
    @ip = console['ip']
    @user = console['user']
    @password = console['password']
  end

  def connect
    @nsc = Connection.new(@ip, @user, @password)
    
    @nsc.login

    unless @nsc.session_id
      puts 'Console login failure'
      exit 1
    end
  
  end

  def display_site(site)
    @site = Site.load(@nsc, site)
    @assets = convert_ip_range(@site.assets)
    puts "Site Name: #{@site.name}"
    puts "Site Engine ID: #{@site.engine}"
    puts "Site Scan Template: #{@site.scan_template_name}"
    puts "Site Assets: "
    @assets.each { |asset| puts "#{asset}" }
  end

  def convert_ip_range(assets)
    ips = []
    assets.each do |asset|
      unless asset.to
        ips << asset.from
      else
        ips << asset.from + "-" + asset.to
      end
    end
    ips
  end


  def display_scans
    @scans = @nsc.scan_activity

    if @scans.empty?
      puts "No scans currently running"
    else
      puts "Scans currently running:"
      @scans.each do |x|
        puts ""
        puts "Scan ID: #{x.scan_id}"
        puts "Site ID: #{x.site_id}"
        puts "Status: #{x.status}"
        puts "Engine ID: #{x.engine_id}"
        puts "Scan Start Time: #{x.start_time}"
        puts "Nodes: #{x.nodes.live}"
        puts ""
      end
    end
  end

  def list(item)
    case item
      when 'scans'
        tp @nsc.scan_activity
      when 'sites'
        tp @nsc.list_sites
      when 'engines'
        tp @nsc.list_engines
    end
  end

  def display_engine(engine_id)
    @engine = Engine.load(@nsc, engine_id)
    puts ""
    puts "Engine Name: #{@engine.name}"
    puts "Engine Address: #{@engine.address}"
    puts "Engine ID: #{@engine.id}"
    puts "Engine Sites: "
    @engine.sites.each { |x| puts "Site ID: #{x.id} Site Name: #{x.name}"}
  end

  def logout
    @nsc.logout
  end

end

data = YAML.load_file('config.yml')
options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: nexpose-magic.rb -c [console] [options]"

  opts.separator ""
  opts.separator "Specific options:"

  opts.on("-c", "--console Console", "<Nexpose Console Name>") do |c|
    options[:console] = c
  end

  opts.on("-e", "--engine <Engine ID>", "Display Scan Engine Information") do |e|
    options[:scan_engine] = e
  end

  opts.on("-t", "--site <site ID>", "Display Site Information") do |t|
    options[:site] = t
  end

  opts.on("-v", "--vscans", "Display currently running Nexpose vulnerabilitycans") do |s|
    options[:scans] = s
  end

  opts.on("-l", "--list [scans] [sites] [engines]", "List Nexpose Scans, Sites, Scan Engines") do |l|
    options[:list] = l 
  end

  opts.on_tail("-h", "--help", "Show help message") do
    puts opts
    exit
  end
end.parse!

console = data.select { |console| console['name'] == options[:console] }.first

if console.empty?
  puts "Console not found in config.yml"
  exit
end

nexpose = NexposeMagic.new(console)
nexpose.connect

if not options[:scan_engine].nil?
  nexpose.display_engine(options[:scan_engine])
elsif not options[:site].nil?
  nexpose.display_site(options[:site])
elsif not options[:list].nil?
  nexpose.list(options[:list])
elsif not options[:scans].nil?
  nexpose.display_scans
end

nexpose.logout








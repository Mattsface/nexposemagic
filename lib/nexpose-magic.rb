# dependency:
# gem install nexpose

require 'optparse'
require 'nexpose'
require 'table_print'
include Nexpose

class NexposeMagic

  def initialize(options)
    @ip = options[:ip]
    @user = options[:user]
    @password = options[:password]
  end

  def connect
    begin
      @nsc = Connection.new(@ip, @user, @password)
      @nsc.login
    rescue => e 
      raise e
    end  
  end

  def populate_site(site)
    @siteinfo = []
    if @site = Site.load(@nsc, site) 
      @assets = convert_ip_range(@site.assets)
      @siteinfo = [ "Site Name: #{@site.name}",
      "Site Engine ID: #{@site.engine}",
      "Site Scan Template: #{@site.scan_template_name}",
      "Site Assets: " ] 
      @assets.each { |asset| @siteinfo << "#{asset}" }
    end
  end

  def populate_engine(engine_id)
    if @engine = Engine.load(@nsc, engine_id) 
      @engineinfo = [ "Engine Name: #{@engine.name}",
      "Engine Address: #{@engine.address}",
      "Engine ID: #{@engine.id}",
      "Engine Sites: " ] 
      @engine.sites.each { |x| @engineinfo << "Site ID: #{x.id} Site Name: #{x.name}" }
    end
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

  def check_scans
    if @scans = @nsc.scan_activity 
      @scans
    else
      false
    end
  end

  def display_scans
    if check_scans
      puts "Scans currently running:"
      @scans.each do |x|
        puts "Scan ID: #{x.scan_id}"
        puts "Site ID: #{x.site_id}"
        puts "Status: #{x.status}"
        puts "Engine ID: #{x.engine_id}"
        puts "Scan Start Time: #{x.start_time}"
        puts "Nodes: #{x.nodes.live}"
        puts ""
      end
    else
        puts "No scans currently running"
    end
  end

  def list(item)
    case item
      when 'sites'
        tp @nsc.list_sites
      when 'engines'
        tp @nsc.list_engines
    end
  end

  def display_site
    populate_site.each { |x| puts x }
  end

  def display_engine
    @engineinfo.each { |x| puts x }
  end

  def logout
    @nsc.logout
  end

end
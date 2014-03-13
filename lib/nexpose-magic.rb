
class NexposeMagic

  attr_accessor :engine, :site, :scans, :sites, :engines

  def initialize(engine=nil, site=nil, scans=nil, list_sites=nil, list_engines=nil)
    @engine = engine 
    @site = site
    @scans = scans
    @list_sites = list_sites
    @list_engines = list_engines
  end

  def populate_site
    @assets = convert_ip_range(@site.assets)
    @siteinfo = [ "Site Name: #{@site.name}",
      "Site Engine ID: #{@site.engine}",
      "Site Scan Template: #{@site.scan_template_name}",
      "Site Assets: " ] 
    @assets.each { |asset| @siteinfo << "#{asset}" }
    @siteinfo
  end

  def populate_engine
    @engineinfo = [ "Engine Name: #{@engine.name}",
    "Engine Address: #{@engine.address}",
    "Engine ID: #{@engine.id}",
    "Engine Sites: " ] 
    @engine.sites.each { |x| @engineinfo << "Site ID: #{x.id} Site Name: #{x.name}" }
    @engineinfo
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

  def populate_scans
    return ["No scans currently running"] if not @scans.nil?

    @scaninfo = [ "Scans currently runnning"]
    @scans.each do |x|
        @scaninfo << "Scan ID: #{x.scan_id}"
        @scaninfo << "Site ID: #{x.site_id}"
        @scaninfo << "Status: #{x.status}"
        @scaninfo << "Engine ID: #{x.engine_id}"
        @scaninfo << "Scan Start Time: #{x.start_time}"
        @scaninfo << "Nodes: #{x.nodes.live}"
        @scaninfo << ""
      end
    @scaninfo
  end

  def list_sites
    tp @sites
  end

  def list_engines
    tp @engines
  end

end
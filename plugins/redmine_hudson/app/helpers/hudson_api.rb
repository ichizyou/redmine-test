# -*- coding: utf-8 -*-
#
require "uri"
require 'net/http'

require File.join( File.dirname( __FILE__ ), '..', 'models', 'hudson_exceptions' )

class HudsonApi

  attr_reader :url, :auth_params
  attr_reader :uri_http, :use_auth

  def self.ci_server_name(base_url, auth_user, auth_password)
    url = "#{base_url}"
    HudsonApi.new(
      :url           => url, 
      :auth_user     => auth_user, 
      :auth_password => auth_password
    ).ci_server_name
  end

  def self.get_version(base_url, auth_user, auth_password)
    url = "#{base_url}"
    HudsonApi.new(
      :url           => url, 
      :auth_user     => auth_user, 
      :auth_password => auth_password
    ).version
  end

  def self.get_job_list(api_url, auth_user, auth_password)
    url = "#{api_url}/xml?depth=0"

    HudsonApi.new(
      :url           => url, 
      :auth_user     => auth_user, 
      :auth_password => auth_password
    ).get
  end

  def self.get_job_details(api_url, auth_user, auth_password)
    url = "#{api_url}/xml?depth=1"
    url << "&xpath=/hudson"
    url << "&exclude=/hudson/view"
    url << "&exclude=/hudson/primaryView"
    url << "&exclude=/hudson/job/build"
    url << "&exclude=/hudson/job/lastCompletedBuild"
    url << "&exclude=/hudson/job/lastStableBuild"
    url << "&exclude=/hudson/job/lastSuccessfulBuild"
    HudsonApi.new(
      :url           => url, 
      :auth_user     => auth_user, 
      :auth_password => auth_password
    ).get
  end

  def self.get_build_results(api_url, auth_user, auth_password)
    url = "#{api_url}/xml/?depth=1"
    url << "&exclude=//build/changeSet/item/path"
    url << "&exclude=//build/changeSet/item/addedPath"
    url << "&exclude=//build/changeSet/item/modifiedPath"
    url << "&exclude=//build/changeSet/item/deletedPath"
    url << "&exclude=//build/culprit"
    url << "&exclude=//module"
    url << "&exclude=//firstBuild&exclude=//lastBuild"
    url << "&exclude=//lastCompletedBuild"
    url << "&exclude=//lastFailedBuild"
    url << "&exclude=//lastStableBuild"
    url << "&exclude=//lastSuccessfulBuild"
    url << "&exclude=//downstreamProject"
    url << "&exclude=//upstreamProject"

    HudsonApi.new(
      :url           => url, 
      :auth_user     => auth_user, 
      :auth_password => auth_password
    ).get
  end

  def self.get_recent_builds(api_url, auth_user, auth_password)
    url = "#{api_url}"

    HudsonApi.new(
      :url           => url, 
      :auth_user     => auth_user, 
      :auth_password => auth_password
    ).get
  end

  def self.request_build(api_url, auth_user, auth_password)
    url = "#{api_url}"

    HudsonApi.new(
      :url           => url, 
      :auth_user     => auth_user, 
      :auth_password => auth_password
    ).get
  end

  def initialize(params)
    @url = params[:url]
    @auth_params = {
      :auth_user     => params[:auth_user], 
      :auth_password => params[:auth_password]
    }
    @auth_params[:use_auth] = @auth_params[:auth_user].present?

    @uri_http = URI.parse( URI.escape(@url) )
    if @uri_http.scheme == "https"
      @uri_http.port = 443 if @uri_http.port.present?
    end

  end

  def ci_server_name
    res = do_request(:head)
    return :jenkins if res.key?("X-Jenkins")
    return :hudson  if res.key?("X-Hudson")
  end

  def version
    res = do_request(:head)
    res.key?("X-Hudson") ? res["X-Hudson"] : res["X-Jenkins"]
  end

  def get
    do_request(:get).body
  end

  def do_request(req_type)

    begin
      http = create_http_connection(@uri_http)
      request = create_http_request(@uri_http, @auth_params, req_type)
    rescue => e
      raise HudsonApiException.new(e)
    end

    begin
      http.request(request)
    rescue Timeout::Error, StandardError => e
      raise HudsonApiException.new(e)
    end
     
  end

  def create_http_connection(uri)

    retval = Net::HTTP.new(uri.host, uri.port)

    if uri.scheme == "https" then
      retval.use_ssl = true
      retval.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    return retval
  rescue => e
    raise e

  end

  def create_http_request(uri, auth_params, req_type = :get)
    
    getpath = uri.path
    getpath += "?" + uri.query if uri.query.present?

    case req_type
    when :head
      retval = Net::HTTP::Head.new(getpath)
    else
      retval = Net::HTTP::Get.new(getpath)
    end
    retval.basic_auth(auth_params[:auth_user], auth_params[:auth_password]) if auth_params[:use_auth]

    return retval
  rescue => e
    raise e

  end
  
end

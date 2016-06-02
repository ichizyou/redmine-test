# coding: utf-8

Given /^HudsonApi.([a-zA-Z0-9_].*?) returns "(.*?)"$/ do |method, response_name|
  HudsonApi.should_receive(method.to_sym).at_least(:once).and_return(get_response("#{response_name}"))
end

Given /^HudsonApi.ci_server_name returns (.*?)$/ do |ret|
  HudsonApi.should_receive(:ci_server_name).at_least(:once).and_return(ret.to_sym)
end

def get_response(name)
  f = open "#{Rails.root}/plugins/redmine_hudson/features/responses/#{name}.xml"
  retval = f.read
  f.close
  return retval
end

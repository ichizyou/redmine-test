# coding: utf-8

class HudsonSettings < ActiveRecord::Base
  unloadable

  include I18n
  
  has_many :health_report_settings, :class_name => 'HudsonSettingsHealthReport', :dependent => :destroy

  validates_presence_of   :project_id, :url
  validates_uniqueness_of :project_id

  DELIMITER = ','

  @@HUMANIZED_ATTRIBUTE_KEY_NAMES = {
    "health_report_settings" => I18n.t(:label_health_report_settings)
  }

  def self.add_last_slash(value)
    added = value
    return "" unless added
    return "" if added.length == 0
    added += "/" unless added.index(/\/$/)
    return added
  end

  def self.human_attribute_name(attribute_key_name)
    @@HUMANIZED_ATTRIBUTE_KEY_NAMES[attribute_key_name] || super
  end

  def self.find_by_project_id(project_id)
    retval = HudsonSettings.find(:first,  :conditions => "project_id = #{project_id}")
    retval = HudsonSettings.new() if retval == nil
    return retval
  end

  def self.to_array(value)
    return [] if value == nil
    return value.split(HudsonSettings::DELIMITER)
  end

  def self.to_value(value)
    return "" if value == nil
    return value.join(HudsonSettings::DELIMITER)
  end

  def use_authentication?
    return false unless self.auth_user
    return false unless self.auth_user.length > 0
    return true
  end

  def job_include?(other)
    return false if self.job_filter == nil
    value = HudsonSettings.to_array( self.job_filter )
    return value.include?(other.to_s)
  end

  def url_for(type)
    return self.url_for_plugin if type == :plugin and self.url_for_plugin and self.url_for_plugin.length > 0
    return self.url
  end

  def url=(value)
    write_attribute(:url, HudsonSettings.add_last_slash(value))
  end

end


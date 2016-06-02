class HudsonApplicationHooks < Redmine::Hook::ViewListener

  include ActionView::Helpers::DateHelper
  include ApplicationHelper

  def view_layouts_base_html_head(context = {})
    project = context[:project]
    return '' unless project
    controller = context[:controller]
    return '' unless controller
    action_name = controller.action_name
    return '' unless action_name

    baseurl = url_for(:controller => 'hudson', :action => 'index', :id => project) + '/../../..'

    if (controller.class.name == 'ProjectsController' and action_name == 'activity')
      hudson = Hudson.find_by_project_id(project.id)
      return '' unless hudson.settings.url
      o = ""
      o << "<style type='text/css'>"
      o << ".hudson-build { background-image: url(#{hudson.settings.url}favicon.ico); }"
      o << "</style>\n"
      o << "<!--[if IE]>"
      o << "<style type='text/css'>"
      o << ".hudson-build { background-image: url(#{baseurl}/plugin_assets/redmine_hudson/images/hudson_icon.png); }"
      o << "</style>\n"
      o << "<![endif]-->"
      return o
    end

    if (controller.class.name == 'IssuesController' and action_name == 'show')
      o = ""
      o << stylesheet_link_tag("hudson.css", :plugin => "redmine_hudson", :media => "screen") + "\n"
      o << javascript_include_tag("jquery.build_result_appender.js", :plugin => "redmine_hudson") + "\n"
      return o
    end

  end

  def view_issues_show_description_bottom(context = {})
    return '' unless context[:issue]
    issue = context[:issue]

    begin
      build_results = render_hudson_build_results issue
    rescue => e
      return  "render_hudson_build_results error: #{e}"
    end

    o = "<script type='text/javascript'>" + "\n"
    o << "//<!--" + "\n"
    o << "$(document).ready(function() {" + "\n"
    o << build_results
    o << "$('body').buildResultAppender({revisions: revisions});" + "\n"
    o << "});" + "\n"
    o << "//-->" + "\n"
    o << "</script>" + "\n"
    
  end

  def render_hudson_build_results(issue)
    o = "revisions = {};\n"
    issue.changesets.each do |changeset|
      o << "// #{changeset.revision}\n"
      builds = HudsonBuild.find_by_changeset(changeset)
      next if builds.length == 0

      o << "revisions['#{changeset.revision}'] = [];\n"
      builds.each do |build|
        job = HudsonJob.where(:id => build.hudson_job_id).first()
        finished_at_tag = link_to(distance_of_time_in_words(Time.now, build.finished_at),
                                  {:controller => 'activities', :action => 'index', :id => job.project.id, :from => build.finished_at.to_date},
                                  :title => format_time(build.finished_at))
        o << "revisions['#{changeset.revision}'].push({"
        o << "jobName: '#{job.name}', "
        o << "number: #{build.number}, result: '#{build.result}', "
        o << "finished_at: '#{build.finished_at}', finished_at_tag: '#{finished_at_tag}', "
        o << "url: '#{build.url_for(:user)}'"
        o << "});\n"
      end 
    end
    o
  end
end

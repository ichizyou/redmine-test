
Given /^"(.*)" project has jobs:/ do |project_name, hudson_jobs_table|
  project = Project.find_by_name(project_name)
  raise Exception.new("project not found - #{project_name}") unless project

  jobs = hudson_jobs_table.hashes.map do |hash|
    hash['name']
  end

  settings = HudsonSettings.find_by_project_id(project.id)
  settings = HudsonSettings.new unless settings
  settings.project_id = project.id
  settings.url = "http://localhost:8080/"
  settings.job_filter = jobs.join(",")
  settings.look_and_feel = "Hudson"
  settings.save!

  hudson_jobs_table.hashes.each do |hash|
    job = HudsonJob.new
    job.project_id = project.id
    job.hudson_id = settings.id
    job.settings = settings
    job.name = hash['name']
    job.save!
  end

end

Given /^Job "(.*)" has build results:/ do |job_name, build_results_table|
  job = HudsonJob.find_by_name(job_name)
  raise Exception.new("Hudson job not found - #{job_name}") unless job

  project = Project.find(job.project_id)
  raise Exception.new("project not found - #{job.project_id}") unless project
  
  build_results_table.hashes.each do |hash|
    build = HudsonBuild.new
    build.hudson_job_id = job.id
    build.number = hash['number']
    build.result = hash['result']
    build.finished_at = DateTime.now
    build.building = hash['building']
    build.error = hash['error']
    build.caused_by = hash['caused_by']
    build.job = job
    build.save!

    hash['revisions'].split(/,/).each do |revision|
      changeset = HudsonBuildChangeset.new
      changeset.hudson_build_id = build.id
      changeset.repository_id = project.repository.id
      changeset.revision = revision
      changeset.build = build
      changeset.save!
    end
  end
end

Then /^I should see build results in Associated revisions:$/ do |results|
  actual = [["revision","job name","build number","build result","build url","finished at"]]
  actual_data = all("#issue-changesets div.changeset").map do |changeset|
    revision = changeset.find(:xpath, "p/a[contains(@title, 'Revision')]")["title"][/Revision (.*)/, 1]
    build_result = changeset.find("span.result").text
    job_name, build_number = changeset.find("a.built-by").native.text.split(" #")
    build_url = changeset.find("a.built-by")["href"]
    finished_at = changeset.text[/ at (.*) ago/, 1] 

    [revision, job_name, build_number, build_result, build_url, finished_at]
  end

  actual.concat actual_data

  results.diff!(actual) 

end

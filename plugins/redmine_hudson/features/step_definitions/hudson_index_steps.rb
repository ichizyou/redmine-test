
When /^I click "([^"]*)" icon of "([^"]*)"$/ do |text, job_name|
  job_id = get_job_id_from_job_name(job_name) 
  find(:xpath, "//img[contains(@id, '-#{job_id}') and not(substring-after(@id, '-#{job_id}')) and @title='#{text}']").click
end

Then /^I should see job description of "([^"]*?)":$/ do |job_name, description|
  # FIXME can't compare crlf...
  description = description.gsub(/\r\n/, " ")
  job_id = get_job_id_from_job_name(job_name) 
  find("div#job-state-#{job_id} div.job-description").text.should eq(description)
end

Then /^I should see latest build of "([^"]*?)":$/ do |job_name, table|

  exp_number      = table.hashes[0]['number']
  exp_result      = table.hashes[0]['result']
  exp_finished_at = table.hashes[0]['finished at'] 

  job_id = get_job_id_from_job_name(job_name) 

  within("#latest-build-#{job_id}") do
    find(".number").should have_content(exp_number)
    find(".result").should have_content(exp_result)
    find(".finished-at").should have_content(exp_finished_at)
  end

end

Then /^I should see health reports of "([^"]*?)":$/ do |job_name, table|

  job_id = get_job_id_from_job_name(job_name) 

  within("#job-state-#{job_id}") do
    actual = all("ul.job-health-reports li").map do |li|
      [li.text.strip]
    end
    actual = actual.unshift(['description'])

    table.diff!(actual)
  end

end

Then /^I should see artifacts of "([^"]*?)":$/ do |job_name, table|

  page.should have_selector("#build-artifacts-list", :visible => true)

  actual = all("#build-artifacts-list ul li").map do |li|
    anchor = li.find("a")
    # FIXME: should not use native object..
    [anchor.native.text, anchor['href']]
  end
  actual = actual.unshift(['item', 'url'])

  table.diff!(actual)

end

Then /^I should see build history:$/ do |histories|
  # wait until build-history element is shown
  page.should have_selector("#build-history", :visible => true)

  actual = find("#build-history").all(".build-entry").map do |entry|
    entry.text.strip.split(" ", 3)
  end
  actual = [["number","result","published at"]].concat(actual)

  histories.diff!(actual)
end

def get_job_id_from_job_name(job_name)
  find(:xpath, "//h3[a/text()='#{job_name}']")["id"].gsub(/job-name-/, "")
end

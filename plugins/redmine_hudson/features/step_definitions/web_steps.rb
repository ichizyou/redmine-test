# coding: utf-8

When /^I go to (.*)$/ do |page_name|
  visit path_to(page_name)
end

When /^I show (.*)$/ do |page_name|
  step("I go to #{page_name}")
end

When /^I click "([^"]*)"(| within "([^"]*)")$/ do |element, temp, area|
  area = "html" unless area
  within(area) do
    click_on element
  end
end

When /^I fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
  fill_in(field, :with => value)
end

When /^I check "([^"]*)"$/ do |field|
  begin
    check(field)
  rescue
    find(:xpath, "//input[@value='#{field}']").set(true)
  end
end

Then /^I (should|should not) see "([^"]*)"(| within "([^"]*)")$/ do |should_or_not, content, work, area|
  area = "html" unless area
  page.within(area) do
    if should_or_not == "should"
      has_content?(content).should be_true
    else
      has_content?(content).should_not be_true
    end
  end
end

Then /^I should see "([^"]*)" linked to "([^"]*)"(| within "([^"]*)")$/ do |content, link_url, work, area|
  area = "html" unless area
  page.within(area) do
    find(:xpath, "//a[@href='#{link_url}' and text()='#{content}']")['href'].should == link_url
  end
end

Then /^the field named "(.*?)" should contain "(.*?)"$/ do |field, value|
  find_field(field).value.should == value
end

Then /^the field named "(.*?)" should be empty$/ do |field|
  find_field(field).value.should be_empty 
end

Then /^the field named "(.*?)" should (not be|be) checked$/ do |field, be_or_not|
  if be_or_not == "be"
    find_field(field).should be_checked
  else
    find_field(field).should_not be_checked
  end
end

Then /^Background image is "(.*?)"$/ do |image_url|
  # CAUTION: using Nokogiri::XML::Element
  page.first('style').native.content.should include(%{background-image: url("#{image_url}")})
end

Then /^show me the page$/ do 
  save_and_open_page
end

Then /^save the page$/ do 
  save_page
end



Then /^I should see links below in sidebar:$/ do |links|
  links.hashes.each do |params|
    step %Q{I should see "#{params['text']}" linked to "#{params['url']}" within "#sidebar"}
  end
end

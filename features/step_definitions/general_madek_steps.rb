Given /^I have set up the world$/ do
  # Set this to a non-JS driver because:
  # 1. The Selenium driver times out during this step
  # 2. This step may be called in backgrounds of tests that have
  #    :js => true, so this would break this step. Therefore
  #    we set our own driver here.
  old_driver = Capybara.current_driver
  Capybara.use_default_driver

  if MetaKey.count == 0 # TODO: Test for more stuff, just having more than 0
                        # keys doesn't guarantee the YAML file has already been
                        # loaded.
    steps %Q{
      Given a user called "Bruce Willis" with username "bruce_willis" and password "fluffyKittens" exists
      And a group called "Admin" exists
      And the user with username "bruce_willis" is member of the group "Admin"
      And I log in as "bruce_willis" with password "fluffyKittens"
    }

    click_on_arrow_next_to("Willis, Bruce")
    click_link("Admin")
    click_link("Import")
    attach_file("uploaded_data", Rails.root + "spec/data/minimal_meta.yml")
    click_button("Import »")
    
  end

  MetaKey.count.should == 89
  Capybara.current_driver = old_driver

  # This is actually normally called in the seeds, but
  # the RSpec developers don't believe in using seeds, so
  # they drop the database even if we seed it before running
  # the tests. Therefore we recreate our world in this step.
  Copyright.init
  Permission.init
  Meta::Department.fetch_from_ldap
  Meta::Date.parse_all

end

Given /^a user called "([^"]*)" with username "([^"]*)" and password "([^"]*)" exists$/ do |person_name, username, password|
  user = User.where(:login => username).first
  if user.nil?
    firstname, lastname = person_name, person_name
    firstname, lastname = person_name.split(" ") if person_name.include?(" ")
    crypted_password = Digest::SHA1.hexdigest(password)
    person = Person.find_or_create_by_firstname_and_lastname(:firstname => firstname,
                                                            :lastname => lastname)
    user = person.build_user(:login => username,
                             :email => "#{username}@zhdk.ch",
                             :password => crypted_password)
    user.usage_terms_accepted_at = DateTime.now
    user.save.should == true
  end
end

Given /^the user with username "(\w+)" is member of the group "(\w+)"/ do |username, groupname|
  user = User.where(:login => username).first
  group = Group.where(:name => groupname).first
  user.groups << group unless user.groups.include?(group)
  user.save.should == true
end

Given /^I log in as "(\w+)" with password "(\w+)"$/ do |username, password|
  visit "/logout"
  visit "/db/login"
  fill_in "login", :with => username
  fill_in "password", :with => password
  click_link_or_button "Log in"
end

Given /^a group called "(\w+)" exists$/ do |groupname|
  create_group(groupname)
end

Given /^I upload some picture titled "([^"]*)"$/ do |title|
  upload_some_picture(title)
end

When /^I wait for the CSS element "([^"]*)"$/ do |css|
  wait_for_css_element(css)
end

When /^I fill in the set title with "([^"]*)"/ do |title|
  fill_in find("#text_media_set").find("input")[:id], :with => title
end


When /I fill in the metadata for entry number (\d+) as follows:/ do |num, table|
  # Makes the text more human-readable, don't have to specify 0 to fill in
  # for the first entry
  media_entry_num = num - 1

  table.hashes.each do |hash|
    all("ul", :text => /#{hash['label']}/)[media_entry_num].all("input").each do |ele|
      fill_in ele[:id], :with => hash['value'] if ele[:id] =~ /_value$/
    end
  end
end

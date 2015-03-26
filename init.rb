Redmine::Plugin.register :redmine_power_subtasks do
  name 'Redmine Power Subtasks plugin'
  author 'Eric Davis'
  description "Customizations to Redmine's subtasks to make them more powerful."
  version '1.0.0'
  author_url 'http://www.littlestreamsoftware.com'
end

require 'redmine_power_subtasks/controller_issues_edit_after_save_hook'
require 'redmine_power_subtasks/view_issues_form_details_bottom_hook'

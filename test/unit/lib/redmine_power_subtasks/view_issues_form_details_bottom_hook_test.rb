require File.dirname(__FILE__) + '/../../../test_helper'

class RedminePowerSubtasks::ViewIssuesFormDetailsBottomHookTest < ActionController::TestCase
  fixtures :projects, :users, :email_addresses,
           :trackers, :projects_trackers,
           :enabled_modules,
           :issue_statuses, :issue_categories, :issue_relations, :workflows,
           :enumerations,
           :issues, :journals, :journal_details,
           :custom_fields, :custom_fields_projects, :custom_fields_trackers, :custom_values

  include Redmine::Hook::Helper

  def controller
    @controller ||= ApplicationController.new
    @controller.response ||= ActionController::TestResponse.new
    # Override Redmine's override of Rails so layouts aren't rendered or checked in hook renders
    def @controller._include_layout?(*args)
      false
    end
    def @controller.url_options
      {}
    end
    @controller
  end

  def request
    @request ||= ActionController::TestRequest.new
  end
  
  def hook(args={})
    call_hook :view_issues_form_details_bottom, args
  end

  def setup
    @project = Project.generate!
    @parent = Issue.generate_with_descendants!(:project => @project)
    @child_without_children = @parent.children.second
  end

  context "#view_issues_form_details_bottom for an issue with no children" do
    should "render nothing" do
      response = hook(:issue => @child_without_children)

      assert_equal "", response.strip
    end
  end

  context "#view_issues_form_details_bottom for an issue with no children" do
    should "render the JavaScript to replace the priority field"
  end
end

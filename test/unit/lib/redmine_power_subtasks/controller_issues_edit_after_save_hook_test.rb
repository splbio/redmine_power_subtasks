require File.dirname(__FILE__) + '/../../../test_helper'

class RedminePowerSubtasks::ControllerIssuesEditAfterSaveHookTest < ActionController::TestCase
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
    @controller
  end

  def request
    @request ||= ActionController::TestRequest.new
  end
  
  def hook(args={})
    call_hook :controller_issues_edit_after_save, args
  end

  def setup
    @low = IssuePriority.where(:name => "Low").first
    @normal = IssuePriority.where(:name => "Normal").first
    @high = IssuePriority.where(:name => "High").first
    @project = Project.generate!
    @parent = Issue.generate_with_descendants!(:project => @project)
    @child1 = @parent.children.first
    @child2 = @parent.children.second
    @grandchild = @child1.children.first
    @child2.update_attributes(:priority => @low)
    @grandchild.update_attributes(:priority => @high)
    @parent.reload
  end

  context "#controller_issues_edit_after_save_hook with no bulk_priority_change params" do
    should "do nothing to the issues tree" do
      assert_equal @high, @parent.reload.priority
      assert_equal @high, @child1.reload.priority
      assert_equal @low, @child2.reload.priority
      assert_equal @high, @grandchild.reload.priority

      hook(:issue => @parent)

      assert_equal @high, @parent.reload.priority
      assert_equal @high, @child1.reload.priority
      assert_equal @low, @child2.reload.priority
      assert_equal @high, @grandchild.reload.priority
    end
  end

  context "#controller_issues_edit_after_save_hook with bulk_priority_change params" do
    should "change the entire issues tree to have it's priority" do
      assert_equal @high, @parent.reload.priority
      assert_equal @high, @child1.reload.priority
      assert_equal @low, @child2.reload.priority
      assert_equal @high, @grandchild.reload.priority

      hook(:issue => @parent, :params => {:bulk_priority => @low.id})

      assert_equal @low, @parent.reload.priority
      assert_equal @low, @child1.reload.priority
      assert_equal @low, @child2.reload.priority
      assert_equal @low, @grandchild.reload.priority
    end

    should "create journals for each leaf issue that was changed" do
      # @grandchild: @high to @normal
      # @child2: @high to @normal
      # Others are parent issues which doesn't track changes (calculated field)
      assert_difference("Journal.count", 2) do
        hook(:issue => @parent, :params => {:bulk_priority => @normal.id})
      end

      assert_equal @normal, @parent.reload.priority
      assert_equal @normal, @child1.reload.priority
      assert_equal @normal, @child2.reload.priority
      assert_equal @normal, @grandchild.reload.priority
    end
end
end

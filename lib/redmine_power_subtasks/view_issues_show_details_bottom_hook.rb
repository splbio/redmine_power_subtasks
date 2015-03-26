module RedminePowerSubtasks
  class ViewIssuesShowDetailsBottomHook < Redmine::Hook::ViewListener

    # Replaces the Priority field on parent issues to allow bulk updates
    #
    # Context
    # - issue
    render_on(:view_issues_show_details_bottom,
              :partial => 'power_subtasks/issue_parent_priority',
              :layout => false)

  end
end

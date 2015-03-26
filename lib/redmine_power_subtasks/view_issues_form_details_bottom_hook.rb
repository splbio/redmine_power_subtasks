module RedminePowerSubtasks
  class ViewIssuesFormDetailsBottomHook < Redmine::Hook::ViewListener

    # Replaces the Priority field on parent issues to allow bulk updates
    #
    # Context
    # - issue
    # - form
    render_on(:view_issues_form_details_bottom,
              :partial => 'power_subtasks/issue_parent_priority',
              :layout => false)

  end
end

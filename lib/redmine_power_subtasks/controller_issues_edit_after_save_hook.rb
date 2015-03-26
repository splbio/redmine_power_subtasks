module RedminePowerSubtasks
  class ControllerIssuesEditAfterSaveHook < Redmine::Hook::Listener

    # Allows updating an entire issue tree's priority when a parent is updated.
    #
    # Context
    # - params
    # - issue
    # - time_entry
    # - journal
    def controller_issues_edit_after_save(context={})
      params = context[:params]
      issue = context[:issue]

      if params && issue && params[:bulk_priority].present? && !issue.leaf?
        priority = IssuePriority.find_by_id(params[:bulk_priority])

        if priority.present?
          # Do each one that way all the callbacks fire and update the parents
          issue.leaves.each do |child_issue|
            child_issue.init_journal(User.current)
            child_issue.priority = priority
            child_issue.save
          end
        end

      end
    end

  end
end

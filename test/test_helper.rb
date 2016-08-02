# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

module TestSetupMethods
  def create_user(login, email, parent_id = nil)
    pwd = repeat_str('123')
    mock_user = User.create() do |u|
      u.login                 = login
      u.password              = pwd
      u.password_confirmation = pwd
      u.firstname             = login
      u.lastname              = 'doe'
      u.mail                  = email
      u.language              = 'en'
      u.mail_notification     = 'only_my_events'
      u.must_change_passwd    = false
      u.parent_id             = parent_id
      u.status                = 1
      u.auth_source_id        = nil
    end
    # block below prints out all errors if validation fails
    if mock_user.errors.any? && @show_debug
      mock_user.errors.each do |attribute, message|
        puts "Error - #{attribute} : #{message}"
      end
    end
    mock_user
  end
end

module TestHelperMethods
  def repeat_str(input, length = Setting.password_min_length)
    puts input if @show_debug
    repeated_input = ""
    while repeated_input.length < length.to_i
      repeated_input << input
    end
    repeated_input
  end

  def find_user(user)
    User.find_by_login(user.login)
  end
end

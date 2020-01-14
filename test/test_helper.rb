ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  parallelize(workers: :number_of_processors)
  fixtures :all

  def is_loggedin?
    !session[:user_id].nil?
  end

  def login_as(user)
    session[:user_id] = user.id
  end
end

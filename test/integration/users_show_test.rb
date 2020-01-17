require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users('dj-hirrot')
  end

  test 'should redirect root_url non-activated user' do
    get user_path(@user)
    assert_template 'users/show'
    @user.update_attribute(:activated, false)
    @user.reload
    get user_path(@user)
    assert_redirected_to root_url
  end
end

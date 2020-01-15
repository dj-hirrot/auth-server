require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users('dj-hirrot')
    @other_user = users('dj-yuta')
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should get new" do
    get join_url
    assert_response :success
  end

  test 'should not allow the admin attribute to be edited via the web' do
    login_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
      user: {
        password: 'changed_password',
        password_confirmation: 'changed_password',
        admin: true
      }
    }
    assert_not @other_user.reload.admin?
  end
end

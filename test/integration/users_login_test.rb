require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users('dj-hirrot')
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: '',
        password: ''
      }
    }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test 'login with valid information followed by logout' do
    get login_path
    post login_path, params: {
      session: {
        email: @user.email,
        password: 'password'
      }
    }

    assert is_loggedin?

    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)

    delete logout_path
    assert_not is_loggedin?
    assert_redirected_to root_url

    # when user opening 2 or more browser
    delete logout_path

    follow_redirect!
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?('')
  end

  test 'login with remembering' do
    login_as(@user, remember_me: '1')
    assert_equal assigns(:user).remember_token, cookies['remember_token']
    assert_not_empty cookies['remember_token']
  end

  test 'login without remembering' do
    # login and save cookies
    login_as(@user, remember_me: '1')
    delete logout_path
    # login after deleted cookies
    login_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end


require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
    @user = users('dj-hirrot')
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    # Mail address is disable.
    post password_resets_path, params: {
      password_reset: {
        email: ''
      }
    }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    # Mail address is active.
    post password_resets_path, params: {
      password_reset: {
        email: @user.email
      }
    }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    # Form's test
    user = assigns(:user)
    # Mail address is disable.
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # Deactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # Mail address is active, Token is deactive
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    # Mailaddress and Token is active
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select 'input[name=email][type=hidden][value=?]', user.email
    # Deactive mail address and password confirm
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: '',
        password_confirmation: ''
      }
    }
    assert_select 'div#error_explanation'
    # Active mail address and password confirm
    patch password_reset_path(user.reset_token), params: {
      email: user.email,
      user: {
        password: 'foobar',
        password_confirmation: 'foobar'
      }
    }
    assert is_loggedin?
    assert_not flash.empty?
    assert_redirected_to user
  end
end

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users('dj-hirrot')
    @other_user = users('dj-yuta')
  end

  test 'unsuccessful edit' do
    login_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'

    patch user_path(@user), params: {
      user: {
        name: '',
        email: '',
        password: 'foo',
        password_confirmation: 'bar'
      }
    }

    assert_template 'users/edit'
    assert_select 'div.alert-danger', 'The form contains 5 errors.'
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    login_as @user
    assert_redirected_to edit_user_url(@user)

    name = 'Hirrot Mori'
    email = 'hirrot@mori.app'

    patch user_path(@user), params: {
      user: {
        name: name,
        email: email,
        password: '',
        password_confirmation: ''
      }
    }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when loggedin as wrong user' do
    login_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when loggedin as wrong user' do
    login_as(@other_user)
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert flash.empty?
    assert_redirected_to root_url
  end
end

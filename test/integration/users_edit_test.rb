require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users('dj-hirrot')
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

  test 'successful edit' do
    login_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'

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
end

require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users('dj-hirrot')
    @non_admin = users('dj-yuta')
  end

  test 'index including pagination and delete links' do
    login_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_user = User.paginate(page: 1)
    first_page_of_user.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test 'index as non-admin' do
    login_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test 'should hide non-activated users' do
    login_as(@admin)
    get users_path
    assert_select 'a[href=?]', user_path(@non_admin)
    @non_admin.update_columns(activated: false)
    get users_path
    @non_admin.reload
    assert_select 'a[href=?]', user_path(@non_admin), count: 0
  end
end

require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = users('dj-hirrot')
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'h1', text: @user.name
    assert_select 'h1 > img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
  end

  test 'should redirect root_url non-activated user' do
    get user_path(@user)
    @user.update_attribute(:activated, false)
    @user.reload
    get user_path(@user)
    assert_redirected_to root_url
  end
end

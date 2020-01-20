require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users('dj-hirrot')
    @micropost = Micropost.new(content: 'Micropost', user_id: @user.id)
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'user_id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = ''
    assert_not @micropost.valid?
  end

  test 'content should be at most 140 charcters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end
end

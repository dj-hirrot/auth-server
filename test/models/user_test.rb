require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "hiroto", email: "hirotoshibutani@gmail.com")
  end

  test "should be valid" do
    assert @user.valid?
  end
end

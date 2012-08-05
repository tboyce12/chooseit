require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end
  test "should not save user without email" do
    user = User.new
    assert !user.save, "Saved user without email"
  end
  test "should not save user with passwords that dont match" do
    hash = {
      :email => 'tboyce@stanford.edu',
      :password => 'abracadabra',
      :password_confirmation => 'willywop'
    }
    user = User.new hash
    assert !user.save, "Saved user with passwords that dont match"
  end
  test "should save user with email, password, and password_confirmation" do
    hash = {
      :email => 'tboyce@stanford.edu',
      :password => 'abracadabra',
      :password_confirmation => 'abracadabra'
    }
    assert User.create(hash), "Failed to save user"
  end
  test "should be able to find tots belonging to a user" do
    user = users(:tom)
    tots = user.tots
    assert !tots.empty?, "Failed to find tom's tots"
  end
end

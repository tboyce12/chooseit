require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "service must belong to a user" do
    orphan = Service.create :provider => 'facebook', :uid => '12345'
    tom = users :tom
    child = tom.services.create :provider => 'facebook', :uid => '23456'
    assert !orphan.persisted?, "Saved a service without an owning user"
    assert child.persisted?, "Failed to save a service belonging to a user"
  end
  
  test "cant have two services with same provider and uid" do
    tom = users :tom
    a = tom.services.create :provider => 'facebook', :uid => '12345'
    b = tom.services.create :provider => 'facebook', :uid => '12345'
    assert a.persisted?, "Failed to save first service"
    assert !b.persisted?, "Saved a duplicate service"
  end
end

require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  test "should get index" do
    sign_in users :tom
    get :index
    assert_response :success
  end
  
end

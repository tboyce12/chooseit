require 'test_helper'

class TotsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get index" do
    sign_in users :tom
    get :index
    assert_response :success
  end

  test "should get show" do
    sign_in users :tom
    get(:show, {'id' => tots(:fireice).id})
    assert_response :success
  end

  test "should get destroy" do
    sign_in users :tom
    assert_difference('Tot.count', -1) do
      delete :destroy, {'id' => tots(:fireice).id}
    end
    assert_redirected_to tots_index_path
  end

  test "should get new" do
    sign_in users :tom
    get :new
    assert_response :success
  end

  test "should get create" do
    sign_in users :tom
    assert_difference('Tot.count', 1) do
      params = {
        :tot => {
          :a => 'fire',
          :b => 'ice'
        }
      }
      post :create, params
    end
    assert_redirected_to tots_index_path
  end

end

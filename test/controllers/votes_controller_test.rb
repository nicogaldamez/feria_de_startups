require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  test "should get up" do
    get :up
    assert_response :success
  end

  test "should get down" do
    get :down
    assert_response :success
  end

end

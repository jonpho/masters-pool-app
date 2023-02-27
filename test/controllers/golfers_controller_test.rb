require "test_helper"

class GolfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @golfer = golfers(:one)
  end

  test "should get index" do
    get golfers_url
    assert_response :success
  end

  test "should get new" do
    get new_golfer_url
    assert_response :success
  end

  test "should create golfer" do
    assert_difference("Golfer.count") do
      post golfers_url, params: { golfer: { firstname: @golfer.firstname, lastname: @golfer.lastname, player_id: @golfer.player_id, status: @golfer.status, tour: @golfer.tour } }
    end

    assert_redirected_to golfer_url(Golfer.last)
  end

  test "should show golfer" do
    get golfer_url(@golfer)
    assert_response :success
  end

  test "should get edit" do
    get edit_golfer_url(@golfer)
    assert_response :success
  end

  test "should update golfer" do
    patch golfer_url(@golfer), params: { golfer: { firstname: @golfer.firstname, lastname: @golfer.lastname, player_id: @golfer.player_id, status: @golfer.status, tour: @golfer.tour } }
    assert_redirected_to golfer_url(@golfer)
  end

  test "should destroy golfer" do
    assert_difference("Golfer.count", -1) do
      delete golfer_url(@golfer)
    end

    assert_redirected_to golfers_url
  end
end

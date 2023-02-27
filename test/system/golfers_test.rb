require "application_system_test_case"

class GolfersTest < ApplicationSystemTestCase
  setup do
    @golfer = golfers(:one)
  end

  test "visiting the index" do
    visit golfers_url
    assert_selector "h1", text: "Golfers"
  end

  test "should create golfer" do
    visit golfers_url
    click_on "New golfer"

    fill_in "Firstname", with: @golfer.firstname
    fill_in "Lastname", with: @golfer.lastname
    fill_in "Player", with: @golfer.player_id
    fill_in "Status", with: @golfer.status
    fill_in "Tour", with: @golfer.tour
    click_on "Create Golfer"

    assert_text "Golfer was successfully created"
    click_on "Back"
  end

  test "should update Golfer" do
    visit golfer_url(@golfer)
    click_on "Edit this golfer", match: :first

    fill_in "Firstname", with: @golfer.firstname
    fill_in "Lastname", with: @golfer.lastname
    fill_in "Player", with: @golfer.player_id
    fill_in "Status", with: @golfer.status
    fill_in "Tour", with: @golfer.tour
    click_on "Update Golfer"

    assert_text "Golfer was successfully updated"
    click_on "Back"
  end

  test "should destroy Golfer" do
    visit golfer_url(@golfer)
    click_on "Destroy this golfer", match: :first

    assert_text "Golfer was successfully destroyed"
  end
end

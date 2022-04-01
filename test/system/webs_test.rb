require "application_system_test_case"

class WebsTest < ApplicationSystemTestCase
  setup do
    @web = webs(:one)
  end

  test "visiting the index" do
    visit webs_url
    assert_selector "h1", text: "Webs"
  end

  test "creating a Web" do
    visit webs_url
    click_on "New Web"

    fill_in "Meeting", with: @web.meeting
    click_on "Create Web"

    assert_text "Web was successfully created"
    click_on "Back"
  end

  test "updating a Web" do
    visit webs_url
    click_on "Edit", match: :first

    fill_in "Meeting", with: @web.meeting
    click_on "Update Web"

    assert_text "Web was successfully updated"
    click_on "Back"
  end

  test "destroying a Web" do
    visit webs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Web was successfully destroyed"
  end
end

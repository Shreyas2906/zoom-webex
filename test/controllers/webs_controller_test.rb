require 'test_helper'

class WebsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @web = webs(:one)
  end

  test "should get index" do
    get webs_url
    assert_response :success
  end

  test "should get new" do
    get new_web_url
    assert_response :success
  end

  test "should create web" do
    assert_difference('Web.count') do
      post webs_url, params: { web: { meeting: @web.meeting } }
    end

    assert_redirected_to web_url(Web.last)
  end

  test "should show web" do
    get web_url(@web)
    assert_response :success
  end

  test "should get edit" do
    get edit_web_url(@web)
    assert_response :success
  end

  test "should update web" do
    patch web_url(@web), params: { web: { meeting: @web.meeting } }
    assert_redirected_to web_url(@web)
  end

  test "should destroy web" do
    assert_difference('Web.count', -1) do
      delete web_url(@web)
    end

    assert_redirected_to webs_url
  end
end

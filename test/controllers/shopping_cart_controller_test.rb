require "test_helper"

class ShoppingCartControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get shopping_cart_add_url
    assert_response :success
  end

  test "should get remove" do
    get shopping_cart_remove_url
    assert_response :success
  end

  test "should get show" do
    get shopping_cart_show_url
    assert_response :success
  end
end

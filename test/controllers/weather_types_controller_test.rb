require 'test_helper'

class WeatherTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @weather_type = weather_types(:one)
  end

  test "should get index" do
    get weather_types_url
    assert_response :success
  end

  test "should get new" do
    get new_weather_type_url
    assert_response :success
  end

  test "should create weather_type" do
    assert_difference('WeatherType.count') do
      post weather_types_url, params: { weather_type: { name: 'nasty', is_precip: true } }
    end

    assert_redirected_to weather_types_url
  end

  test "should get edit" do
    get edit_weather_type_url(@weather_type)
    assert_response :success
  end

  test "should update weather_type" do
    patch weather_type_url(@weather_type), params: { weather_type: { name: 'gorgeous', is_precip: false } }
    assert_redirected_to weather_types_url
  end

  test "should destroy weather_type" do
    assert_difference('WeatherType.count', -1) do
      delete weather_type_url(@weather_type)
    end

    assert_redirected_to weather_types_url
  end
end

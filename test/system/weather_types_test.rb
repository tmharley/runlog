require "application_system_test_case"

class WeatherTypesTest < ApplicationSystemTestCase
  setup do
    @weather_type = weather_types(:one)
  end

  test "visiting the index" do
    visit weather_types_url
    assert_selector "h1", text: "Weather types"
  end

  test "creating a Weather type" do
    visit weather_types_url
    click_on "New Weather Type"

    fill_in 'Name', with: 'foggy'

    click_on "Create"

    assert_selector ".toast-body", text: "Weather type was successfully created."
  end

  test "updating a Weather type" do
    visit edit_weather_type_url(@weather_type)

    click_on "Update"

    assert_selector ".toast-body", text: "Weather type was successfully updated."
  end

  test "destroying a Weather type" do
    visit edit_weather_type_url(@weather_type)
    page.accept_confirm do
      click_on "Delete", match: :first
    end

    assert_selector ".toast-body", text: "Weather type was successfully deleted."
  end
end

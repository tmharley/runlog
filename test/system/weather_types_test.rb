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

    click_on "Create"

    assert_selector ".toast-body", text: "Weather type was successfully created."
    click_on "Back"
  end

  test "updating a Weather type" do
    visit edit_weather_type_url(@weather_type)
    # click_on "Edit", match: :first

    click_on "Update"

    assert_text "Weather type was successfully updated"
    click_on "Back"
  end

  test "destroying a Weather type" do
    visit weather_type_url(@weather_type)
    page.accept_confirm do
      click_on "Delete", match: :first
    end

    assert_text "Weather type was successfully destroyed"
  end
end

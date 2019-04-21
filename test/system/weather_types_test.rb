require "application_system_test_case"

class WeatherTypesTest < ApplicationSystemTestCase
  setup do
    @weather_type = weather_types(:one)
  end

  test "visiting the index" do
    visit weather_types_url
    assert_selector "h1", text: "Weather Types"
  end

  test "creating a Weather type" do
    visit weather_types_url
    click_on "New Weather Type"

    click_on "Create Weather type"

    assert_text "Weather type was successfully created"
    click_on "Back"
  end

  test "updating a Weather type" do
    visit weather_types_url
    click_on "Edit", match: :first

    click_on "Update Weather type"

    assert_text "Weather type was successfully updated"
    click_on "Back"
  end

  test "destroying a Weather type" do
    visit weather_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Weather type was successfully destroyed"
  end
end

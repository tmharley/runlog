require "application_system_test_case"

class ShoesTest < ApplicationSystemTestCase
  setup do
    @shoe = shoes(:one)
  end

  test "visiting the index" do
    visit shoes_url
    assert_selector "h1", text: "Shoes"
  end

  test "creating a Shoe" do
    visit shoes_url
    click_on "New Shoe"

    click_on "Create Shoe"

    assert_text "Shoe was successfully created"
    click_on "Back"
  end

  test "updating a Shoe" do
    visit shoes_url
    click_on "Edit", match: :first

    click_on "Update Shoe"

    assert_text "Shoe was successfully updated"
    click_on "Back"
  end

  test "destroying a Shoe" do
    visit shoes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shoe was successfully destroyed"
  end
end

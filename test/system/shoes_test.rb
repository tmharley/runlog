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

    fill_in 'Manufacturer', with: 'Shoemaker'
    fill_in 'Model', with: 'XT3000'
    fill_in 'Size', with: '6.5'
    fill_in 'Color 1', with: '885500'
    fill_in 'Color 2', with: 'addbed'
    fill_in 'Color 3', with: 'c0ffee'

    click_on "Create"

    assert_selector ".toast-body", text: "Shoe was successfully created."
    click_on "All Shoes"
  end

  test "updating a Shoe" do
    visit shoe_url(@shoe)
    click_on "Edit", match: :first

    click_on "Update"

    assert_selector '.toast-body', text: "Shoe was successfully updated."
    click_on "All Shoes"
  end

  test "destroying a Shoe" do
    visit shoe_url(@shoe)
    page.accept_confirm do
      click_on "Delete", match: :first
    end

    assert_selector '.toast-body', text: "Shoe was successfully deleted."
  end
end

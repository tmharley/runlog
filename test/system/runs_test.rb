require "application_system_test_case"

class RunsTest < ApplicationSystemTestCase
  setup do
    @run = runs(:one)
  end

  test "visiting the index" do
    visit runs_url
    assert_selector "h1", text: "All runs"
  end

  test "creating a Run" do
    visit runs_url
    click_on "New Run"

    fill_in 'Distance', with: '3.14'
    fill_in 'Duration', with: '29:59'
    fill_in 'Weather', with: '65'
    fill_in 'Elevation gain', with: '200'
    fill_in 'Heart rate', with: '162'
    fill_in 'Notes', with: 'Sample notes'

    click_on "Create"

    assert_text "Run was successfully created"
    click_on "All Runs"
  end

  test "updating a Run" do
    visit run_url(@run)
    click_on "Edit", match: :first

    click_on "Update"

    assert_text "Run was successfully updated"
    click_on "All Runs"
  end

  test "destroying a Run" do
    visit run_url(@run)
    page.accept_confirm do
      click_on "Delete", match: :first
    end

    assert_text "Run was successfully destroyed"
  end
end

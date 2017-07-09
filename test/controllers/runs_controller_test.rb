require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  setup do
    @run = runs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:runs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create run" do
    assert_difference('Run.count') do
      post :create, params: {run: { start_time_string: '2017-01-01 12:00',
                                    is_night: false,
                                    distance: 4.00,
                                    duration_string: '36:00',
                                    temperature: 72,
                                    weather_type_id: 2,
                                    elev_gain: 150,
                                    is_race: false }}
    end

    assert_redirected_to run_path(assigns(:run))
  end

  test "should show run" do
    get :show, params: {id: @run}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @run}
    assert_response :success
  end

  test "should update run" do
    put :update, params: {id: @run,
                          run: { distance: @run.distance,
                                 duration: @run.duration,
                                 elev_gain: @run.elev_gain,
                                 start_time: @run.start_time,
                                 temperature: @run.temperature }}
    assert_redirected_to run_path(assigns(:run))
  end

  test "should destroy run" do
    assert_difference('Run.count', -1) do
      delete :destroy, params: {id: @run}
    end

    assert_redirected_to runs_path
  end
end

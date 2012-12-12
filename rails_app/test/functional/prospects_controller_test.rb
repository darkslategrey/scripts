require 'test_helper'

class ProspectsControllerTest < ActionController::TestCase
  setup do
    @prospect = prospects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prospects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create prospect" do
    assert_difference('Prospect.count') do
      post :create, prospect: { addr: @prospect.addr, contact: @prospect.contact, departement: @prospect.departement, fax: @prospect.fax, mail: @prospect.mail, name: @prospect.name, srvc_code: @prospect.srvc_code, srvc_name: @prospect.srvc_name, tel: @prospect.tel, url: @prospect.url }
    end

    assert_redirected_to prospect_path(assigns(:prospect))
  end

  test "should show prospect" do
    get :show, id: @prospect
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @prospect
    assert_response :success
  end

  test "should update prospect" do
    put :update, id: @prospect, prospect: { addr: @prospect.addr, contact: @prospect.contact, departement: @prospect.departement, fax: @prospect.fax, mail: @prospect.mail, name: @prospect.name, srvc_code: @prospect.srvc_code, srvc_name: @prospect.srvc_name, tel: @prospect.tel, url: @prospect.url }
    assert_redirected_to prospect_path(assigns(:prospect))
  end

  test "should destroy prospect" do
    assert_difference('Prospect.count', -1) do
      delete :destroy, id: @prospect
    end

    assert_redirected_to prospects_path
  end
end

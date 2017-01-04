require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bartek)
  end

  test 'home page layout' do
    get root_path
    assert_template 'static_pages/home'
    get contact_path
    assert_select 'title', full_title('Contact')
  end

  test 'home page root link' do
    get root_path
    assert_select 'a[href=?]', root_path, count: 2
  end

  test 'home page help link' do
    get root_path
    assert_select 'a[href=?]', help_path
  end

  test 'home page contact link' do
    get root_path
    assert_select 'a[href=?]', contact_path
  end

  test 'home page about link' do
    get root_path
    assert_select 'a[href=?]', about_path
  end

  test 'links for logged user' do
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', users_path
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a[href=?]', edit_user_path(@user)
  end
end

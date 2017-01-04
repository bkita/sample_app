require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:bartek)
  end

  test 'should include paginate div on index page' do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1) do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end

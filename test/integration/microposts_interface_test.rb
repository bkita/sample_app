require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest


  def setup
    @user = users(:bartek)
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'

    # Valid submission
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: "JB testing" } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match 'JB testing', response.body

    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end

    # Visit different user (no delete links)
    get user_path(users(:jo))
    assert_select 'a', text: 'delete', count: 0
  end
end

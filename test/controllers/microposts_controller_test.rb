require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end

  test 'create should redirect to login page when not logged in' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { microposts: { content: 'Hello from test' } }
    end
    assert_redirected_to login_url
  end

  test 'destroy should redirect to login page when not logged in' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test 'should not allow to delete someone else post' do
    log_in_as(users(:bartek))
    assert_no_difference 'Micropost.count' do
      delete micropost_path(microposts(:ants))
    end
    assert_redirected_to root_url
  end
end

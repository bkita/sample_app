require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @relationship = Relationship.new(follower_id: users(:bartek).id,
                                     followed_id: users(:jo).id)
  end



  test 'follower id must be preset' do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test 'followed id must be preset' do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end

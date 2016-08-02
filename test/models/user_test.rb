require File.expand_path('../../test_helper', __FILE__)

class UserTest < ActiveSupport::TestCase
  include TestSetupMethods
  include TestHelperMethods
  def setup
    @show_debug = false
  end

  test "parent_id_required?" do
    @alice = create_user('alice', 'alice@doe.com')
    assert @alice.errors.any?,
      "User should have failed creation - #{@alice.inspect}"
  end

  test "cannot_set_parent_id_to_child_id" do
    flunk('Functionality does not exist') # comment this out to test actual code
    @alice = create_user('alice','alice@doe.com', 1)
    @bob = create_user('bob','bob@doe.com', @alice.id)
    assert_not find_user(@alice).update({:parent_id => @bob.id.to_i}),
      "Should not allow update with child as parent - #{find_user(@alice).inspect}"
  end
end

require 'test_helper'

class TotTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "find random not touched by working" do
    novotes = users(:novotes)
    tot = Tot.find_random_not_touched_by(novotes)
    assert tot, "Couldnt find a tot to vote on"
  end
end

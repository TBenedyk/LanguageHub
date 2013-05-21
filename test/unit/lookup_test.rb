require 'test/unit'

class LookupTest < Test::Unit::TestCase

	def test_should_have_zero_for_weight_when_not_shipping
	    assert_equal("Ruby", Lookup.language("tbenedyk") )
	end

end

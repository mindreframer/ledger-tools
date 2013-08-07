require_relative 'test_helper'



describe "String" do
  describe :indent_to_least_space do
    it "works" do
      vars = [
        ["  n\n    b\n         a\n", "n\n  b\n       a"],
        ["1\n b\n", "1\n b"],
      ]
      vars.each do |var|
        var[0].indent_to_least_space.must_equal var[1]
      end
    end
  end
end
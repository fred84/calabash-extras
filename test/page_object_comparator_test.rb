require 'test/unit'
require 'calabash-extras/page_object_comparator'

class PageObjectComparatorTest < Test::Unit::TestCase

  class DummyBasePage

    include Calabash::Extras::PageObjectComparator

    def initialize(value)
      @value = value
    end
  end

  class Page1 < DummyBasePage; end
  class Page2 < DummyBasePage; end

  def test_instances_of_same_class
    page1 = Page1.new 'value'
    page2 = Page1.new 'other'

    assert_equal page1.hash, page2.hash, 'Hash should be unique per class, not instance'
    assert_equal page1, page2, 'Object should be compared by class, not instance'
  end

  def test_instances_of_different_classes
    page1 = Page1.new 'same value'
    page2 = Page2.new 'same value'

    refute_equal page1.hash, page2.hash, 'Hash should be unique per class, not instance'
    refute_equal page1, page2, 'Object should be compared by class, not instance'
  end
end
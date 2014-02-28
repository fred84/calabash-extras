require 'test/unit'
require 'walker'
require 'page_object_comparator'

class WalkerTest < Test::Unit::TestCase

  class BaseDummyPage
    include Calabash::Extras::PageObjectComparator
    attr_accessor :will_match, :called, :back_called

    def initialize
      @called = false
      @back_called = false
    end

    def all_elements
      'list of all elements in string'
    end

    def match(all_elements)
      @will_match
    end

    def go
      @called = true
    end

    def back
      @back_called = true
    end
  end

  class EulaDummyPage < BaseDummyPage; end
  class LoginDummyPage < BaseDummyPage; end
  class MainMenuDummyPage < BaseDummyPage; end
  class UnreachablePage < BaseDummyPage; end
  class DeadEndPage < BaseDummyPage; end
  class NonExistentPage < BaseDummyPage; end
  class RefundDummyPage < BaseDummyPage; end
  class OrderHistoryDummyPage < BaseDummyPage; end
  class OrderInfoDummyPage < BaseDummyPage; end

  def setup
    @eula = EulaDummyPage.new
    @login = LoginDummyPage.new
    @main_menu = MainMenuDummyPage.new
    @unreachable = UnreachablePage.new
    @not_existent = NonExistentPage.new
    @order_history = OrderHistoryDummyPage.new
    @order_info = OrderInfoDummyPage.new
    @refund = RefundDummyPage.new

    @matrix = {
        @eula => {
            @login => lambda { @eula.go },
        },
        @login => {
            @main_menu => lambda { @login.go },
            @eula => lambda { @main_menu.back }
        },
        @main_menu => {
            @login => lambda { @main_menu.back },
            @order_history => lambda { @main_menu.go }
        },
        @order_history => {
            @main_menu => lambda { @order_history.back },
            @order_info => lambda { @order_history.go }
        },
        @order_info => {
            @order_history => lambda { @order_info.back },
            @refund => lambda { @order_info.go }
        },
        @refund => {
            @order_info => lambda { @refund.back }
        },
        @unreachable => {
            # unreachable
        }
    }

    @walker = Calabash::Extras::Walker.new(0, @matrix, lambda { |str| } )
  end

  def test_refund_to_main_menu
    @refund.will_match = true
    @walker.go @main_menu

    assert_back_called @refund
    assert_back_called @order_info
    assert_back_called @order_history
  end

  def test_eula_to_refund_page
    @eula.will_match = true
    @walker.go @refund

    assert_called @eula
    assert_called @login
    assert_called @main_menu
    assert_called @order_history
    assert_called @order_info
    assert_called @order_info
  end

  def test_unreachable
    @eula.will_match = true

    err = assert_raise RuntimeError do
      @walker.go @unreachable
    end

    assert_equal 'Unable to find path from "%s" to "%s"' % [@eula, @unreachable.name], err.message
  end

  def test_not_found
    @eula.will_match = true

    err = assert_raise RuntimeError do
      @walker.go @not_existent
    end

    assert_equal 'Page "%s" does not exist' % [@not_existent], err.message
  end

  def test_unable_to_determine_current_page

  end

  private

  def assert_called (page, method = :go)
    assert page.called, 'Call to method "%s" of page %s was expected' % [method, page.name]
  end

  def assert_back_called (page)
    assert page.back_called, 'Call to method "back" of page %s was expected' % [page.name]
  end
end







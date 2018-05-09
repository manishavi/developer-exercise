class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)
  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Subject
  attr_accessor :cards, :value, :blackjack, :busted, :winner
  def initialize
    @cards = []
    @value = 0
    @blackjack = false
    @winner = false
  end

  def total_value
    @value = 0
    @ace = false
    unless @cards.empty?
      @cards.each do |card|
        if card.name == :ace  
          @ace = true
        else
          @value = @value + card.value
        end
      end
      if @ace == true 
        if  (@value + 11) < 21
          @value += 11
          @blackjack = false
        elsif (@value + 11) == 21
          @value = 21
          if @cards.size == 2 
            @blackjack = true
          end
        else
          @value = @value + 1
        end
      end
    end
    @value
  end
end

class House
  attr_accessor :player, :dealer, :deck
  def initialize
    @player = Subject.new
    @dealer = Subject.new
    @deck = Deck.new
  end

  def play
    puts "Start of play"
    puts "===================================="
    @player.cards << @deck.deal_card
    @dealer.cards << @deck.deal_card
    @player.cards << @deck.deal_card
    @dealer.cards << @deck.deal_card
    puts "Show dealer's second card:"
    puts "#{@dealer.cards[1].name}"
    puts "*************************************"
    puts "Player's total value to begin with: #{@player.total_value}"
    puts "Player's first card:#{@player.cards[0].suite} - #{@player.cards[0].name} - #{@player.cards[0].value}"
    puts "Player's second card:#{@player.cards[1].suite} - #{@player.cards[1].name} - #{@player.cards[1].value}"
    puts "Checking Blackjack...."
    check_blackjack
    until @player.winner || @dealer.winner || @player.blackjack || @dealer.blackjack
      puts "Game continues:"
      puts "Type 1 for hit, or 2 for stay"
      option = gets.chomp
      if option == "1"
        @player.cards << @deck.deal_card
      elsif option == "2"
        until @dealer.total_value >= 17
          @dealer.cards << @deck.deal_card
        end
        decide_winner
      else
        puts "Invalid Input. Terminating..."
      end 
    end
  end

  def decide_winner
      puts "\nDealer: #{@dealer.total_value} && Player: #{@player.total_value}"
      check_blackjack
      unless @dealer.blackjack == true || @player.blackjack == true
        if @dealer.total_value > 21
          @player.winner = true
          puts "Dealer busted, player wins"
        elsif @player.total_value > 21
          @dealer.winner = true
          puts "Player busted, dealer wins"
        elsif @dealer.total_value > @player.total_value
          @dealer.winner = true
          puts "Dealer is the winner"
        else
          @player.winner = true
          puts "Player is the winner"
        end
      end
  end

  def check_blackjack
    if @dealer.blackjack == true
      @player.busted = true
      puts "Player busted, delaer has blackjack...game over" 
    elsif @player.blackjack == true
      @dealer.busted = true
      puts "Dealer busted, player has blackjack...game over" 
    end
  end
end

require 'test/unit'

class HouseTest < Test::Unit::TestCase
  def setup
    @house = House.new
  end
  def test_decide_winner_no_blackjack_player
    @house.player.cards << Card.new(:hearts, :ten, 10)
    @house.player.cards << Card.new(:spades, :ten, 10)
    @house.dealer.cards << Card.new(:hearts, :seven, 7)
    @house.dealer.cards << Card.new(:hearts, :seven, 10)
    @house.decide_winner
    assert_equal @house.player.winner, true
    assert_equal @house.dealer.winner, false
  end
  def test_decide_winner_no_blackjack_dealer
    @house.player.cards << Card.new(:hearts, :ten, 10)
    @house.player.cards << Card.new(:spades, :seven, 7)
    @house.dealer.cards << Card.new(:hearts, :seven, 6)
    @house.dealer.cards << Card.new(:hearts, :seven, 10)
    @house.dealer.cards << Card.new(:hearts, :seven, 3)
    @house.decide_winner
    assert_equal @house.dealer.winner, true
    assert_equal @house.player.winner, false
  end
end

class SubjectTest < Test::Unit::TestCase
  def setup
    @player = Subject.new
  end
  def test_subject_calculate_value
    assert_equal @player.total_value, 0
  end
  def test_black_jack
    @player.cards << Card.new(:hearts, :ace, [11,1])
    @player.cards << Card.new(:hearts, :ten, 10)
    assert_equal @player.total_value, 21
    assert_equal @player.blackjack, true
  end
end

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end
  
  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end
  
  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end
  
  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    assert_equal(false, @deck.playable_cards.include?(card))
  end

  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end

@house = House.new
@house.play
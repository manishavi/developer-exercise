require 'minitest/autorun'

class Array
  def where(ary)
    @self = self
    arr = Array.new
      self.each do |hash|
        @element = hash;
        @condition=ary.values[0];
        @key = ary.keys[0];
        if(@condition.kind_of?(Regexp))
           @result = @element.detect{|k,v| k==@key && v=~@condition}
          unless @result.nil?
            arr.push(@element)
          end
        else
          @result = @element.detect {|k,v| k==@key && v==@condition} 
          unless @result.nil?
            arr.push(@element)
          end
        end
      end
      arr
  end
end

class WhereTest < Minitest::Test
  def setup
    @boris   = {:name => 'Boris The Blade', :quote => "Heavy is good. Heavy is reliable. If it doesn't work you can always hit them.", :title => 'Snatch', :rank => 4}
    @charles = {:name => 'Charles De Mar', :quote => 'Go that way, really fast. If something gets in your way, turn.', :title => 'Better Off Dead', :rank => 3}
    @wolf    = {:name => 'The Wolf', :quote => 'I think fast, I talk fast and I need you guys to act fast if you wanna get out of this', :title => 'Pulp Fiction', :rank => 4}
    @glen    = {:name => 'Glengarry Glen Ross', :quote => "Put. That coffee. Down. Coffee is for closers only.",  :title => "Blake", :rank => 5}

    @fixtures = [@boris, @charles, @wolf, @glen]
  end

  def test_where_with_exact_match
    assert_equal [@wolf], @fixtures.where(:name => 'The Wolf')
  end

  def test_where_with_partial_match
    assert_equal [@charles, @glen], @fixtures.where(:title => /^B.*/)
  end

  def test_where_with_mutliple_exact_results
    assert_equal [@boris, @wolf], @fixtures.where(:rank => 4)
  end

  # def test_with_with_multiple_criteria
  #   assert_equal [@wolf], @fixtures.where(:rank => 4, :quote => /get/)
  # end

  # def test_with_chain_calls
  #   assert_equal [@charles], @fixtures.where(:quote => /if/i).where(:rank => 3)
  # end
end


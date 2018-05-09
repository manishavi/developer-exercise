class Array
  def where(ary)
    @arr = Array.new
    @iter = self
    ary.each do |key, val|
      if @arr.any? 
        @iter = @arr
        @arr = []
      end 
      @iter.each do |hash|
        @element = hash;
        if(val.kind_of?(Regexp))
          @result = @element.detect{|k,v| k==key && v=~val}
          unless @result.nil?
            @arr.push(@element)
          end
        else
          @result = @element.detect {|k,v| k==key && v==val} 
          unless @result.nil?
            @arr.push(@element)
          end
        end
      end
    end
    @arr
  end
end
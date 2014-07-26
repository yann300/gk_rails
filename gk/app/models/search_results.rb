class SearchResults 

   def initialize(results, total)
        @results = results
	@total = total
    end

   def getResult
        return @results
    end

   def getTotal
        return @total
    end
end


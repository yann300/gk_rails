
require "search_result_helper"
class SearchManager 
include SearchResultHelper
   def initialize()       
   end
	
def search(searchString, startIndex) 
	return self.Search(searchString, startIndex)      
   end
end

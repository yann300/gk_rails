
require "search_result_helper"
class SearchManager 
include SearchResultHelper
   def initialize()       
   end
	
def search(searchString) 
	return self.Search(searchString)      
   end
end

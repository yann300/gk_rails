
require "search_result_helper"
class SearchManager 
include SearchResultHelper
   def initialize()       
   end
	
def search(searchString, startIndex, lang) 
	return self.Search(searchString, startIndex, lang)      
   end
end

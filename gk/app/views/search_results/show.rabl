# app/views/users/search_results.rabl
object @searchResult

node :results do |searchResult|
  searchResult.getResult
end



module SearchResultHelper
require "rubygems"
require "json"
require "httpclient"

  def Search(searchString)
	client = HTTPClient.new
	hightlight = '"highlight" : { "pre_tags" : ["<b>"], "post_tags" : ["</b>"], "fields" : { "content" : {} } }'

	query = '{"query": {"query_string": { "query": "' + searchString + '" } }, ' + hightlight + '  }'


	res = client.post('http://91.121.25.98:9200/_search', query)
logger = Logger.new(STDOUT)
logger.debug res.body
	parsed = JSON.parse(res.body)

	resultsA = []

	
	logger.debug parsed["took"]
	
	parsed["hits"]["hits"].each do|item|
  		resultsA.push(SearchResult.new(item["_source"]["url"], item["_source"]["title"], "", item["highlight"]["content"]))
	end
	
	return SearchResults.new(resultsA)
  end
end

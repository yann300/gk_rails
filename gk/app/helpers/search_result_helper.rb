module SearchResultHelper
require "rubygems"
require "json"
require "httpclient"

  def Search(searchString, startIndex)
	client = HTTPClient.new
	hightlight = '"highlight" : { "pre_tags" : ["<b>"], "post_tags" : ["</b>"], "fields" : { "content" : {} } }'
	size = '"from" : '  + startIndex + ', "size" : 5'
	sort = '"sort" : [{ "post_date" : {"order" : "desc"} },"_score"]'


	query = '{ ' + sort + ', ' + size + ', "query": { "query_string": { "query": "' + searchString + '" } }, ' + hightlight + '  }'

	logger = Logger.new(STDOUT)
	#res = client.post('http://91.121.25.98:9200/_search', query)
	res = client.post('http://127.0.0.1:9200/_search', query)
	logger.debug res.body
	parsed = JSON.parse(res.body)

	resultsA = []

	parsed["hits"]["hits"].each do|item|
		hightlight = ''
		if (item["highlight"] != nil)
			hightlight = item["highlight"]["content"]
		end
  		resultsA.push(SearchResult.new(item["_source"]["url"], item["_source"]["title"], "", hightlight))
	end
	total = parsed["hits"]["total"]
	return SearchResults.new(resultsA, total)
  end
end

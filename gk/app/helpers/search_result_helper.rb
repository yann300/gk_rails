module SearchResultHelper
require "rubygems"
require "json"
require "httpclient"

  def Search(searchString)
	client = HTTPClient.new
	hightlight = '"highlight" : { "pre_tags" : ["<b>"], "post_tags" : ["</b>"], "fields" : { "content" : {} } }'
	size = '"from" : 0, "size" : 50'
	sort = '"sort" : [{ "post_date" : {"order" : "dsc", "ignore_unmapped" : true} },"_score"]'


	query = '{ ' + sort + ', ' + size + ', "query": { "query_string": { "query": "' + searchString + '" } }, ' + hightlight + '  }'


	res = client.post('http://91.121.25.98:9200/_search', query)

	parsed = JSON.parse(res.body)

	resultsA = []

	parsed["hits"]["hits"].each do|item|
		hightlight = ''
		if (item["highlight"] != nil)
			hightlight = item["highlight"]["content"]
		end
  		resultsA.push(SearchResult.new(item["_source"]["url"], item["_source"]["title"], "", hightlight))
	end
	
	return SearchResults.new(resultsA)
  end
end

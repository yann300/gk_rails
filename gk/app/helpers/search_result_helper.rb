module SearchResultHelper
require "rubygems"
require "json"
require "httpclient"

  def GetEnhanceQuery(searchString, lang, field)
	enhancedQuery = ''
	if (searchString[0] == "\"" && searchString[searchString.length - 1] == "\"")
		searchString = searchString.gsub("\"", "")
		enhancedQuery = '"match" : { "' + field + '_' + lang + '"  : { "query" :  "' + searchString + '", "type" : "phrase", "operator" : "and" } }' 
	else
		enhancedQuery = '"match" : { "' + field + '_' + lang + '" : { "query" : "' + searchString + '", "operator" : "or" } }'  
	end
	return enhancedQuery
  end

  def Search(searchString, startIndex)
	logger = Logger.new(STDOUT)
	client = HTTPClient.new
	hightlight = '"highlight" : { "pre_tags" : ["<b>"], "post_tags" : ["</b>"], "fields" : { "content" : { } } }'
	size = '"from" : '  + startIndex + ', "size" : 40'
	#sort = '"sort" : [{ "post_date" : {"order" : "desc"} },"_score"]'
	sort = '"sort" : [ { "_score" : {"order" : "desc"} },  { "post_date" : {"order" : "desc"} }]'
	logger.debug searchString
	translator = BingTranslatorConnect.new
	translator.ensureAccessToken
	langSource = translator.detect(searchString);
	if (langSource == "en")
		frtranslation = translator.translate(searchString, 'fr', langSource)
		entranslation = searchString
		detranslation = translator.translate(searchString, 'de', langSource)
		
	elsif (langSource == "fr")
		entranslation = translator.translate(searchString, 'en', langSource)
		detranslation = translator.translate(searchString, 'de', langSource)
		frtranslation = searchString
	
	elsif (langSource == "de")
		entranslation = translator.translate(searchString, 'en', langSource)
		frtranslation = translator.translate(searchString, 'fr', langSource)
		detranslation = searchString
	end
	
	logger.debug entranslation
        logger.debug detranslation
	logger.debug frtranslation

	#firstQuery = '"match" : { "_all" : { "query" :  "guerre", "type" : "phrase", "operator" : "and" } }' 
	#secondQuery = '"match" : { "_all" : { "query" :  "krieg", "type" : "phrase", "operator" : "and" } }' 
	boolQuery = '
	    "bool" : {   
		"should" : [
		    {
		        ' + self.GetEnhanceQuery(entranslation, "en", "content")  + '
		    },
		    {
		        ' + self.GetEnhanceQuery(entranslation, "en", "title")  + '
		    },
		    {
		        ' + self.GetEnhanceQuery(detranslation, "de", "content")  + '
		    },
	            {
		        ' + self.GetEnhanceQuery(detranslation, "de", "title")  + '
		    },
		    {
		        ' + self.GetEnhanceQuery(frtranslation, "fr", "content")  + '
		    },
		    {
		        ' + self.GetEnhanceQuery(frtranslation, "fr", "title")  + '
		    }
		],
		"minimum_should_match" : 1		
	    }
	'

	functions_decay = '"functions": [
            {
                "exp": {
                    "post_date": {                        
                        "scale" : "1d",
			"decay" : 0.5
                    }
                }
            },
	    {
		"script_score": { "script": "_score * doc[\"customRelevance\"].value" } 
		}		
        ],'
	
	function_score = ' "function_score" :  { ' + functions_decay + ' "boost_mode": "replace", "query" : { ' + boolQuery + '  } }  '
                    
	
	query = '{ ' + sort + ', ' + size + ', "query": { ' + function_score + ' }, ' + hightlight + '  }'
	#query = '{ ' + sort + ', ' + size + ', ' + enhancedQuery + ', ' + hightlight + '  }'

	
	#res = client.post('http://91.121.25.98:9200/_search', query)
	res = client.post('http://127.0.0.1:9200/_search', query)
	#logger.debug query
	parsed = JSON.parse(res.body)
        #logger.debug res.body
	resultsA = []

	parsed["hits"]["hits"].each do|item|
		hightlight = ''
		if (item["highlight"] != nil)
			hightlight = item["highlight"]["content"]
		end
  		resultsA.push(SearchResult.new(item, "", hightlight))
	end
 	
	total = parsed["hits"]["total"]
	return SearchResults.new(resultsA, total)
  end
end

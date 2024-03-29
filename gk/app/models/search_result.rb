class SearchResult 
	require 'uri'

   def initialize(item, content, matched_content)
	post_date = item["_source"]["post_date"]
	if (post_date != nil)
		post_date["00:00:00"] = ""
	end     

	@url = item["_source"]["url"]
	@title = item["_source"]["title"]
	@content = content
	@highlight = matched_content
	begin
	myUri = URI.parse( @url )
	@host = myUri.host	
	rescue Exception => e
	@host = @url.split('//').first.split('/').first;
	end	
	
	@post_date = post_date
	@ID = item["_source"]["id"]
	@score = item["_score"]
	@image = item["_source"]["image"]
	@customRelevance = item["_source"]["customRelevance"]
    end
end


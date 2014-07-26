class SearchResult 
	require 'uri'

   def initialize(url, title, post_date, content, matched_content, id)
	if (post_date != nil)
		post_date["00:00:00"] = ""
	end        

	@url = url
	@title = title
	@content = content
	@highlight = matched_content
	myUri = URI.parse( url )
	@host = myUri.host
	@post_date = post_date
	@ID = id
    end
end


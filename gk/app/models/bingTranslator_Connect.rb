class BingTranslatorConnect 
	require "httpclient"

   def initialize()
        @logger = Logger.new(STDOUT)
	@client = HTTPClient.new
	@clientId = 'gk300'
	@clientSecret = 'l9S+FOfDa9cr0ufZP8YyqfBwSbKpxZ5r3q3QmDOIXNM='
	@access_token = nil
    end

    def ensureAccessToken
	if (@access_token == nil)
		query = "grant_type=client_credentials&client_id=" + @clientId + "&client_secret=" + @clientSecret + "&scope=http://api.microsofttranslator.com"
		res = @client.post('https://datamarket.accesscontrol.windows.net/v2/OAuth2-13', query)
		logger.debug res.body
		result = JSON.parse(res.body)
		@access_token = result.access_token
	end
	return @access_token
    end



   def translate(value, lang)
	res = @client.post("http://api.microsofttranslator.com/v2/Http.svc/Translate?text=" + value + "&to=" + lang, nil, { 'Authorization' => 'Bearer ' + @access_token  } )
        result = JSON.parse(res.body)
	return result.string 
    end
end


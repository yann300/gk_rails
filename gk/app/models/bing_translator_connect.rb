class BingTranslatorConnect 
	require "httpclient"
require 'uri'
require 'rexml/document'
@@access_token = nil
@@accessed_time = nil
@@expiration_time = nil
   def initialize()
        @logger = Logger.new(STDOUT)
	@client = HTTPClient.new
	@clientId = 'gk300'
	#@clientSecret = "l9S+FOfDa9cr0ufZP8YyqfBwSbKpxZ5r3q3QmDOIXNM="
	@clientSecret = "l9S%2BFOfDa9cr0ufZP8YyqfBwSbKpxZ5r3q3QmDOIXNM%3D"
	
    end

    def ensureAccessToken()
	if (@@accessed_time != nil)
		diff = TimeDifference.between(@@accessed_time, Time.now).in_seconds		

		if (diff + 15 >= @@expiration_time)
			@@access_token = nil
			@@accessed_time = nil
			@@expiration_time = nil
		end
		
	end
	if (@@access_token == nil)
		@logger.debug 'ask new access token'
		query = "grant_type=client_credentials&client_id=" + @clientId + "&client_secret=" + @clientSecret + "&scope=http://api.microsofttranslator.com"
		res = @client.post('https://datamarket.accesscontrol.windows.net/v2/OAuth2-13', query, { 'content-type' => 'application/x-www-form-urlencoded' })
		result = JSON.parse(res.body)
		@@accessed_time = Time.now
		@@expiration_time = result["expires_in"].to_i
		
		@@access_token = result["access_token"]
	end
	
	return @@access_token
    end



   def translate(value, lang)
	res = @client.get("http://api.microsofttranslator.com/v2/Http.svc/Translate?text=" + value + "&from=fr&to=" + lang, nil, { 'Authorization' => 'Bearer ' + @@access_token, 'content-type' => 'application/x-www-form-urlencoded'  } )
	
	data = REXML::Document.new(res.body)
	return data.root.text
    end
end


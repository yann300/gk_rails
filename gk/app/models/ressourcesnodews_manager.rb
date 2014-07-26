
require "rubygems"
require "json"
require "httpclient"

class RessourcesnodewsManager 

   def initialize()       
   end
	
   def getRessourceNodesFrom(urls) 
	client = HTTPClient.new     	
	
	query = '{ "urls" : { "items" : ["' + urls.join("\",\"") + '"] } }'		
	res = client.post('http://127.0.0.1:8080/gk_engine_front/rest/RessourceNodesWS/getRessourceNodesFrom', query, { 'content-type' => 'application/json' })

	logger = Logger.new(STDOUT)
	logger.debug query
	logger.debug res

	return res.body
   end

   def getRessourceNode(nodeName) 
	client = HTTPClient.new     
	query = ''
	res = client.post('http://127.0.0.1:8080/gk_engine_front/rest/RessourceNodesWS/getRessourceNode/' + nodeName, query)    
  	return res.body
  end

  def addRessource(nodeName, url) 
	client = HTTPClient.new     
	query = '{ "url" : "' + url + '"  }'
	res = client.post('http://127.0.0.1:8080/gk_engine_front/rest/RessourceNodesWS/addRessourceNode/' + nodeName, query, { 'content-type' => 'application/json' })      
  	return res.body
  end
end

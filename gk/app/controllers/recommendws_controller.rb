class RecommendwsController < ApplicationController
	
require "httpclient"

  respond_to :json, :xml 
  def addPublicationRecommendation
	client = HTTPClient.new
	query = '{ "script" : "ctx._source.customRelevance = ctx._source.customRelevance + 0.4" }'
	res = client.post('http://127.0.0.1:9200/gkindex/doc/' + params[:id] + '/_update', query)
	logger = Logger.new(STDOUT)
	logger.debug res
  end

  respond_to :json, :xml 
  def addPublicationFocus
	client = HTTPClient.new
	query = '{ "script" : "ctx._source.customRelevance_focus = ctx._source.customRelevance_focus + 0.4" }'
	res = client.post('http://127.0.0.1:9200/gkindex/doc/' + params[:id] + '/_update', query)
	logger = Logger.new(STDOUT)
	logger.debug res
  end

end

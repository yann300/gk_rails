class SearchResultsController < ApplicationController

  respond_to :json, :xml  
  def show
	  searchmanager = SearchManager.new()
	@searchResult = searchmanager.search(params[:q])
  end
end
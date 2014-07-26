class RessourcenodeswsController < ApplicationController

  respond_to :json, :xml 
  def getRessourceNodesFrom
	  ressourceManager = RessourcesnodewsManager.new()
@getRessourceNodesFromResult = ressourceManager.getRessourceNodesFrom(params[:urls])
logger = Logger.new(STDOUT)
logger.debug 'TEST'
logger.debug @getRessourceNodesFromResult.to_s
logger.debug 'TESTEND'
	  
  end

  respond_to :json, :xml  
  def getRessourceNode
	  ressourceManager = RessourcesnodewsManager.new()
	  @getRessourceNodeResult = ressourceManager.getRessourceNode(params[:nodeName])
  end

  respond_to :json, :xml  
  def addRessource
	  ressourceManager = RessourcesnodewsManager.new()
          ressourceManager.addRessource(params[:nodeName], params[:url])
  end
end

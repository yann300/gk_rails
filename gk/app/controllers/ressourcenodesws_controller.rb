class RessourcenodeswsController < ApplicationController

  respond_to :json, :xml 
  def getRessourceNodesFrom
	  ressourceManager = RessourcesnodewsManager.new()
@getRessourceNodesFromResult = ressourceManager.getRessourceNodesFrom(params[:urls])
  end
  
  respond_to :json, :xml  
  def addRessource
	  ressourceManager = RessourcesnodewsManager.new()
          ressourceManager.addRessource(params[:content], params[:sources])
  end

  respond_to :json, :xml  
  def getLastCreatedRessourceNode
	  ressourceManager = RessourcesnodewsManager.new()
          @getLastCreatedRessourceNodeResult = ressourceManager.getLastCreatedRessourceNode(params[:length])
  end
end

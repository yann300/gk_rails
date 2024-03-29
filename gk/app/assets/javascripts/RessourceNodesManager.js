
function ressourceNodesManager()
{
	_.extend(this, Backbone.Events);

	this.updateRessourceDisplayed = function (data){
		var nodews = new ressourceNodeWS();
		nodews.on(nodews.GETRESSOURCENODEFROM_COMPLETE, this.updateRessourceDisplayedCallBackUI, this);
		var urls = [];
		$('.resultcontainerinfonode_updatepending').each(function (index){	
			if (urls.indexOf($(this).attr('urlref')) == -1){	
				urls.push($(this).attr('urlref'));
			}
		});		
		if (urls.length > 0){
			nodews.getRessourceNodeFrom(urls);
		}
	}

	this.updateRessourceDisplayedCallBackUI = function (data)
	{
		
		$(data.nodes.result).each(function (index){
			var content = this.content.substring(0, 50) + "...";
			$(this.sources).each(function(i){
					var targets = $("[urlref='" + this.url + "']");
						
					if (targets.length > 0){
							$(targets).each(function(i){
										$(this).html($(this).html() + ' ' + content);	
										$(this).removeClass('resultcontainerinfonode_updatepending');
								})
					}
			});
		});
	}
	
	this.getLastCreatedRessourceNode = function (length){
		var nodews = new ressourceNodeWS();
		nodews.on(nodews.GETLASTCREATEDRESSOURCENODE_COMPLETE, this.getLastCreatedRessourceNodeCallBackUI, this);
		nodews.getLastCreatedRessourceNode(length);
	}

	this.getLastCreatedRessourceNodeCallBackUI = function (data)
	{
		var style_class = "";
		var focus_class = 0;
		$(data.nodes.result).each(function(i) {
			if (focus_class%2 == 0){ 
							style_class = "focus_pair";
			}  
			else{
							style_class = "focus_impair";			
			}
			var htmlContainer = _.template($('#focus-template').html(), {focus : this, style_class : style_class  });			
			$('.focuses_content').append(htmlContainer);
			focus_class++;
		});
	}
}

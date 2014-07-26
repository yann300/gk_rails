
function ressourceNodesManager()
{
	_.extend(this, Backbone.Events);

	this.updateRessourceDisplayed = function (data){
		var nodews = new ressourceNodeWS();
		nodews.on(nodews.GETRESSOURCENODEFROM_COMPLETE, this.updateRessourceDisplayedCallBackUI, this);
		var urls = [];
		$('.resultcontainerinfonode_updatepending').each(function (index){		
			urls.push($(this).attr('urlref'));
		});		
		if (urls.length > 0){
			nodews.getRessourceNodeFrom(urls);
		}
	}

	this.updateRessourceDisplayedCallBackUI = function (data)
	{
		var oData = $.parseJSON(data.string.result);
		$(oData.items.entry).each(function (index){
			var target = $("[urlref='" + this.key + "']");
			if (this.value != null) {
				$(this.value.item).each(function (index){
					$(target).html($(target).html() + ' ' + this.name);		
				});
			}
			$(target).removeClass('resultcontainerinfonode_updatepending');
		});
	}

	this.getCurrentRessourceNode = function (data){
		var nodews = new ressourceNodeWS();
		nodews.on(nodews.GETRESSOURCENODE_COMPLETE, this.getCurrentRessourceNodeCallBackUI, this);
		nodews.getRessourceNode('berlin');
	}
	
	this.getCurrentRessourceNodeCallBackUI = function (data)
	{
		var oData = $.parseJSON(data.string.result);
		oData.comment = "voila le commentaire décrivant le sujet ";
		if (typeof(oData.associatedUrls) == 'string'){
			oData.associatedUrls = [ oData.associatedUrls ];
		}
		var html = _.template($('#search-results-news-template').html(), { node: oData} );
		$('.newscontent').html(html);
	}
}

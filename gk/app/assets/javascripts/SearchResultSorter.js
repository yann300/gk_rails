function searchResultSorter(panelContainerId)
{
	this.panelContainerId = panelContainerId;
	
		
	
	this.applyResults = function (results){
		var me = this;
		
		var hostArticleContainerHash = [];		
		
		$(results).each(function() {
			console.log(this);
			if (hostArticleContainerHash[this.host] == undefined || this.customRelevance > 1){			
				var html = _.template($('#hostresult-container-template').html(), { });
				var contResult = $(html);	
				$(me.panelContainerId).append(contResult);
				me.put(this, contResult, "hostContent");
				
				hostArticleContainerHash[this.host] = contResult; 				
				var popupContainer = $("<div id='hostArticleMorePopUp' style='display:none;' ><div class='popUp' ></div><div>").appendTo(contResult);
				me.put(this, contResult.find('#hostArticleMorePopUp'), "popUp");

				me.initAction(contResult, this.host);
			}
			else{		
				var contResult = hostArticleContainerHash[this.host];				
				
				var moreNb = parseInt(contResult.find('.hostResultontainer-more span.resultNumber').html()) + 1;
				contResult.find('.hostResultontainer-more span.resultNumber').html(moreNb);
				contResult.find('.hostResultontainer-more span.hostName').html(this.host);
				contResult.find('.hostResultontainer-more').show();
				me.put(this, contResult.find('#hostArticleMorePopUp'), "popUp");
			}
		
		});
		hostArticleContainerHash = [];	
		
	}
		
	
	this.put = function(result, container, target){
		var html = _.template($('#search-result-template').html(), {result: result});
		$(container).find('.' + target).append(html);
	}
	

	this.getHostArticleHash = function (){
		return this.hostArticleObjectHash;
	}

	this.initAction = function(contResult, host){
		
		contResult.find('.hostResultontainer-more').unbind('click').bind('click', function (){					
					$(contResult).find('#hostArticleMorePopUp').dialog({ 
						width:700, 
						height:700, 
						title : host, 
						close: function (event, ui) {
   							$(this).dialog("destroy");
						} 
					});	
				});		
		}
	}


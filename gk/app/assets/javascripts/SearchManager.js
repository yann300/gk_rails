function searchManager(containerId)
{
	
	_.extend(this, Backbone.Events);

	this.UPDATEUI_COMPLETE = "UPDATEUI_COMPLETE";
	this.UPDATEUILOADMORE_COMPLETE = "UPDATEUILOADMORE_COMPLETE";
	
	this.containerId = containerId;
	this.currentIndex = 0;
	this.resultSorter = new searchResultSorter('#' + this.containerId + ' .results');
	
	this.getLang = function(){
		return $('#langselect').val();	
	}
	
	this.search = function (inputString)
	{	
		var me = this;
		$('.content_search_result').addClass('content_search_result_started');
		$('.content_search_result').animate({
			height:	'500px'
		}, function(){
			$('#' + me.containerId).html('');
			$('#' + me.containerId).hide();
			$('.loading_result').show();
			
			
			me.currentIndex = 0;
			$('#loadMore').hide();	
			var caller = new searchCaller(inputString);
			caller.on(caller.SEARCH_COMPLETE, me.updateUI, me);
			caller.search(inputString, 0, me.getLang());	
			
			});
		
	}

	this.loadMoreSearch = function (inputString)
	{
		$('#loadMore').removeClass('loadMore_plus');
		$('#loadMore').addClass('loadMore_loading');	
		var caller = new searchCaller(inputString);
		caller.on(caller.SEARCH_COMPLETE, this.updateUIloadMore, this);
		caller.search(inputString, this.currentIndex, this.getLang());
	}

	this.updateUIloadMore = function (data){		
		this.updateSearchPanel(data);	
		this.trigger(this.UPDATEUILOADMORE_COMPLETE, data.searchresults.results);	
	}

	this.updateUI = function (data){
		
		$('.loading_result').hide();
		$('.content_search_result').css('height','inherit');
		$('#' + this.containerId).show();
		var htmlContainer = _.template($('#search-results-container-template').html(), {});
		$('#' + this.containerId).html(htmlContainer);
		$('#' + this.containerId + ' .headerinformation').html(data.searchresults.total + " results.");
		this.updateSearchPanel(data);	
		//$('#' + this.containerId).fadeIn(400);
		this.trigger(this.UPDATEUI_COMPLETE, data.searchresults.results);	
	}

	this.updateSearchPanel = function (data){
		this.currentIndex = this.currentIndex + data.searchresults.results.length;
		$('#loadMoreContainer').remove(); //in case load more is already displayed.
		this.resultSorter.applyResults(data.searchresults.results);		
		if (this.currentIndex + 1 <= data.searchresults.total)
		{
			var htmlLoadMore = _.template($('#search-results-loadmore-template').html(), {});
			$('#' + this.containerId + ' .results').append(htmlLoadMore);
			this.initLoadMore();			
		}
		this.initAction();
	}

	this.initAction = function() {
		var me = this;
		$('.recommend').unbind('click').bind('click', function(){				
			var id = $(this).attr('sourceid');
			id = id.replace(/\//g, '%2f');
			var caller = new PublicationRecommandationCaller();
			caller.on(caller.RECOMMANDATIONSENT_COMPLETE, me.updateUIRecommandationSent, me);
			caller.addRecommandation(id);
		});
	}

	this.updateUIRecommandationSent = function(){
		alert("recommandation sent");
	}

	this.initLoadMore = function (){
		var me = this;
		$('#loadMore').click(function (){
			query = $('#searchInput').val();		 
			me.loadMoreSearch(query);
		});	
	}
}

function searchCaller()
{
	_.extend(this, Backbone.Events);

	this.SEARCH_COMPLETE = "SEARCH_COMPLETE";
	this.search = function (inputString, startIndex, lang)
	{
		var me = this;
		$.ajax("/search_results/search.json?lang=" + lang + "&q=" + inputString + "&i=" + startIndex)
		.done(function(data) {
			me.trigger(me.SEARCH_COMPLETE, data);
		})
		.fail(function() {
			alert( e.message );
		})
		.always(function() {
		
		});
	}
}

function PublicationRecommandationCaller()
{
	_.extend(this, Backbone.Events);

	this.RECOMMANDATIONSENT_COMPLETE = "RECOMMANDATIONSENT_COMPLETE";
	this.addRecommandation = function (id)
	{
		var me = this;	
		var query = JSON.stringify({ id: id }); 		
		$.ajax({
			url : "/recommendws/addPublicationRecommendation",
			data : query,
			type : 'POST',				 
			contentType: 'application/json'
		})
		.done(function(dataReturn) {
			me.trigger(me.RECOMMANDATIONSENT_COMPLETE, null);
		})
		.fail(function(e) {
			alert( e.message );
		})
		.always(function() {
	
		});	
	}
}

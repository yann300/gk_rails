function searchManager(containerId)
{
	this.containerId = containerId;
	this.currentIndex = 0;
	
	this.search = function (inputString)
	{	
		$('#loadMore').hide();	
		var caller = new searchCaller(inputString);
		caller.on(caller.SEARCH_COMPLETE, this.updateUI, this);
		caller.search(inputString, 0);		
	}

	this.loadMoreSearch = function (inputString)
	{
		var caller = new searchCaller(inputString);
		caller.on(caller.SEARCH_COMPLETE, this.updateUIloadMore, this);
		caller.search(inputString, this.currentIndex + 1);
	}

	this.updateUIloadMore = function (data){
		this.currentIndex = this.currentIndex + data.searchresults.results.length;
		var html = _.template($('#search-results-template').html(), {results: data.searchresults.results});
		$('#' + this.containerId + ' .results').append(html);
		if (this.currentIndex + 1 >= data.searchresults.total)
		{
			$('#loadMore').hide();		
		}
	}

	this.updateUI = function (data){
		this.currentIndex = data.searchresults.results.length - 1;
		var htmlContainer = _.template($('#search-results-container-template').html(), {});
		$('#' + this.containerId).html(htmlContainer);
		var html = _.template($('#search-results-template').html(), {results: data.searchresults.results});
		$('#' + this.containerId + ' .results').html(html);
		$('#' + this.containerId + ' .headerinformation').html(data.searchresults.total + " results.");
		if (data.searchresults.results.length < data.searchresults.total)
		{
			$('#loadMore').show();		
		}		
	}
}

function searchCaller()
{
	_.extend(this, Backbone.Events);

	this.SEARCH_COMPLETE = "SEARCH_COMPLETE";
	this.search = function (inputString, startIndex)
	{
		var me = this;
		$.ajax("/search_results/search.json?q=" + inputString + "&i=" + startIndex)
		.done(function(data) {
			me.trigger(me.SEARCH_COMPLETE, data);
		})
		.fail(function() {
			alert( "error" );
		})
		.always(function() {
		
		});
	}
}

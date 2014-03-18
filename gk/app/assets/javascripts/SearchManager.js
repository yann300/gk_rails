function searchManager(containerId)
{
	this.containerId = containerId;
	this.search = function (inputString)
	{
		var caller = new searchCaller(inputString);
		caller.on(caller.SEARCH_COMPLETE, this.updateUI, this);
		caller.search(inputString);
	}

	this.updateUI = function (data){
		var html = _.template($('#search-result-template').html(), {results: data.searchresults.results});
		$('#' + this.containerId).html(html);
	}
}

function searchCaller()
{
	_.extend(this, Backbone.Events);

	this.SEARCH_COMPLETE = "SEARCH_COMPLETE";
	this.search = function (inputString)
	{
		var me = this;
		$.ajax("/search_results/search.json?q=" + inputString)
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
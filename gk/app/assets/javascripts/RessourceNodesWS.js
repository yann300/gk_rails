
function ressourceNodeWS()
{
	_.extend(this, Backbone.Events);

	this.GETRESSOURCENODEFROM_COMPLETE = "GETRESSOURCENODEFROM_COMPLETE";
	this.GETRESSOURCENODE_COMPLETE = "GETRESSOURCENODE_COMPLETE";
	this.ADDRESSOURCE_COMPLETE = "ADDRESSOURCE_COMPLETE";
	
	this.getRessourceNode = function (nodeName)
	{
		var me = this;		
		var query = JSON.stringify({ nodeName : nodeName  });  		
		$.ajax({
			url :"/ressourcenodesws/getRessourceNode",	
			data : query,		
			type : 'POST',	
			dataType: "JSON",
			contentType: 'application/json'			
		})
		.done(function(dataReturn) {
			me.trigger(me.GETRESSOURCENODE_COMPLETE, dataReturn);
		})
		.fail(function(e) {
			alert( e.message );
		})
		.always(function() {
		
		});
	}

	this.addRessource = function (nodeName, url)
	{
		var me = this;
		var query = JSON.stringify({ nodeName: nodeName, url : url   });  
		$.ajax({
			url : "/ressourcenodesws/addRessource",
			data : query,
			type : 'POST',
			dataType: "json", 
			contentType: 'application/json'
		})
		.done(function(dataReturn) {
			me.trigger(me.ADDRESSOURCE_COMPLETE, dataReturn);
		})
		.fail(function(e) {
			alert( e.message );
		})
		.always(function() {
		
		});
	}

	this.getRessourceNodeFrom = function (urls)
	{
		var me = this;
		var query = JSON.stringify({ urls : urls  });  
		$.ajax({
			url : "/ressourcenodesws/getRessourceNodesFrom",
			data : query,
			type : 'POST',
			dataType: "json", 
			contentType: 'application/json'
		})
		.done(function(dataReturn) {
			me.trigger(me.GETRESSOURCENODEFROM_COMPLETE, dataReturn);
		})
		.fail(function(e) {
			alert( e.message );
		})
		.always(function() {
		
		});
	}
}

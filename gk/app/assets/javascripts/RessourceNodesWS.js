
function ressourceNodeWS()
{
	_.extend(this, Backbone.Events);

	this.GETLASTCREATEDRESSOURCENODE_COMPLETE = "GETLASTCREATEDRESSOURCENODE_COMPLETE";
	this.GETRESSOURCENODEFROM_COMPLETE = "GETRESSOURCENODEFROM_COMPLETE";	
	this.ADDRESSOURCE_COMPLETE = "ADDRESSOURCE_COMPLETE";	
	

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

	this.getLastCreatedRessourceNode = function (length)
	{
		var me = this;
		var query = JSON.stringify({ length : length  });  
		$.ajax({
			url : "/ressourcenodesws/getLastCreatedRessourceNode",
			data : query,
			type : 'POST',
			dataType: "json", 
			contentType: 'application/json'
		})
		.done(function(dataReturn) {
			me.trigger(me.GETLASTCREATEDRESSOURCENODE_COMPLETE, dataReturn);
		})
		.fail(function(e) {
			//alert( e.message );
		})
		.always(function() {
		
		});
	}
}

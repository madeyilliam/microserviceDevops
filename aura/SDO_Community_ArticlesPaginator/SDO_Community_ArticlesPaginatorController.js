({
	previousPage : function(component, event, helper) {
        var myEvent = $A.get("e.c:SDO_Community_ArticlePageChange");
        myEvent.setParams({ "direction": "previous"});
        myEvent.fire();
	},
	nextPage : function(component, event, helper) {
        var myEvent = $A.get("e.c:SDO_Community_ArticlePageChange");
        myEvent.setParams({ "direction": "next"});
        myEvent.fire();
	}
})
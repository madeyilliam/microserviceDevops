({
    doInit : function(component, event, helper) {
        let promises = [
            helper.getInsights(component),
            helper.getContactSuggestions(component)
        ]
        Promise.all(promises);
    },
    newInsight : function(component){
        let recordId = component.get('v.recordId');
        component.getEvent('renderPanel').setParams({
            type : 'c:SDO_Tool_Insights_EditAccountInsight',
            attributes : {
                recordId: recordId
            }
        }).fire();
    },
    newContact : function(component){
        let recordId = component.get('v.recordId');
        component.getEvent('renderPanel').setParams({
            type : 'c:SDO_Tool_Insights_EditContactSuggestion',
            attributes : {
                recordId: recordId
            }
        }).fire();
    }
})
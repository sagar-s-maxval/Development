({
    loadifwProsecutionList: function(component, event, helper) {
        helper.onLoad(component, event);
        helper.lastSyncedDate(component, event);
    },
    
    IfwRefereshwin: function(component, event, helper) {
        //var recordId = component.get('v.recordId');    
        //helper.refresh(component, event);
        helper.onLoad(component, event);
    },
    
    datasync: function(component, event, helper) {
        helper.syncifwdata(component, event);
        helper.syncPAIRAnalyticData(component, event);
    },
    
    lastSyncedDateCal: function(component, event, helper) {
        helper.lastSyncedDate(component, event);
    },
    //For PAIR Application Mapping
    applicationsync: function(component, event, helper) {
        helper.syncPAIRapplication(component, event);
        helper.syncBibiloPAIRapplication(component, event);
    },
    
})
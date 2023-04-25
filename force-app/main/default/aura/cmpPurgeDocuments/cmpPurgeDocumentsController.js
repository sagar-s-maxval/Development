({
    purgeDocuments : function(component, event, helper) {
        let action = component.get('c.manuallyPurgeDocuments');
        let params = {
            recordId : component.get('v.recordId')
        }
        helper.makeApexCall(component, event, helper, action, params, helper.showSuccess);
    }
});
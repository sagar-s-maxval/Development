({
    doInit : function(component, event, helper) {
        component.set('v.IDF', component.get('v.recordId'));

        helper.getAllDocuments(component, event, helper);
    },

    editDocument : function(component, event, helper) {
        component.set('v.canUserAdd', true);
    },

    updateDocumentsInfo : function(component, event, helper) {
        helper.updateDocuments(component, event, helper);
    }
});
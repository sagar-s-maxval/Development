({
    doInit : function(component, event, helper) {
        helper.initialize(component, helper);
    },

    handleRowAction: function (component, event, helper) {
        let action = event.getParam('action');
        let row = event.getParam('row');
        helper.changeDocumentType(component, action, row);
    },

    handleCellChangeAction: function (component, event, helper) {
        let draftValues = component.find("docTable").get("v.draftValues");
        helper.saveEdition(component, draftValues);
    },

    updateSelectedRows: function(component, event, helper) {
        let selectedRows = event.getParam('selectedRows');
        helper.activateDocuments(component, selectedRows);
    }
})
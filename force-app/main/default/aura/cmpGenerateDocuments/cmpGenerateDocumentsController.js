({
    doInit: function (component, event, helper) {
        helper.checkIfAllowed(component, helper);
        let action = component.get("c.getListViewId");
        action.setParams({
            "listViewName": component.get("v.viewListLabel")
        });


        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let base = '/lightning/o/SDOC__SDTemplate__c/list?filterName=';
                component.set("v.viewListLink", base + response.getReturnValue());
            } else {
                let error = response.getError();
                console.log('error in doInit cmpGenerateDocuments', error);
            }
        });
        $A.enqueueAction(action);
    },

    updateSelectedRows: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedSDocsAgreements', selectedRows);
    },

    generateDocument: function (component, event, helper) {
        helper.generateDocument(component);
    },
});
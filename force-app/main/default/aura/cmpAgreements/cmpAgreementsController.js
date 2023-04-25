({
    doInit: function(component, event, helper) {
        component.set('v.columns', [
            {label: 'Template name', fieldName: 'name', type: 'text'},
            {label: 'Preview Link', fieldName: 'link', type: 'url', typeAttributes: { target: '_blank', label : 'Preview/Edit'}},
        ]);
        helper.fetchData(component);
    },

    updateSelectedRows: function(component, event, helper){
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedTemplates', selectedRows);
    },

    generateDocuments: function(component, event, helper) {
        var action = component.get('c.generateSDocs');
        action.setParams({
            'IdfRecord' : component.get('v.recordId'),
            'selectedTemplates' : component.get('v.selectedTemplates')
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The documents are getting generated!"
                });
                toastEvent.fire();
                console.log('--generated successfully-- ');
            }else{
                var error = response.getError();
                console.log('--error-- ', error);
            }
        });

        $A.enqueueAction(action);
    }
});
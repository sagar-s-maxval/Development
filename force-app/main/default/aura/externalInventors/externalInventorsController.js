({
    doInit: function(component, event, helper) {
        helper.loadInventors(component, event, helper);
        component.set('v.columns', [
                    {
                        type: 'button-icon',
                        initialWidth: 10,
                        typeAttributes:
                        {
                            iconName: 'utility:delete',
                            name: 'delete',
                            iconPosition: 'left'
                        },
                        cellAttributes: { alignment: 'center' }
                    },
                    {label: 'Name', fieldName: 'Name', type: 'text'},
                    {label: 'Email Address', fieldName: 'SymphonyIPM__Email__c', type: 'email'},
                    {label: 'Comments', fieldName: 'External_Comments__c', type: 'text'},
                ]);
    },

    addInventor: function (component, event, helper) {
        let email = component.get('v.email');
        let primaryInventorEmail = component.get('v.primaryInventor');
        let coInventors = component.get('v.coInventorEmails');
        let inventors = component.get('v.inventorsCreated');
        let success = email.toLowerCase()
            .match(
                /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
            );
        if (success) {
            if (email.includes('thermofisher.com') || email.includes('ppd.com')) {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": "Please add Thermo Fisher Scientific employees to the Co-Inventors field above."
                });
                toastEvent.fire();
            } else {
                if (inventors.find(i => i.SymphonyIPM__Email__c === email) || primaryInventorEmail === email || coInventors.find(i => i.SymphonyIPM__Email__c === email)) {
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Selected Inventor already exist."
                    });
                    toastEvent.fire();
                } else  {
                    helper.createExternalInventor(component, event, helper);
                }
            }
        } else {
            component.set('v.invalidEmail', true);
        }
    },

    onToggleChange: function (component, event, helper) {
        if (!component.get('v.isExternalInventor')) {
            if (component.get('v.idfId')) {
                helper.deleteAllExternals(component, event, helper);
                component.set('v.isError', false);
            } else {
                component.set('v.inventors', []);
                component.set('v.inventorsCreated', []);
            }
        }
    },

    deleteRecord: function(component, event, helper) {
        let inventorId = event.getParam('row').Id;

        helper.deleteInventor(component, event, helper, inventorId);
    },
});
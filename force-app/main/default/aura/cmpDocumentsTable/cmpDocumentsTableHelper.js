({
    showApexError: function (helper, errors) {
        if (!errors || !errors.length) {
            return;
        }

        for (let i = 0; i < errors.length; ++i) {
            if (errors[i].message) {
                helper.showToast('error', errors[i].message);
                return;
            }

            if (!errors[i].pageErrors || !errors[i].pageErrors.length) {
                continue;
            }

            helper.showToast('error', errors[i].pageErrors[0].message);
            return;
        }
    },

    showToast: function (type, message) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type[0].toUpperCase() + type.substring(1).toLowerCase(),
            "message": message
        });

        toastEvent.fire();
    },

    getAllDocuments : function(component, event, helper) {
        let action = component.get('c.getAllDocuments');
        let recordId = component.get('v.IDF');
        let params = {
            recordId : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result) {
                    component.set('v.date1', result.Purchase_of_Rights_Sent_Date__c);
                    component.set('v.date2', result.Utilization_Declaration_Sent_Date__c);
                    component.set('v.date3', result.Remuneration_Agreement_Sent_Date__c);

                    let idfs = component.get('v.inventionDisclosure');
                    idfs.push(result);
                    component.set('v.inventionDisclosure', idfs);
                }

            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    updateDocuments : function(component, event, helper) {
        let action = component.get('c.updateDocuments');

        let documents = component.get('v.documents');
        let idf = component.get('v.IDF');
        let userId = $A.get("$SObjectType.CurrentUser.Id");

        let params = {
            recordId : idf,
            date1 : component.get('v.date1'),
            date2 : component.get('v.date2'),
            date3 : component.get('v.date3')
        };
        console.log('PARAMS: ' + JSON.stringify(params));

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Documents Update",
                    "message": "Documents information was successfully updated."
                });

                toastEvent.fire();
                component.set('v.canUserAdd', false);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },
});
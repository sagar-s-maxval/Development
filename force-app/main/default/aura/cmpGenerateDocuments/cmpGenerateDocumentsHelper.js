({
    checkIfAllowed: function (component, helper) {
        let action = component.get('c.checkIfDocuSignIsAllowed');
        action.setParams({
            'idfId': component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log('--result-- ', result);
                component.set('v.isAllowed', result);
                if (result) {
                    helper.fetchSDocsAgreements(component);
                }
            } else {
                let error = response.getError();
                console.log('error-- ', error);
            }
        });

        $A.enqueueAction(action);
    },

    fetchSDocsAgreements: function (component) {
        component.set('v.columns', [
            {label: 'Template Name', fieldName: 'name', type: 'text'},
        ]);

        let action = component.get("v.isPatent") ? component.get('c.getSDocsPatentTemplates') : component.get('c.getSDocsIDFTemplates');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log('--fetchSDocsAgreements-- ', result);
                component.set('v.availableSDocsAgreements', result);
            } else {
                let error = response.getError();
                console.log('error-- ', error);
            }
        });

        $A.enqueueAction(action);
    },

    generateDocument: function (component) {
        component.set('v.isButtonDisabled', true);
        let selectedSDocsAgreements = component.get('v.selectedSDocsAgreements');
        console.log(selectedSDocsAgreements);
        let action = component.get('c.generateDocumentFromTemplate');
        action.setParams({
            'recordId': component.get('v.recordId'),
            'selectedSDocsAgreements': selectedSDocsAgreements,
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                let result = response.getReturnValue();
                component.set('v.selectedSDocsAgreements', []);

                console.log('result', result);

                let toastEvent = $A.get("e.force:showToast");
                if (result === 'Success') {
                    toastEvent.setParams({
                        "title": "Success",
                        "message": "Documents are getting generated. It may take a few moments.",
                        "type": "success"
                    });
                } else {
                    toastEvent.setParams({
                        "title": "Error",
                        "message": result,
                        "type": "error"
                    });
                }
                toastEvent.fire();
                component.set('v.isButtonDisabled', false);
                // setTimeout(window.location.reload(), 5000);
            } else if (state === "ERROR") {
                let errors = response.getError();
                console.error(errors);
                component.set('v.isButtonDisabled', false);
            }
        });

        $A.enqueueAction(action);
    },
});
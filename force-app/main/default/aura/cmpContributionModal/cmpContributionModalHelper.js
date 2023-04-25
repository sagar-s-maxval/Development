({
    setColumns: function (component) {
        component.set('v.columns', [{
                label: 'Inventor Name',
                fieldName: 'SymphonyIPM__Inventor_Name__c',
                type: 'text'
            },
            {
                label: 'Email Address',
                fieldName: 'SymphonyIPM__Inventor_Email__c',
                type: 'email'
            },
            {
                label: 'Contribution %',
                fieldName: 'Contribution__c',
                type: 'number',
                editable: true,
                typeAttributes: {
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 2
                }
            }
        ]);
    },

    doInitHelper: function (component, event, helper) {
        let action = component.get('c.checkIfThereAreEligibleInventors');
        let recordId = component.get('v.recordId');
        let params = {
            inventionDisclosureId: recordId
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            console.log(JSON.stringify(response));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result) {
                    helper.loadData(component, event, helper);
                    helper.setColumns(component);
                }
                component.set('v.showModal1', result);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    loadData: function (component, event, helper) {
        let action = component.get('c.getIDInventors');
        let recordId = component.get('v.recordId');
        let params = {
            inventionDisclosureId: recordId
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.data', result);
                let sum = 0;
                result.forEach(elem => sum += (elem.Contribution__c * 1));
                if (sum !== 100) {
                    sum = Math.round((sum + Number.EPSILON) * 100) / 100;
                }
                component.set('v.totalContribution', sum);
                if (sum > 100 && component.get('v.showToast')) {
                    helper.showToast('warning', 'Contribution is more than 100.');
                }
                if (sum >= 0 && sum < 100 && component.get('v.showToast')) {
                    helper.showToast('warning', 'Total contribution is less than 100.')
                }
                component.set('v.showToast', true);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

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

    saveContributions: function (component, event, helper) {
        let action = component.get('c.updateContributions');
        let data = component.find("contrTable").get("v.draftValues");
        let sum = 0;
        data.forEach(elem => sum += (elem.Contribution__c * 1));
        console.log(sum);
        if (sum < 0) {
            helper.showToast('error', 'Contributions cannot be less than 0.');
            return;
        }

        let params = {
            data: data
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            console.log(JSON.stringify(response.getReturnValue()));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                helper.doInitHelper(component, event, helper);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    countTotalContribution : function(component, event, helper) {
        let data = component.find("contrTable").get("v.draftValues");
        let sum = 0;
        data.forEach(elem => sum += (elem.Contribution__c * 1));
        if (sum !== 100) {
            sum = Math.round((sum + Number.EPSILON) * 100) / 100;
        }
        component.set('v.totalContribution', sum);
    }
    
});
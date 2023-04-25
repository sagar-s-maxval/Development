({
    makeApexCall : function(component, event, helper) {
        let action = component.get('c.getRemunerations');
        let recordId = component.get('v.IDF');
        let userId = $A.get("$SObjectType.CurrentUser.Id");

        let params = {
            inventionDisclosureId : recordId,
            userId : userId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(JSON.stringify(response));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                helper.populateLists(component, event, helper, result);
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

    populateLists : function(component, event, helper, value)  {
        let contributions = [];
        let i = 0;
        value.forEach(remuneration => contributions.push({
            serialNumber: ++i,
            fullName: remuneration.Inventor_Full_Name__c,
            contribution: remuneration.Contribution__c,
            submitted: remuneration.Is_Submitted__c
        }));

        let selectedInventors = [];
        value.forEach(remuneration => selectedInventors.push(remuneration.Inventor_Full_Name__c));
        component.set('v.selectedInventorsNames', selectedInventors);
        component.set('v.serialNumber', i);

        let totalContribution = 0;
        value.forEach(remuneration => totalContribution += remuneration.Contribution__c);

        component.set('v.contributions', contributions);
        component.set('v.selectedInventors', value);
        component.set('v.totalContribution', totalContribution);
    },

    getDefaultRemuneration : function(component, event, helper) {
        let action = component.get('c.countRemuneration');
        let recordId = component.get('v.IDF');
        let params = {
            inventionDisclosureId : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.contribution', result);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getAllInventors : function(component, event, helper) {
        let selectedInventors = component.get('v.selectedInventorsNames');


        let action = component.get('c.getInventorsForRemuneration');
        let recordId = component.get('v.IDF');
        let params = {
            idf : recordId,
            selectedInventors : selectedInventors
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let contributions = [];
                let i = component.get('v.serialNumber');
                result.forEach(inventor => contributions.push({
                    serialNumber: ++i,
                    fullName: inventor.SymphonyIPM__Inventor_Name__c,
                    contribution: 'not filled yet'
                }));
                component.set('v.additionalInventors', contributions);
                component.set('v.serialNumber', ++i);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },
});
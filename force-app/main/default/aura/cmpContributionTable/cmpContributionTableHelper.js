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

    getMaximumRemuneration : function(component, event, helper) {
        let action = component.get('c.getMaximumAllowedContribution');
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let recordId = component.get('v.IDF');
        let params = {
            inventionDisclosureId : recordId,
            userId : userId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.maxAllowedContribution', result);
            } else {
                let errors = response.getError();
                console.log('THROWS ERROR 1');
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
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
                console.log('THROWS ERROR 2');
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getAllInventors : function(component, event, helper) {
        let action = component.get('c.getAllInventorsForRemuneration');
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let recordId = component.get('v.IDF');
        let params = {
            idf : recordId,
            userId : userId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let contributions = [];
                let i = 0;
                result.forEach(inventor => contributions.push({
                    serialNumber: ++i,
                    fullName: inventor.SymphonyIPM__Inventor_Name__c,
                    contribution: inventor.Contribution__c
                }));
                let totalContribution = 0;
                result.forEach(inventor => totalContribution += (inventor.Contribution__c * 1));
                component.set('v.additionalInventors', contributions);
                component.set('v.totalContribution', totalContribution.toFixed(2));
                component.set('v.serialNumber', ++i);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getCurrentInventor : function(component, event, helper) {
            let action = component.get('c.getCurrentInventorForRemuneration');
            let userId = $A.get("$SObjectType.CurrentUser.Id");
            let recordId = component.get('v.IDF');
            let params = {
                idf : recordId,
                userId : userId
            };

            action.setParams(params);

            action.setCallback(this, function(response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let result = response.getReturnValue();
                    if (result) {
                        component.set('v.contribution', result.Contribution__c);
                        component.set('v.inventorName', result.SymphonyIPM__Inventor_Name__c);
                        if (component.get('v.contribution') === 0.00) {
                            helper.splitContribution(component, event, helper);
                            component.set('v.split', true);
                        }
                        helper.getMaximumRemuneration(component, event, helper);
                    } else {
                        component.set('v.contribution', 0);
                        component.set('v.canUserAdd', false);
                    }
                } else {
                    let errors = response.getError();
                    helper.showApexError(helper, errors);
                }
            });

            $A.enqueueAction(action);
        },

    updateContribution : function(component, event, helper) {
        let action = component.get('c.updateContribution');

        let contribution = component.get('v.contribution');
        let idf = component.get('v.IDF');
        let userId = $A.get("$SObjectType.CurrentUser.Id");

        let params = {
            idf : idf,
            userId : userId,
            contribution : contribution
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Contribution Update",
                    "message": "Your contribution was successfully added."
                });

                toastEvent.fire();
                helper.getAllInventors(component, event, helper);
                helper.getCurrentInventor(component, event, helper);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    updateSplitContribution : function(component, event, helper) {
        let action = component.get('c.updateSplitContribution');

        let contribution = component.get('v.contribution');
        let idf = component.get('v.IDF');

        let params = {
            idf : idf,
            contribution : contribution
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "title": "Contribution Update",
                    "message": "Contribution was successfully split."
                });

                toastEvent.fire();
                helper.getAllInventors(component, event, helper);
                helper.getCurrentInventor(component, event, helper);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    splitContribution : function(component, event, helper) {
        if (component.get('v.split')) {
            helper.getDefaultRemuneration(component, event, helper);
        } else {
            component.set('v.contribution', 0);
        }
    }
});
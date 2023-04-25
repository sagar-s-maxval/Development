({
    makeApexCall: function(component, event, helper) {
        let action = component.get('c.getAdditionalInventors');
        let recordId = component.get('v.IDF');
        let primaryInventorId = component.get('v.primaryInventor');

        let params = {
            idf: recordId,
            primaryInventorId: primaryInventorId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let ids = result.map(record => record.Id).join(',');
                component.set('v.coInventors', ids);
                console.log('COINVENTORS 1 ' + ids);
                component.set('v.coInvLoaded', true);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getGroupDivisionBU: function(component, event, helper) {
        let action = component.get('c.getDivisionBUGroup');
        let primaryInventorId = component.get('v.primaryInventor');

        let params = {
            inventorId: primaryInventorId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log('____________________');
                console.log(JSON.stringify(result));
                if (result.Group_Formula__c) {
                    component.set('v.Group', result.Group_Formula__c);
                }
                if (result.Division_Formula__c) {
                    component.set('v.Division', result.Division_Formula__c);
                }

                helper.setDivisionPicklistDependentValues(component);
                helper.setBusinessUnitPicklistDependentValues(component);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getPicklistsValues: function(component, event, helper) {
        let action = component.get('c.getPickListValuesIntoList');
        action.setParams({});

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();

                component.set('v.groupValues', result['Group__c']);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    showApexError: function(helper, errors) {
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

    showToast: function(type, message) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type[0].toUpperCase() + type.substring(1).toLowerCase(),
            "message": message
        });

        toastEvent.fire();
    },

    getTitle: function(component, event, helper) {
        let action = component.get('c.getTitle');
        let idf = component.get('v.IDF');

        let params = {
            idf: idf
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.titleName', result);
                component.set('v.title', result);
            } else {
                helper.showApexError(helper, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    setBusinessUnitPicklistDependentValues : function(component, helper){
        let division = component.get('v.Division');
        let action = component.get('c.getBUPicklistValues');
        action.setParams({
            'division' : division
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.businessUnitValues', result);
            } else {
                helper.showApexError(helper, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    setDivisionPicklistDependentValues : function(component, helper){
        let group = component.get('v.Group');
        let action = component.get('c.getDivisionPicklistValues');
        action.setParams({
            'sel_group' : group
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log('==result==', result);
                component.set('v.divisionValues', result);
            } else {
                helper.showApexError(helper, response.getError());
            }
        });

        $A.enqueueAction(action);
    },

    loadInitialPicklistValues : function(component, helper, idfRecordId){
        let action = component.get('c.getInitPicklistValues');
        action.setParams({
            'idf' : idfRecordId
        });

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result.Group_Formula__c) {
                    component.set('v.Group', result.Group_Formula__c);
                }
                if (result.Division_Formula__c) {
                    component.set('v.Division', result.Division_Formula__c);
                }
                if (result.SymphonyIPM__Hierarchy__r.Business_Unit__c) {
                    component.set('v.BusinessUnit', result.SymphonyIPM__Hierarchy__r.Business_Unit__c);
                }
                
                helper.setDivisionPicklistDependentValues(component, helper);
                helper.setBusinessUnitPicklistDependentValues(component, helper);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    }
});
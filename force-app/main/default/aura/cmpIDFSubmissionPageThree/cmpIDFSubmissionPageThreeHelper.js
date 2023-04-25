({
    makeApexCall : function(component, event, helper) {
        let action = component.get('c.getIDF');
        let recordId = component.get('v.IDF');
        let params = {
            idf : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(JSON.stringify(response));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                console.log(JSON.stringify(result));
                helper.populateData(component, event, helper, result);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getPicklistsValues : function(component, event, helper) {
        let action = component.get('c.getPicklistValues');
        let params = {};

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(JSON.stringify(response));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let plValues = [];
                result.forEach(
                    pv => plValues.push(
                        {
                            label: pv,
                            value: pv
                        }
                    )
                );
                component.set("v.categories", plValues);
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

    populateData: function(component, event, helper, data) {
        component.set('v.q7answer', data.Question_7__c);
        component.set('v.q8answer', data.Question_8__c);
        component.set('v.q10answer', data.Question_10__c);
        component.set('v.q11answer', data.Question_11__c);
        component.set('v.q12answer', data.Question_12__c);
        component.set('v.q13answer', data.Question_13__c);
        component.set('v.q14answer', data.Question_14__c);
        component.set('v.q15answer', data.Question_15__c);
        component.set('v.q16answer', data.Question_16__c);
        component.set('v.q17answer', data.Question_17__c);

        if(data.Invention_Category__c) {
            let q9 = data.Invention_Category__c.split(';').map(elem => ({label: elem, name:elem}));
            component.set('v.q9', q9);
            component.set('v.q9String', data.Invention_Category__c);
            if(data.Invention_Category__c.includes('Other')) {
                component.set('v.otherComment', data.Other_Comments__c);
                component.set('v.showOther', true);
            }

            component.set('v.categories', component.get('v.categories').filter(elem => !data.Invention_Category__c.includes(elem.label)));
        }

        component.set('v.q7', data.Question_7_Radio__c);
        component.set('v.q8', data.Question_8_Radio__c);
        component.set('v.q10', data.Question_10_Radio__c);
        component.set('v.q12', data.Question_12_Radio__c);
        component.set('v.q14', data.Question_14_Radio__c);
        component.set('v.q15', data.Question_15_Radio__c);
        component.set('v.q16', data.Question_16_Radio__c);
        component.set('v.q17', data.Question_17_Radio__c);
        component.set('v.myIdeas', data.MyIdea_ID_s__c);

        component.set('v.q6', data.Has_the_invention_already_been_tested__c);
        component.set('v.q6answer', data.What_is_the_result__c);
    }
});
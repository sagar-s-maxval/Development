({
    makeApexCall : function(component, event, helper) {
        let action = component.get('c.getIDF');
        let recordId = component.get('v.IDF');
        let params = {
            idf : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            console.log("response", response.getReturnValue())
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
        console.log('data.Technical_field_of_invention__c', data.Technical_field_of_invention__c);
        component.set('v.q1', data.Technical_field_of_invention__c || '');
        component.set('v.q2', data.Question_2__c || '');
        component.set('v.q3', data.Question_3__c || '');
        component.set('v.q4', data.Question_4__c);
        component.set('v.q5', data.Question_5__c);
        component.set('v.q6', data.Question_6__c || '');

        component.set('v.q2a', data.Question_2a__c || '');
        component.set('v.q2b', data.Question_2b__c || '');
        component.set('v.q2c', data.Question_2c__c || '');
        component.set('v.q2d', data.Question_2d__c || '');
    },

    removeHTML: function (str){
        var tmp = document.createElement("DIV");
        tmp.innerHTML = str;
        return tmp.textContent || tmp.innerText || "";
    }
});
({
    checkuseraccess : function(component, event, helper) {
        let action = component.get('c.checkuseraccess');
        let recordId = component.get('v.IDF');
        //console.log('IDF id-->'+component.get('v.IDF'));
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let params = {
            idfid : recordId
         };
       action.setParams(params);
       action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
               //  console.log('Rating permission coming as'+result);
               console.log('User has Role'+result);
                component.set('v.UserhasRole', result);
                
            } else {
                let errors = response.getError();
               helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },
    makeApexCall : function(component, event, helper) {
        let action = component.get('c.getReview');
        let recordId = component.get('v.IDF');
        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let params = {
            inventionDisclosureId : recordId,
            userId : userId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.review', result);
                if (result) {
                    let reviews = [];
                    reviews.push(result);
                    component.set('v.reviews', reviews);
                } else {
                    component.set('v.showMessage', true);
                }
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getRecommendations: function (component, event, helper) {
        let action = component.get('c.getRecommendationOptions');
        action.setParams({});
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.recommendations', result);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getStatusAllowance: function(component, event, helper) {
        let action = component.get('c.getStatusAllowance');
        let params = {
            status : component.get('v.status')
        };

        action.setParams(params);
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                 console.log('Rating permission coming as'+ component.get('v.status'));
                console.log('Rating permission coming as'+result);
                component.set('v.allowAddRating', result);
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
});
({
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
            console.log(JSON.stringify(response));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result) {
                    component.set('v.q1', result.How_novel_is_the_invention__c);
                    component.set('v.q2', result.Does_the_invention_solve_problem__c);
                    component.set('v.q3', result.Does_the_invention_achieve_results__c);
                    component.set('v.q4', result.Does_the_invention_represent_technology__c);
                    component.set('v.q5', result.Is_it_likely_competitors_will_practice__c);
                    component.set('v.q6', result.Does_the_invention_have_applicability__c);
                    component.set('v.q7', result.Business_value_of_the_invention__c);
                    component.set('v.q8', result.How_difficult_will_it_be_to_design__c);
                    component.set('v.q9', result.How_difficult_will_it_be_to_detect_use__c);
                    component.set('v.q10', result.Likelihood_that_invention_implementable__c);
                    component.set('v.q11', result.Recommendations__c);
                    component.set('v.comments', result.SymphonyIPM__Review_Comments__c);
                    component.set('v.reviewId', result.Id);
                }
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getRecommendationOptions: function (component, event, helper) {
        let action = component.get('c.getRecommendationOptions');
        action.setParams({});
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.recommendationOptions', result);
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
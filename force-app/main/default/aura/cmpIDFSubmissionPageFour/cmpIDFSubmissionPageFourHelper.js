({
    makeApexCall : function(component, event, helper) {
        let action = component.get('c.getRemuneration');
        let recordId = component.get('v.IDF');
        let userId = component.get('v.userId');
        let params = {
            userId : userId,
            inventionDisclosureId : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();

                if (result.Inventor_Full_Name__c) {
                    component.set('v.qa', result.Inventor_Full_Name__c);
                }
                component.set('v.remId', result.Id);
                component.set('v.qb', result.Question_b__c);
                component.set('v.qc', result.Question_c__c);
                component.set('v.qd', result.Question_d__c);
                component.set('v.qe', result.Question_e__c);
                component.set('v.qf', result.Question_f__c);
                component.set('v.qg', result.Question_g__c);
                if (result.Contribution__c) {
                    component.set('v.contribution', result.Contribution__c);
                }
                component.set('v.qdRadio', result.Question_d_Radio__c);
                component.set('v.qeRadio', result.Question_e_Radio__c);
                component.set('v.qfRadio', result.Question_f_Radio__c);
                component.set('v.comments', result.Comments__c);
                component.set('v.qhCalculations', result.Is_Calculations_Simulations__c);
                component.set('v.qhComputer', result.Is_Computer_Software__c);
                component.set('v.qhDesigns', result.Is_Designs_Planning__c);
                component.set('v.qhEvaluations', result.Is_Evaluation_Test__c);
                component.set('v.qhLaboratory', result.Is_Laboratory_Equipment__c);
                component.set('v.qhMaterials', result.Is_Materials_Prototypes__c);
                component.set('v.optionBestSuited', result.Option_that_is_best_suited__c);
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

    getReceivedResponses : function(component, event, helper) {
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
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.data', result);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getMaxAllowedContribution : function(component, event, helper) {
        let action = component.get('c.getMaximumAllowedContribution');
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
                component.set('v.maxContributionAllowed', result);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    setColumns : function(component) {
        component.set('v.columns', [{
                label: 'Inventor Name',
                fieldName: 'Inventor_Full_Name__c',
                type: 'text',
                wrapText: true,
                initialWidth: 300
            },
            {
                label: 'Is the invention in your field of work?',
                fieldName: 'Question_b__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'What training did you have and what was your job function when you made the invention?',
                fieldName: 'Question_c__c',
                type: 'text',
                wrapText: true,
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Was the problem defined by instructions from your superiors?',
                fieldName: 'Question_d_Radio__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'What information did the instructions contain?',
                fieldName: 'Question_d__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Was the company already aware of the problem?',
                fieldName: 'Question_e_Radio__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Which sources provided you with the information?',
                fieldName: 'Question_e__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Did you become aware of the deficiency or the requirement yourself?',
                fieldName: 'Question_f_Radio__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Which deficiency or requirement did you determine yourself?',
                fieldName: 'Question_f__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Briefly explain your share in the invention.',
                fieldName: 'Question_g__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Laboratory equipment',
                fieldName: 'Is_Laboratory_Equipment__c',
                type: 'boolean',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Computer / software',
                fieldName: 'Is_Computer_Software__c',
                type: 'boolean',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Materials / prototypes',
                fieldName: 'Is_Materials_Prototypes__c',
                type: 'boolean',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Designs / planning',
                fieldName: 'Is_Designs_Planning__c',
                type: 'boolean',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Calculations / simulations',
                fieldName: 'Is_Calculations_Simulations__c',
                type: 'boolean',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Evaluations / test',
                fieldName: 'Is_Evaluation_Test__c',
                type: 'boolean',
                initialWidth: 300,
                wrapText: true
            },
            {
                label: 'Comments',
                fieldName: 'Comments__c',
                type: 'text',
                initialWidth: 300,
                wrapText: true
            },
        ]);
    }
});
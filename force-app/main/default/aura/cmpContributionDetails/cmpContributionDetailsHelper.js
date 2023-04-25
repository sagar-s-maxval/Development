({
    populateColumns: function (component) {
        component.set('v.columns', [{
                label: 'Inventor Name',
                fieldName: 'Inventor_Full_Name__c',
                type: 'text',
                wrapText: true
            },
            {
                label: 'Contribution',
                fieldName: 'Contribution__c',
                type: 'number'
            },
            {
                label: 'User',
                fieldName: 'User__c',
                type: 'text'
            },
            {
                label: 'Is the invention in your field of work?',
                fieldName: 'Question_b__c',
                type: 'boolean'
            },
            {
                label: 'What training did you have and what was your job function when you made the invention?',
                fieldName: 'Question_c__c',
                type: 'text'
            },
            {
                label: 'Was the problem defined by instructions from your superiors?',
                fieldName: 'Question_d_Radio__c',
                type: 'text'
            },
            {
                label: 'Was the company already aware of the problem?',
                fieldName: 'Question_e_Radio__c',
                type: 'text'
            },
            {
                label: 'Did you become aware of the deficiency or the requirement yourself?',
                fieldName: 'Question_f_Radio__c',
                type: 'text'
            },
            {
                label: 'Briefly explain your share in the invention',
                fieldName: 'Question_g__c',
                type: 'text'
            },
            {
                label: 'Comments',
                fieldName: 'Comments__c',
                type: 'text',
                wrapText: true
            },
            {
                label: 'Calculations / simulations',
                fieldName: 'Is_Calculations_Simulations__c',
                type: 'text'
            },
            {
                label: 'Computer / software',
                fieldName: 'Is_Computer_Software__c',
                type: 'text'
            },
            {
                label: 'Designs / planning',
                fieldName: 'Is_Designs_Planning__c',
                type: 'text'
            },
            {
                label: 'Evaluations / test',
                fieldName: 'Is_Evaluation_Test__c',
                type: 'text'
            },
            {
                label: 'Laboratory equipment',
                fieldName: 'Is_Laboratory_Equipment__c',
                type: 'text'
            },
            {
                label: 'Materials / prototypes',
                fieldName: 'Is_Materials_Prototypes__c',
                type: 'text'
            },
            {
                label: 'Option that is best suited based on your contribution to the invention',
                fieldName: 'Option_that_is_best_suited__c',
                type: 'text'
            }
        ]);
    },

    makeApexCall: function (component, event, helper, ids) {
        let action = component.get('c.getRemunerations');
        let params = {
            inventionDisclosureId: component.get('v.recordId'),
            userId: null
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
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
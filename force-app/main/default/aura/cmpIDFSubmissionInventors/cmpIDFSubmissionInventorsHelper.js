({

    doInitHelper: function (component, event, helper) {
        let inventors = [];
        let primaryInventorId = component.get('v.primaryInventor');
        let coInventorsIds = component.get('v.coInventors');

        if (primaryInventorId) {
            inventors.push(primaryInventorId);
        }
        if (coInventorsIds) {
            if (coInventorsIds.includes(',')) {
                coInventorsIds = coInventorsIds.split(',');
                while (coInventorsIds.indexOf('') >= 0) {
                    coInventorsIds.splice(coInventorsIds.indexOf(''), 1);
                }
                inventors.push(...coInventorsIds);
            } else {
                inventors.push(coInventorsIds);
            }
        }

        helper.makeApexCall(component, event, helper, inventors);
        helper.setColumns(component);
    },

    makeApexCall: function (component, event, helper, ids) {
        let action = component.get('c.getInventorsList');
        let params = {
            inventorsIDs: ids
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let indexOfPrimary = result.findIndex(elem => elem.Id === ids[0]);

                let primaryInventor = result.splice(indexOfPrimary, 1);
                let data = [];
                if (primaryInventor) {
                    data = data.concat(primaryInventor);
                }
                if (result) {
                    data = data.concat(result);
                }
                component.set('v.coInventorList', result);
                component.set('v.data', data);
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

    setColumns: function (component) {
        component.set('v.columns', [
                    {
                        type: 'button-icon',
                        initialWidth: 10,
                        typeAttributes:
                        {
                            iconName: 'utility:delete',
                            name: 'delete',
                            iconPosition: 'left'
                        }
                    },
            {
                label: 'Name',
                fieldName: 'Name',
                type: 'text'
            },
            {
                label: 'Employer Country',
                fieldName: 'SymphonyIPM__Location__c',
                type: 'text'
            },
            {
                label: 'Nationality/Citizenship	',
                fieldName: 'SymphonyIPM__CitizenshipPicklist__c',
                type: 'text'
            },
            {
                label: 'Phone Number (work)',
                fieldName: 'PhoneNumber__c',
                type: 'phone'
            },
            {
                label: 'Email Address (work)',
                fieldName: 'SymphonyIPM__Email__c',
                type: 'email'
            },
            {
                label: 'Employer Name',
                fieldName: 'EmployerName__c',
                type: 'text'
            },
            {
                label: 'Employer Address',
                fieldName: 'EmployerAddress__c',
                type: 'text'
            }
        ]);
    }
});
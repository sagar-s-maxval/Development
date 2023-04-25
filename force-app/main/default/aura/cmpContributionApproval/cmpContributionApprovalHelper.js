({
    getIDInventors : function(component, event, helper) {
        let action = component.get('c.getIDInventorsApproving');
        let recordId = component.get('v.recordId');
        let params = {
            inventionDisclosureId: recordId
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let index = 0;
                let userData = [result[0]];
                result = result.filter(elem => elem.Id !== userData[0].Id);

                result.forEach(elem => elem['SerialNumber'] = ++index);
                result.forEach(elem =>  elem['Is_Contribution_Approved__c'] = '');
                component.set('v.data', result);
                userData.forEach(elem => elem['SerialNumber'] = ++index);
                userData.forEach(elem =>  elem['actionLabel'] = elem.Is_Contribution_Approved__c ? 'Confirmed' : 'Confirm' );
                userData.forEach(elem =>  elem['actionVariant'] = elem.Is_Contribution_Approved__c ? 'brand' : 'neutral' );
                userData.forEach(elem =>  elem['isEditable'] = elem.Is_Contribution_Approved__c ? false : true );
                userData.forEach(elem => elem['rowIcon'] = elem.Is_Contribution_Approved__c ? 'utility:check' : '')

                component.set('v.dataUser', userData);
                component.set('v.isApproved', userData.length > 0 && userData[0].Is_Contribution_Approved__c);
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    setColumns: function (component) {
        component.set('v.columns', [{
                label: 'Serial Number',
                fieldName: 'SerialNumber',
                type: 'text',
                initialWidth: 150
            },
            {
                label: 'Name',
                fieldName: 'SymphonyIPM__Inventor_Name__c',
                type: 'text',
                initialWidth: 400
            },
            {
                label: 'Contribution Percentage',
                fieldName: 'Contribution__c',
                type: 'number'
            }
        ]);
        component.set('v.columnsUser', [
            {
                label: 'Name',
                fieldName: 'SymphonyIPM__Inventor_Name__c',
                type: 'text'
            },
            {
                label: 'Contribution Percentage',
                fieldName: 'Contribution__c',
                type: 'number',
                editable: { fieldName: 'isEditable'},
                typeAttributes: {
                    minimumFractionDigits: 0,
                    maximumFractionDigits: 2
                },
                cellAttributes: {
                     alignment: 'center'
                }
            },
            {
                label: 'Approve',
                fieldName: 'Is_Contribution_Approved__c',
                type: 'button',
                typeAttributes: {
                    label: { fieldName: 'actionLabel'},
                    name: 'Approve',
                    variant: { fieldName: 'actionVariant'},
                    title: 'Click to Approve',
                    iconName: { fieldName: 'rowIcon' },
                    disabled: {fieldName: 'Is_Contribution_Approved__c'}
                },
                cellAttributes: {
                     alignment: 'center'
                }
            }
        ]);
    },

    updateRecord: function(component, recordId, isApproved) {
        let action = component.get('c.updateIDInventors');
        let params = {
            recordId: recordId,
            isApproved: isApproved
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                $A.get('e.force:refreshView').fire();
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    saveContributions: function (component, event, helper) {
        let action = component.get('c.updateContributions');
        let data = component.find("contrTable").get("v.draftValues");
        let sum = 0;
        data.forEach(elem => sum += (elem.Contribution__c * 1));
        console.log(sum);
        if (sum < 0) {
            helper.showToast('error', 'Contributions cannot be less than 0.');
            return;
        }

        let params = {
            data: data
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            console.log(JSON.stringify(response.getReturnValue()));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                helper.doInitHelper(component, event, helper);
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
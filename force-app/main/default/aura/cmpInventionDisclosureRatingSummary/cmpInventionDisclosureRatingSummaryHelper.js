({
    makeApexCall : function(component, event, helper) {
        let action = component.get('c.getReviews');
        let recordId = component.get('{!v.pageReference.state.c__recordId}');
        component.set('v.IDF', recordId);
        let params = {
            inventionDisclosureId : recordId
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            console.log(JSON.stringify(response));
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.reviews', result);
                console.log(JSON.stringify(result));
                let columns = [
                    {
                        label: '',
                        initialWidth: 200,
                        fieldName: 'header',
                        type: 'text',
                        cellAttributes: { alignment: 'center' }
                    }
                ];
                for (let i = 0; i < result.length; i++) {
                    columns.push({
                        label: '',
                        initialWidth: 250,
                        fieldName: 'col' + i,
                        type: 'text',
                        cellAttributes: { alignment: 'center' }
                    });
                }
                component.set('v.columns', columns);

            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },

    getDocketNumber: function(component, event, helper) {
        let action = component.get('c.getDocketNumber');
        let params = {
            recordId: component.get('v.IDF')
        };

        action.setParams(params);

        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                component.set('v.docketNumber', result.Name);
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
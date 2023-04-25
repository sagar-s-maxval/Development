({
    makeApexCall: function (component, event, helper, ids) {
        let action = component.get('c.fetchPicklist');
        let params = {
            idf: component.get('v.IDF')
        };

        action.setParams(params);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let documents = ['Utilization Declaration', 'Purchase of Rights Agreement', 'Remuneration Agreement'];
                let documentsToShow = [];
                if (result) {
                    documents.forEach(doc => {
                        if (!result.includes(doc)) {
                            documentsToShow.push(doc);
                        }
                    })
                } else {
                    documentsToShow = documents;
                }

                if (documentsToShow.length === 0) {
                    component.set('v.selectedEmail', '');
                    let navigate = component.get('v.navigateFlow');
                    navigate('NEXT');
                } else {
                    component.set('v.emails', documentsToShow);
                }
            } else {
                let errors = response.getError();
                helper.showApexError(helper, errors);
            }
        });

        $A.enqueueAction(action);
    },
});
({
    searchInventorsHelper: function(component, txtSearchWord, arrSelectedInvIds) {
        let action = component.get('c.searchInventors');
        action.setParams({
            searchWord: txtSearchWord,
            InvIds: arrSelectedInvIds
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();
                    
                    if (state === "SUCCESS") {
                        if (result.length > 0) {
                            component.set('v.isShowSearchResult', true);
                            component.find("lstAvailableInventors").set("v.options", result);
                        } else {
                            component.set('v.isShowSearchResult', false);
                        }
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },

    getSelectedInventorsHelper: function(component, helper, arrSelectedInvIds) {
        console.log('arrSelectedInvIds: ' + arrSelectedInvIds)
        let primaryInventor = component.get('v.primaryInventor');
        let action = component.get('c.getSelectedInventors');
        action.setParams({
            InvIds: arrSelectedInvIds,
            primaryInventor: primaryInventor
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    if (state === "SUCCESS") {
                        let existing = [];
                        result.forEach(record => existing.push(record));
                        let res = component.set("v.lstSelectedInventors", existing);

                        let coInventors = existing.map(record => record.name);
                        component.set('v.strSelectedInvIds', coInventors.join(','));
                        component.set('v.arrSelectedInvIds', coInventors);
                        let returnValue = component.get("v.coInventors");
                        let appEvent = $A.get("e.c:IDFAppEvent1");
                        component.set('v.selectedInventors', result);
                        appEvent.setParams({
                            "IDFAppEvent1": returnValue
                        });
                        appEvent.fire();
                        let inventors = existing.map(record => record.name);
                        helper.getSelectedInventorsToFlowHelper(component, inventors);
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);

    },

    getSelectedInventorsToFlowHelper: function(component, arrSelectedInvIds) {
        console.log('arrSelectedInvIds: ' + arrSelectedInvIds)
        let primaryInventor = component.get('v.primaryInventor');
        let action = component.get('c.getSelectedInventorsToFlow');
        action.setParams({
            InvIds: arrSelectedInvIds,
            primaryInventor: primaryInventor
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    if (state === "SUCCESS") {
                        component.set('v.selectedInventors', result);
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);

    },

    deleteInventor : function(component, event, helper, id) {
        console.log('In delete: ' + id);
        let action = component.get('c.deleteIDInventor');
        let idf = component.get('v.recordId');
        action.setParams({
            inventorId: id,
            inventionDisclosureId: idf
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();
                    if (state === "ERROR") {
                        let errors = response.getError();
                        helper.showApexError(helper, errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },

    showApexError: function(helper, errors) {
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

    showToast: function(type, message) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type[0].toUpperCase() + type.substring(1).toLowerCase(),
            "message": message
        });

        toastEvent.fire();
    },
})
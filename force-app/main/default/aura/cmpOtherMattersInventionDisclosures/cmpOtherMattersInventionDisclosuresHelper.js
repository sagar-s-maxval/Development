({
    doInitHelper: function(component, event, helper) {
        let action = component.get('c.getUsedDisclosuresIds');
        action.setParams({
            omId: component.get('v.recordId')
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    if (state === "SUCCESS") {
                        component.set('v.idfIds', result);
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },

    searchInventorsHelper: function(component, txtSearchWord) {
        let action = component.get('c.searchDisclosures');
        action.setParams({
            searchWord: txtSearchWord,
            usedDisclosuresIds: component.get('v.idfIds')
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
    updateConnection: function(component, helper, patentId, recordId) {
        let action = component.get('c.updateOMDisclosureConnection');
        action.setParams({
            disclosureId: patentId,
            omId: recordId,
            connect: true
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    if (state === "ERROR") {
                        let errors = response.getError();
                        console.error(errors);
                    } else {
                        component.set('v.isShowSearchResult', false);
                        helper.doInitHelper(component, event, helper);
                        $A.get('e.force:refreshView').fire();
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },

});
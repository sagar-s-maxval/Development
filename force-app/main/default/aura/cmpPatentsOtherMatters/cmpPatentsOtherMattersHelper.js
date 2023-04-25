({
    doInitHelper: function(component, event, helper) {
        let action = component.get('c.getUsedOMIds');
        action.setParams({
            patentId: component.get('v.recordId')
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    if (state === "SUCCESS") {
                        component.set('v.patentsIds', result);
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
        let action = component.get('c.searchOMs');
        action.setParams({
            searchWord: txtSearchWord,
            usedOMIds: component.get('v.patentsIds')
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
    updateConnection: function(component, helper, patentId, omId) {
        let action = component.get('c.updateOMPatentConnection');
        action.setParams({
            patentId: patentId,
            omId: omId,
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
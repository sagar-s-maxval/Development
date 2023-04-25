({
    doInitHelper: function (component, event, helper) {
        let action = component.get('c.getUsedKeywordsIds');
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
                        component.set('v.keywordsIds', result);
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
        let action = component.get('c.searchKeywords');
        action.setParams({
            searchWord: txtSearchWord,
            usedKeywordsIds: component.get('v.keywordsIds')
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
        let action = component.get('c.updateOMKeywordConnection');
        action.setParams({
            keywordId: patentId,
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
                        helper.doInitHelper(component, event, helper);
                        component.set('v.isShowSearchResult', false);
                         $A.get('e.force:refreshView').fire();
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },

});
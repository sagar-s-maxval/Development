({
    doInitHelper: function(component, event, helper) {
        let action = component.get('c.getUsedDOIds');
        action.setParams({
            Trdid: component.get('v.recordId')
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();

                    if (state === "SUCCESS") {
                        component.set('v.TradeMarkIds', result);
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
        let action = component.get('c.searchdisputes');
        action.setParams({
            searchWord: txtSearchWord,
            UsedDOids: component.get('v.TradeMarkIds')
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
    updateConnection: function(component, helper, dipsuteid, TradeMarkId) {
        let action = component.get('c.updatedisputeoppConnection');
        action.setParams({
            disoppId: dipsuteid,
            trademarkid: TradeMarkId,
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
                      //  helper.doInitHelper(component, event, helper);
                        $A.get('e.force:refreshView').fire();
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },

});
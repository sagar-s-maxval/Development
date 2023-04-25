({
    searchInventorsHelper: function(component, txtSearchWord) {
        let action = component.get('c.searchProductLines');
        action.setParams({
            searchWord: txtSearchWord,
            selectedLines: component.get('v.selectedLines')
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

    getSelectedLines : function(component, event, helper, selectedIds) {
        let action = component.get('c.getSelectedLines');
        let params = {
            selectedIds: selectedIds
        };
        helper.makeApexCall(component, event, helper, action, params, helper.setSelectedLines);
    },

    setSelectedLines : function(component, event, helper, result) {
        component.set('v.lstSelectedLines', result);
        let string = result.map(elem => elem.label).join(';');
        component.set('v.lines', string);
    },

});
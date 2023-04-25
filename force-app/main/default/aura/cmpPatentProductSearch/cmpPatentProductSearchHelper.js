({
    searchInventorsHelper: function(component, txtSearchWord) {
        let products = component.get('v.availableProducts');

        let searched = products.filter(elem => elem.label.includes(txtSearchWord));
        if (searched.length > 0) {
            component.set('v.isShowSearchResult', true);
            component.find("lstAvailableInventors").set("v.options", searched);
        }

//        let action = component.get('c.searchProducts');
//        action.setParams({
//            searchWord: txtSearchWord
//        });
//        action.setCallback(
//            this,
//            $A.getCallback(
//                function(response) {
//                    let state = response.getState();
//                    let result = response.getReturnValue();
//
//                    if (state === "SUCCESS") {
//                        if (result.length > 0) {
//                            component.set('v.isShowSearchResult', true);
//                            component.find("lstAvailableInventors").set("v.options", result);
//                        } else {
//                            component.set('v.isShowSearchResult', false);
//                        }
//                    } else if (state === "ERROR") {
//                        let errors = response.getError();
//                        console.error(errors);
//                    }
//                }
//            )
//        );
//        $A.enqueueAction(action);
    },

    getSelectedProducts : function(component, event, helper, selectedIds) {
        let action = component.get('c.getSelectedProducts');
        let params = {
            selectedIds: selectedIds
        };
        helper.makeApexCall(component, event, helper, action, params, helper.setSelectedLines);
    },

    setSelectedLines : function(component, event, helper, result) {
        component.set('v.lstSelectedProducts', result);
        let string = result.map(elem => elem.label).join(';');
        component.set('v.products', string);
    }

});
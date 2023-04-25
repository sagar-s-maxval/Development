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

    getSelectedInventorsHelper: function(component, arrSelectedInvIds) {
        let action = component.get('c.getSelectedInventors');
        action.setParams({
            InvIds: arrSelectedInvIds,
            primaryInventor: component.get('v.primaryInventor')
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

                        let coInventors = existing.map(record => record.name).join(',');
                        component.set('v.strSelectedInvIds', coInventors);
                        let returnValue = component.get("v.coInventors");
                        let appEvent = $A.get("e.c:IDFAppEvent1");

                        appEvent.setParams({
                            "IDFAppEvent1": returnValue
                        });
                        appEvent.fire();
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);

    }
})
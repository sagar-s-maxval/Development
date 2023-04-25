({
    deleteRecord: function (cmp, event, helper) {

        let getAction = cmp.get("c.getRelatedTo");
        getAction.setParams({"id": cmp.get("v.recordId")});            
        

        getAction.setCallback(this, function (response) {

            let relatedToId = response.getReturnValue();

            console.log("response", response);
            console.log("relatedToId", relatedToId);
            console.log("response JSON", JSON.stringify(response));
            console.log("response JSON", response.getState());
            console.log("response JSON", response.getError());

            let delAction = cmp.get("c.deleteEmailMessage");
            delAction.setParams({"id": cmp.get("v.recordId")});

            delAction.setCallback(this, function () {
                $A.get('e.force:refreshView').fire();

                let dismissActionPanel = $A.get("e.force:closeQuickAction");
                dismissActionPanel.fire();

                if (relatedToId !== null && relatedToId !== 'null') {
                    let navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": relatedToId
                    });
                    navEvt.fire();
                }
            });

            $A.enqueueAction(delAction);

        });

        $A.enqueueAction(getAction);

    }
});
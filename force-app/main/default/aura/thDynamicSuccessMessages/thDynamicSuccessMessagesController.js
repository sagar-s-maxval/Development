({
    invoke: function (component, event, helper) {
        let message = component.get('v.messages');

        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success",
            "message": message,
            "type": "success"
        });
        toastEvent.fire();
    }
});
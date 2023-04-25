({
    handleChange : function(component, event, helper) {
        let response = event.getSource().getLocalId();
        component.set("v.value", response);
        let navigate = component.get("v.navigateFlow");
        navigate("NEXT");
    }
});
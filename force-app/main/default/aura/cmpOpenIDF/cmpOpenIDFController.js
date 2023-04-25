({

    invoke : function(component, event, helper) {
        let url = component.get("v.url");
        window.open(url, "_self");
    }
})
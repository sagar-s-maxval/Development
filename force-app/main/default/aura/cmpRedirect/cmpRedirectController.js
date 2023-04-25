({

    invoke : function(component, event, helper) {
        console.log('In redirect');
        let url = component.get("v.url");
        let redirect = $A.get("e.force:navigateToURL");

        redirect.setParams({
            'url': url
        });

        redirect.fire();
    }
})
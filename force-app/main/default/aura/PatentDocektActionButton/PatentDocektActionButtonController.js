({
	onButtonPressed : function(component, event, helper) {
    console.log('hi');
       var navService = component.find("navService");
        var pageReference = {
            "type": "standard__component",
            "attributes": {
                "componentName": "c__PatentDocketActionTable"    
            },
            state: {
                c__recordId: component.get('v.recordId')
            }    
            
        };
       // var pageReference = cmp.get("v.pageReference");
      //  event.preventDefault();
     //   navService.navigate(pageReference);
    //     const navService = component.find('navService');
       // const pageReference = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
        const handleError = (error) => {
            console.log(error);
        };
        navService.generateUrl(pageReference).then(handleUrl, handleError);
            }
})
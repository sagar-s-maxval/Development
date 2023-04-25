({
    handleClick : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        //alert(component.get("v.HomePage")+'HomePage');
        component.set('v.HomePage',true);
        //alert(component.get("v.HomePage")+'comp1');
        evt.setParams({
            componentDef: "c:cmpIDFNew",
            componentAttributes: {
                 HomePage : component.get("v.HomePage")
                // Attributes here.
                 }
        });
        evt.fire();
        
    }
   /* 
    handleClick : function(component, event, helper) {
        var flow = component.find("flowData");
       
        flow.startFlow("IDF_Submission");   
    },*/
    
})
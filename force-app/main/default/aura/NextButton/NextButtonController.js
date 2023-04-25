({
	myAction : function(component, event, helper) {
		
	},
    
     doInit : function(component, event, helper) 
    {
        var country = component.get("v.country");
        var caseType = component.get("v.caseType");
        console.log("country---->"+country);
        console.log("caseType---->"+caseType);
		/* var action = component.get("c.getCountry");
         action.setCallback(this, function(response) 
                            {
                                var state = response.getState();
            					 var result1 = response.getReturnValue();  
                               // alert(result1);
                                if(state==='SUCCESS')
                                {
                                    var result = response.getReturnValue();  
                                   
                                    
                                }
                                
                                else
                                {
                                     console.log(state);
                					 var errors = response.getError();
                						if (errors) 
                                        {
                    									if (errors[0] && errors[0].message) 
                                                        {
                       
                        									console.log("Error message: " + 
                                 								errors[0].message);
                    									}
                                        }             

                                }
                                
                            });
         $A.enqueueAction(action);*/
	},
    onButtonPressed : function(component, event, helper) 
    {
        var country = component.get("v.country");
        var caseType = component.get("v.caseType");
        console.log("country---->"+country);
        console.log("caseType---->"+caseType);
    }
})
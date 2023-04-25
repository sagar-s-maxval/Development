({
    fetchSearchInstructions : function(component,event,helper) 
    {
        var action = component.get('c.getSearchInstruction'); 
        var ProposedMarkId = component.get("v.recordId");
        action.setParams({'ProposedMarkId': ProposedMarkId});
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    var objSearchInsWrapper = response.getReturnValue();
                    if (state === "SUCCESS") 
                    {
                        {
                            objSearchInsWrapper.forEach((searchInstruction) => {
                                console.log(searchInstruction)})
                            // Set the list attribute in component with the value returned by func
                            component.set('v.WrapperSearchInstructionList',objSearchInsWrapper);
                            //component.set("v.objSearchInsList",objSearchInsList);
                        }
                    }
                    else if(state==="INCOMPLETE")
                    {
                        
                    }
                        else if (state === "ERROR") 
                        {
                            var errors = response.getError();
                            if (errors) 
                            {
                                if (errors[0] && errors[0].message) 
                                {
                                    console.log("Error message: " + errors[0].message);
                                }
                            } 
                            else 
                            {
                                console.log("Unknown error");
                            }
                        }  
                } 
            )
        );
        $A.enqueueAction(action);
    },
    fetchSearchInstructionsJurisdictions : function(component,event,helper)
    {
        var action = component.get('c.getSearchInstructionUniqueJurisdictions');
        var ProposedMarkId = component.get("v.recordId");
        action.setParams({'ProposedMarkId': ProposedMarkId});
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response)
                {
                    var state = response.getState();
                    var jursdictionsList = response.getReturnValue();
                    if (state === "SUCCESS")
                    {
                        {
                            // Set the list attribute in component with the value returned by func
                            component.set('v.JurisdictionsList',jursdictionsList);
                            //component.set("v.objSearchInsList",objSearchInsList);
                        }
                    }
                    else if(state==="INCOMPLETE")
                    {

                    }
                    else if (state === "ERROR")
                    {
                        var errors = response.getError();
                        if (errors)
                        {
                            if (errors[0] && errors[0].message)
                            {
                                console.log("Error message: " + errors[0].message);
                            }
                        }
                        else
                        {
                            console.log("Unknown error");
                        }
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },
    fetchSearchInstructionsFinalRecommendation : function(component,event,helper)
    {
        var action = component.get('c.getSearchInstructionFinalRecommendation');
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response)
                {
                    var state = response.getState();
                    var jursdictionsList = response.getReturnValue();
                    if (state === "SUCCESS")
                    {
                        {
                            // Set the list attribute in component with the value returned by func
                            component.set('v.JurisdictionsList',jursdictionsList);
                            //component.set("v.objSearchInsList",objSearchInsList);
                        }
                    }
                    else if(state==="INCOMPLETE")
                    {

                    }
                    else if (state === "ERROR")
                    {
                        var errors = response.getError();
                        if (errors)
                        {
                            if (errors[0] && errors[0].message)
                            {
                                console.log("Error message: " + errors[0].message);
                            }
                        }
                        else
                        {
                            console.log("Unknown error");
                        }
                    }
                }
            )
        );
        $A.enqueueAction(action);
    }
})
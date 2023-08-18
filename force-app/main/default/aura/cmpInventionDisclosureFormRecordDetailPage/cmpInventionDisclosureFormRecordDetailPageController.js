({
	Onload : function(component, event, helper) 
    {
        var recid = component.get("v.recordId");
        helper.helperMethod(component,component.get("v.recordId"));
	}
})
({
    doInit : function(component, event, helper) 
    {
        helper.fetchSearchInstructions(component, event, helper);
        helper.fetchSearchInstructionsJurisdictions(component, event, helper);
    },
    OnClickMoreController : function(component, event, helper)
    {
        var SelectedIndex = event.getSource().get("v.name");
        var temp = component.get('v.WrapperSearchInstructionList');
        temp[SelectedIndex].IsShow = true;
        component.set("v.WrapperSearchInstructionList",temp);
    },
    OnClickLessController : function(component, event, helper) {
        var SelectedIndex = event.getSource().get("v.name");
        var temp = component.get('v.WrapperSearchInstructionList');
        temp[SelectedIndex].IsShow = false;
        component.set("v.WrapperSearchInstructionList", temp);
    }

})
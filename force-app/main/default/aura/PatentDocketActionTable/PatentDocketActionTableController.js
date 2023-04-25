({
    init : function (component) {
        console.log('here recid'+component.get("v.pageReference").state.c__recordId);
        component.set("v.caseid",component.get("v.pageReference").state.c__recordId);
        // Find the component whose aura:id is "flowId"
        var flow = component.find("flowId");       // In that component, start your flow. Reference the flow's Unique Name.
        var inputVariables = [
         { name : "recordId", type : "String", value: component.get("v.pageReference").state.c__recordId }
         ];
        flow.startFlow("Patent_Docket_Action_Table",inputVariables);
    }
    
         
})
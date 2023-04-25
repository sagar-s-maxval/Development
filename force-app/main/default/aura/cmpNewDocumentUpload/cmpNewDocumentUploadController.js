({
    init: function (component, event, helper) {
        let flow = component.find("flowData");
        let value = helper.getParameterByName(component, event, 'inContextOfRef');
        let context = JSON.parse(window.atob(value));
        component.set('v.patentId', context.attributes.recordId);
       let inputVariables = [
            {name: "iPatentId", type: "String", value: context.attributes.recordId},
            {name: "isPatent", type: "Boolean", value: context.attributes.recordId.startsWith('a2K')},
            {name: "isMark", type: "Boolean", value: context.attributes.recordId.startsWith('a4D')},
            {name: "isDO", type: "Boolean", value: context.attributes.recordId.startsWith('a4l')},
            {name: "isDOD", type: "Boolean", value: context.attributes.recordId.startsWith('a49')}
       ];
        flow.startFlow("Create_New_Patent_Document", inputVariables);
    },

    onCancel: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/" + component.get('v.patentId')
        });
        urlEvent.fire();
    }
})
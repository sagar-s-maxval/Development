({
    doInit: function(component, event, helper) {
        let action = component.get('c.getAttachments');
        let params = {
            recordId: component.get('v.recordId')
        }
        helper.makeApexCall(component, event, helper, action, params, helper.showAttachments)
    }
});
({
    doInit : function(component, event, helper) {
        //check for PCT Oor Priority
        let action = component.get('c.checkIsPatentPCTorPriority');
        let params = {
            patentId: component.get('v.recordId')
        }

        helper.makeApexCall(component, event, helper, action, params, helper.setIsPCT);
    }
});
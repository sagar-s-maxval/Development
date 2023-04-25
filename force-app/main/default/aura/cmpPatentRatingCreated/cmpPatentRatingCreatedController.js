({
    doInit : function(component, event, helper) {
        helper.showToast('success', component.get('v.message'));

        let navigate = component.get('v.navigateFlow');
        navigate('NEXT');
    }
});
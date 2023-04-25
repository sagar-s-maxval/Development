({
    doInit : function(component) {
        console.log('RECORD: ' + component.get('v.recordId'));
        let navigate = component.get('v.navigateFlow');
        navigate('NEXT');
    }
});
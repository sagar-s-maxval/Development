({
    onButtonPressed: function(cmp, event, helper) {
        // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
        // Fire that action
        console.log(actionClicked);
        if (actionClicked === 'CANCEL') {
            cmp.set('v.buttonClicked', 'CANCEL');
            let navigate = cmp.get('v.navigateFlow');
            navigate('NEXT');
        } else if (actionClicked === 'EDIT') {
            cmp.set('v.buttonClicked', 'EDIT');
            cmp.set('v.allowEdit', true);
        } else if (actionClicked === 'NEXT') {
            cmp.set('v.buttonClicked', 'NEXT');
            let navigate = cmp.get('v.navigateFlow');
            navigate('NEXT');
        } else if (actionClicked === 'SEND') {
            cmp.set('v.buttonClicked', 'SEND');
            let navigate = cmp.get('v.navigateFlow');
            navigate('NEXT');
        }
    }
})
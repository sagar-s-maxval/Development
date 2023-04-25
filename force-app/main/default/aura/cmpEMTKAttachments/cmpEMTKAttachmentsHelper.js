({
    showAttachments: function(component, event, helper, results) {
        component.set('v.attachments', results);
        if (results.length > 0) {
            component.set('v.emailId', results[0].ParentId);
        }
    }
});
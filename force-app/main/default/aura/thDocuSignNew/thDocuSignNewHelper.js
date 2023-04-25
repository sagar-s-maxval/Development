({
    fetchEmailTemplateFolders: function (component) {
        let action = component.get('c.getEmailTemplateFolders');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result) {
                    let options = result;
                    options.forEach(elem => elem.label = elem.Name);
                    options.forEach(elem => elem.value = elem.Id);
                    component.set('v.emailTemplateFolders', options);
                }
            } else {
                let error = response.getError();
                console.log('error-- ', error);
            }
        });

        $A.enqueueAction(action);
    },

    fetchEmailTemplateDefaultFolder: function (component) {
        let action = component.get('c.getEmailTemplateDefaultFolder');
        let folderName = component.get('v.defaultTemplateName');
        action.setParams({'folderName': folderName});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result) {
                    component.set('v.folderValue', result.Id);
                }
            } else {
                let error = response.getError();
                console.log('error-- ', error);
            }
        });

        $A.enqueueAction(action);
    },

    fetchEmailTemplates: function (component, folderId) {
        let action = component.get('c.getEmailTemplatesFromPatent');
        action.setParams({'folderId': folderId});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result) {
                    let options = result;
                    options.forEach(elem => elem.label = elem.Name);
                    options.forEach(elem => elem.value = elem.Id);
                    component.set('v.emailTemplates', options);
                }
            } else {
                let error = response.getError();
                console.log('error-- ', error);
            }
        });

        $A.enqueueAction(action);
    }
});
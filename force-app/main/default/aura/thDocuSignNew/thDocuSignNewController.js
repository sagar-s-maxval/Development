({
    initController: function (component, event, helper) {
        helper.fetchEmailTemplateDefaultFolder(component);
        helper.fetchEmailTemplateFolders(component);
    },

    openPreviewModal: function (component, event, helper) {
        component.set("v.isPreviewModalOpen", true);
    },

    openAttachmentModal: function (component, event, helper) {
        component.set('v.isAttachmentModalOpen', true);
    },

    closeModal: function (component) {
        component.set("v.isModalOpen", false);
        component.set('v.isAttachmentModalOpen', false);
        component.set("v.isPreviewModalOpen", false);
        component.set("v.isAddPersonModalOpen", false);
    },

    NewRecord: function (component, event, helper) {
        component.set('v.isAddPersonModalOpen', true);
        var flow = component.find("flowData");
        var inputVariables = [
            {
                name: "recordId",
                type: "String",
                value: component.get("v.recordId")
            },
            {
                name: "sObject",
                type: "Boolean",
                value: component.get("v.IsPatent")
            }
        ];
        flow.startFlow("cmpAPDocuSginedPerson", inputVariables);

    },

    statusChange: function (component, event) {
        if (event.getParam('status') === "FINISHED_SCREEN" || event.getParam('status') === "FINISHED") {
            component.set('v.isAddPersonModalOpen', false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: "Success!",
                message: "Record Updated successfully!",
                type: "success"
            });
            toastEvent.fire();
            $A.get("e.force:closeQuickAction").fire();
        }
    },

    sendToApex: function (component, event, helper) {
        let personList = component.find("personList");
        let reviewerList = component.find("reviewerList");
        let fileList = component.find("fileList");

        let files = fileList.getElement().getSelectedDocumentsIds();
        let signers = personList.getElement().getSelectedSignersSrt();
        let additional = reviewerList.getElement().getSelectedReviewersIds();
        let carbonCopies = reviewerList.getElement().getCCsPersonsSrt();

        let allRecipients = [].concat(signers).concat(additional);

        if (component.get('v.templateValue') === '') {
            component.set('v.templateValue', undefined);
        }

        let docusignParams = {
            "templateId": component.get('v.templateValue'),
            "recordId": component.get("v.recordId"),
            "filesIds": files,
            "inventorsIds": allRecipients,
            "ccPersonsIds": carbonCopies,
            "emailBody": component.get("v.emailBody"),
            "isMultipleSign": true // always multi
        };
        console.log(docusignParams);

        let action = component.get("c.send");
        action.setParams(docusignParams);

        action.setCallback(this, function (response) {
            let state = response.getState();
            if(state === 'ERROR') {
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    for (let i = 0; i < errors.length; i++) {
                        message += errors[i].message;
                        message += i > 0 ? ', ' : '';
                    }
                }
                component.set("v.statusErrorMessage", response.getError()[0].message);
            }
            component.set("v.isShowStatus", true);
            component.set("v.isPreloader", false);
        })

        $A.enqueueAction(action);
        component.set("v.isPreviewModalOpen", false);
        component.set("v.isPreloader", true);
    },

    onFolderChange: function (component, event, helper) {
        let folderId = component.get('v.folderValue');
        helper.fetchEmailTemplates(component, folderId);
    },

    onTemplateChange: function (component, event, helper) {
        let templateId = component.get('v.templateValue');
        var templates = component.get('v.emailTemplates');
        templates.forEach(elm => {
            if (elm.Id === templateId) {
                component.set('v.emailBody', elm.HtmlValue);
            }
        });
    },

    rowSelect: function (component, event, helper) {

        let eventSource = event.getParam("eventSource");

        console.log('eventSource:', eventSource);
        console.log('event:', JSON.stringify(event));

        switch (eventSource) {
            case "thFileList":
                let fileAmount = event.getParam("amountOfFilesSelected");
                component.set("v.notOneFileSelected", fileAmount < 1);

                if (fileAmount < 1) {
                    component.find("personList").setPersons(false);
                }

                if (fileAmount >= 1) {
                    let relatedPersonsIds = event.getParam("relatedPersonsIds");

                    component.find("personList").setPersons(relatedPersonsIds);

                    // enable Send Envelope button
                    component.set("v.noPersonsSelected", !relatedPersonsIds);
                }

                // Prevent more that 1 file for Invention Disclosure
                if(!component.get("v.IsPatent")) {
                    component.set("v.tooManyFileSelected", fileAmount > 1);
                }

                break;

            case "thPersonsList":
                let perAmount = event.getParam("amountOfSelected");
                component.set("v.noPersonsSelected", perAmount === 0);
                // let persons = component.find("personList").getElement().getSelectedSignersSrt();
                // component.set("v.noPersonsSelected", persons.length === 0);
                break;

            case "thReviewerList":
                let perAmount1 = event.getParam("amountOfSelected");
                component.set("v.noReviewerSelected", perAmount1 === 0);
                // let reviewers = component.find("reviewerList").getElement().getSelectedReviewersIds();
                // component.set("v.noReviewerSelected", reviewers.length === 0);

                break;
        }

        let filesSelectionInvalid =
            component.get("v.notOneFileSelected") || // OR
            component.get("v.tooManyFileSelected") || // OR
            (component.get("v.noPersonsSelected") && // AND
                component.get("v.noReviewerSelected"));

        component.set("v.isSendDisabled", filesSelectionInvalid);
    },

    onPreloader: function (component, event) {
        component.set("v.isPreloader", event.getParam("isPreloader"));
    },

    onPageRefresh: function () {
        $A.get('e.force:refreshView').fire();
    },

    onAcknowledge: function (component) {
        // reset view
        component.set("v.isShowStatus", false);
        component.set("v.isSendDisabled", true);
        component.set("v.statusErrorMessage", '');
        component.set('v.emailBody', '');
        component.set('v.templateValue', '');

        component.get("v.notOneFileSelected", true);
        component.get("v.noPersonsSelected", true);
        component.get("v.noReviewerSelected", true);
    }
});
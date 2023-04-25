({
    initialize: function (component, helper) {
        var action = component.get('c.getDocTypePickListValues');
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var docTypes = response.getReturnValue();
                console.log('---docTypes--- ', docTypes);
                helper.setTableColumns(component, docTypes);
                helper.fetchData(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": errors,
                    "type": "error"
                });
                toastEvent.fire();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    setTableColumns: function (component, docTypes) {
        component.set('v.columns', [
            {
                label: 'Document Name',
                fieldName: 'File_Name_Big__c',
                type: 'text',
                editable: true,
                typeAttributes: {required: true}
            },
            {
                label: 'Document Date', fieldName: 'Upload_Date__c', type: 'date-local', editable: true,
                typeAttributes: {
                    year: 'numeric',
                    day: 'numeric',
                    month: 'numeric',
                }
            },
            {label: 'Comments', fieldName: 'Comments__c', type: 'text', editable: true},
            {label: 'Document Type', fieldName: 'Document_Type__c', type: 'text'},
            {type: 'action', typeAttributes: {rowActions: docTypes}},
        ]);
    },

    fetchData: function (component) {
        let action = component.get('c.getEmailMessageDocuments');
        action.setParams({
            'emailMessageId': component.get('v.emailMessageId'),
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                //component.set('v.selectedSDocsAgreements', []);
                component.set('v.allDocuments', result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": errors,
                    "type": "error"
                });
                toastEvent.fire();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    changeDocumentType: function (component, action, row) {
        let rows = component.get('v.allDocuments');
        let dataToBeUpdatedWhenButtonIsPressed = [];

        rows.forEach(e => {
            if (e.Id === row.Id) {
                e.Document_Type__c = action.name;
            }
            dataToBeUpdatedWhenButtonIsPressed.push(e);
        })
        component.find("docTable").set("v.draftValues", null);
        component.set('v.updateRows', dataToBeUpdatedWhenButtonIsPressed);
    },

    saveEdition: function (component, row) {
        let rows = component.get('v.allDocuments');
        let dataToBeUpdatedWhenButtonIsPressed = [];

        row.forEach(elm => {
            let rowIndex = elm.id.split('-')[1];
            if (elm.File_Name_Big__c) {
                rows[rowIndex].File_Name_Big__c = elm.File_Name_Big__c;
            } else if (elm.Upload_Date__c) {
                rows[rowIndex].Upload_Date__c = elm.Upload_Date__c;
            } else if (elm.Comments__c) {
                rows[rowIndex].Comments__c = elm.Comments__c;
            } else if (elm.Comments__c === '') {
                rows[rowIndex].Comments__c = elm.Comments__c;
            }
            dataToBeUpdatedWhenButtonIsPressed.push(rows[rowIndex])
        })
        component.set('v.updateRows', dataToBeUpdatedWhenButtonIsPressed);
        component.find("docTable").set("v.draftValues", null);
    },

    updateDocuments: function (component, rows) {
        var action = component.get('c.updatePatentDocuments');
        action.setParams({
            'documents': rows
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                console.log('---result--- ', result);

                //component.set('v.selectedSDocsAgreements', []);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error",
                    "message": errors,
                    "type": "error"
                });
                toastEvent.fire();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    activateDocuments: function (component, selectedRows) {
        console.log(selectedRows)
        let rows = component.get('v.allDocuments');
        let dataToBeUpdatedWhenButtonIsPressed = [];
        console.log(rows)
        rows.forEach(elm => {
            let field = component.get('v.patentId').startsWith('a2K') ? 'Patent__c' : 'Trademark__c';
            elm.isActive__c = false;
            elm[field] = null;
            console.log('---elm.Id1-- ', elm.Id);
            selectedRows.forEach(elm2 => {
                if (elm.Id === elm2.Id) {
                    console.log('---elm.Id-- ', elm2.Id);
                    elm.isActive__c = true;
                    elm[field] = component.get('v.patentId');
                }
            });
            console.log('---elm--- ', elm);
            dataToBeUpdatedWhenButtonIsPressed.push(elm);
        });
        console.log('dataToBeUpdatedWhenButtonIsPressed', dataToBeUpdatedWhenButtonIsPressed);
        component.set('v.updateRows', dataToBeUpdatedWhenButtonIsPressed);
    }
})
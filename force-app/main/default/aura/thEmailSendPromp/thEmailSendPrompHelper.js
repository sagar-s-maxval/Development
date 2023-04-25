({
    openModal : function(component, payload) {
        try {
            let defaultToPersonIds = payload.toPersonIds__c != null && payload.toPersonIds__c !== '' ? payload.toPersonIds__c.split(",") : [];
            let defaultCcPersonIds = payload.ccPersonIds__c != null && payload.ccPersonIds__c !== '' ? payload.ccPersonIds__c.split(",") : [];

            component.set("v.isOpen", true);
            let flow = component.find('flow');
            let inputVariables = [
                {name: "iRecordId", type: "String", value: payload.recordId__c},
                {name: "vDefaultToPersonIds", type: "String", value: defaultToPersonIds},
                {name: "vDefaultCcPersonIds", type: "String", value: defaultCcPersonIds},
                {name: "iSubject", type: "String", value: payload.Subject__c},
                {name: "vDefaultSendPDF", type: "Boolean", value: payload.Send_Attachment__c},
                {name: "iBody", type: "String", value: payload.Body__c},];
            flow.startFlow('Send_Email_With_Auto_Populated_Recipients_and_Edit_Mode', inputVariables);
        } catch (err) {
            console.log(err)
        }
    },
});
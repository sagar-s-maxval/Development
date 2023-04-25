({
    doInit: function (component, event, helper) {
        const channel = '/event/Email_Prompt_Event__e';
        const replayId = -1;

        let userId = $A.get("$SObjectType.CurrentUser.Id");
        let recordId = component.get('v.recordId');


        const empApi = component.find("empApi");

        console.log('here')
        //A callback function that's invoked for every event received
        const callback = function (message) {
            let obj = message.data.payload;

            console.log(obj.toPersonIds__c);
            console.log(obj.Send_Attachment__c);
            console.log(obj.ccPersonIds__c);
            console.log(obj.Body__c);
            console.log(obj.Subject__c);

            if (obj.recordId__c === recordId && obj.UserId__c === userId) {
                component.set("v.isModalOpen", obj.isModalOpen__c);

                helper.openModal(component, obj);

            }
        };

        // Subscribe to the channel and save the returned subscription object.
        empApi.subscribe(channel, replayId, callback).then(function (newSubscription) {
            console.log("Subscribed to channel Email_Prompt_Event__e" + channel);
            console.log(newSubscription)
        });

        const errorHandler = function (message) {
            console.error("Received error ", JSON.stringify(message));
        };

        //A callback function that's called when an error response is received from the server for the handshake, connect, subscribe, and unsubscribe meta channels.
        empApi.onError(errorHandler);
    },

    closeFlowModal: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },

    closeModalOnFinish: function (component, event, helper) {
        if (event.getParam('status') === "FINISHED") {
            component.set("v.isModalOpen", false);
        }
    }
});
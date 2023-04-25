({
    doInit: function (component, event, helper) {
        helper.fetchOpinion(component, event, helper);
    },

    refreshAction: function (component) {
        window.setTimeout(
            $A.getCallback(function() {
                window.location.reload();
            }), 2000
        );
    },

    edit: function (component, event, helper) {
        let SelectedIndex = event.getSource().get("v.name");
        let temp = component.get('v.wrapperRecommendationOpinion');
        let editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": temp[SelectedIndex].recordId
        });
        editRecordEvent.fire();
    },

    reSendEmail: function (component, event, helper) {
        let SelectedIndex = event.getSource().get("v.name");
        let temp = component.get('v.wrapperRecommendationOpinion');
        let recordId = component.get('v.recordId');
        // if (!temp[SelectedIndex].recommendationOpinion.Is_Resend_Email__c) {
        //     helper.updateRecommendationOpinion(component, temp[SelectedIndex].recordId);
        // }

        component.set('v.reSendDisabled1', SelectedIndex);
        helper.openModal(component, temp[SelectedIndex].recommendationOpinion, recordId)

        // action.setParams({
        //     'email': temp[SelectedIndex].recommendationOpinion.Persons__r.SymphonyIPM__Email__c,
        //     'name': temp[SelectedIndex].recommendationOpinion.Persons__r.Name,
        //     'recordId': recordId,
        // });
        // action.setCallback(this, function (response) {
        //     let state = response.getState();
        //     if (state === "SUCCESS") {
        //         let result = response.getReturnValue();
        //         component.set('v.reSendDisabled1', SelectedIndex);
        //
        //         let toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({
        //             "title": "Success",
        //             "message": "Email has been sent successfully",
        //             "type": "success"
        //         });
        //
        //         toastEvent.fire();
        //
        //     }
        // });
        $A.enqueueAction(action);
        // helper.refreshPage(component);
    },

    closeFlowModal : function(component, event, helper) {
        component.set("v.isModalOpen", false);
    },

    closeModalOnFinish : function(component, event, helper) {
        if(event.getParam('status') === "FINISHED") {
            component.set("v.isModalOpen", false);
        }
    }
})
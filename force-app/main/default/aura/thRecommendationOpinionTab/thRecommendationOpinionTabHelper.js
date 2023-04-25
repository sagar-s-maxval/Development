({
    fetchOpinion: function (component, event, helper) {
        let action = component.get('c.getRecommendationOpinionWrapper');
        let dORecId = component.get("v.recordId");
        action.setParams({'dORecId': dORecId});
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) {
                    let state = response.getState();
                    let objOpinionWrapper = response.getReturnValue();
                    if (state === "SUCCESS") {
                        // $A.get('e.force:refreshView').fire();

                        // Set the list attribute in component with the value returned by func
                        component.set('v.wrapperRecommendationOpinion', objOpinionWrapper);

                    } else if (state === "INCOMPLETE") {

                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        } else {
                            console.log("Unknown error");
                        }
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },

    updateRecommendationOpinion: function (component, ROId) {
        let action = component.get('c.updateRecommendationOpinion');
        action.setParams({'ROId': ROId});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                if (result) {
                    console.log('Ok')
                }
            } else {
                let error = response.getError();
                console.log('error-- ', error);
            }
        });

        $A.enqueueAction(action);
    },

    openModal : function(component, recommOpin, recordId) {
        component.set("v.isModalOpen", true);
        try {
        let inputVariables = [
            {name: "rRecommendationOpinion", type: "SObject", value: recommOpin},
            {name: "iRecordId", type: "String", value: recordId},
            ];

        let flow = component.find('flow');
        flow.startFlow('Send_Email_After_Revisit_Recommendation_Clicked', inputVariables);
        } catch (err) {
            console.log(err)
        }
    },
    //
    // refreshPage: function (component) {
    //     $A.get('e.force:refreshView').fire();
    // }
})
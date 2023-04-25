({
    init: function (component) {
        let flow = component.find("flowData");
        let inputletiables = [{
            name: "IDF",
            type: "String",
            value: component.get('v.idfId')
        }];
        flow.startFlow("ContributionDetails", inputletiables);
    },

    handleFlowFinished: function(component, event) {
        if (event.getParam("status") === "FINISHED") {
            component.set('v.openFlow', false);
        }
    }
});
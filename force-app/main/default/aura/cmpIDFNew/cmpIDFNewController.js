({
    init: function (component) {
        let flow = component.find("flowData");
        let inputletiables = [];
        flow.startFlow("IDF_Submission", inputletiables);
    },
});
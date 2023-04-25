({
    getReport: function(component, event, helper) {
        let action = component.get('c.getFamilyReport');
        let params = {
            patentId: component.get('v.recordId')
        };

        helper.makeApexCall(component, event, helper, action, params, helper.openReport);
    },

    openReport: function(component, event, helper, results) {
        let url = '/lightning/r/Report/' + results.reportId + '/view?fv0=' + results.familyId;
        window.open(url, '_blank');
    }
});
({
    init: function (cmp, evt, helper) {
        let pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__cmpDocketingActivityFullScreenView',
            },
            state: {
                "c__collapseButtonHelpText": cmp.get("v.collapseButtonHelpText"),
                "c__recordId": cmp.get("v.recordId"),
                "c__sObjectApiName": cmp.get("v.sObjectApiName"),
                "c__parentLookupField": cmp.get("v.parentLookupField"),
                "c__fieldSet": cmp.get("v.fieldSet"),
                "c__nameAsUrl": cmp.get("v.nameAsUrl"),
                "c__header": cmp.get("v.header"),
            }
        };

        cmp.set("v.pageReference", pageReference);
    },

    redirect: function (cmp, evt, helper) {

        let pageReference = cmp.get("v.pageReference");
        let navService = cmp.find("navService");

        evt.preventDefault();
        navService.navigate(pageReference);
    }
});
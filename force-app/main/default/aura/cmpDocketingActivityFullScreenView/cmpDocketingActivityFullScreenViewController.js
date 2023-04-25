({
    onPageReferenceChange: function (cmp, evt, helper) {
        let myPageRef = cmp.get("v.pageReference");
        let recordId = myPageRef.state.c__recordId;
        let sObjectApiName = myPageRef.state.c__sObjectApiName;
        let parentLookupField = myPageRef.state.c__parentLookupField;
        let fieldSet = myPageRef.state.c__fieldSet;
        let nameAsUrl = myPageRef.state.c__nameAsUrl;
        let header = myPageRef.state.c__header;
        let collapseButtonHelpText = myPageRef.state.c__collapseButtonHelpText;

        cmp.set("v.recordId", recordId);
        cmp.set("v.sObjectApiName", sObjectApiName);
        cmp.set("v.parentLookupField", parentLookupField);
        cmp.set("v.fieldSet", fieldSet);
        cmp.set("v.nameAsUrl", nameAsUrl);
        cmp.set("v.header", header);
        cmp.set("v.returnHelpText", collapseButtonHelpText);

        cmp.set("v.loaded", true);

    },

    return: function () {
        window.history.back();
    }
});
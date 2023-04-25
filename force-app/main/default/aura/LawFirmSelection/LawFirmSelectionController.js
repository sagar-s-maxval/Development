({
    loadIDFlow : function (component, event, helper) {
        helper.getLawfirmList(component);
       // helper.getOCs(component,event, helper);
		//var flow = component.find("flowData");
		//flow.startFlow("Disclosure_Review");
	},
    loadOCs : function (component, event, helper) {
		var SelectedLawfirmId = component.find("ddlLawfirm").get("v.value");
        helper.getOCs(component, SelectedLawfirmId);	
	},
    setSelectedOC : function (component, event, helper) {
		var SelectedOCId = component.find("ddlOutsideCounsel").get("v.value");
        component.set("v.OutputParam", SelectedOCId);
        //component.set("v.selectedOCId", SelectedOCId);
	},
    SelectLawfirm : function(component, event, helper){
        console.log('selected lawfrim');
        var SelectedLawfirmId = component.find("ddlLawfirm").get("v.value");
        component.set("v.selectedLawfirm", SelectedLawfirmId);
        //alert('Selected LawFirm----->'+SelectedLawfirmId);
        
        helper.getOCs(component,event, helper);
    },
    SelectConfirmLawfirm : function(component, event, helper){
        var SelectedLawfirmId = component.find("confirmLawfirmTier").get("v.value");
        component.set("v.selectedConfirmLawfirm", SelectedLawfirmId);
        helper.getLawfirmList(component);
    }
})
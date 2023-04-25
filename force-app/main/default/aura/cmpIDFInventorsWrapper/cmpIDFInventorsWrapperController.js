({
    doInit : function(component, event, helper) {
        helper.makeApexCall(component, event, helper);
        helper.getTitle(component, event, helper);
        helper.getPicklistsValues(component, event, helper);

        var idfRecordId = component.get('v.IDF');
        if(idfRecordId != '' && idfRecordId != null){
            console.log('--loadInitialPicklistValues--- ', idfRecordId);
            helper.loadInitialPicklistValues(component, helper, idfRecordId);
        }
    },

    onPrimaryInventorChanged: function (component, event, helper) {
        let primaryInventor = component.get('v.primaryInventor');

        if (primaryInventor) {
            let primaryInventorList = [];
            primaryInventorList.push(primaryInventor);

            component.set('v.selectedPrimaryInventor', primaryInventorList);
            helper.getGroupDivisionBU(component, event, helper);
        }

    },

    checkBusinessUnit: function(component, event, helper) {
        let group = component.get('v.Group');
        let division = component.get('v.Division');
        let businessUnit = component.get('v.BusinessUnit');
        let result = true;

        if (businessUnit && group && division) {
            result = businessUnit.includes(group) && businessUnit.includes(division);
        }

        component.set('v.buCheck', result);
    },

    changeDivisionPLValues : function(component, event, helper) {
        component.set('v.Division', '');
        component.set('v.BusinessUnit', '');
        helper.setDivisionPicklistDependentValues(component, helper);
    },

    changeBusinessUnitPLValues : function(component, event, helper) {
        component.set('v.BusinessUnit', '');
        helper.setBusinessUnitPicklistDependentValues(component, helper);
    }
});
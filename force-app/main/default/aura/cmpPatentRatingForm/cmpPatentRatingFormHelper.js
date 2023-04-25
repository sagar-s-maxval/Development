({
    getReview : function(component, event, helper) {
        let action = component.get('c.getReview');

        let recordId = component.get('v.recordId');
        let userId = component.get('v.userId');
        let params = {
            patentId : recordId,
            userId : userId
        };

        helper.makeApexCall(component, event, helper, action, params, helper.setReview);
    },

    getPicklists: function(component, event, helper) {
        let action = component.get('c.getPicklistValues');
        let params = {};

        helper.makeApexCall(component, event, helper, action, params, helper.setPicklists);
    },

    getProducts: function(component, event, helper) {
        let action = component.get('c.getPatentProducts');
        let params = {
            linesIds: component.get('v.productLinesSelected')
        };
        helper.makeApexCall(component, event, helper, action, params, helper.setProducts);
    },

    getProductLines: function(component, event, helper) {
        let action = component.get('c.getProductLinesValues');
        let params = {
            selectedIds: component.get('v.productLinesSelected')
        };
        helper.makeApexCall(component, event, helper, action, params, helper.setProductLines);
    },

    setProductLines: function (component, event, helper, results) {
        component.set('v.productLines', results);
    },

    setProducts : function(component, event, helper, result) {
        let options = result.map(elem => ({'label': elem.Label__c, 'value' : elem.Id}));
        component.set('v.products', options);
    },

    setReview : function(component, event, helper, result) {
        if (result.Intensifying_Innovation__c) {
            component.set('v.q1', result.Intensifying_Innovation__c);
        }

        component.set('v.q2', result.CSO_Program_Name__c);
        component.set('v.q3', result.CSO_Innovative_Type__c);

        if (result.CSO_Top_Program__c) {
            component.set('v.q4', result.CSO_Top_Program__c);
        }
        component.set('v.productLinesString', result.Product_Lines__c);
        if (result.Product_Lines__c) {
            let action2 = component.get('c.getSelectedLinesByLabel');
            let string = result.Product_Lines__c.split(';');
            let params2 = {
                selectedLabels: string
            }
            helper.makeApexCall(component, event, helper, action2, params2, helper.setSplitLines);
        }
        component.set('v.productsString', result.Product_multiple__c);
        if (result.Product_multiple__c) {
            let action = component.get('c.getSelectedProductsByLabel');
            let string = result.Product_multiple__c.split(';');
            let params = {
                selectedLabels: string
            }
            helper.makeApexCall(component, event, helper, action, params, helper.setSplitProducts);
        }
        component.set('v.q5', result.CSO_NPI_Number__c);
        component.set('v.q6', result.CSO_Tech_Area_1__c);
        component.set('v.q7', result.CSO_Tech_Area_2__c);
        component.set('v.q8', result.Patent_Product__c);
        component.set('v.q9', result.Product_Line__c);
        component.set('v.q10', result.Taxonomy__c);
        component.set('v.q11', result.Case_Rating__c);
        component.set('v.ratingId', result.Id);
    },

    setPicklists : function(component, event, helper, results) {
        let innovationsTypes = results['CSO_Innovative_Type__c'].map(elem => ({'label' : elem, 'value' : elem}));
        let taxonomies = results['Taxonomy__c'].map(elem => ({'label' : elem, 'value' : elem}));
        let caseRatings = results['Case_Rating__c'].map(elem => ({'label' : elem, 'value' : elem}));

        component.set('v.InnovationTypes', innovationsTypes);
        component.set('v.Taxonomy', taxonomies);
        component.set('v.CaseRatings', caseRatings);
    },

    setSplitLines: function(component, event, helper, results) {
        component.set('v.productLinesSelected', results.map(elem => elem.value));
    },

    setSplitProducts: function(component, event, helper, results) {
        component.set('v.productsSelected', results.map(elem => elem.value));
    },

    handleProductLineChange: function(component, event, helper) {
        let linesSelected = component.get('v.productLinesSelected');
        let linesValues = component.get('v.productLines');

        let filteredValues = linesValues.filter(elem => !linesSelected.includes(elem.value));
        component.set('v.productLines', filteredValues);
    }
});
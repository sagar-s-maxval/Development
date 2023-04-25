({
    getReviews : function(component, event, helper) {
        let action = component.get('c.getReviews');

        let recordId = component.get('v.recordId');

        let params = {
            patentId : recordId
        };
        helper.makeApexCall(component, event, helper, action, params, helper.setReviews);
    },

    getPicklists: function(component, event, helper) {
        let action = component.get('c.getPicklistValues');
        let params = {};

        helper.makeApexCall(component, event, helper, action, params, helper.setPicklists);
    },

    setReviews : function(component, event, helper, result) {
//        let mappedResults = [];
//        for (let elem of result) {
//            let local = elem;
//            let array = local['Product_Lines__c'].split(';');
//            let mapped = array.map(newElem => ({'label': newElem}));
//            local['Product_Lines__c'] = mapped;
//            mappedResults.push(local);
//        }
//        console.log('Product Lines: ' + JSON.stringify(mappedResults));
console.log('RATINGS: ' + JSON.stringify(result));
        component.set('v.ratings', result);
    },

    setPicklists : function(component, event, helper, results) {
        let innovationsTypes = results['CSO_Innovative_Type__c'].map(elem => ({'label' : elem, 'value' : elem}));
        let taxonomies = results['Taxonomy__c'].map(elem => ({'label' : elem, 'value' : elem}));
        let caseRatings = results['Case_Rating__c'].map(elem => ({'label' : elem, 'value' : elem}));

        component.set('v.InnovationTypes', innovationsTypes);
        component.set('v.Taxonomy', taxonomies);
        component.set('v.CaseRatings', caseRatings);
    }
});
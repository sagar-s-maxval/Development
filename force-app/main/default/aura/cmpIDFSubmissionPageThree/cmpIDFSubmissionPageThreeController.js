({
    doInit : function(component, event, helper) {
        let radioOptions = [
            { label: 'Yes', value: 'Yes'},
            { label: 'No', value: 'No'},
            { label: 'Not sure', value: 'Not sure'}
        ];

        component.set('v.optionValues', radioOptions);
        helper.getPicklistsValues(component, event, helper);
        helper.makeApexCall(component, event, helper);
    },

    handleCategoryChange : function(component, event, helper) {
        let selectedValue = event.getParam('value');
        if (selectedValue) {
            let selectedValues = component.get('v.q9');
            selectedValues.push({label: selectedValue, name:selectedValue});

            component.set('v.q9', selectedValues);
            component.set('v.q9Value', null);

            let valuesString = selectedValues.map(elem => elem.name).join(';');
            component.set('v.q9String', valuesString);
            component.set('v.showOther', valuesString.includes('Other'));

            let options = component.get('v.categories')
                .filter(elem => elem.value !== selectedValue);
            component.set('v.categories', options);
        }
    },

    removeCategory: function(component, event, helper) {
//        let selectedItem = event.currentTarget.dataset.record;
        let selectedItem = event.getParam('item').name;

        let selectedValues = component.get('v.q9').filter(elem => elem.name !== selectedItem);
        component.set('v.q9', selectedValues);

        let valuesString = selectedValues.map(elem => elem.name).join(';');
        component.set('v.q9String', valuesString);
        component.set('v.showOther', valuesString.includes('Other'));
        console.log('Q9: ' + JSON.stringify(selectedValues));
        console.log('STRING: ' + valuesString);
        console.log('1) ' + valuesString.includes('Other'));
        if (!valuesString.includes('Other')) {
            component.set('v.otherComment', null);
        }

        let options = component.get('v.categories');
        options.push({label: selectedItem, value: selectedItem});

        component.set('v.categories', options);
        component.set('v.q9Value', null);
    },

    changeQ7: function(component, event, helper) {
        let newValue = component.get('v.q7');

        if (newValue !== 'Yes') {
            component.set('v.q7answer', null);
        }
    },

    changeQ8: function(component, event, helper) {
        let newValue = component.get('v.q8');

        if (newValue !== 'Yes') {
            component.set('v.q8answer', null);
        }
    },

    changeQ9: function(component, event, helper) {
        let newValue = component.get('v.q9');

        if (newValue.indexOf('Other') > -1) {
            component.set('v.otherComment', null);
        }
    },

    changeQ10: function(component, event, helper) {
        let newValue = component.get('v.q6');

        if (newValue !== 'Yes') {
            component.set('v.q6answer', null);
        }
    },

    changeQ11: function(component, event, helper) {
        let newValue = component.get('v.q16');

        if (newValue !== 'Yes') {
            component.set('v.q16answer', null);
        }
    },

    changeQ12: function(component, event, helper) {
        let newValue = component.get('v.q10');

        if (newValue !== 'Yes') {
            component.set('v.q10answer', null);
            component.set('v.q11answer', null);
        }
    },

    changeQ13: function(component, event, helper) {
        let newValue = component.get('v.q12');

        if (newValue !== 'Yes') {
            component.set('v.q12answer', null);
            component.set('v.q13answer', null);
        }
    },

    changeQ14: function(component, event, helper) {
        let newValue = component.get('v.q14');

        if (newValue !== 'Yes') {
            component.set('v.q14answer', null);
        }
    },

    changeQ15: function(component, event, helper) {
        let newValue = component.get('v.q15');

        if (newValue !== 'Yes') {
            component.set('v.q15answer', null);
        }
    },

    changeQ16: function(component, event, helper) {
        let newValue = component.get('v.q17');

        if (newValue !== 'Yes') {
            component.set('v.q17answer', null);
        }
    },
});
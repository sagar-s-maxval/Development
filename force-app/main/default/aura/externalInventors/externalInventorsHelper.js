({
    loadInventors: function(component, event, helper) {
        let action = component.get('c.getExternalInventors');
        let params = {
            recordId: component.get('v.idfId')
        };

        console.log(JSON.stringify(params));

        helper.makeApexCall(component, event, helper, action, params, helper.setInventors);
    },

    setInventors: function(component, event, helper, results) {
        component.set('v.inventors', results);
    },

    createExternalInventor: function(component, event, helper) {
        let name = component.get('v.name');
        let email = component.get('v.email');
        let comments = component.get('v.comments');

        let action = component.get('c.createInventor');
        let params = {
            name: name,
            email: email,
            comments: comments,
            recordId: component.get('v.idfId')
        };
        helper.makeApexCall(component, event, helper, action, params, helper.clearForm);

    },

    clearForm: function(component, event, helper, results) {
        if (!component.get('v.idfId')) {
            let inventorsCreated = component.get('v.inventorsCreated');
            inventorsCreated.push(results);
            component.set('v.inventorsCreated', inventorsCreated);
            component.set('v.inventors', inventorsCreated);
            console.log(inventorsCreated);
        } else {
            helper.loadInventors(component, event, helper);
        }
        component.set('v.email', '');
        component.set('v.name', '');
        component.set('v.comments', '');
        component.set('v.invalidEmail', false);
    },

    deleteAllExternals: function(component, event, helper) {
        let action = component.get('c.deleteAllExternals');
        let params = {
            recordId: component.get('v.idfId')
        };

        helper.makeApexCall(component, event, helper, action, params, helper.onDeleteSuccess);
    },

    onDeleteSuccess: function(component, event, helper, results) {
        component.set('v.email', '');
        component.set('v.name', '');
        component.set('v.comments', '');
        component.set('v.invalidEmail', false);
    },

    deleteInventor: function(component, event, helper, inventorId) {
        let action = component.get('c.deleteInventor');
        let params = {
            inventorId: inventorId
        }

        if (component.get('v.idfId')) {
            helper.makeApexCall(component, event, helper, action, params, helper.reloadData);
        } else {
            helper.makeApexCall(component, event, helper, action, params, helper.removeFromTheList);
            let inventors = component.get('v.inventorsCreated').filter(elem => elem.Id !== inventorId);
            component.set('v.inventors', inventors);
            component.set('v.inventorsCreated', inventors);
        }

    },

    reloadData: function(component, event, helper, results) {
        helper.loadInventors(component, event, helper);
    },

    removeFromTheList: function(component, event, helper, results) {

    }
});
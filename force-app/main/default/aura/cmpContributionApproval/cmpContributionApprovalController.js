({
    doInit : function(component, event, helper) {
        helper.getIDInventors(component, event, helper);
        helper.setColumns(component);
    },

    handleRowAction: function (component, event, helper) {
        let action = event.getParam('action');
        let row = event.getParam('row');
        let data = component.get('v.dataUser');
        data = data.map(function(rowData) {
            if (row.actionLabel === 'Confirmed') {
                rowData.actionLabel = 'Confirm';
            } else {
                rowData.actionLabel = 'Confirmed';
            }
            return rowData;
        });

        component.set("v.dataUser", data);

        helper.updateRecord(component, row.Id, row.actionLabel === 'Confirmed');
        component.set('v.isApproved', true);
    },

    handleCellChange: function(component,event, helper) {
        helper.saveContributions(component, event, helper);
    },
});
({
    doInit : function(component, event, helper) {
        
        component.set('v.vColumns', [
            {label: 'Docket No.', fieldName: 'Doclink', type: 'url',sortable: true,
             typeAttributes: {label: { fieldName: 'docketno' }, target: '_blank'}},
            {   label: 'Title',fieldName: 'title',type: 'title',sortable: true},
            {label: 'Business Unit', fieldName: 'bu', type: 'url',sortable: true,
             typeAttributes: {label: { fieldName: 'buname' }, target: '_blank'}},
            {label: 'Parent IDF', fieldName: 'ParentIDFID', type: 'url',sortable: true,
             typeAttributes: {label: { fieldName: 'ParentIDFname' }, target: '_blank'}},
            {label: 'Related Patent', fieldName: 'RelatedPatentID', type: 'url',sortable: true,
             typeAttributes: {label: { fieldName: 'RelatedPatentname' }, target: '_blank'}},
           // {   label: 'Parent IDF',fieldName: 'bu',type: 'text',sortable: true},
             // {   label: 'Related Parent',fieldName: 'bu',type: 'text',sortable: true},
            // {label: 'Firstnamed Inventor', fieldName: 'inventorid', type: 'url',sortable: true,
           //  typeAttributes: {label: { fieldName: 'inventor' }, target: '_blank'}},
         //   {   label: 'Inhouse counsel',fieldName: 'ic',type: 'text',sortable: true},
            {   label: 'Created Date',fieldName: 'Createddate',type: 'date',sortable: true}
        ]);
        
    
        
        helper.getIDFlist(component,event);
    },
    handleSort: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortDirection", sortDirection);
       helper.sortData(component, fieldName, sortDirection);
    }
})
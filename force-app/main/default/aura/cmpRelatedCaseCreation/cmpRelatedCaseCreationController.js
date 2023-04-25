({
    loadfamilyList: function(component, event, helper) {
        helper.onLoad(component, event);
        
    },
    
      handleSort : function(component,event,helper){
      //  var fieldName = event.getParam('fieldName');
        var sortDirection = component.get("v.sortDirection");
          if(sortDirection=='ASC')
              sortDirection='DESC';
          else
               sortDirection='ASC';              
        component.set("v.sortedBy", 'filingDate');
       // component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, event);
    },
     delete : function(component, event) {
   		//alert('pat id---->'+ event.target.id);
        var action = component.get("c.deletePat");
        action.setParams({PatId : event.target.id});
        action.setCallback(this, function(response) {
            if(response.getReturnValue() != null){
                alert(response.getReturnValue());
            }
            
         //window.location.reload();

        //$A.get('e.force:refreshView').fire();
        });
        $A.enqueueAction(action);
 },
     familyRefereshwin: function(component, event, helper) {        
         helper.onLoad(component, event);
     },
   
})
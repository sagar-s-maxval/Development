({
   
    
    openModel: function(component, event, helper) {
      // Set isModalOpen attribute to true
      component.set("v.isModalOpen", true);
        
   },
  
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
       window.open('https://tfip.lightning.force.com/lightning/o/Other_Matters__c/list?filterName=Recent','_top')
       
   },
    handleSuccess : function(component, event, helper) {
        const fields = event.getParam('fields');
        console.log("**"+JSON.stringify(fields));
        var name = fields.Name.value;
        component.find('notifLib').showToast({
            "variant": "success",
            "message": "Other Matters "+name+ " is created"
        });
        var payload = event.getParams("id"); 
		var navEvt = $A.get("e.force:navigateToSObject"); 
		navEvt.setParams({ "recordId": payload.id, "slideDevName": "Detail" }); 
		navEvt.fire();
    },
    
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
    
       var projx = component.get("v.projX");
       var projy = component.get("v.projY");
       var projz = component.get("v.projZ");
       console.log('value---->'+projx);
       console.log('value---->'+projy);
       console.log('value---->'+projz);
       component.set("v.isModalOpen", false);
       alert('Alert all the values will be cleared!')
       var warningToast = $A.get("e.force:showToast");
            var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'This is a warning message.',
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
       
   },
})
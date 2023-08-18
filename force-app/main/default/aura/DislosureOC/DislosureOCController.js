({
	doinit : function(component, event, helper) {
		console.log('Record ID-->'+component.get("v.recordId"));
         var action = component.get('c.getlawfirm'); 
        action.setParams({
            "recordid" : component.get("v.recordId") 
            
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success-->'+a.getReturnValue());
                component.set("v.lawfirms",a.getReturnValue());
               var idr= component.get("v.recordId");
                component.set("v.selectedValue",a.getReturnValue())
                console.log('record id-->'+idr);
                helper.getoutcounsel(component); 
                
               // component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
        
	},
    change: function(component, event, helper) {
        // alert(event.getParam("value"));
       // console.log('Event -->'+event.target.value);
        // console.log('Event -->'+component.get("v.selectedValue"));
        var se=component.find('selectedlaw').get("v.value");
        component.set("v.selvalue",se);
       console.log('val -->'+se);
        var selvall=component.get("v.selvalue");
          var action = component.get('c.getousidecounsel'); 
        action.setParams({
            "lawfirm" : selvall ,"recordid" :component.get("v.recordId") 
            
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('ouside counsel s-->'+a.getReturnValue());
                component.set("v.outsidecounsel",a.getReturnValue());
             //    $A.get('e.force:refreshView').fire();
              // var idr= component.get("v.recordId");
              //  component.set("v.selectedValue",a.getReturnValue())
               // console.log('record id-->'+idr);
               // component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
    },
    changecounsel: function(component, event, helper) {
         var se=component.find('selectoutside').get("v.value");
       component.set("v.selcounsel",se);
       console.log('val -->'+se);
          var action = component.get('c.updatedisclosure'); 
        action.setParams({
            "outcounsel" : se ,"recordid" :component.get("v.recordId") 
            
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
             console.log('success-->'+state);
            if(state == 'SUCCESS') {
                $A.get('e.force:refreshView').fire();
                console.log('ouside counsel s-->'+a.getReturnValue());
                if(a.getReturnValue()=='success'){
                    console.log('success');
                }
            }
        });
        $A.enqueueAction(action);
    }
})
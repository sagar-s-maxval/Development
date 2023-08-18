({
	getoutcounsel : function(component) {
		 var action = component.get('c.getlawcounsel'); 
        action.setParams({
            "recordid" : component.get("v.recordId") 
            
        });
        action.setCallback(this, function(a){
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                console.log('success helper method-->'+a.getReturnValue());
                component.set("v.outsidecounsel",a.getReturnValue());
               
                
               // component.set('v.sObjList', a.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	}
})
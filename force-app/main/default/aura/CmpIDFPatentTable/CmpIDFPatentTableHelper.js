({
     sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.IDFList");
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        data.sort(function(a,b){ 
            var a = key(a) ? key(a).toLowerCase() : '';
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a>b) - (b>a));
        });    
        component.set("v.IDFList",data);
    },
	getIDFlist: function (component, event) {
        console.log('HEre'+component.get('v.recordId'));
         let action = component.get('c.getidfinfo');
        action.setParams({
            recordId: component.get('v.recordId')
        });
        action.setCallback(
            this,
            $A.getCallback(
                function(response) {
                    let state = response.getState();
                    let result = response.getReturnValue();
                     if (state === "SUCCESS") {
                          console.log('HEre reslt is'+JSON.stringify(result));
                          component.set("v.IDFList",result);
                        if(result!=''){
                             
                         }
                    } else if (state === "ERROR") {
                        let errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
    }
})
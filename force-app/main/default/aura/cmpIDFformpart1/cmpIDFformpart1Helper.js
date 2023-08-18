({
    
    getBusinessSegment : function(component,event) {
       // alert('MySelection:');
       var action = component.get('c.getBusinessSegment');
       action.setCallback
       (
           this,
           $A.getCallback
           (
               function (response) 
               {
                   var state = response.getState();
                   if (state === "SUCCESS") 
                   {
                       
                       component.set('v.ManagingSegments', response.getReturnValue());
                   } 
                   else if (state === "ERROR") 
                   {
                       var errors = response.getError();
                       console.error(errors);
                   }
               }
           )
       );
       $A.enqueueAction(action);
   },
    /*   getinventor : function(component,event) {
        // alert('MySelection:');
        var action = component.get('c.getinventors');
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        // alert(response.getReturnValue());
                        component.set('v.invcon', response.getReturnValue());
                        var inven=JSON.stringify(response.getReturnValue()[0].Id); 
                        var invid= inven.substring(1,inven.length - 1);
                        component.set('v.selectedinv',invid); 
                        
                        //  alert('mentor'+invid);
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },
    getMentor : function(component,event) {
        // alert('MySelection:');
        var action = component.get('c.getmentor');
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        // alert(response.getReturnValue());
                        
                        component.set('v.mencon', response.getReturnValue());
                     /*   var mentor=JSON.stringify(response.getReturnValue()[0].Id); 
                        var mentorid= mentor.substring(1,mentor.length - 1);
                        // alert('mentor'+mentorid);
                        component.set('v.selectedmen',mentorid);
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },
    getPrimary : function(component,event) {
        // alert('MySelection:');
        var action = component.get('c.getprimary');
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        //alert(JSON.stringify(response.getReturnValue()));
                        component.set('v.pri', response.getReturnValue());
                   /*     var pricon=JSON.stringify(response.getReturnValue()[0].Id); 
                        var priconid= pricon.substring(1,pricon.length - 1);
                        component.set('v.selectedpri',priconid); 
                        
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
    }, */
    
    
})
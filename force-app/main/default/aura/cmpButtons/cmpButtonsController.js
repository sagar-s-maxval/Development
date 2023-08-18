({
     init: function(component, event, helper) {
         
          var rating = component.get("v.RatingVal");
        //alert('Rating Val--->'+rating);
         if((rating === '')||( rating === undefined) || (rating === null))
         {
             component.set("v.CheckCancel",true);
            // alert("executed Inside if");
         }
         else
         {
             component.set("v.CheckCancel",false);
            //  alert("executed  out if");
         }
         
     },
	 handleEdit : function(component, event, helper) 
    {
       var response = event.getSource().getLocalId();
        //  alert('Response>>>'+response);
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
        //console.log('navigate'+navigate)
        if(response=='EditId')
        {
            navigate("NEXT");
        }
        
    },
    handleCancel  : function(component, event, helper) 
    {      
        var response = event.getSource().getLocalId();
       
    //   alert('Response>>>'+response);
        component.set("v.value", response);
        var navigate = component.get("v.navigateFlow");
     //  alert('navigate'+navigate)
        if(response=='BACK')
        {
         // alert(response);
            navigate(response);
       }
        
     
    }
    
})
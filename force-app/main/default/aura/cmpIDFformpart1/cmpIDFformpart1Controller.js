({
    init: function(component, event, helper) {
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
        var today2 = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today2', today2);
        var today3 = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today3', today3);
        var today4 = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today4', today4);
        
        
        
        helper.getBusinessSegment(component,event);
     /*   helper.getinventor(component,event);
        helper.getMentor(component,event);
        helper.getPrimary(component,event); */
       
        
        component.set('v.pathBoolean', true);
        component.set("v.check",  component.get("v.check"));
         component.set("v.option2", component.get("v.option2"));
        
        //alert(component.get('v.Title'));
        /*if(component.get("v.selectedtech")!="")
                {   
                    //alert('dfsf'+ component.get("v.selectedtech"));
                    component.set('v.pathBoolean', true);
                }*/
        
        
        
        /*var SelectedPath = component.find("ddlPath").get("v.value");
        if(SelectedPath != null)
        {
            var optPaths = component.get("v.optPaths"), 
            value = component.find("contactList").get("v.value"),
            index = contacts.findIndex(item => item.Id == value),
            contactName = index >= 0? contacts[index].Name: null;
            alert('PathName'+PathName);
        }*/
    },
    
    AssignTitle : function(component, event, helper)
    {
        var titleinv = component.find("titleId").get("v.value");
        component.set("v.Title", titleinv);
        //alert("Main cmp value-->"+component.get("v.Title"));
        var cmpEvent = $A.get("e.c:IDFTitleEvent");  
        cmpEvent.setParams({"InventionTitle" :titleinv}); 
        cmpEvent.fire();
        //   alert("fired Title");
    }, 
     
    AssignSummary : function(component, event, helper)
    {
        var Summaryinv = component.find("SummaryId").get("v.value");
        component.set("v.Summary", Summaryinv);
        //alert("Main cmp value-->"+component.get("v.Title"));
        var cmpEvent = $A.get("e.c:IDFSummaryEvent");  
        cmpEvent.setParams({"InventionSummary" :Summaryinv}); 
        cmpEvent.fire();
        //   alert("fired Summary");
    }, 
        
    
    checking : function (component, event, helper) 
    {
      
        var checked = component.find("check").get("v.checked");
        var optionn = component.find("option2").get("v.checked");
        if(checked==true){
             component.set("v.check", true);
             component.set("v.option2", false);
             }
           
       // alert(changeValue);
    },
    
    uncheckfirst : function (component, event, helper) 
    {
        var optionn = component.find("option2").get("v.checked");
        if(optionn==true){
            component.set("v.option2", true);
            component.set("v.check", false);
        }
           
       // alert(changeValue);
    },
    
   
    
 /*   currentinv : function (component, event, helper) {
        var Selectedinv = component.find("invId").get("v.value");
        component.set("v.selectedinv", Selectedinv);
    },  
    currentmen : function (component, event, helper) {
        var Selectedinv1 = component.find("mentorId").get("v.value");
        component.set("v.selectedmen", Selectedinv1); 
    }, */
/*    priInv : function (component, event, helper) {
        var Selectedinv1 = component.find("priId").get("v.value");
        //alert('Pri Inv -->'+Selectedinv1);
        component.set("v.selectedpri", Selectedinv1);
        var cmpEvent = $A.get('e.c:IDFPrimaryInventorEvent');
        cmpEvent.setParams({"PrimaryInventor" : Selectedinv1});
        cmpEvent.fire();
    } */
    
    SetManagingSegment : function (component, event, helper) 
	{
        var SelectedManagingSeg = component.find("ManagingSeg").get("v.value");
        component.set("v.selectedManagingSegment", SelectedManagingSeg);
        console.log('BS===='+SelectedManagingSeg);
        var cmpEvent = $A.get('e.c:IDFManagingSegment');
        cmpEvent.setParams({"ManagingSegment" : SelectedManagingSeg});
        cmpEvent.fire();
    }
    
})
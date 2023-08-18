({
    loadValuesController : function(component,event,helper) {
        var isedit = '';
        helper.getprbtechenablestatus(component,event);
        helper.getManagingSegments(component,event);
        if(component.get("v.DisclosureId")!=false && component.get("v.DisclosureId")!=null && component.get("v.DisclosureId") != undefined)
        {
        isedit=component.get("v.DisclosureId");    
        }
        else 
        {
            isedit='';
        }
        if(component.get("v.DisclosureId") != undefined)
        helper.getPath(component,event,helper,isedit);
        helper.getstage(component,event);
        if(component.get("v.DisclosureId")!=false && component.get("v.DisclosureId")!=null )
        {  
             helper.getManagingSegments(component,event);
         
        
           //  helper.getManagingSegments(component,event); // Managing segments
             component.set('v.pathBoolean', true);
            var action = component.get('c.populateAdditionalInventors');
            action.setParams({ DisclosureId : component.get("v.DisclosureId") });
            action.setCallback
            (this,$A.getCallback
             ( function (response)
              {  
                  var state = response.getState();
                 
                  var result = response.getReturnValue();
                
                  //alert(JSON.stringify(state));
                  
                  //   alert(result.length +"len");
                  if(result.length > 0){
                      if (state === "SUCCESS")
                      {  
                          
                          component.set("v.lstSelectedInventors", result);
                          var selectedInventorId;
                          var arrSelectedInventorIdsValue =[];
                          //var i;
                          for(var i=0;i<result.length;i++)
                          {  
                              selectedInventorId=result[i].name;
                              //alert('selectedInventorId-----------'+selectedInventorId);
                              arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
                              arrSelectedInventorIdsValue.push(selectedInventorId);
                          }
                          component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue);
                          component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue.join(","));
                      }
                      
                  }
                  else if (state === "ERROR")
                  {
                      var errors = response.getError();
                      //alert(JSON.stringify(errors));
                      console.error(errors);
                  }
              }
             )
            )
            
           var action1 = component.get('c.otherpopulateAdditionalInventors');
            action1.setParams({ DisclosureId : component.get("v.DisclosureId") });
            action1.setCallback
            (this,$A.getCallback
             ( function (response)
              {  
                  var state = response.getState();
                  var result = response.getReturnValue();
                  //alert(JSON.stringify(result[0].name));
                  //alert(result.length +"len");
                  if(result.length > 0){
                      if (state === "SUCCESS")
                      {  
                          component.set("v.otherlstSelectedInventors", result);
                          console.log('check value=='+result);
                          var selectedInventorId;
                          var arrSelectedInventorIdsValue =[];
                          //var i;
                          for(var i=0;i<result.length;i++)
                          {  
                              selectedInventorId=result[i].name;
                              //alert('selectedInventorId-----------'+selectedInventorId);
                              arrSelectedInventorIdsValue = component.get("v.otherSelectedInvIds");
                              arrSelectedInventorIdsValue.push(selectedInventorId);
                          }
                          component.set("v.otherSelectedInvIds", arrSelectedInventorIdsValue);
                          component.set("v.otherSelectedInvIds", arrSelectedInventorIdsValue.join(","));
                      }
                      
                  }
                  else if (state === "ERROR")
                  {
                      var errors = response.getError();
                      //alert(JSON.stringify(errors));
                      console.error(errors);
                  }
              }
             )
            )
             $A.enqueueAction(action1);
            $A.enqueueAction(action);
        }
          helper.getValues(component,event,helper);
    },
    
    searchInventorsController : function(component, evt, helper) {
        var isEscKey = evt.keyCode === 27;
        if (isEscKey)
        {
            component.set('v.isShowSearchResult',false);
        }
        else {
            var txtselectedintorsid = component.find("txtsearchinventors").get("v.value");
            var arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
            helper.searchInventorsHelper(component, txtselectedintorsid, arrSelectedInventorIdsValue);
        }
        
    },
    
    othersearchInventorsController : function(component, evt, helper) {
        var isEscKey = evt.keyCode === 27;
        if (isEscKey)
        {
            component.set('v.otherisShowSearchResult',false);
        }
        else {
            var txtselectedintorsid = component.find("othertxtsearchinventors").get("v.value");
            var arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
            //alert(arrSelectedInventorIdsValue);
            
            helper.othersearchInventorsHelper(component, txtselectedintorsid, arrSelectedInventorIdsValue);
        }
        
    },
    getSelectedInventorsController: function(component, event, helper) 
    {
        
        var selectedInventorId = component.find("lstAvailableInventors").get("v.value");
        //  alert('selectedInventorId----'+selectedInventorId);
        var arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
        arrSelectedInventorIdsValue = [];
        arrSelectedInventorIdsValue.push(selectedInventorId);
        //   alert('arrSelectedInventorIdsValue------'+arrSelectedInventorIdsValue)
        component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue);
        //    alert('arrSelectedInvIds'+ component.get("v.arrSelectedInvIds"));
        component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
        //alert('primary '+component.get("v.strSelectedInventorIds"));
        component.set('v.isShowSearchResult',false);
        var selectedinv = component.get("v.arrSelectedInvIds");
         //alert(selectedinv);
        helper.getSelectedInventorsHelper(component, selectedinv);
        component.find('txtsearchinventors').set('v.value','');
        component.find('txtsearchinventors').focus();
        component.set("v.inputdisable", true); 
        //component.set("v.strSelectedInventorIds", "v.lstSelectedInventors.id");
        //var Ans2=component.find("txtSearchInventors").get("v.value");
        //component.set("v.strSelectedInvIds", Ans2);
      //  alert('value: '+component.get("v.strSelectedInvIds"));
        
        
    },
    
    othergetSelectedInventorsController: function(component, event, helper) 
    {
        
        var selectedInventorId = component.find("otherlstAvailableInventors").get("v.value");
        //  alert('selectedInventorId----'+selectedInventorId);
        var arrSelectedInventorIdsValue = component.get("v.otherSelectedInvIds");
        arrSelectedInventorIdsValue = [];
        arrSelectedInventorIdsValue.push(selectedInventorId);
        //   alert('arrSelectedInventorIdsValue------'+arrSelectedInventorIdsValue)
        component.set("v.otherSelectedInvIds", arrSelectedInventorIdsValue);
        //    alert('arrSelectedInvIds'+ component.get("v.arrSelectedInvIds"));
        component.set("v.otherstrSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
        //alert('primary '+component.get("v.strSelectedInventorIds"));
        component.set('v.otherisShowSearchResult',false);
        var selectedinv = component.get("v.otherSelectedInvIds");
        //alert(selectedinv);
        helper.othergetSelectedInventorsHelper(component, selectedinv);
        component.find('othertxtsearchinventors').set('v.value','');
        component.find('othertxtsearchinventors').focus();
        component.set("v.inputdisable", true); 
        
        
    },
    
    removeSelectedInventorsController: function (component, event) 
    {
        var selectedInventorId = event.getParam("item").name;
        
        // Remove the pill from view
        var items = component.get('v.lstSelectedInventors');
        var item = event.getParams("index");
        items.splice(item, 1);
        component.set('v.lstSelectedInventors', items); 
        
        var arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
        var index = arrSelectedInventorIdsValue.indexOf(selectedInventorId);
        if (index > -1) {
            arrSelectedInventorIdsValue.splice(index, 1);
        }
        component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue);
        component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
        //component.set("v.strSelectedInventorIds",'');
    },
    removeOtherSelectedInventorsController: function (component, event) 
    {
        var selectedInventorId = event.getParam("item").name;
        
        // Remove the pill from view
        var items = component.get('v.otherlstSelectedInventors');
        var item = event.getParams("index");
        items.splice(item, 1);
        component.set('v.otherlstSelectedInventors', items); 
        
        var arrSelectedInventorIdsValue = component.get("v.arrOtherSelectedInvIds");
        var index = arrSelectedInventorIdsValue.indexOf(selectedInventorId);
        if (index > -1) {
            arrSelectedInventorIdsValue.splice(index, 1);
        }
        component.set("v.arrOtherSelectedInvIds", arrSelectedInventorIdsValue);
        component.set("v.otherstrSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
    },
    SetManagingSegment : function (component, event, helper) 
    {
        var SelectedManagingSeg = component.find("ManagingSeg").get("v.value");
        component.set("v.selectedManagingSegment", SelectedManagingSeg);
        //var cmpEvent = $A.get('e.c:IDFManagingSegment');
        var cmpEvent = $A.get('e.c:ManagementEvent');
        cmpEvent.setParams({"ManageSegment" : SelectedManagingSeg});
        cmpEvent.fire();
    },
    DCB : function(component, event, helper)
    {
        var text = component.find("comment").get("v.value"); 
        var cmpEvent = $A.get('e.c:IDFOtherContribution');
        cmpEvent.setParams({"otherContribution" : text});
        cmpEvent.fire();
        component.set("v.OtherContribution",text);
    },
    DCBP : function(component, event, helper)
    {
        var text2 = component.find("newproblem").get("v.value"); 
        //alert('value-->'+text);
        component.set("v.OtherBusinessProblem",text2);
         var cmpEvent = $A.get('e.c:IDFOtherBusinessProblem');
        cmpEvent.setParams({"OtherBusinessProblem" : text2});
        cmpEvent.fire();
    },
    ChangeOtherSegment : function(component, event, helper){
        var SelectedValue=component.get('v.DevelopedforOtherSegment');
        console.log('SelectedValue=='+SelectedValue);
        if(SelectedValue=='No'){
            component.set('v.selectedManagingSegment','');         
            component.set('v.OtherContribution','');
            component.set('v.otherlstSelectedInventors',[]);
            component.set('v.otherContactPill',false);           
            var cmpEvent = $A.get("e.c:IDFOtherBusinessSegment");  
            cmpEvent.setParams({"otherSelectedInventors" :''}); 
            cmpEvent.fire();       
        } 
        //Pass Selected value to SaveAndAsubmit
        var cmpEvent1 = $A.get("e.c:IDFDevelopedForOtherSegment");  
        cmpEvent1.setParams({"IDFDevelopedForOtherSegment" :SelectedValue}); 
        cmpEvent1.fire();   
    },
    setSelectedPath : function (component, event, helper) {
        var SelectedPath = component.find("ddlPath").get("v.value");
        component.set("v.selectedtech", SelectedPath);
      // alert('path--'+SelectedPath);
        var cmpEvent = $A.get("e.c:IDFPathEvent");  
        cmpEvent.setParams({"InventionPath" :SelectedPath}); 
        cmpEvent.fire();
        //alert('fired Path');
    },
    setstage : function (component, event, helper) {
        var Selectedstage = component.find("stage").get("v.value");
        //alert(Selectedstage+'Selectedstage');
        component.set("v.selectedstage", Selectedstage);
        var cmpEvent = $A.get('e.c:IDFCurrentStageOfInvention');
        cmpEvent.setParams({"CurrentStageOfInvention" : Selectedstage});
        cmpEvent.fire();
        //alert('fired Current stage of inv');
    }
})
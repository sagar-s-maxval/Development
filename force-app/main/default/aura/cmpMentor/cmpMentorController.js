({
    loadValuesControllers : function(component,event,helper) {
        console.log('onload');
        console.log('ID'+component.get("v.DisclosureIds"));
        if(component.get("v.DisclosureIds")!="false" && component.get("v.DisclosureIds")!=null )
        {  
            //alert('DisclosureId id addinv --->'+component.get("v.DisclosureIds"));
            var action = component.get('c.populateMentor');
            action.setParams({DisclosureIds : component.get("v.DisclosureIds")});
           //  alert('test'+action);
            //   alert('test2');
            action.setCallback
            (this,
             $A.getCallback
             ( function (response)
              {  
                  var state = response.getState();
                  console.log('state'+state);
                  var result = response.getReturnValue();
                  // alert('state'+result);
                  console.log('result---'+JSON.stringify(result));
                  if(state === "SUCCESS")
                  {  
                         //alert(JSON.stringify(result));
                      //alert(result.length +"len");           
                      if(result.length > 0)
                      {
                          component.set("v.lstSelectedInventors", result);
                           //alert('result---'+ JSON.stringify(result));
                          var selectedInventorId;
                          var arrSelectedInventorIdsValue;
                           // alert('arrSelectedInventorIdsValue'+arrSelectedInventorIdsValue);
                          var i;
                          for(i=0;i<result.length;i++)
                          {  
                              selectedInventorId=result[i].name;
                              arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
                              arrSelectedInventorIdsValue.push(selectedInventorId);
                          }
                          component.set("v.arrSelectedInventorIds", arrSelectedInventorIdsValue);
                          // alert('list of ids----'+component.get("v.arrSelectedInventorIds"));
                          component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
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
            $A.enqueueAction(action);
        }
        
    },
    searchInventorsController: function (component, evt, helper)
    	{
      		 var isEscKey = evt.keyCode === 27;
       		 if (isEscKey)
        		{
            		   // alert('xdf');
          		  component.set('v.isShowSearchResult',false);
       		    }
        else
        	{
                var txtSearchInventors = component.find('txtSearchInventors').get('v.value');
               // alert(txtSearchInventors+'txtSearchInventors');
                
                var arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
               // alert(component.get("v.arrSelectedInventorIds")+'arrSelectedInventorIdsValue');
                helper.searchInventorsHelper(component, txtSearchInventors, arrSelectedInventorIdsValue);
            }
   	 },
    
    removeSelectedInventorsController: function (component, event)
    {
        var selectedInventorId = event.getParam("item").name;
        
        // Remove the pill from view
        var items = component.get('v.lstSelectedInventors');
        var item = event.getParam("index");
        items.splice(item, 1);
        component.set('v.lstSelectedInventors', items);      
        var arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
        component.set("v.strRemovedInventorIds", arrSelectedInventorIdsValue.join(","));
        console.log('hhh'+arrSelectedInventorIdsValue.join(","));
        var index = arrSelectedInventorIdsValue.indexOf(selectedInventorId);
        if (index > -1)
            {
                arrSelectedInventorIdsValue.splice(index, 1);
            }
        component.set("v.arrSelectedInventorIds", arrSelectedInventorIdsValue);
        var removedInv = component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
        
        
    },
    
    getSelectedInventorsController: function(component, event, helper)
    {
        var selectedInventorId = component.find("lstAvailableInventors").get("v.value");
      // alert(selectedInventorId+'selectedInventorId');
        var arrSelectedInventorIdsValue = component.get("v.arrSelectedInventorIds");
        arrSelectedInventorIdsValue.push(selectedInventorId);
       // alert('----'+arrSelectedInventorIdsValue);
        component.set("v.arrSelectedInventorIds", arrSelectedInventorIdsValue);
       //alert(component.get("v.arrSelectedInventorIds")+'arrSelectedInventorIdsValue');
        component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
      // alert(component.get("v.strSelectedInventorIds")+'-------selectedInventorId');
        component.set('v.isShowSearchResult',false);
        //alert('---------->'+ component.get("v.strSelectedInventorIds"));
        helper.getSelectedInventorsHelper(component, component.get("v.arrSelectedInventorIds"));
        component.find('txtSearchInventors').set('v.value','');
        component.find('txtSearchInventors').focus();
        //helper.getSelectedInventorsHelper(component);
        //alert('Values:' + component.get("v.arrSelectedInventorIds"));
    }
    
})
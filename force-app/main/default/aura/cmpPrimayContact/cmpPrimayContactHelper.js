({
    
    searchInventorsHelper : function  (component, txtSearchWord, arrSelectedInventorIds)  {
        
        var action = component.get('c.searchInventors');
        action.setParams({ searchword : txtSearchWord, inventorIds : arrSelectedInventorIds });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function(response)
                {
                    //alert("triggered");
                    var state = response.getState();
                    var result = response.getReturnValue();
                    
                    if(state === "SUCCESS")
                    {
                        if(result.length > 0)
                        {
                            component.set('v.isShowSearchResult',true);
                            component.find("lstAvailableInventors").set("v.options", result);
                        }
                        else
                        {
                            component.set('v.isShowSearchResult',false);
                        }
                        
                    }
                }
            )
        );
        
        $A.enqueueAction(action);
    },

 othersearchInventorsHelper : function  (component, txtSearchWord, arrSelectedInventorIds)  {
        var action = component.get('c.othersearchInventors');
        action.setParams({ searchword : txtSearchWord, inventorIds : arrSelectedInventorIds });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function(response)
                {
                    var state = response.getState();
                    var result = response.getReturnValue();
                    
                    if(state === "SUCCESS")
                    {
                        console.log('length=='+result.length);
                        console.log('result'+result);
                        if(result.length > 0)
                        {
                            component.set('v.otherisShowSearchResult',true);
                            component.find("otherlstAvailableInventors").set("v.options", result);
                        }
                        else
                        {
                            component.set('v.otherisShowSearchResult',false);
                        }
                        
                    }
                }
            )
        );
        
        $A.enqueueAction(action);
    },
        
    getSelectedInventorsHelper : function(component, selectedinv) 
    {
        var action = component.get('c.getSelectedInventors');
        action.setParams({ inventorIds : selectedinv });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    //alert(JSON.stringify(response.getReturnValue()));
                    var state = response.getState();
                    var result = response.getReturnValue();
                    //var auotpopval = component.find('txtSearchInventors').get('v.value');
                    if (state === "SUCCESS") 
                    {
                       //alert('test'+JSON.stringify(result));
                        console.log('in primary contact selected=='+result);
                        component.set('v.lstSelectedInventors', result);
                        //alert(component.get('v.lstSelectedInventors'));
                        //var Primary = result;
                       // alert(Primary[0].name);
                        
                      // alert(result[0].label);
                        component.set('v.strSelectedInventorIds',result[0].name);
                      //  alert(component.get('v.strSelectedInventorIds'));
                        // component.set('v.strSelectedInvIds',result[0].Id);
                       // alert(component.get('v.strSelectedInvIds'));
                       //alert('selected inventor name:'+ component.get('v.strSelectedInventorIds'));
                        var returnValue = component.get("v.strSelectedInventorIds");
                        
                        var cmpEvent = $A.get("e.c:IDFPrimaryContactEvt");  
                        cmpEvent.setParams({"PrimaryContact" :result}); 
                        cmpEvent.fire();
                        
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        //alert(JSON.stringify(errors));
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
        
    },
    
    othergetSelectedInventorsHelper : function(component, selectedinv) 
    {
        var action = component.get('c.othergetSelectedInventors');
        console.log('selectedinv='+selectedinv);
        action.setParams({ inventorIds : selectedinv });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    //alert(JSON.stringify(response.getReturnValue()));
                    var state = response.getState();
                    var result = response.getReturnValue();
                    //var auotpopval = component.find('txtSearchInventors').get('v.value');
                    if (state === "SUCCESS") 
                    {
                       //alert('test'+JSON.stringify(result));
                       console.log('in other contact selected=='+JSON.stringify(result));
                        component.set('v.otherlstSelectedInventors', result);
							// component.set('v.otherContactPill',true);
                       //alert('result[0].Name'+result[0].name);
                        component.set('v.otherstrSelectedInventorIds',result[0].name);
                       //alert('selected inventor name:'+ component.get('v.strSelectedInventorIds'));
                        var returnValue = component.get("v.otherstrSelectedInventorIds");
                         var cmpEvent = $A.get("e.c:IDFOtherBusinessSegment");  
                          cmpEvent.setParams({"otherSelectedInventors" :result}); 
                          cmpEvent.fire();
                        
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        //alert(JSON.stringify(errors));
                        console.error(errors);
                    }
                }
            )
        );
        $A.enqueueAction(action);
        
    },
   
    getstage : function(component,event) {
         
        var action = component.get('c.getstage');
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
                         //alert(response.getReturnValue());
                        component.set('v.stages', response.getReturnValue());
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
    
    //Managing Segments
    getManagingSegments : function(component,event) {
        
        var action = component.get("c.getManagingSegment");
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
                        console.log('managing segment=='+response.getReturnValue());
                        if( response.getReturnValue()==''){
                        component.set('v.DevelopedforOtherSegment','NO');
                        }
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
    getPath : function(component,event,helper,isedit) {
       console.log('path called' + isedit);
        //alert('ess'+isedit);
        var action = component.get("c.getpaths");
        action.setParams({'editviewID':isedit});
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    //alert('state'+state);
                    if(state == "SUCCESS") 
                    {
                     //alert('test'+JSON.stringify(response.getReturnValue()));
                        //alert('newtest'+component.get('v.selectedtech'));
                        var res=response.getReturnValue();
                        component.set('v.optPaths',res.listPath);
                        component.set('v.pathselected',res.TechPath);
                        
                        //alert('----'+component.get('v.pathselected'))

                        //   var ab=JSON.stringify(response.getReturnValue()[0].Id);
                        //    ab = ab.substring(1, ab.length - 1);
                        //   component.set('v.ans2',ab);
                        
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        //alert('errors'+JSON.stringify(errors));
                        console.error(errors);
                        console.log('tech'+JSON.stringify(errors)); 
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },
    
    getprbtechenablestatus : function(component,event) {
        var action = component.get("c.getprbtechenablestatusctr");
        action.setParams({'recid':component.get('v.DisclosureId')});
        console.log('-id-'+component.get('v.DisclosureId'));
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    console.log('---'+state);
                    if (state === "SUCCESS") 
                    {
                     //alert('Testing'+response.getReturnValue());  
                        component.set('v.isprbtechdisabled', response.getReturnValue());
                        
                    } 
                    else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        console.error('errors'+errors);
                        console.log('errors'+JSON.stringify(errors));
                    }
                }
            )
        );
        $A.enqueueAction(action);
    },
    
    getValues: function(component,event) {
        var action = component.get("c.getValues");
        action.setParams({ DisclosureId : component.get("v.DisclosureId") });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    var state = response.getState();
                    var result = response.getReturnValue();
                    console.log('get values=='+JSON.stringify(result));
                    if (state === "SUCCESS"){
                        if(result ===null ){
                            component.set('v.DevelopedforOtherSegment','No');
                            //Pass Selected value to SaveAndAsubmit
                                var cmpEvent = $A.get("e.c:IDFDevelopedForOtherSegment");  
                                cmpEvent.setParams({"IDFDevelopedForOtherSegment" :'No'}); 
                                cmpEvent.fire();
                            component.set('v.otherlstSelectedInventors',[]);
                                console.log('get values=='+JSON.stringify(result));
                                }
                    } else if (state === "ERROR") 
                    {
                        var errors = response.getError();
                        console.error(errors);
                    }
                } 
            )
        );
        $A.enqueueAction(action);
    }
})
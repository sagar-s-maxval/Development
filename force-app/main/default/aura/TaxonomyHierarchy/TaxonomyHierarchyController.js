({  showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
     component.set('v.loaded', !component.get('v.loaded'));
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();
    },

    hideSpinner : function (component, event, helper) {
        component.set('v.loaded', !component.get('v.loaded'));
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();
    },
    
    
    
    
    
    
    
    chekfalse: function(component, event, helper) {
     console.log('coming in');
       var selectedId= event.getSource().get("v.text"); 
   // console.log('recid-->'+checkCmp.get("v.text"));
     var action = component.get('c.updatefalsewords');
      action.setParams({"recordId":selectedId});
      action.setCallback(this,function(response){
            var state = response.getState();
         console.log(response.getReturnValue());
        if(response.getReturnValue() === 'success')
        {  
            console.log('coming in');
        $A.get('e.force:refreshView').fire();
       }
     
     });
        $A.enqueueAction(action);
    
    
    
},
  chekkey:  function(component, event, helper) {
    var checkCmp = component.find("checkbox");
        var selectedId='';
      selectedId= event.getSource().get("v.text"); 
      console.log(selectedId);
      console.log('coming in 55');
      console.log('coming in '+selectedId);
  // var recid=checkCmp.get("v.text");
    //  console.log('coming in 66'+recid);
  //  console.log('recid-->'+checkCmp.get("v.text"));
     var action = component.get('c.updateKeywords');
      action.setParams({"recordId":selectedId});
     action.setCallback(this,function(response){
            var state = response.getState();
         console.log(response.getReturnValue());
        if(response.getReturnValue() === 'success')
        {  
            console.log('coming in');
        $A.get('e.force:refreshView').fire();
       }
     
     });
        $A.enqueueAction(action); 
    
},
    redirecttolist:  function(component, event, helper) {
        
          var relatedListEvent = $A.get("e.force:navigateToRelatedList");
    relatedListEvent.setParams({
        "relatedListId": "SymphonyIPM__Keyword_Association__r",
        "parentRecordId": component.get("v.recordId")
    });
    relatedListEvent.fire();
    },
    
    doInit : function(component, event, helper) {
       // const username = component.get('v.CurrentUser')['Profile'].Name;
       // console.log('Current user profile name:'+username);
        component.set('v.columns', [
            { label: 'Name', fieldName: 'Name', type: 'text' },
            { label: 'Description', fieldName: 'Description__c', type: 'text' },
            { label: 'Comments', fieldName: 'Comments__c', type: 'text' },
        ]);
		//helper.getFiltersData(component);
		helper.getchildHierarchyData(component);
        var action = component.get('c.fetchKeywords');
        action.setParams({"recordId":component.get('v.recordId')});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            component.set("v.responseMessage",response.getReturnValue());
            
            var rspMsg=response.getReturnValue();
            //console.log(rspMsg);
            var result = JSON.parse(rspMsg);
            //keywordslist
            if(state === 'SUCCESS')
            {   
                var map1level = new Map(Object.entries(result));
				console.log('map1level-->'+map1level);
                var keyList=[];
                for (const [key, value] of map1level.entries()) {
            console.log('key-->'+key);
                    var name=key.split("--");
                    var data=name[1].split('**');
            var data1=data[1].split('&&');
            var data2=data1[1].split('%%');
            var keyid=data2[0];
            var sec=data2[1];
              console.log('Key id-->'+keyid);
           // var dat=data[1].split("??");
           // var sec=dat[1].split('%%');
            console.log('seconDry'+sec);
          
            
          
                  var secon=key.split("??");
                 console.log('data->'+data1);
                  //  keyList.push({"label":name[0],"description": data[0],"comments":data[1],"value":key});
            keyList.push({"label":name[0],"Id":keyid,"secondary":sec,"description": data1[0],"value":key});
            
        }
                component.set("v.keywordslist",keyList);
            }
        });
        $A.enqueueAction(action);
    },
    
    handlekeywordClick : function (component,event,helper){
        //console.log(component.get("v.responseMessage"));
        var selectedvalue=event.getSource().get("v.title");
        helper.getTreeStructure(component,selectedvalue);
    },
    
    handleDeleteClick : function (component,event,helper){
        //console.log(component.get("v.responseMessage"));
        var selectedvalue=event.getSource().get("v.title");
        console.log(selectedvalue);
        //action.setParams({"recordId":component.get('v.recordId')});
        var action = component.get('c.deleteKeywords');
        action.setParams({"recordId":component.get('v.recordId'),"keywordName":selectedvalue});
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log(response.getReturnValue());
            
            var keywordslist=component.get('v.keywordslist');
            if(response.getReturnValue() === 'Success')
            {   
                var deletedrecordindex;
                for(var i=0;i<keywordslist.length;i++){
                    if(keywordslist[i].label == selectedvalue){
                        deletedrecordindex =i;
                    }
                }
                keywordslist.splice(deletedrecordindex, 1);
                component.set('v.keywordslist',keywordslist);
            }else{
                console.log(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
    loadValuesController : function (component,event,helper) 
    {
        $(document).ready(function(){
            //alert('testing');
            jQuery.fn.highlight = function(pat) {
                function innerHighlight(node, pat) {
                    var skip = 0;
                    if (node.nodeType == 3) {
                        var pos = node.data.toUpperCase().indexOf(pat);
                        pos -= (node.data.substr(0, pos).toUpperCase().length - node.data.substr(0, pos).length);
                        if (pos >= 0) {
                            var spannode = document.createElement('span');
                            spannode.className = 'highlight';
                            var middlebit = node.splitText(pos);
                            var endbit = middlebit.splitText(pat.length);
                            var middleclone = middlebit.cloneNode(true);
                            spannode.appendChild(middleclone);
                            middlebit.parentNode.replaceChild(spannode, middlebit);
                            skip = 1;
                        }
                    }
                    else if (node.nodeType == 1 && node.childNodes && !/(script|style)/i.test(node.tagName)) {
                        for (var i = 0; i < node.childNodes.length; ++i) {
                            i += innerHighlight(node.childNodes[i], pat);
                        }
                    }
                    return skip;
                }
                console.log(this.length);
                console.log(pat);
                console.log(pat.length);
                /*return this.length && pat && pat.length ? this.each(function() {
                    innerHighlight(this, pat.toUpperCase());
                }) : this;*/
                return this.each(function() {
                    innerHighlight(this, pat.toUpperCase());
                });
            };
            
            
        });//doc.ready
        component.set("v.isShowSearchResult",true);
         $("#tblInventors tr").remove();
        var tblrow="<tr><td><span></span>";
        tblrow = tblrow + "<input type='hidden' value=''/></td></tr>";                    
        $("#tblInventors tbody").append(tblrow); 
        component.set("v.isShowSearchResult",false);
        
    },
    
    onblur : function(component, event, helper) { 
        console.log('blur called::');
        
        component.set("v.isShowSearchResult", false );
        component.set("v.displaytable", false );
        component.set("v.SearchKeyWord", '');
        
        console.log(component.get("v.data"));
        var lstRecords=component.get("v.data");
        console.log(lstRecords);
        console.log(lstRecords.length);
        
        if(lstRecords.length > 0){
            
            component.set('v.isLoading',true);
            var action = component.get('c.saveRecords');
            action.setParams({"recordId":component.get('v.recordId'),"lstkeywords":lstRecords});
            action.setCallback(this,function(response){
                var state = response.getState();
                console.log(response.getReturnValue());
                var respMsg=response.getReturnValue();
                component.set('v.isLoading',false);
                if(respMsg == 'Success'){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type" : "success",
                        "title": "Success!",
                        "message": "Keyword has been added successfully."
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }else{
                     var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode" : "sticky",
                        "type" : "error",
                        "title": "Error",
                        "message": respMsg
                    });
                    toastEvent.fire();
                }
                component.set("v.selectedkeyIds",[]);
                component.set("v.data",[]);
            });
            $A.enqueueAction(action);
        }
    },
    
    onclickSearch :function(component, event, helper) { 
            console.log('onclickSearch');
            helper.getFiltersData(component);
    },
    
    keyPressController : function(component, event, helper) { 
        //alert("Inside keyup");
       	console.log(component.get("v.SearchKeyWord"));
        var isEscKey = event.keyCode === 27;
        if (isEscKey)
        {
            component.set('v.isShowSearchResult',false);
            component.set("v.SearchKeyWord", '');
        }
        
        var getInputkeyWord = component.get("v.SearchKeyWord");
        if(getInputkeyWord.length > 0 ){
            helper.getData(component,getInputkeyWord);
        }else{
            component.set("v.isShowSearchResult", false);
        } 
    },
    
	searchNameClick : function(component, event, helper) { 
        var selectedvalue=event.getSource().get("v.title");
        console.log('searchNameClick::'+selectedvalue);
    }
    
   
    
     
})
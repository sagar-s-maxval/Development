({
	getTreeStructure: function (component,selectedvalue){
        console.log(selectedvalue);
        //return;
        console.log(component.get("v.selectedTree") == selectedvalue);
        if(component.get("v.selectedTree") == selectedvalue){
            component.set("v.items", null);
            component.set("v.displaytree",false);
            component.set("v.selectedTree","");
        }else{
            component.set("v.selectedTree",selectedvalue);
            component.set("v.displaytree",true);
        }
        var result = JSON.parse(component.get("v.responseMessage"));
            var jsonTree='';
            var level1index=0;
            var level2index=0;
            var level3index=0;
            var level4index=0;
            var maplevel = new Map(Object.entries(result));
        	for (const [key0, value0] of maplevel.entries()) {
                    if(key0 != selectedvalue){
                        continue;
                    }
                var map1level = new Map(Object.entries(value0));
                for (const [key, value] of map1level.entries()) {
                    var level1index=0;
                    var level2index=0;
                    var level3index=0;
                    var level4index=0;
                    //console.log(key, value);
                    var names=key.split('**');
                    jsonTree +='{"label": "'+names[0].split('--')[0] +'","name": "'+(level1index+1) +'",'
                    +'"metatext": "'+ (names.length ==2?names[1].split('&&')[0]:'') +'",'
                    +'"disabled": false,';
                    console.log('key:'+key);
                    if(key ===selectedvalue){
                        jsonTree +='"expanded": false,';
                    }else{
                        jsonTree +='"expanded": true,'
                        		
                    }
                    jsonTree +='"items":[' ;
                    level1index++;
                    if(typeof (value) == 'object'){
                        var map2level = new Map(Object.entries(value));
                        for (const [key1, value1] of map2level.entries()) {
                            //console.log(key1, value1);
                            var names1=key1.split('**');
                            jsonTree +='{"label": "'+names1[0].split('--')[0] +'","name": "1.'+(level2index+1) +'",'
                            +'"metatext": "'+ (names1.length ==2?names1[1].split('&&')[0]:'') +'",'
                            +'"disabled": false,';
                            console.log('key1:'+key1);
                            if(key1 ===selectedvalue){
                                jsonTree +='"expanded": false,';
                            }else{
                                jsonTree +='"expanded": true,' ;                             		
                            }
                            jsonTree +='"items":[';  
                            level2index++;
                            if(typeof (value1) == 'object'){
                                var map3level = new Map(Object.entries(value1));
                                for (const [key2, value2] of map3level.entries()) {
                                    var names2=key2.split('**');
                                    jsonTree +='{"label": "'+names2[0].split('--')[0] +'","name": "1.1.'+(level3index+1) +'",'
                                    +'"metatext": "'+ (names2.length ==2?names2[1].split('&&')[0]:'') +'",'
                                    +'"disabled": false,';
                                    console.log('key2:'+key2);
                                     console.log('names2[1]:'+names2[1]);
                                    if(key2 ===selectedvalue){
                                        jsonTree +='"expanded": false,';
                                    }else{
                                        jsonTree +='"expanded": true,';
                                    }
                                    jsonTree +='"items":[' 
                                    level3index++;
                                    if(typeof (value2) == 'string'){
                                        var names3=value2.split('**');
                                        console.log('names3-->'+names3);
                                        jsonTree +='{"label": "'+names3[0].split('--')[0] +'","name": "1.1.1.'+(level4index+1) +'",'
                                        +'"metatext": "'+ (names3.length ==2?names3[1].split('&&')[0]:'') +'",'
                                        if(value2 ===selectedvalue){
                                            jsonTree +='"expanded": false,';
                                        }else{
                                            jsonTree +='"expanded": true,';
                                        }
                                        jsonTree +='"disabled": false}';
                                        
                                       // console.log('names3----'+names3[1].split('&&')[0]);
                                        level4index++;
                                    }
                                }
                                jsonTree +=']}';
                            }
                            jsonTree +=']}';
                        }
                    }
                    jsonTree +=']},';
                }
        }
          var maplevel = new Map(Object.entries(result));
        	for (const [key0, value0] of maplevel.entries()) {
                    if(key0 != selectedvalue){
                        continue;
                    }
                var map1level = new Map(Object.entries(value0));
                for (const [key, value] of map1level.entries()) {
                   // if(key.contains('(')){
                        console.log('key-->'+key);
                    var test=key.split('**');
                    console.log('Test-->'+test[1]);
                   var n=test[1].includes("(");
                    var distest=test[1].split('(');
                     console.log('distest in-->'+distest);
                    if(n==true){
                        console.log('coming in-->');
                         console.log('json before comma-->'+jsonTree);
                        jsonTree=jsonTree.slice(0, -1);
                        console.log('json after removing  comma-->'+jsonTree);
                      //  jsonTree='{"label":'+test[1]+',"name": "0","metatext":'+ test[1]+',"disabled": false,"expanded":true,"items":['+jsonTree;
                        jsonTree  =' {"label":"'+distest[0]+ '","metatext":"'+ distest[0]+'","expanded":true,"items":['+jsonTree+']},';
                        // console.log(jsonTree);
                    }
                   // }
				}
			}
         console.log('JSON TREE IS-->'+jsonTree);
                //console.log(jsonTree);
                jsonTree =jsonTree.substring(0, jsonTree.length - 1);
        		//console.log(jsonTree);
                //console.log('[' + jsonTree +']');
                var items =JSON.parse('[' + jsonTree +']');
        		
                //console.log(items);
                component.set('v.items', items);
    },
    
    getchildHierarchyData :function (component){
        var action = component.get("c.fetchHierarchyKeywords");
        	//action.setParams({'isFirstLoad':component.get("v.serachFirstLoad")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                  if (state === "SUCCESS") {
					/*var maplevel = new Map(Object.entries(response.getReturnValue()));
                      console.log('maplevel::'+maplevel);*/
                      console.log(response.getReturnValue());
                      const result = response.getReturnValue();
					  console.log(Object.keys(response.getReturnValue()));
					  var map1 = new Map();
                      Object.keys(result).forEach(function (item) {
                          map1[item] = result[item];
                    });
                    console.log(map1);
					component.set("v.hierarchySearchData",map1);
					console.log(component.get("v.hierarchySearchData"));
                  }
            });
        $A.enqueueAction(action);
    },
    
    getFiltersData: function (component){
        var action = component.get("c.fetchAllKeywords");
        	//action.setParams({'isFirstLoad':component.get("v.serachFirstLoad")});
            action.setCallback(this, function(response) {
                var state = response.getState();
                  if (state === "SUCCESS") {
					component.set("v.serachFirstLoad",true);
                    $("#tblInventors tbody").append(''); 
					//console.log(response.getReturnValue());  
					var storeResponse = response.getReturnValue();
                    $("#tblInventors tr").remove();
                    var fieldsForSearch =storeResponse;                
                    for(var i=0; i<fieldsForSearch.length;i++)
                    {
                        var tblrow="<tr><td><span>"+fieldsForSearch[i].label+"</span>";
                        tblrow = tblrow + "<input type='hidden' value='" + JSON.stringify(fieldsForSearch[i].keyword) +"'/></td></tr>";                    
                        $("#tblInventors tbody").append(tblrow); 
                    }
                    
                    //$("#tblInventors tr").on('click', 'td', function() {
					$("#tblInventors tr").on('click', 'td', function() {
                        console.log('clicked');
                       var selectedInventorID= $(this).parents('tr').find('input[type="hidden"]').val();   
                       var listSelectedInvs = JSON.parse(decodeURIComponent(selectedInventorID));
                       var invID=listSelectedInvs;
                       var selectid =invID.Id;
                        
                        //console.log(':::selectedkeyIds::::'+component.get("v.selectedkeyIds"));
                        var lstkeyIds=component.get("v.selectedkeyIds");
                     //   lstkeyIds.push({"key":invID.Name + '-' + invID.Description__c,"value" :selectid});
                         lstkeyIds.push({"key":invID.Description__c + '-' + invID.Name,"value" :selectid});
                        component.set("v.selectedkeyIds",lstkeyIds);
                        
                        var tabledata = component.get("v.data");
                        tabledata.push(listSelectedInvs);
                        component.set("v.data",tabledata);
                        if(lstkeyIds.length >0){
                        	component.set("v.displaytable",true);
                        }
                        $(this).parents('tr').remove();
                    }); 
                    //----- if storeResponse size is equal 0 ,display No Records Found... message on screen.                
                    if (fieldsForSearch.length == 0) {
                        component.set("v.Message", 'No records found...If you cannot find the person you are looking for,');
                        
                        var message=component.get("v.Message");
                        var tblrow="<tr><td><center>"+message+"<br/>"+'No Records Found'+"</center></td></tr>";
                        $("#tblInventors tbody").append(tblrow);
                         
                    } else {
                        component.set("v.Message", '');
                        // set searchResult list with return value from server.
                    }
                    component.set("v.isShowSearchResult", true);
                  }
            });
            $A.enqueueAction(action);
    },
    
    getData : function (component,selectedvalue){
        console.log('selectedvalue::'+selectedvalue);
        var action = component.get("c.fetchLookUpValues");
            action.setParams({'searchKeyWord': selectedvalue});
            action.setCallback(this, function(response) {
                var state = response.getState();
                  if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    $("#tblInventors tr").remove();
                    var fieldsForSearch =storeResponse;                
                    for(var i=0; i<fieldsForSearch.length;i++)
                    {
                        var tblrow="<tr><td><span>"+fieldsForSearch[i].label+"</span>";
                        tblrow = tblrow + "<input type='hidden' value='" + JSON.stringify(fieldsForSearch[i].keyword) +"'/></td></tr>";                    
                        $("#tblInventors tbody").append(tblrow); 
                    }
					//console.log($("#tblInventors"));
					$("#tblInventors").highlight((selectedvalue));  
                    
                    $("#tblInventors tr").on('click', 'td', function() {
                       var selectedInventorID= $(this).parents('tr').find('input[type="hidden"]').val();   
                       var listSelectedInvs = JSON.parse(decodeURIComponent(selectedInventorID));
                       var invID=listSelectedInvs;
                       var selectid =invID.Id;
                        var lstkeyIds=component.get("v.selectedkeyIds");
                        lstkeyIds.push({"key":invID.Name + '-' +invID.Description__c,"value" :selectid});
                        component.set("v.selectedkeyIds",lstkeyIds);
                        //console.log(component.get("v.selectedkeyIds"));
                        var tabledata = component.get("v.data");
                        tabledata.push(listSelectedInvs);
                        component.set("v.data",tabledata);
                        if(lstkeyIds.length >0){
                        	component.set("v.displaytable",true);
                        }
                        $(this).parents('tr').remove();
                    }); 
                    //----- if storeResponse size is equal 0 ,display No Records Found... message on screen.                
                    if (fieldsForSearch.length == 0) {
                        component.set("v.Message", 'No records found...If you cannot find the person you are looking for,');
                        
                        var message=component.get("v.Message");
                        var tblrow="<tr><td><center>"+message+"<br/>"+'No Records Found'+"</center></td></tr>";
                        $("#tblInventors tbody").append(tblrow);
                         
                    } else {
                        component.set("v.Message", '');
                        // set searchResult list with return value from server.
                    }
                    component.set("v.isShowSearchResult", true);
                }
                else{
                var errors = response.getError();
                           if (errors)
                           {
                               if (errors[0] && errors[0].message)
                               {
                                    alert(errors[0].message );//Fetching Custom Message.
                               }
                           }
                }
            });
            
            // enqueue the Action  
            $A.enqueueAction(action);
    },
    
    
})
({
    loadGoodsAndServices : function(component, event, helper) 
    {
        //var recordId = 'a2D41000003NBDMEA4';
        //var recordId = 'a2D41000003NNaeEAG';
        var recordId = component.get('v.recordId');
        component.set('v.trademarkId', recordId);
        helper.getGoodsAndServices(component, component.get('v.trademarkId'));
        
        
    },
    
    editRecordController : function(component, event, helper) 
    {
        var TMGoodsServicesId = event.getSource().get('v.value');
        var sObjectName = component.get('v.sObjectName');
        //alert(sObjectName);
        var editTMGoodsServicesEvent = $A.get("e.force:editRecord");
        editTMGoodsServicesEvent.setParams({
            "recordId": TMGoodsServicesId
        });
        editTMGoodsServicesEvent.fire();
    },
    deleteRecordController : function(component, event, helper) 
    {
        helper.deleteGoodsAndServicesHelper(component, component.get('v.trademarkId'), event.getSource().get('v.value'))
    },
    newRecordController : function(component, event, helper) 
    {       
        helper.gettrademarkGSClassPicklist(component);
        component.set("v.createModal",true);        
    },   
    createTrademarkGS: function(component, event, helper) {
        
        //var classValue = component.find("classField").get("v.value");
        //var goodsLangValue = component.find("goodsLangField").get("v.value");
        //var fillingBasisValue = component.find("fillingBasisField").get("v.value");
        var classValue = component.find("classField");
        classValue = Array.isArray(classValue) ? classValue[0].get("v.value") : classValue.get("v.value");
        var goodsLangValue = component.find("goodsLangField");
        goodsLangValue = Array.isArray(goodsLangValue) ? goodsLangValue[0].get("v.value") : goodsLangValue.get("v.value");
        var fillingBasisValue = component.find("fillingBasisField");
        fillingBasisValue = Array.isArray(fillingBasisValue) ? fillingBasisValue[0].get("v.value") : fillingBasisValue.get("v.value");
        
        // and set set the "isOpen" attribute to "False for close the model Box.
        if(classValue != '' && classValue != '--- None ---'){
            if(goodsLangValue != '' && goodsLangValue != '--- None ---'){    
                if(fillingBasisValue != '' && fillingBasisValue != '--- None ---'){
                    component.set("v.createModal", false);                           
                    //alert("record : "+JSON.stringify(component.get("v.newTrademarkGS")));
                    
                    var action = component.get("c.insertTSG");
                    component.set("v.newTrademarkGS.Dispute_Opposition__c",component.get("v.recordId"));
                    action.setParams({
                        tsg : component.get("v.newTrademarkGS"),
                        TrademarkId : component.get("v.recordId")
                    });
                    action.setCallback(this,function(response){
                        var state= response.getState();                        
                        if(state == "SUCCESS"){
                            var trademarkGS={ 'sobjectType': 'DisputeOpposition_Goods_Services__c',
                                             'SymphonyIPM__Class__c': '--- None ---',
                                             'SymphonyIPM__Goods_Description__c': '',
                                             'SymphonyIPM__Domestic_Classes__c': '',
                                             'SymphonyIPM__Good_s_Language__c': '--- None ---',
                                             'SymphonyIPM__Filing_Basis__c': '--- None ---',
                                             'SymphonyIPM__First_Use_Date__c': '',
                                             'SymphonyIPM__First_Use_in_Commerce_Date__c': '',
                                            };
                            
                            component.set("v.newTrademarkGS",trademarkGS);
                            component.set("v.error",false);
                            $A.get('e.force:refreshView').fire();    
                            
                        }else if (state=="ERROR") {
                            var errorMsg = action.getError()[0].message;
                            console.log(errorMsg);
                        }
                        $A.get('e.force:refreshView').fire();
                    });
                    $A.enqueueAction(action);        
                    helper.getGoodsAndServices(component,component.get('v.trademarkId'));
                }else{
                    component.set("v.errorMsg"," Please Select Filing Basis value ! ");
                    component.set("v.error",true);
                }   
            }else{
                component.set("v.errorMsg"," Please Select Good's Language value ! ");
                component.set("v.error",true);
            }                
        }  else{
            component.set("v.errorMsg"," Please Select Class value ! ");
            component.set("v.error",true);
        }   
    },
    //******************************
    
    
    
    closeCreateModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"
        var trademarkGS={ 'sobjectType': 'Trademark_Goods_Services__c',
                         'SymphonyIPM__Class__c': '--- None ---',
                         'SymphonyIPM__Goods_Description__c': '',
                         'SymphonyIPM__Domestic_Classes__c': '',
                         'SymphonyIPM__Good_s_Language__c': '--- None ---',
                         'SymphonyIPM__Filing_Basis__c': '--- None ---',
                         'SymphonyIPM__First_Use_Date__c': '',
                         'SymphonyIPM__First_Use_in_Commerce_Date__c': '',
                        };
        
        component.set("v.newTrademarkGS",trademarkGS);
        component.set("v.error",false);  
        component.set("v.createModal", false);
        component.set("v.error",false);
    },
    
})
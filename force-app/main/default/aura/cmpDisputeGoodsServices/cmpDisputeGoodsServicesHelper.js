({
	getGoodsAndServices : function(component, trademarkId) 
    {
		var action = component.get('c.getGoodsAndServices');
        action.setParams({ trademarkId : trademarkId });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    //alert(JSON.stringify(response.getReturnValue()));	
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        component.set('v.objGoodsServiceList',response.getReturnValue());
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
    deleteGoodsAndServicesHelper : function(component, trademarkId, goodsServiceId) 
    {
		var action = component.get('c.deleteGoodsAndServices');
        action.setParams({ goodsServiceId : goodsServiceId });
        action.setCallback
        (
            this,
            $A.getCallback
            (
                function (response) 
                {
                    //alert(JSON.stringify(response.getReturnValue()));	
                    var state = response.getState();
                    if (state === "SUCCESS") 
                    {
                        //component.set('v.objGoodsServiceList',response.getReturnValue());
                        this.getGoodsAndServices(component, trademarkId);
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
    gettrademarkGSClassPicklist : function(component){
        var action = component.get("c.TrademarkGSClass");
        action.setCallback(this,function(response){
          var state = response.getState();
            if(state = "SUCCESS"){
                var StoreResponse = response.getReturnValue();
                //alert("response : "+JSON.stringify(response.getReturnValue()));
				var classVal1 =[];
                var goods1 =[];
                var filingB1 =[];
                
                classVal1.push('--- None ---');                
                goods1.push('--- None ---');
                filingB1.push('--- None ---');
                
                for (let cval in StoreResponse.classVal) {  
                    classVal1.push( StoreResponse.classVal[cval] );
                }
                for (let gval in StoreResponse.goods) {  
                    goods1.push( StoreResponse.goods[gval] );
                }
                 for (let fval in StoreResponse.filingB) {  
                    filingB1.push( StoreResponse.filingB[fval] );
                }
                
                component.set("v.classList",classVal1);
                component.set("v.goodsLandgist",goods1);
                component.set("v.fillingBasisList",filingB1);
            }        
        });
        $A.enqueueAction(action);
    } 
})
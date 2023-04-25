({
	itemSelected : function(component, event, helper) {
        let target = event.target;
        let SelIndex = helper.getIndexFrmParent(target,helper,"data-selectedIndex");
        console.log('SEL INDEX: ' + SelIndex);
        console.log(component.get('v.server_result').length);
        if(SelIndex){
            console.log('INSIDE');
            let serverResult = component.get("v.server_result");
            let selItem = serverResult[SelIndex];
            console.log(selItem);
            component.set("v.selItem",selItem);
            component.set("v.last_ServerResult",serverResult);

            console.log('I AM BEFORE THE EVENT');
            let cmpEvent = component.getEvent("setSelectedInventor");
            cmpEvent.setParams({
                "selectedInventor" : selItem
            })
            cmpEvent.fire();
            component.set("v.server_result",null); 
        } 
	},

    serverCall : function(component, event, helper) {  
        var target = event.target;  
        var searchText = target.value; 
        var last_SearchText = component.get("v.last_SearchText");
        //Escape button pressed 
        if (event.keyCode == 27 || !searchText.trim()) { 
            helper.clearSelection(component, event, helper);
        } else if(searchText.trim() != last_SearchText  && /\s+$/.test(searchText) ){
            //Save server call, if last text not changed
            //Search only when space character entered

            let limit = component.get("v.limit");
            let usedInventors = component.get('v.usedInventors');
            let usedInventorsIds = usedInventors.map(inventor => inventor.Id);
            let action = component.get('c.findUsers');
            action.setStorable();
            
            action.setParams({
                searchTerm : searchText,
                idsToExclude : usedInventorsIds
            });
    
            action.setCallback(this,function(a){
                this.handleResponse(a,component,helper);
            });
            
            component.set("v.last_SearchText",searchText.trim());
            console.log('Server call made');
            $A.enqueueAction(action); 
        } else if(searchText && last_SearchText && searchText.trim() == last_SearchText.trim()){
            component.set("v.server_result", component.get("v.last_ServerResult"));
            console.log('Server call saved');
        }         
	},

    handleResponse : function (res,component,helper){
        console.log(res.getReturnValue());
        if (res.getState() === 'SUCCESS') {
            let retObj = res.getReturnValue();
            if(retObj.length <= 0){
                var noResult = JSON.parse('[{"Name":"No Results Found"}]');
                component.set("v.server_result",noResult); 
            	component.set("v.last_ServerResult",noResult);
            } else {
                component.set("v.server_result",retObj); 
            	component.set("v.last_ServerResult",retObj);
            }  
        } else if (res.getState() === 'ERROR'){
            let errors = res.getError();
            if (errors) {
                if (errors[0] && errors[0].message) {
                    alert(errors[0].message);
                }
            } 
        }
    },

    getIndexFrmParent : function(target,helper,attributeToFind){
        //User can click on any child element, so traverse till intended parent found
        var SelIndex = target.getAttribute(attributeToFind);
        while(!SelIndex){
            target = target.parentNode ;
			SelIndex = helper.getIndexFrmParent(target,helper,attributeToFind);           
        }
        return SelIndex;
    },

    clearSelection: function(component, event, helper){
        component.set("v.selItem",null);
        component.set("v.server_result",null);
    } 
})
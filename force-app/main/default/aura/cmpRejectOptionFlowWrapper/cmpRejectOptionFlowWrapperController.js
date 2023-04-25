({
    init : function (component) {
        var action = component.get("c.getFinalRecommendationValues");
        action.setCallback(this, function(response){
            let state = response.getState();
            console.log("STATE:" + state);
            if (state === 'SUCCESS'){
                let list = response.getReturnValue();
                console.log("LIST: " + list);

                let map=[];
               list.forEach((x,i) => map.push({label:x,value:x}))

                component.set("v.finalRecommendation",map);
            }
            else if(state === 'ERROR'){
                alert('Error occurred meanwhile getting picklist values');
                console.log(response.getError());
            }
        })
        $A.enqueueAction(action);

    },
    handleChange: function (component,event){
        let value = component.find("recommendation").get("v.value");
        component.set("v.answer",value);
        console.log(value);
    },
})
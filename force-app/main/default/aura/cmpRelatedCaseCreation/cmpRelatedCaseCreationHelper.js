({
    onLoad: function(component, event)
    {
       // alert('onLoad call');
        //console.log('onLoad call');
        //call apex class method
        component.set('v.arrSelectedBasePatentIds','');
        component.set('v.arrSelectedParentPatentIds','');
        var action = component.get('c.fetchfamilys');
        action.setParams({
            "AssetId": component.get("v.recordId")
        });
        //alert('Reocrd Id-->>' + component.get("v.recordId"));
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                //set response value in ListofIFW attribute on component.
                var objData = response.getReturnValue();
              /*  for (var i = 0; i < objData.length; i++) {
                    console.log('Here ')
                   if(objData[i].status=='NOA Received')
                        objData[i].status='Allowed';
                }*/
                component.set('v.Listoffamily', objData);
               // alert(JSON.stringify(objData));
            }
            console.log('Data : '+JSON.stringify(response.getReturnValue()));
        });
         /*var action = component.get("c.fetchPatentList");       
       action.setCallback(this, function(response){
            var state = response.getState();
           alert('Response'+state);
            if (state === "SUCCESS") {
                var objPatentData= response.getReturnValue();
                component.set("v.PatentList",objPatentData);
                alert(JSON.stringify(objPatentData));
            }
            alert(component.get("v.PatentList"));
       });*/
        $A.enqueueAction(action);
    },   

 sortData: function(component, event) {
        var sortedBy = 'filingDate';
        var sortDirection = component.get("v.sortedDirection");
     console.log(sortDirection);
     if(sortDirection==='asc')
         sortDirection='desc';
       else
     sortDirection='asc';   
        var cloneData;//.slice(0);
          cloneData =JSON.parse(JSON.stringify(component.get("v.Listoffamily")));
        
        // Return the value stored in the field
        let keyValue = (a) => {
            return a[sortedBy];
        };

        // cheking reverse direction 
        let isReverse = sortDirection === 'asc' ? 1: -1;

        // sorting data 
        cloneData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
         component.set("v.sortedDirection", sortDirection);
         component.set("v.Listoffamily", cloneData);
      
     
    }
   
})
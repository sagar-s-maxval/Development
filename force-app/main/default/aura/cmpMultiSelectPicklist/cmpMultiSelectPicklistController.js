({
    search : function(component, event, helper) {
        var isEscKey = event.keyCode === 27;
        if (isEscKey){
            component.set('v.isSucess',false);
        }else{
            component.set('v.isSucess',true);
            var options = component.get('v.options');
            var opts = [];
            var txtSearch = component.find('txtSearch').get('v.value');
            options.forEach(element => {
                var index = element.label.toLowerCase().indexOf(txtSearch);
                if(index > -1){
                    opts.push({ "class": "optionClass", label: element.label, value: element.name });
                }
            });
            component.find("InputSelectMultiple").set("v.options", opts);
        }
 
    },

    onSelect : function(component, event, helper) {
        var selectCmp = component.find('InputSelectMultiple');
        var opts = selectCmp.get('v.options');
        var selectedValue = selectCmp.get("v.value");
    
        var items = component.get('v.value');
        var index = 0;
        var updateOpts =  [];
        opts.forEach(element => {
            if(element.value == selectedValue){
                items.push({
                    label: element.label,
                    name: element.value,
                });
            }else{
                updateOpts.push({
                    label: element.label,
                    name: element.value,
                });
            }
            index++;
        });
		
		console.log('--items--- ', items.length);
		var searchInp = component.find("txtSearch");
		if(component.get("v.required") == true && items.length == 0){
            searchInp.setCustomValidity("Select at-least one value");
            searchInp.reportValidity();
        }else{
            searchInp.set('v.validity', {valid:true});
        }
        component.set('v.value', items);
        component.set('v.isSucess',false);
        searchInp.set('v.value','');
        searchInp.focus();
        component.set('v.options', updateOpts);
        //Fire change event
        var cmpChangeEvent = component.getEvent('change');
        cmpChangeEvent.fire();


    },

    onRemove : function(component, event, helper) {
        var name = event.getParam("item").name;
        var items = component.get('v.value');
        var item = event.getParam("index");
        var options = component.get('v.options');
        options.push(items[item]);
        component.set('v.options', options);

        items.splice(item, 1);
        component.set('v.value', items);
        
        var searchInp = component.find("txtSearch");
        if(component.get("v.required") == true && items.length > 0){
            searchInp.setCustomValidity("");
            searchInp.set('v.validity', {valid:true});
            searchInp.reportValidity();
        }
        //Fire change event
        var cmpChangeEvent = component.getEvent('change');
        cmpChangeEvent.fire();
    },
})
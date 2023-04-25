({
		 toggleAccordion : function(component, event, helper) {
        helper.toggleAccordion(component);
    },
        init: function(component, event, helper) {
            helper.getdata(component, event);
            
    },
    handleClick:function(component, event, helper) {
        
        component.set("v.showedit",true);
    },
    clickclose:function(component, event, helper) {
        
        component.set("v.showedit",false);
    },
    savetext:function(component, event, helper) {
        helper.save(component, event);
     //   component.set("v.showedit",false);
      //   component.set('v.showAccordion',true );
        
    }
	
})
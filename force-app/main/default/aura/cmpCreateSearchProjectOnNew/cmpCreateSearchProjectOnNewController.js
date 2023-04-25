({
    doInit : function(component) {
        let input = [{name:"showText",type:"Boolean",value:true}];
        let flow = component.find('flow');
        flow.startFlow('Create_New_Search_Project',input);
    }
});
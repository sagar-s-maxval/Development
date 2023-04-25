({
    handleChangeTextArea: function (component,event){
        let value = component.find("descriptionArea").get("v.value");
        component.set("v.description",value);
    }
});
({
    doInit : function(component, event, helper) {
        helper.makeApexCall(component, event, helper);
    },
    onFirstChanged : function(component, event, helper) {

        let q2 = component.get('v.q2') || '';
        let q1 = component.get('v.q1') || '';
        let q2a = component.get('v.q2a') || '';
        let q2b = component.get('v.q2b') || '';
        let q2c = component.get('v.q2c') || '';
        let q2d = component.get('v.q2d') || '';
        let q3 = component.get('v.q3') || '';
        let q4 = component.get('v.q4') || '';
        let q5 = component.get('v.q5') || '';
        let q6 = component.get('v.q6') || '';

        // console.log("Raw: " + q1);
        // console.log("Parsed " + helper.removeHTML(text));

        component.set('v.isFirstValid', q1.length < 50000);

        let anyError = false;

        let richTextValidity = [
            q1.length < 50000, q2.length < 30000, q2a.length < 30000,
            q2b.length < 30000, q2c.length < 30000, q2d.length < 30000,
            q3.length < 10000, q4.length < 5000, q5.length < 10000, q6.length < 30000];
        for(let i = 0; i < richTextValidity.length ; i++){
            if(!richTextValidity[i]){
                anyError = true;
                break;
            }
        }
        let evt = $A.get("e.c:ExceededLimitEvent");
        if(anyError){
            evt.setParams({ "isExceededLimit" : true });
        }
        else {
            evt.setParams({ "isExceededLimit" : false });
        }

        evt.fire();

    }
});
({
    showApexError: function (helper, errors) {
        if (!errors || !errors.length) {
            return;
        }

        for (let i = 0; i < errors.length; ++i) {
            if (errors[i].message) {
                helper.showToast('error', errors[i].message);
                return;
            }

            if (!errors[i].pageErrors || !errors[i].pageErrors.length) {
                continue;
            }

            helper.showToast('error', errors[i].pageErrors[0].message);
            return;
        }
    },

    showToast: function (type, message) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type[0].toUpperCase() + type.substring(1).toLowerCase(),
            "message": message
        });

        toastEvent.fire();
    },

    makeApexCall: function (component, event, helper, action, params, callback) {
        if (params) {
            action.setParams(params);
        }
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let results = response.getReturnValue();
                callback(component, event, helper, results);
            } else if (state === "ERROR") {
                helper.showApexError(helper, response.getError());
            }
        });

        $A.enqueueAction(action);
    }

});
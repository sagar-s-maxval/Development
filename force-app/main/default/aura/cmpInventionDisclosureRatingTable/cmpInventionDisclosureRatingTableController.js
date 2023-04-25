({
    doInit: function (component, event, helper) {
        component.set('v.options', [
            {
                'label': '0',
                'value': '0'
            },
            {
                'label': '1',
                'value': '1'
            },
            {
                'label': '2',
                'value': '2'
            },
            {
                'label': '3',
                'value': '3'
            },
            {
                'label': '4',
                'value': '4'
            },
            {
                'label': '5',
                'value': '5'
            },
        ]);

        let pageReference = {
            type: 'standard__component',
            attributes: {
                componentName: 'c__cmpInventionDisclosureRatingSummary',
                pageName: 'Rating Summary'
            },
            state: {
                c__recordId: component.get('v.IDF')
            }
        };

        component.set("v.pageReference", pageReference);
        helper.checkuseraccess(component, event, helper);
        helper.makeApexCall(component, event, helper);
        helper.getRecommendations(component, event, helper);
        helper.getStatusAllowance(component, event, helper);
       
            
    },

    openSummary: function(component, event, helper) {
        const navService = component.find('navService');
        const pageReference = component.get('v.pageReference');
        const handleUrl = (url) => {
            window.open(url);
        };
        const handleError = (error) => {
            console.log(error);
        };
        navService.generateUrl(pageReference).then(handleUrl, handleError);
    },

    editRating: function (component, event, helper) {
        let navigate = component.get('v.navigateFlow');
        navigate('NEXT');
    }
});
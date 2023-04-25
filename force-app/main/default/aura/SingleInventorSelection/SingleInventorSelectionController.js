({
	loadValuesController: function(component, event, helper) {
		let from_NewAssetInventorFlow = component.get("v.from_NewAssetInventorFlow");
		if (from_NewAssetInventorFlow) {
		    component.set("v.placeholder", "");
        } else {
            component.set("v.placeholder", "Search for Primary Inventor");
        }

		if (typeof(component.get("v.coInventors")) != "undefined") {
			let coInventorsList = component.get("v.coInventors").split(",");
			component.set('v.arrSelectedInvIds', coInventorsList);
		}
		let inventorId = component.get("v.strSelectedInvIds");
		if (inventorId != null && inventorId != '') {
			let action = component.get("c.fetchInventor");
			action.setParams({
				inventorId: inventorId
			});
			action.setCallback(this, function(response) {
				let state = response.getState();
				if (state === "SUCCESS") {
					let storeResponse = response.getReturnValue();
					helper.getSelectedInventorsHelper(component, inventorId);
				}
			});
			$A.enqueueAction(action);

		} else {
			if (!from_NewAssetInventorFlow) {
				let action = component.get("c.fetchUser");
				action.setCallback(this, function(response) {
					let state = response.getState();
					if (state === "SUCCESS") {
						let storeResponse = response.getReturnValue();
						if ((component.get("v.recordId") != null && component.get("v.strSelectedInvIds") != null) || component.get("v.recordId") == undefined) {
							component.set("v.lstSelectedInventors", storeResponse);
							component.set("v.strSelectedInvIds", storeResponse.name);
							let appEvent = $A.get("e.c:IDFAppEvent1");
							appEvent.setParams({
								"IDFAppEvent1": storeResponse.name
							});
							appEvent.fire();
						}
					} else {
						component.set("v.inputdisable", false);
					}
				});
				$A.enqueueAction(action);
			}
		}
	},
	searchInventorsController: function(component, evt, helper) {
		if (typeof(component.get("v.coInventors")) != "undefined" && component.get("v.coInventors") != null) {
			let coInventorsList = component.get("v.coInventors").split(",");
			component.set('v.arrSelectedInvIds', coInventorsList);
		}
		let txtSearchInventors = component.find('txtSearchInventors').get('v.value');
		let arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");

		if (txtSearchInventors.length > 0) {
			helper.searchInventorsHelper(component, txtSearchInventors, arrSelectedInventorIdsValue);
		} else {
			component.set('v.isShowSearchResult', false);
		}
	},
	removeSelectedInventorsController: function(component, event) {
		let selectedInventorId = event.getParam("item").name;
		// Remove the pill from view
		let items = component.get('v.lstSelectedInventors');
		let item = event.getParam("index");
		items.splice(item, 1);
		component.set('v.lstSelectedInventors', items);

		let arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
		let index = arrSelectedInventorIdsValue.indexOf(selectedInventorId);
		if (index > -1) {
			arrSelectedInventorIdsValue.splice(index, 1);
		}
		component.set("v.strSelectedInvIds", null);
		component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue);
		component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue.join(","));
		component.set("v.inputdisable", false);
		let appEvent = $A.get("e.c:IDFAppEvent1");
		appEvent.setParams({
			"IDFAppEvent1": ""
		});
		appEvent.fire();
	},
	getSelectedInventorsController: function(component, event, helper) {
		console.log('coInventors - ' + component.get("v.coInventors"));
		if (typeof(component.get("v.coInventors")) != "undefined") {
			console.log('inside v.coInventors')
			let coInventorsList = component.get("v.coInventors").split(",");
			component.set('v.arrSelectedInvIds', coInventorsList);
		}
		let selectedInventorId = component.find("lstAvailableInventors").get("v.value");
		let arrSelectedInventorIdsValue = component.get("v.arrSelectedInvIds");
		arrSelectedInventorIdsValue = [];
		arrSelectedInventorIdsValue.push(selectedInventorId);
		component.set("v.arrSelectedInvIds", arrSelectedInventorIdsValue);
		component.set("v.strSelectedInventorIds", arrSelectedInventorIdsValue.join(","));
		component.set('v.isShowSearchResult', false);
		helper.getSelectedInventorsHelper(component, component.get("v.arrSelectedInvIds"));
		component.find('txtSearchInventors').set('v.value', '');
		component.find('txtSearchInventors').focus();
		component.set("v.inputdisable", true);
	},
	onblur: function(component, event, helper) {
		component.set("v.isShowSearchResult", false);
	}
})
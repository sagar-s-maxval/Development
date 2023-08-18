({
	//----------------------- SAVE BUTTON REPLACEMENT -----------------------
	validateRequired: function(component, event) 
    {
        var isValid = true;
        var isPrimary = false;
        var countInventors = 0;
        var allRecordsRows = component.get("v.InventorRecords");
        var PrimaryAddedInList = false;
        component.set('v.VDTPrimaryInventor',''); 
        component.set('v.IsNameChoosen',false);
        //alert('Inv check'+component.get('v.IsNameChoosen'));
        /*for(var indexVar = 0; indexVar < allRecordsRows.length; indexVar++) 
        {
            if(allRecordsRows[indexVar].IsPrimary != true)
            {
                allRecordsRows[indexVar].IsPrimary = false;
            }
            else if(allRecordsRows[indexVar].IsPrimary == true)
            {
                PrimaryAddedInList = true;
            }
        }*/
        //alert('allRecordsRows validation --->'+JSON.stringify(allRecordsRows));
        /*for(var indexVar = 0; indexVar < allRecordsRows.length; indexVar++) 
        {
            alert('allRecordsRows[indexVar].Name'+allRecordsRows[indexVar].Name);
            alert('allRecordsRows[indexVar].RoleOfConception'+allRecordsRows[indexVar].RoleOfConception);
            alert('allRecordsRows[indexVar].IsPrimary'+allRecordsRows[indexVar].IsPrimary);
            
            if(allRecordsRows[indexVar].Name === '') 
            {
                isValid = false;
                component.set('v.IsNameChoosen',true); //If inventor is not choosen 
            }
            if(allRecordsRows[indexVar].RoleOfConception === '') //else if was changed to if
            {
                isValid = false;
                component.set('v.IsRoleOfConceptionEntered',true); // If Role of conception is not entered
            }
            
            //alert('allRecordsRows[indexVar].IsPrimary --------->>>>'+allRecordsRows[indexVar].IsPrimary);
            /*if(allRecordsRows[indexVar].IsPrimary == false)
            {
                if(allRecordsRows[indexVar].Name != '' && allRecordsRows[indexVar].RoleOfConception != '' )
                {
                	//if(PrimaryAddedInList != true)
                    //{
                    	isPrimary = true; //If true, Primary inventor is not selected
                        
                    //}
                }
                else
                {
                    component.set('v.ValidatePrimaryInventor',false);
                }
            }
            else
            {
                component.set('v.ValidatePrimaryInventor',false);
                isPrimary = false;
                component.set('v.VDTPrimaryInventor',allRecordsRows[indexVar].Recid);
            }* /
            //------------
            if(allRecordsRows[indexVar].IsPrimary == true)
            {
                isPrimary = true; //Primary inventor is selected
                component.set('v.VDTPrimaryInventor',allRecordsRows[indexVar].Recid);
            }
            
        }*/  
        //-------------
        var InvSelected = false;
        var ROCEntered = false;
        for(var indexVar = 0; indexVar < allRecordsRows.length; indexVar++) 
        {
            //alert('Inv-->'+allRecordsRows[indexVar].Name);
            if(allRecordsRows[indexVar].Name === '') 
            {
                isValid = false;
                InvSelected = true;
                break;
                //component.set('v.IsNameChoosen',true); //If inventor is not choosen 
            }
        }
        if(InvSelected == true)
        {
            //alert('InvSelected if'+InvSelected);
            component.set('v.IsNameChoosen',true);
        }
        else if(InvSelected == false)
        {
            //alert('InvSelected else'+InvSelected);
            component.set('v.IsNameChoosen',false);
        }
        //alert('INVENTOR'+component.get('v.IsNameChoosen'));
        for(var indexVar = 0; indexVar < allRecordsRows.length; indexVar++) 
        {
            if(allRecordsRows[indexVar].RoleOfConception === '') //else if was changed to if
            {
                isValid = false;
                ROCEntered = true;
                break;
                //component.set('v.IsRoleOfConceptionEntered',true); // If Role of conception is not entered
            }
        }
        if(ROCEntered == true)
        {
            component.set('v.IsRoleOfConceptionEntered',true);
        }
        else if(ROCEntered == false)
        {
            component.set('v.IsRoleOfConceptionEntered',false);
        }
        for(var indexVar = 0; indexVar < allRecordsRows.length; indexVar++) 
        {
            if(allRecordsRows[indexVar].IsPrimary == false || allRecordsRows[indexVar].IsPrimary == true)
            {
                isPrimary = true; //Primary inventor is selected
                if(allRecordsRows[indexVar].Recid != '')
                {
                	component.set('v.VDTPrimaryInventor',allRecordsRows[indexVar].Recid);
                }
                else if(allRecordsRows[indexVar].Recid == '')
                {
                    allRecordsRows[indexVar].IsPrimary = false;
                }
                break;
            }
        }
        //-----------------
        //alert('isPrimary-'+isPrimary);
        //alert('pri inv-->'+component.get('v.VDTPrimaryInventor'));
        component.set('v.InventorRecords',allRecordsRows);
        //alert('list--'+component.get('v.InventorRecords'));
        component.set('v.IsValid',isValid);
        //alert('isValid value --- >'+isValid);
        component.set('v.VDTInventorsSelected',component.get('v.InventorRecords'));
        if(isPrimary == true)
        {
            if(component.get('v.VDTPrimaryInventor') != '')
            {
                allRecordsRows[0].IsPrimary = true;
            	component.set('v.ValidatePrimaryInventor',false);
            }
            else
            {
                component.set('v.ValidatePrimaryInventor',true);
            }
            //component.set('v.SuccessMsg',false);
            //component.set('v.ErrorMessageForInventors', 'Please select First Named Inventor!');
            //component.set('v.InventorRecords',allRecordsRows);
        }
        else if(isPrimary == false)
        {
            
            component.set('v.ValidatePrimaryInventor',true);
            //component.set('v.SuccessMsg',false);
            //component.set('v.InventorRecords',allRecordsRows);
            //return isValid;
        }
        if(component.get("v.VDTPrimaryInventor") != null)
        {
            component.set('v.ValidatePrimaryInventor',false);
            if(component.get('v.IsRoleOfConceptionEntered') === false && component.set('v.IsNameChoosen') === false)
            {
                isValid = true;
            }
        }
       	//alert('Role of conception-->'+component.get('v.IsRoleOfConceptionEntered'));
        //alert('>>>>>>>>'+isValid );
        return isValid;
    }
	//-----------------------------------------------------------------------
})
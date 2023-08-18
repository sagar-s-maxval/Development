({ 
    init: function(component, event, helper) {
        //alert('primarycontact'+component.get('v.primarycontact'));
        
        //console.log('init'+component.get('v.primarycontact'));
        if((component.get("v.IDF")!= null && component.get("v.IDF") != "false") )
        { 
            //----------SAVE BUTTON REPLACEMENT ---------------
            var listInventorsSelected = component.get("v.InventorRecords");
            if(listInventorsSelected.length === 0)
            {
                listInventorsSelected.push({
                    'sobjectType' : 'WrapperInventorInfo',
                    'Recid':'',
                    'Name' : '',
                    'RoleOfConception' : '',
                    'IsPrimary':false,
                    'IndexVal':0
                });
                component.set("v.InventorRecords", listInventorsSelected);
            }
            //-------------------------------------------------
            //Basic Invention Info----
            
            component.set("v.VDTTitle",component.get("v.Title"));
            component.set("v.VDTSummary",component.get("v.Summary"));
            component.set("v.VDTPath",component.get("v.Path")); 
            component.set("v.VDTCurrentStageOfInvention",component.get("v.stages"));
            //Contributor Information
            component.set("v.VDTPrimaryInventor",component.get("v.primaryInventor"));
            //  alert('load----inv---'+component.get("v.primaryInventor"));
            if(component.get("v.primaryInventor") != null)
            {
                component.set('v.ValidatePrimaryInventor',false);
            }
            //alert('7777777777'+component.get('v.ValidatePrimaryInventor'));
            //Invention Description
            component.set("v.VDTProblemQ11",component.get("v.question11")); 
            //alert('question11'+ component.get("v.question11"));
            component.set("v.VDTSolutionQ12",component.get("v.question12"));
            //alert('question12'+ component.get("v.question12"));
            component.set("v.VDTFeatureQ13",component.get("v.question13")); 
            component.set("v.VDTAlternativeQue14",component.get("v.question14"));
            //Additional Questions
            //Prior Submission
            //component.set("v.VDTIsPriorsubmission21Event",component.get("v.VDTIsPriorsubmission21Event")); 
            component.set("v.VDTIsPriorsubmission21Event",component.get("v.questioncheckbox21"));
            component.set("v.VDTPriorsubmissionEvent21",component.get("v.question21Textbox"));
            
            //Public Disclosures
            //component.set("v.VDTISPublicDisclosureCheckQ22",component.get("v.VDTISPublicDisclosureCheckQ22"));
            component.set("v.VDTISPublicDisclosureCheckQ22",component.get("v.questioncheckbox22"));
            component.set("v.VDTPublicDisclosure22",component.get("v.question22Textbox"));
            component.set("v.VDTPublicDisclosureDate",component.get("v.Question22PublicDisDate"));
            
            
            //Current Commercial use
            component.set("v.VDTIsCommercialCheckQ23",component.get("v.questioncheckbox23")); 
            component.set("v.VDTCommercialEvent23",component.get("v.question23Textbox")); 
            component.set("v.VDTEarlierUsedDate",component.get("v.Question23earlierUseDate"));
            component.set("v.VDTExternalUse",component.get("v.question230Textbox"));
            //component.set("v.ExternalUseEvent23Chk",component.get("v.questioncheckbox230"));
            component.set("v.VDTExternalUseChk",component.get("v.questioncheckbox230"));
            component.set("v.VDTEarlierExternalUseDate",component.get("v.Question24EarlierExternalUseDate"));
            
            
            //Future Implementation
            //component.set("v.VDTFutureimplementation24checkbox",component.get("v.VDTFutureimplementation24checkbox"));
            //component.set("v.VDTFutureimplementation24checkbox",component.get("v.questioncheckbox25")); commented on 8/4/2020 to resolve switching/toggle between 2.4 and 2.5 questions - Leena
            component.set("v.VDTFutureimplementation24checkbox",component.get("v.questioncheckbox24")); 
            //alert('VDTFutureimplementation24checkbox'+component.get("v.VDTFutureimplementation24checkbox"));
            component.set("v.VDTFutureEventQ24",component.get("v.question24Textbox"));
            //Competing Products / Solutions
            component.set("v.VDTIsproductsQ25checkbox",component.get("v.questioncheckbox25"));
            component.set("v.VDTproductsQ25",component.get("v.question25Textbox")); 
            component.set("v.VDTEarlierPlannedUseDate",component.get("v.Question25EarlierPlannedDate"));
            
            
            //Third Party Contributions
            //alert('Third party--->'+component.get("v.questioncheckbox26"));
            component.set("v.VDTIsThirdparty26checkbox",component.get("v.questioncheckbox26"));
            component.set("v.VDTThirdPartyQ26",component.get("v.question26Textbox"));
            //Detection
            component.set("v.VDTIsReverseDetection",component.get("v.questioncheckbox27A")); 
            component.set("v.VDTReverseDetection",component.get("v.questionTextbox27A"));
            component.set("v.VDTTestingchk",component.get("v.questioncheckbox27B"));
            component.set("v.VDTTestingtxt",component.get("v.questionTextbox27B"));
            component.set("v.VDTliteraturechk",component.get("v.questioncheckbox27C"));
            component.set("v.VDTliteratureTxt",component.get("v.questionTextbox27C"));
            component.set("v.VDTOtherChk",component.get("v.questioncheckbox27F"));
            component.set("v.VDTOtherTxt",component.get("v.questionTextbox27F"));
            component.set("v.VDTThirdPartyConfidentiality",component.get("v.Confidentialityadded"));
            //alert('on load confi txt-- >' +component.get("v.VDTThirdPartyConfidentiality"));
            component.set("v.VDTIsThirdPartyConfidentiality",component.get("v.IsConfidentialityadded"));
            component.set("v.VDTManagingSegment",component.get("v.ManagingSegments")); //Managing Segment
            //alert('Value passed from flow'+component.get("v.IsConfidentialityadded"));
            //alert('VDTIsThirdPartyConfidentiality-- >' +component.get("v.VDTIsThirdPartyConfidentiality"));
            component.set("v.VDTImpossible",component.get("v.questioncheckbox27D"));
            component.set("v.VDTDontKnow",component.get("v.questioncheckbox27E"));
            
            //Business Value
            component.set("v.VDTBusinessValue",component.get("v.quest29")); 
            
        }
        /*     else
        {
            //alert('Date on load -->'+component.get("v.Question22PublicDisDate"));
            //var newdate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
          //  var currentTime = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
           // var currentTimeStr = currentTime.toString();
           // component.set("v.VDTPublicDisclosureDate",currentTimeStr);
           // component.set("v.Question22PublicDisDate",currentTimeStr);
            //alert(currentTimeStr+'currentTimeStr');
        } */
        
    },
    //Save button controller
    handleChange : function(component, event, helper) 
    {
        //alert('saving');
        /*alert('save'); 
        alert('VDTIsPriorsubmission21Event'+component.get("v.VDTIsPriorsubmission21Event"));
        alert('VDTISPublicDisclosureCheckQ22'+component.get("v.VDTISPublicDisclosureCheckQ22"));
        alert('VDTIsCommercialCheckQ23'+component.get("v.VDTIsCommercialCheckQ23"));
        alert('VDTExternalUseChk'+component.get("v.VDTExternalUseChk"));
        alert('VDTFutureimplementation24checkbox'+component.get("v.VDTFutureimplementation24checkbox"));
        alert('VDTIsproductsQ25checkbox'+component.get("v.VDTIsproductsQ25checkbox"));
        alert('VDTIsThirdparty26checkbox'+component.get("v.VDTIsThirdparty26checkbox"));
        alert('VDTIsThirdPartyConfidentiality'+component.get("v.VDTIsThirdPartyConfidentiality"));
        alert('VDTPriorsubmissionEvent21'+component.get('v.VDTPriorsubmissionEvent21'));
        alert('VDTPublicDisclosureDate'+component.get("v.VDTPublicDisclosureDate"));
        alert('VDTPublicDisclosure22'+component.get("v.VDTPublicDisclosure22"));
        alert('VDTCommercialEvent23'+component.get("v.VDTCommercialEvent23"));
        alert('VDTExternalUse'+component.get("v.VDTExternalUse"));
        alert('VDTFutureEventQ24'+component.get("v.VDTFutureEventQ24"));
        alert('VDTproductsQ25'+component.get("v.VDTproductsQ25"));
        alert('VDTThirdPartyQ26'+component.get("v.VDTThirdPartyQ26"));
        alert('VDTThirdPartyConfidentiality'+component.get("v.VDTThirdPartyConfidentiality"));
        alert('VDTDontKnow'+component.get("v.VDTDontKnow"));
        alert('VDTImpossible'+component.get("v.VDTImpossible"));
        alert('VDTOtherTxt'+component.get("v.VDTOtherTxt"));
        alert('VDTOtherChk'+component.get("v.VDTOtherChk"));
        alert('VDTliteratureTxt'+component.get("v.VDTliteratureTxt"));
        alert('VDTliteraturechk'+component.get("v.VDTliteraturechk"));
        alert('VDTTestingtxt'+component.get("v.VDTTestingtxt"));
        alert('VDTTestingchk'+component.get("v.VDTTestingchk"));
        alert('VDTReverseDetection'+component.get("v.VDTReverseDetection"));
        alert('VDTIsReverseDetection'+component.get("v.VDTIsReverseDetection"));*/
        //alert('VDTPublicDisclosure22'+component.get("v.VDTPublicDisclosure22"));
        //alert('VDTPublicDisclosureDate'+component.get("v.VDTPublicDisclosureDate"));
        //alert('VDTIsCommercialCheckQ23'+component.get("v.VDTIsCommercialCheckQ23"));
        var listOfInventorIds = [];
        var listOfConcatenatedInfoInvs = [];
        var response = event.getSource().getLocalId();
        //alert('VDTTitle'+component.get('v.VDTTitle'));
        //alert('OnsaveValidateInv'+component.get('v.OnsaveValidateInv'));
        //alert('InvalidInvSearch'+component.get('v.InvalidInvSearch'));
        //  alert('primarycontact'+component.get('v.primarycontact'));
        //alert('inventor21--'+component.get("v.VDTTitle"));
        //alert('error valueee '+component.get("v.isBlankInv"));
        //alert('error '+component.get('v.InvalidInvSearch'));
        //alert('error2 '+component.get('v.OnsaveValidateInv'));
        
        // Changes for solving blank and Invalid Inventors related issue
        // Start
        var AllRowsList = component.get("v.InventorRecords");
        console.log('AllRowsList '+JSON.stringify(AllRowsList));
        //alert('on save '+JSON.stringify(AllRowsList));
        //alert('invrec '+AllRowsList);
        //AllRowsList.splice(DeleteinvsElement,1);
        //----------
        var chkbool = false;
        for(var i=0; i < AllRowsList.length; i++)
        {
            //alert('invrec 22'+JSON.stringify(AllRowsList[i]));
            if((AllRowsList[i].Name=='' || AllRowsList[i].Name==undefined) && AllRowsList[i].Recid=='')
            {
                chkbool = true;
                break;
            } else {
                chkbool = false;
            }
        }
        if(chkbool == true) 
        {
            component.set('v.OnsaveValidateInv',true);
            component.set('v.InvalidInvSearch','InvalidInventor');
        } else {
            component.set('v.OnsaveValidateInv',false);
            component.set('v.InvalidInvSearch','');
        }
        //alert('chkbool '+chkbool);
        //----------
        component.set('v.InventorRecords',AllRowsList);
        //End
        var Onsave = component.get('v.OnsaveValidateInv');
        var Search = component.get('v.InvalidInvSearch');
        console.log('OnsaveValidateInv-->'+Onsave);
        console.log('InvalidInvSearch-->'+Search);
        if((component.get("v.VDTTitle") === " " )|| (component.get("v.VDTTitle") === null)|| (component.get("v.VDTTitle").length === 0) || (component.get('v.OnsaveValidateInv') === true) || component.get('v.InvalidInvSearch') === 'InvalidInventor')
        {
            if((component.get("v.VDTTitle") === " " )|| (component.get("v.VDTTitle") === null)|| (component.get("v.VDTTitle").length === 0))
            {
                component.set('v.ErrorMessage','Please provide a title for the invention');
                
            }
            if((component.get("v.VDTSummary") === " " )|| (component.get("v.VDTSummary") === null)|| (component.get("v.VDTSummary").length === 0))
            {
                component.set('v.ErrorMessage','Please provide a Summary of the Invention');
            }
            
            
            
            else if((component.get('v.OnsaveValidateInv') === true)&& (component.get('v.InvalidInvSearch') === 'InvalidInventor'))
            {
                component.set('v.ErrorMessage','Please select valid Inventor(s)...');
            }
            
            /* else if(((Onsave === true)||(Onsave === false))&& ((Search =='InvalidInventor')||((Search =='')||(Search == null))))
                {
                    alert('inside error if ');
                    component.set('v.ErrorMessage','Please select valid Inventor(s)...');
                }
            */
            component.set('v.Error',true);
            
            // Adding to fire the error msg from cmp1 to cmp2 -----***
            var Err = component.get("v.ErrorMessage");
            // alert(Err);
            var cmpevent = $A.get('e.c:cmpsubmitAndSaveBottom2Event');
            cmpevent.setParams({"ErrorMessage2":Err});
            cmpevent.fire();
            
            //------------------------------------------------------
            
        }     
        else
        {
            component.set('v.Error',false);
            component.set('v.ErrorMessage','');
            //------------------ 7/5/2020----------
            
            if(component.get("v.VDTIsPriorsubmission21Event") === '')
            {
                component.set("v.VDTIsPriorsubmission21Event",'true');
            }
            if(component.get("v.VDTISPublicDisclosureCheckQ22") === '')
            {
                component.set("v.VDTISPublicDisclosureCheckQ22",'true');
            }
            if(component.get("v.VDTIsCommercialCheckQ23") === '')
            {
                component.set("v.VDTIsCommercialCheckQ23",'true');
            }
            if(component.get("v.VDTExternalUseChk") === '')
            {
                component.set("v.VDTExternalUseChk",'true');
            }
            if(component.get("v.VDTFutureimplementation24checkbox") === '')
            {
                component.set("v.VDTFutureimplementation24checkbox",'true');
            }
            if(component.get("v.VDTIsproductsQ25checkbox") === '')
            {
                component.set("v.VDTIsproductsQ25checkbox",'true');
            }
            if(component.get("v.VDTIsThirdparty26checkbox") === '')
            {
                component.set("v.VDTIsThirdparty26checkbox",'true');
            }
            if(component.get("v.VDTIsThirdPartyConfidentiality") === '')
            {
                component.set("v.VDTIsThirdPartyConfidentiality",'true');
            }
            //alert('else');
            var cmpevent = $A.get('e.c:FooterToForm2CheckBoxesEvt');
            cmpevent.setParams({'IsPrior':component.get("v.VDTIsPriorsubmission21Event"),
                                'IsPublic':component.get("v.VDTISPublicDisclosureCheckQ22"),
                                'IsCommercial':component.get("v.VDTIsCommercialCheckQ23"),
                                'IsExternal':component.get("v.VDTExternalUseChk"),
                                'IsFuture':component.get("v.VDTFutureimplementation24checkbox"),
                                'IsProduct':component.get("v.VDTIsproductsQ25checkbox"),
                                'IsThirdparty':component.get("v.VDTIsThirdparty26checkbox"),
                                'IsThirdPartyConf':component.get("v.VDTIsThirdPartyConfidentiality"),
                                'PriorText':component.get('v.VDTPriorsubmissionEvent21'),
                                'PublicDate':component.get("v.VDTPublicDisclosureDate"),
                                'PublicText':component.get("v.VDTPublicDisclosure22"),
                                'PublicDate1':component.get("v.VDTEarlierUsedDate"),
                                
                                'CommercialText':component.get("v.VDTCommercialEvent23"),
                                'PublicDate2':component.get("v.VDTEarlierExternalUseDate"),
                                'ExternalText':component.get("v.VDTExternalUse"),
                                'FutureText':component.get("v.VDTFutureEventQ24"),
                                'PublicDate3':component.get("v.VDTEarlierPlannedUseDate"),
                                'ProductText':component.get("v.VDTproductsQ25"),
                                'ThirdPartyText':component.get("v.VDTThirdPartyQ26"),
                                'ThirdPartyConfiText':component.get("v.VDTThirdPartyConfidentiality")});
            cmpevent.fire();
            //-------------------------------------
            /*   var navEvt = $A.get("e.force:navigateToSObject");
            
            navEvt.setParams({ "recordId": component.get("v.IDF")}); 
           
            navEvt.fire(); 
            */
            //var invidsStr = component.get('v.strSelectedInventorIdsTemp');
            //var invInfoStr = component.get('v.strSelectedInventorInfoTemp');
            var invidconcatenate = [];
            var invinfoconcatenate = [];
            var primaryInventor = false;
            //alert('Records -->'+JSON.stringify(component.get('v.InventorRecords')));
            var ListOfInventorsWithRole = component.get('v.InventorRecords');
            for(var i=0; i < ListOfInventorsWithRole.length; i++)
            {
                var recordval = ListOfInventorsWithRole[i];
                listOfInventorIds.push(recordval.Recid);
                //invidconcatenate = listOfInventorIds.join(',');
                component.set('v.strSelectedInventorIds',listOfInventorIds.join(', '));
                if(i == 0)
                {
                    primaryInventor = true;
                }
                else
                {
                    primaryInventor = false;
                }
                //alert('----'+recordval.EmailId);
                
                
                
                listOfConcatenatedInfoInvs.push(recordval.Recid+'<#>'+recordval.RoleOfConception+'<#>'+primaryInventor+'<#>'+recordval.EmailId);
                //invinfoconcatenate = listOfConcatenatedInfoInvs.join(',');
                component.set('v.strSelectedInventorInfo',listOfConcatenatedInfoInvs.join('<###>'));
            }
            
            var j=0;
            var listtemp = [];
            for(var i=0; i < ListOfInventorsWithRole.length; i++)
            {
                var temp = ListOfInventorsWithRole[j];
                j=j+1;
                listtemp.push(temp);
            }
            //alert('listtemp'+listtemp);
            
            //component.set('v.strSelectedInventorIds',invidsStr+','+invidconcatenate);
            //component.set('v.strSelectedInventorInfo',invInfoStr+','+invinfoconcatenate);
            //alert('save list1'+component.get('v.strSelectedInventorIds'));
            //alert('save list2'+component.get('v.strSelectedInventorInfo'));
            var cmp = $A.get('e.c:InventorsFinalSelectedListEvt');
            cmp.setParams({'strSelectedInventorIdsEvt':component.get('v.strSelectedInventorIds'),'strSelectedInventorInfoEvt':component.get('v.strSelectedInventorInfo')});
            cmp.fire();
            
            var navigate = component.get("v.navigateFlow");
            //    alert('-------'+response);
            if(response=='HomId')
            { 	   
                if((component.get("v.IDF")!= null && component.get("v.IDF") != "false") )
                {
                    window.open('/one/one.app?#/sObject/'+component.get("v.IDF")+'/view',"_self");
                }
                navigate("NEXT");
                //  alert(event.getParam("status"));
                if(event.getParam("status") === "FINISHED")
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Success!",
                        "message": "The record has been updated successfully."
                    }); 
                    
                    toastEvent.fire();
                }
            } 
            component.set("v.savebutton",true);
            
            
        }
    },
    //Submit button controller
    handleChange2 : function(component, event, helper) 
    {
        //alert('saving123');
        //---------------------------SAVE BUTTON REPLACEMENT ----------------------------
        // try{
        
        debugger
        var listOfInventorIds = [];
        var listOfConcatenatedInfoInvs = [];
        var validate = helper.validateRequired(component, event,helper);
        var ListOfInventorsWithRole = component.get('v.InventorRecords');
        //alert('ListOfInventorsWithRole --->'+JSON.stringify(ListOfInventorsWithRole));
        /*else 
        {
            if(component.get('v.ValidatePrimaryInventor') == false)
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type": 'error',
                    "message": "Please fill the details of Inventors..."
                });
                toastEvent.fire();
            }
        }*/
        
        // alert('VDTThirdPartyConfidentiality-->'+component.get("v.VDTThirdPartyConfidentiality"));
        var response = event.getSource().getLocalId();
        var ErrorList=[];
        //alert('response-----'+response);
        component.set("v.ErrorMessage","");
        var error = component.set("v.ErrorFields",[]);
        
        //alert('pri inv'+component.get("v.VDTPrimaryInventor") );
        if(component.get("v.VDTPrimaryInventor") != null)
        {
            component.set('v.ValidatePrimaryInventor',false);
        }
        //alert('inventor22--'+component.get("v.VDTTitle"));
        //alert('prior chk value--->'+component.get("v.VDTISPublicDisclosureCheckQ22"));
        if((component.get("v.VDTTitle") === " " )|| (component.get("v.VDTTitle") === null)|| (component.get("v.VDTTitle").length === 0) 
           || (component.get("v.VDTSummary") === " " )|| (component.get("v.VDTSummary") === null)|| (component.get("v.VDTSummary").length === 0)
           
           //|| (component.get("v.VDTManagingSegment") === " " )|| (component.get("v.VDTManagingSegment") === null)|| (component.get("v.VDTManagingSegment").length === 0)
           || (component.get("v.VDTPath") === " " )|| (component.get("v.VDTPath") === null)|| (component.get("v.VDTPath").length === 0)
           || (component.get("v.VDTCurrentStageOfInvention") === " " )|| (component.get("v.VDTCurrentStageOfInvention") === null)|| (component.get("v.VDTCurrentStageOfInvention").length === 0)
           //|| (component.get("v.VDTPrimaryInventor") === " " )|| (component.get("v.VDTPrimaryInventor") === null)|| (component.get("v.VDTPrimaryInventor").length === 0)
           || (component.get("v.VDTProblemQ11") === " " )|| (component.get("v.VDTProblemQ11") === null)|| (component.get("v.VDTProblemQ11").length === 0)
           || (component.get("v.VDTSolutionQ12") === " " )|| (component.get("v.VDTSolutionQ12") === null)|| (component.get("v.VDTSolutionQ12").length === 0)
           || (component.get("v.VDTFeatureQ13") === " " )|| (component.get("v.VDTFeatureQ13") === null)|| (component.get("v.VDTFeatureQ13").length === 0)
           || (component.get("v.VDTAlternativeQue14") === " " )|| (component.get("v.VDTAlternativeQue14") === null)|| (component.get("v.VDTAlternativeQue14").length === 0)
           || ((component.get("v.VDTIsPriorsubmission21Event") === '')||(((component.get("v.VDTIsPriorsubmission21Event") === 'true')||(component.get("v.VDTIsPriorsubmission21Event") === true)) && ((component.get("v.VDTPriorsubmissionEvent21") === '') || (component.get("v.VDTPriorsubmissionEvent21") === null)|| (component.get("v.VDTPriorsubmissionEvent21").length === 0))))
           
           
           
           || ((component.get("v.VDTISPublicDisclosureCheckQ22") === '')||(((component.get("v.VDTISPublicDisclosureCheckQ22") === 'true')||(component.get("v.VDTISPublicDisclosureCheckQ22") === true)) &&  ((component.get("v.VDTPublicDisclosureDate") === '') || (component.get("v.VDTPublicDisclosureDate") === null)  || (component.get("v.VDTPublicDisclosureDate").length === 0)  
                                                                                                                                                                                                             && (component.get("v.VDTPublicDisclosure22") === '') || (component.get("v.VDTPublicDisclosure22") === null)|| (component.get("v.VDTPublicDisclosure22").length === 0))))
           
           
           
           //|| ((component.get("v.VDTIsCommercialCheckQ23") === '')||(((component.get("v.VDTIsCommercialCheckQ23") === 'true')||(component.get("v.VDTIsCommercialCheckQ23") === true)) &&  ((component.get("v.VDTEarlierUsedDate") === '') || (component.get("v.VDTEarlierUsedDate") === null)  
           //        && (component.get("v.VDTCommercialEvent23") === '') || (component.get("v.VDTCommercialEvent23") === null)|| (component.get("v.VDTCommercialEvent23").length === 0))))
           
           
           // || ((component.get("v.VDTIsCommercialCheckQ23") === '')||(((component.get("v.VDTIsCommercialCheckQ23") === 'true')||(component.get("v.VDTIsCommercialCheckQ23") === true)) && ((component.get("v.VDTCommercialEvent23") ==='') || (component.get("v.VDTCommercialEvent23") === null)|| (component.get("v.VDTCommercialEvent23").length === 0))
           //  && ((component.get("v.VDTEarlierUsedDate") === '') || (component.get("v.VDTEarlierUsedDate") === null)|| (component.get("v.VDTEarlierUsedDate").length === 0))))
           
           
           || ((component.get("v.VDTExternalUseChk") === '')||(((component.get("v.VDTExternalUseChk") === 'true')||(component.get("v.VDTExternalUseChk") === true)) && ((component.get("v.VDTExternalUse") === '') || (component.get("v.VDTExternalUse") === null)|| (component.get("v.VDTExternalUse").length === 0)))	
               &&  ((component.get("v.VDTEarlierExternalUseDate") === '') || (component.get("v.VDTEarlierExternalUseDate") === null)|| (component.get("v.VDTEarlierExternalUseDate").length === 0)))
           
           // || ((component.get("v.VDTExternalUseChk") === '')||(((component.get("v.VDTExternalUseChk") === 'true')||(component.get("v.VDTExternalUseChk") === true)) &&  ((component.get("v.VDTEarlierExternalUseDate") === '') || (component.get("v.VDTEarlierExternalUseDate") === null)
           //         && (component.get("v.VDTExternalUse") === '') || (component.get("v.VDTExternalUse") === null)|| (component.get("v.VDTExternalUse").length === 0))))
           
           
           //  || ((component.get("v.VDTExternalUseChk") === '')||(((component.get("v.VDTExternalUseChk") === 'true')||(component.get("v.VDTExternalUseChk") === true)) && ((component.get("v.VDTExternalUse") === '') || (component.get("v.VDTExternalUse") === null)|| (component.get("v.VDTExternalUse").length === 0))
           //  &&  ((component.get("v.VDTEarlierExternalUseDate") === '') || (component.get("v.VDTEarlierExternalUseDate") === null)|| (component.get("v.VDTEarlierExternalUseDate").length === 0))))
           
           
           
           
           || ((component.get("v.VDTFutureimplementation24checkbox") === '')||(((component.get("v.VDTFutureimplementation24checkbox") === 'true')||(component.get("v.VDTFutureimplementation24checkbox") === true)) && ((component.get("v.VDTFutureEventQ24") === '') || (component.get("v.VDTFutureEventQ24") === null)|| (component.get("v.VDTFutureEventQ24").length === 0)))	
               &&  ((component.get("v.VDTEarlierPlannedUseDate") === '') || (component.get("v.VDTEarlierPlannedUseDate") === null)|| (component.get("v.VDTEarlierPlannedUseDate").length === 0)))
           
           //|| ((component.get("v.VDTFutureimplementation24checkbox") === '')||(((component.get("v.VDTFutureimplementation24checkbox") === 'true')||(component.get("v.VDTFutureimplementation24checkbox") === true)) &&  ((component.get("v.VDTEarlierPlannedUseDate") === '') || (component.get("v.VDTEarlierPlannedUseDate") === null)  
           //       && (component.get("v.VDTFutureEventQ24") === '') || (component.get("v.VDTFutureEventQ24") === null)|| (component.get("v.VDTFutureEventQ24").length === 0))))
           
           
           // || ((component.get("v.VDTFutureimplementation24checkbox") === '')||(((component.get("v.VDTFutureimplementation24checkbox") === 'true')||(component.get("v.VDTFutureimplementation24checkbox") === true)) && ((component.get("v.VDTFutureEventQ24") === '') || (component.get("v.VDTFutureEventQ24") === null)|| (component.get("v.VDTFutureEventQ24").length === 0))
           //&&  ((component.get("v.VDTEarlierPlannedUseDate") === '') || (component.get("v.VDTEarlierPlannedUseDate") === null)|| (component.get("v.VDTEarlierPlannedUseDate").length === 0))))
           
           
           
           
           
           || ((component.get("v.VDTIsproductsQ25checkbox") === '')||(((component.get("v.VDTIsproductsQ25checkbox") === 'true')||(component.get("v.VDTIsproductsQ25checkbox") === true)) && ((component.get("v.VDTproductsQ25") ==='') || (component.get("v.VDTproductsQ25") === null)|| (component.get("v.VDTproductsQ25").length === 0))))
           || ((component.get("v.VDTIsThirdparty26checkbox") === '')||(((component.get("v.VDTIsThirdparty26checkbox") === 'true')||(component.get("v.VDTIsThirdparty26checkbox") === true)) && ((component.get("v.VDTThirdPartyQ26") === '') || (component.get("v.VDTThirdPartyQ26") === null)|| (component.get("v.VDTThirdPartyQ26").length === 0))))
           || ((component.get("v.VDTIsReverseDetection") === true) && ((component.get("v.VDTReverseDetection") ==='') || (component.get("v.VDTReverseDetection") === null)|| (component.get("v.VDTReverseDetection").length === 0)))
           || ((component.get("v.VDTTestingchk") === true) && ((component.get("v.VDTTestingtxt") ==='') || (component.get("v.VDTTestingtxt") === null)|| (component.get("v.VDTTestingtxt").length === 0)))
           || ((component.get("v.VDTliteraturechk") === true) && ((component.get("v.VDTliteratureTxt") ==='') || (component.get("v.VDTliteratureTxt") === null)|| (component.get("v.VDTliteratureTxt").length === 0)))
           || ((component.get("v.VDTOtherChk") === true) && ((component.get("v.VDTOtherTxt") ==='') || (component.get("v.VDTOtherTxt") === null)|| (component.get("v.VDTOtherTxt").length === 0)))
           || ((component.get("v.VDTIsThirdPartyConfidentiality") ==='')||(((component.get("v.VDTIsThirdPartyConfidentiality") ==='true')||(component.get("v.VDTIsThirdPartyConfidentiality") === true)) && ((component.get("v.VDTThirdPartyConfidentiality") ==='') || (component.get("v.VDTThirdPartyConfidentiality") === null)|| (component.get("v.VDTThirdPartyConfidentiality").length === 0))))
           //|| ((component.get("v.VDTIsThirdPartyConfidentiality") === true) && ((component.get("v.VDTIsThirdPartyConfidentiality") === "") || (component.get("v.VDTIsThirdPartyConfidentiality") === null)|| (component.get("v.VDTIsThirdPartyConfidentiality").length === 0)))
           || (((component.get("v.VDTPrimaryInventor") ==='')|| (component.get("v.VDTPrimaryInventor") === null)|| (component.get("v.VDTPrimaryInventor").length === 0)  || (component.get('v.IsValid') === false) || (component.get('v.ValidatePrimaryInventor') === true)))
           || ((component.get("v.VDTIsReverseDetection") === false) && (component.get("v.VDTTestingchk") === false) && (component.get("v.VDTliteraturechk") === false)  && (component.get("v.VDTOtherChk") === false) && (component.get("v.VDTImpossible") === false) && (component.get("v.VDTDontKnow") === false ))
           ||((component.get("v.DevelopedForOtherSegment")=='Yes') &&( (component.get("v.OtherBusinessSegment") === " " )|| (component.get("v.OtherBusinessSegment") === undefined)))
           ||((component.get("v.DevelopedForOtherSegment")=='Yes') &&( (component.get("v.ContactFromOtherBusinessSegment") === " " )|| (component.get("v.ContactFromOtherBusinessSegment") === undefined)))
           ||((component.get("v.DevelopedForOtherSegment")=='Yes') &&( (component.get("v.otherContribution") === " " )|| (component.get("v.otherContribution") === undefined)))
           ||(component.get("v.OtherBusinessProblem") === " " )|| (component.get("v.OtherBusinessProblem") === undefined)
           ||(component.get("v.BusinessSegment") === " " )|| (component.get("v.BusinessSegment") === undefined)
           || (component.get("v.VDTBusinessValue") === " " )|| (component.get("v.VDTBusinessValue") === null)|| (component.get("v.VDTBusinessValue").length === 0))
            
        {
            
            
            
            if((component.get("v.VDTTitle") === " " )|| (component.get("v.VDTTitle") === null)|| (component.get("v.VDTTitle").length === 0))
            {   
                ErrorList.push(" Title of Invention");
            }
            if((component.get("v.VDTSummary") === " " )|| (component.get("v.VDTSummary") === null)|| (component.get("v.VDTSummary").length === 0))
            {   
                ErrorList.push(" Summary of the Invention");
            }
            
            
            if(component.get("v.BusinessSegment")===undefined || component.get("v.BusinessSegment")==''){
                ErrorList.push(" Business Segment");
            }
            if((component.get("v.DevelopedForOtherSegment")=='Yes') && (component.get("v.OtherBusinessSegment")===undefined || component.get("v.OtherBusinessSegment")=='')){
                ErrorList.push(" Other Business Segment");
            }
            if((component.get("v.DevelopedForOtherSegment")=='Yes')&& (component.get("v.ContactFromOtherBusinessSegment")===undefined || component.get("v.ContactFromOtherBusinessSegment")=='')){
                ErrorList.push(" Contact From Other Business Segment");
            }
            if(component.get("v.DevelopedForOtherSegment")=='Yes'){
                if(component.get("v.otherContribution")===undefined || component.get("v.otherContribution")==''){
                    ErrorList.push(" Describe Contribution from Other Business Segment");
                }else{
                    var charLength=component.get("v.otherContribution").length;
                    if(charLength > 255){
                        ErrorList.push(" Describe Contribution from Other Business Segment length should not be more than 255 characters");
                    }
                }
            }
            if(component.get("v.OtherBusinessProblem")===undefined || component.get("v.OtherBusinessProblem")==''){
                ErrorList.push(" What individual or business first identified the problem, or business need, to be solved by this invention?");
            }
            if((component.get("v.VDTPath") === " " )|| (component.get("v.VDTPath") === null)|| (component.get("v.VDTPath").length === 0))
            {
                ErrorList.push(" PRB Technology Area");
            }
            if((component.get("v.VDTCurrentStageOfInvention") === " " )|| (component.get("v.VDTCurrentStageOfInvention") === null)|| (component.get("v.VDTCurrentStageOfInvention").length === 0))
            {
                ErrorList.push(" Current stage of invention");
            }
            
            //Ends here
            //  alert('2/*/*');
            
            //alert('Before if -- Primary Inventor error'+component.get("v.VDTPrimaryInventor")+'--size--'+component.get("v.VDTPrimaryInventor").length); //component.get("v.VDTInventorsSelected").length === 0) || 
            if(((component.get("v.VDTPrimaryInventor") === " " )|| (component.get("v.VDTPrimaryInventor") === null)|| (component.get("v.VDTPrimaryInventor").length === 0)|| (component.get('v.IsValid') === false) || (component.get('v.ValidatePrimaryInventor') === true)))
            {
                //if((component.get("v.VDTPrimaryInventor") === " " )|| (component.get("v.VDTPrimaryInventor") === null)|| (component.get("v.VDTPrimaryInventor").length === 0))
                //{
                //alert('pri'+component.get('v.ValidatePrimaryInventor'));
                //alert('Primary Inventor error'); //component.get("v.VDTInventorsSelected").length === 0) ||
                if((component.get("v.VDTPrimaryInventor") === " " )|| (component.get("v.VDTPrimaryInventor") === null)|| (component.get("v.VDTPrimaryInventor").length === 0) || (component.get('v.ValidatePrimaryInventor') === true) )
                {
                    ErrorList.push("First Named Inventor");          
                }
                if((component.get('v.IsValid') === false) && (component.get('v.IsRoleOfConceptionEntered') === true))
                {
                    ErrorList.push(" Role In Conception");
                }
                else if(component.get('v.IsValid') === false)
                {
                    ErrorList.push(" Inventor(s)");
                }
                /*if((component.get('v.IsValid') === false) && (component.get('v.IsNameChoosen') === true))
                {
                    ErrorList.push("Inventor(s)");
                }
                if((component.get('v.IsValid') === false) && (component.get('v.IsRoleOfConceptionEntered') === true))
                {
                    ErrorList.push("Role In Conception");
                }*/
            
            //}
        }
            
            // alert('ErrorList'+ErrorList);
            
            /*if((component.get("v.VDTThirdPartyConfidentiality") === " " )|| (component.get("v.VDTThirdPartyConfidentiality") === null)|| (component.get("v.VDTThirdPartyConfidentiality").length === 0))
            {
                ErrorList.push("Third Party Confidentiality");
            } */
            
            if((component.get("v.VDTProblemQ11") === " " )|| (component.get("v.VDTProblemQ11") === null)|| (component.get("v.VDTProblemQ11").length === 0))
            {
                ErrorList.push(" Question 1.1");
            }
            if((component.get("v.VDTSolutionQ12") === " " )|| (component.get("v.VDTSolutionQ12") === null)|| (component.get("v.VDTSolutionQ12").length === 0))
            {
                ErrorList.push(" Question 1.2");
            }
            if((component.get("v.VDTFeatureQ13") === " " )|| (component.get("v.VDTFeatureQ13") === null)|| (component.get("v.VDTFeatureQ13").length === 0))
            {
                ErrorList.push(" Question 1.3");
            }
            if((component.get("v.VDTAlternativeQue14") === " " )|| (component.get("v.VDTAlternativeQue14") === null)|| (component.get("v.VDTAlternativeQue14").length === 0))
            {
                ErrorList.push(" Question 1.4");
            }
            if((component.get("v.VDTIsPriorsubmission21Event") === '')||(((component.get("v.VDTIsPriorsubmission21Event") === 'true')||(component.get("v.VDTIsPriorsubmission21Event") === true)) && ((component.get("v.VDTPriorsubmissionEvent21") === '') || (component.get("v.VDTPriorsubmissionEvent21") === null)|| (component.get("v.VDTPriorsubmissionEvent21").length === 0))))
            {
                if(component.get("v.VDTIsPriorsubmission21Event") === '')
                {
                    ErrorList.push(" 2.1 Prior Submissions");
                }
                else if((component.get("v.VDTIsPriorsubmission21Event") === 'true')||(component.get("v.VDTIsPriorsubmission21Event") === true))
                {
                    if((component.get("v.VDTPriorsubmissionEvent21") ==='')|| (component.get("v.VDTPriorsubmissionEvent21") === null)|| (component.get("v.VDTPriorsubmissionEvent21").length === 0))
                    {
                        ErrorList.push(" 2.1 Prior Submissions Text Box");
                        //   alert('ErrorList'+ErrorList);
                    }
                }
            }
            
            if((component.get("v.VDTISPublicDisclosureCheckQ22") ==='')||(((component.get("v.VDTISPublicDisclosureCheckQ22") == 'true')||(component.get("v.VDTISPublicDisclosureCheckQ22") == true)) || ((component.get("v.VDTPublicDisclosureDate") ===" ") || (component.get("v.VDTPublicDisclosureDate") === null)|| (component.get("v.VDTPublicDisclosureDate").length === 0)
                                                                                                                                                                                                         && (component.get("v.VDTPublicDisclosure22") ==='') || (component.get("v.VDTPublicDisclosure22") === null)|| (component.get("v.VDTPublicDisclosure22").length === 0))))
            {	  
                if(component.get("v.VDTISPublicDisclosureCheckQ22") ==='')
                {
                    ErrorList.push(" 2.2 Public Disclosure ");
                }
                else if((component.get("v.VDTISPublicDisclosureCheckQ22") ==='true')||(component.get("v.VDTISPublicDisclosureCheckQ22") === true))
                {
                    if((component.get("v.VDTPublicDisclosureDate") ==='') || (component.get("v.VDTPublicDisclosureDate") === null)|| (component.get("v.VDTPublicDisclosureDate").length === 0))
                    {
                        
                        ErrorList.push(" 2.2 Public Disclosure Date ");
                    }
                    if((component.get("v.VDTPublicDisclosure22") ==='') || (component.get("v.VDTPublicDisclosure22") === null)|| (component.get("v.VDTPublicDisclosure22").length === 0))
                    {
                        ErrorList.push(" 2.2 Public Disclosure Text Box ");
                    }
                }
            }
            
            
            
            if((component.get("v.VDTIsCommercialCheckQ23") ==='')||(((component.get("v.VDTIsCommercialCheckQ23") === 'true')||(component.get("v.VDTIsCommercialCheckQ23") === true)) && ((component.get("v.VDTCommercialEvent23") === "") || (component.get("v.VDTCommercialEvent23") === null)|| (component.get("v.VDTCommercialEvent23").length === 0))	
                                                                    ||((component.get("v.VDTEarlierUsedDate") === '') || (component.get("v.VDTEarlierUsedDate") === null)|| (component.get("v.VDTEarlierUsedDate").length === 0))))
                
                //if((component.get("v.VDTIsCommercialCheckQ23") ==='')||(((component.get("v.VDTIsCommercialCheckQ23") === 'true')||(component.get("v.VDTIsCommercialCheckQ23") === true)) && ((component.get("v.VDTCommercialEvent23") === "") || (component.get("v.VDTCommercialEvent23") === null)|| (component.get("v.VDTCommercialEvent23").length === 0))	
                // ||((component.get("v.VDTEarlierUsedDate") === '') || (component.get("v.VDTEarlierUsedDate") === null)|| (component.get("v.VDTEarlierUsedDate").length === 0))))
            {
                if(component.get("v.VDTIsCommercialCheckQ23") === '')
                {
                    ErrorList.push(" 2.3 Current Commercial Use");
                }
                else if((component.get("v.VDTIsCommercialCheckQ23") === 'true')||(component.get("v.VDTIsCommercialCheckQ23") === true))
                {
                    /*  if((component.get("v.VDTEarlierUsedDate") ==='') || (component.get("v.VDTEarlierUsedDate") === null)|| (component.get("v.VDTEarlierUsedDate").length === 0))
                    {
                       ErrorList.push(" 2.3 Date of Earliest Use ");
                    }*/
                if((component.get("v.VDTCommercialEvent23") === '')|| (component.get("v.VDTCommercialEvent23") === null)|| (component.get("v.VDTCommercialEvent23").length === 0))
                {
                    ErrorList.push(" 2.3 Current Commercial Use Text Box ");
                }
            }
        }
            /* console.log(''+component.get("v.VDTExternalUseChk"));
                  console.log(''+component.get("v.VDTExternalUse"));
                  console.log(''+component.get("v.VDTEarlierExternalUseDate"));
               */
            
            
            
            if((component.get("v.VDTExternalUseChk") ==='')||(((component.get("v.VDTExternalUseChk") == 'true')||(component.get("v.VDTExternalUseChk") == true)) || ((component.get("v.VDTEarlierExternalUseDate") ===" ") || (component.get("v.VDTEarlierExternalUseDate") === null)|| (component.get("v.VDTEarlierExternalUseDate").length === 0)
                                                                                                                                                                     && (component.get("v.VDTExternalUse") ==='') || (component.get("v.VDTExternalUse") === null)|| (component.get("v.VDTExternalUse").length === 0))))
                
                //if((component.get("v.VDTExternalUseChk") ==='')||(((component.get("v.VDTExternalUseChk") === 'true')||(component.get("v.VDTExternalUseChk") === true)) && ((component.get("v.VDTExternalUse") ==='') || (component.get("v.VDTExternalUse") === null)|| (component.get("v.VDTExternalUse").length === 0))
                // || ((component.get("v.VDTEarlierExternalUseDate") ==='') || (component.get("v.VDTEarlierExternalUseDate") === null)|| (component.get("v.VDTEarlierExternalUseDate").length === 0))))
                
            {
                if(component.get("v.VDTExternalUseChk") === '')
                {
                    ErrorList.push(" Is External Use");
                }
                else if((component.get("v.VDTExternalUseChk") === 'true')||(component.get("v.VDTExternalUseChk") === true))
                {
                    if((component.get("v.VDTEarlierExternalUseDate") ==='') || (component.get("v.VDTEarlierExternalUseDate") === null)|| (component.get("v.VDTEarlierExternalUseDate").length === 0))
                    {
                        ErrorList.push("  Date of Earliest External Use");	
                    }
                    if((component.get("v.VDTExternalUse") === '')|| (component.get("v.VDTExternalUse") === null)|| (component.get("v.VDTExternalUse").length === 0))
                    {
                        ErrorList.push(" External Use Text Box");
                    }
                }
            }
            //Added on 8/4/2020 to handle validation for Third Party Confidentiality
            if((component.get("v.VDTIsThirdPartyConfidentiality") === '')||(((component.get("v.VDTIsThirdPartyConfidentiality") ==='true')||(component.get("v.VDTIsThirdPartyConfidentiality") === true)) && ((component.get("v.VDTThirdPartyConfidentiality") ==='') || (component.get("v.VDTThirdPartyConfidentiality") === null)|| (component.get("v.VDTThirdPartyConfidentiality").length === 0))))
            {
                if(component.get("v.VDTIsThirdPartyConfidentiality") === '')
                {
                    ErrorList.push(" 2.4 Third-Party Payor Confidentiality");
                }
                else if((component.get("v.VDTIsThirdPartyConfidentiality") === 'true')||(component.get("v.VDTIsThirdPartyConfidentiality") === true))
                {
                    
                    if((component.get("v.VDTThirdPartyConfidentiality") === '')|| (component.get("v.VDTThirdPartyConfidentiality") === null)|| (component.get("v.VDTThirdPartyConfidentiality").length === 0))
                    {
                        ErrorList.push(" 2.4 Third-Party Payor Confidentiality Text Box");
                    }
                }
            }            //alert('4/*/*');
            //----------------------------------------------------------------------
            
            
            if((component.get("v.VDTFutureimplementation24checkbox") ==='')||(((component.get("v.VDTFutureimplementation24checkbox") == 'true')||(component.get("v.VDTFutureimplementation24checkbox") == true)) || ((component.get("v.VDTEarlierPlannedUseDate") ===" ") || (component.get("v.VDTEarlierPlannedUseDate") === null)|| (component.get("v.VDTEarlierPlannedUseDate").length === 0)
                                                                                                                                                                                                                     && (component.get("v.VDTFutureEventQ24") ==='') || (component.get("v.VDTFutureEventQ24") === null)|| (component.get("v.VDTFutureEventQ24").length === 0))))    
                
                // if((component.get("v.VDTFutureimplementation24checkbox") === '')||(((component.get("v.VDTFutureimplementation24checkbox") === 'true')||(component.get("v.VDTFutureimplementation24checkbox") === true)) && (((component.get("v.VDTFutureEventQ24") === '') || (component.get("v.VDTFutureEventQ24") === null)|| (component.get("v.VDTFutureEventQ24").length === 0)))    	
                //||((component.get("v.VDTEarlierPlannedUseDate") === " ") || (component.get("v.VDTEarlierPlannedUseDate") === null)|| (component.get("v.VDTEarlierPlannedUseDate").length === 0))))
            {
                if(component.get("v.VDTFutureimplementation24checkbox") === '')
                {
                    ErrorList.push(" 2.5 Future Implementation");
                }
                else if((component.get("v.VDTFutureimplementation24checkbox") === 'true')||(component.get("v.VDTFutureimplementation24checkbox") === true))
                {
                    if((component.get("v.VDTEarlierPlannedUseDate") ==='') || (component.get("v.VDTEarlierPlannedUseDate") === null)|| (component.get("v.VDTEarlierPlannedUseDate").length === 0))
                    {
                        ErrorList.push(" 2.5 Date of Earliest Planned Use ");
                    }
                    
                    if((component.get("v.VDTFutureEventQ24") === '')|| (component.get("v.VDTFutureEventQ24") === null)|| (component.get("v.VDTFutureEventQ24").length === 0))
                    {
                        ErrorList.push(" 2.5 Future Implementation Text Box");
                    }
                }
            }
            
            if((component.get("v.VDTIsproductsQ25checkbox") === '')||(((component.get("v.VDTIsproductsQ25checkbox") === 'true')||(component.get("v.VDTIsproductsQ25checkbox") === true)) && ((component.get("v.VDTproductsQ25") === "") || (component.get("v.VDTproductsQ25") === null)|| (component.get("v.VDTproductsQ25").length === 0))))
            {
                if(component.get("v.VDTIsproductsQ25checkbox") === '')
                {
                    ErrorList.push(" 2.6 Competing Products / Solutions");
                }
                else if((component.get("v.VDTIsproductsQ25checkbox") === 'true')||(component.get("v.VDTIsproductsQ25checkbox") === true))
                {
                    
                    if((component.get("v.VDTproductsQ25") === '') || (component.get("v.VDTproductsQ25") === null)|| (component.get("v.VDTproductsQ25").length === 0))
                    {
                        ErrorList.push(" 2.6 Competing Products / Solutions Text Box");
                    }
                }
            }
            if((component.get("v.VDTIsThirdparty26checkbox") === '')||(((component.get("v.VDTIsThirdparty26checkbox") === 'true')||(component.get("v.VDTIsThirdparty26checkbox") === true)) && ((component.get("v.VDTThirdPartyQ26") === "") || (component.get("v.VDTThirdPartyQ26") === null)|| (component.get("v.VDTThirdPartyQ26").length === 0))))
            {
                if(component.get("v.VDTIsThirdparty26checkbox") === '')
                {
                    ErrorList.push(" 2.7 Third Party Contributions");
                }
                else if((component.get("v.VDTIsThirdparty26checkbox") === 'true')||(component.get("v.VDTIsThirdparty26checkbox") === true))
                {
                    
                    if((component.get("v.VDTThirdPartyQ26") === '') || (component.get("v.VDTThirdPartyQ26") === null)|| (component.get("v.VDTThirdPartyQ26").length === 0))
                    {
                        ErrorList.push(" 2.7 Third Party Contributions Text Box");
                    }
                }
            }
            if(component.get("v.VDTIsReverseDetection") === true)
            {
                if((component.get("v.VDTReverseDetection") === '') || (component.get("v.VDTReverseDetection") === null)|| (component.get("v.VDTReverseDetection").length === 0))
                {
                    ErrorList.push(" 2.8 Reverse engineering");
                }
            }
            
            if(component.get("v.VDTTestingchk") === true)
            {
                if((component.get("v.VDTTestingtxt") === '') || (component.get("v.VDTTestingtxt") === null)|| (component.get("v.VDTTestingtxt").length === 0))
                {
                    ErrorList.push(" 2.8 Testing a competitive solution");
                }
            }
            
            if(component.get("v.VDTliteraturechk") === true)
            {
                if((component.get("v.VDTliteratureTxt") === '') || (component.get("v.VDTliteratureTxt") === null)|| (component.get("v.VDTliteratureTxt").length === 0))
                {
                    ErrorList.push(" 2.8 Reading product literature");
                }
            }
            
            if(component.get("v.VDTOtherChk") === true)
            {
                if((component.get("v.VDTOtherTxt") === '') || (component.get("v.VDTOtherTxt") === null)|| (component.get("v.VDTOtherTxt").length === 0))
                {
                    ErrorList.push(" 2.8 Other");
                }
            }
            
            /*if((component.get("v.VDTIsThirdPartyConfidentiality") === '')||((component.get("v.VDTIsThirdPartyConfidentiality") ==='true') && ((component.get("v.VDTThirdPartyConfidentiality") === " ") || (component.get("v.VDTThirdPartyConfidentiality") === null)|| (component.get("v.VDTThirdPartyConfidentiality").length === 0))))
            {
                if(component.get("v.VDTIsThirdPartyConfidentiality") === '')
                {
                    ErrorList.push("Is Third Party Confidentiality");
                }
                else if(component.get("v.VDTIsThirdPartyConfidentiality") === 'true' )
                {
                   
                    if((component.get("v.VDTThirdPartyConfidentiality") === " ") || (component.get("v.VDTThirdPartyConfidentiality") === null)|| (component.get("v.VDTThirdPartyConfidentiality").length === 0))
                    {
                        ErrorList.push("Third Party Confidentiality");
                    }
                }
            }Commented on 8/4/2020 in order to show the validation errors in the same order as the IDF form, added before future implementation ques*/
            // alert(component.get("v.VDTOtherChk")+'sdvf');
            if((component.get("v.VDTIsReverseDetection") === false) && (component.get("v.VDTTestingchk") === false) && (component.get("v.VDTliteraturechk") === false ) && (component.get("v.VDTOtherChk") === false) && (component.get("v.VDTImpossible") === false) && (component.get("v.VDTDontKnow") === false ))
            {
                //alert('2.8 --->'+ErrorList);
                ErrorList.push(" 2.8 Detectability ");
            } 
            
            if((component.get("v.VDTBusinessValue") === " " )|| (component.get("v.VDTBusinessValue") === null)|| (component.get("v.VDTBusinessValue").length === 0))
            {
                ErrorList.push(" 2.9 Business Value");
            }
            
            // alert('5/*/*');
            
            component.set('v.Error',true);
            
            // Added to sync ---  
            var piorvalue = component.get("v.Error");
            var tempvalue=component.get("v.TopBooleanValue");
            //alert('piorvalue>>>'+piorvalue);
            if(piorvalue == true )
            {
                component.set("v.TopBooleanValue",false);
                // alert('setting in comp1 '+component.get("v.TopBooleanValue"));
                component.set("v.VDTErrorlistsync2",'');
            }
            
            
            
            //alert('errormsg----if ' +component.get('v.Error'));
            
        }
        else
        {
            component.set('v.Error',false);
            component.set('v.ErrorMessage','');
            if(validate)
            {
                //var invidsStr = component.get('v.strSelectedInventorIdsTemp');
                //var invInfoStr = component.get('v.strSelectedInventorInfoTemp');
                var invidconcatenate = [];
                var invinfoconcatenate = [];
                var primaryInventor = false;
                for(var i=0; i < ListOfInventorsWithRole.length; i++)
                {
                    var recordval = ListOfInventorsWithRole[i];
                    listOfInventorIds.push(recordval.Recid);
                    //invidconcatenate = listOfInventorIds.join(',');
                    //alert('invidconcatenate'+invidconcatenate);
                    component.set('v.strSelectedInventorIds',listOfInventorIds.join(', '));
                    if(i == 0)
                    {
                        primaryInventor = true;
                    }
                    else
                    {
                        primaryInventor = false;
                    }
                    listOfConcatenatedInfoInvs.push(recordval.Recid+'<#>'+recordval.RoleOfConception+'<#>'+primaryInventor+'<#>'+recordval.EmailId);
                    //invinfoconcatenate = listOfConcatenatedInfoInvs.join(',');
                    component.set('v.strSelectedInventorInfo',listOfConcatenatedInfoInvs.join('<###>'));
                }
                
                var j=0;
                var listtemp = [];
                for(var i=0; i < ListOfInventorsWithRole.length; i++)
                {
                    var temp = ListOfInventorsWithRole[j];
                    var temp1 = ListOfInventorsWithRole[i];
                    j=j+1;
                    //listtemp.push(temp);
                }
                
                
                
                
                //component.set('v.strSelectedInventorIds',invidsStr+','+invidconcatenate);
                //component.set('v.strSelectedInventorInfo',invInfoStr+','+invinfoconcatenate);
                //alert('strSelectedInventorIds-submit----------    '+component.get('v.strSelectedInventorIds'));
               // alert('strSelectedInventorInfo--submit---------    '+component.get('v.strSelectedInventorInfo'));
                var cmp = $A.get('e.c:InventorsFinalSelectedListEvt');
                cmp.setParams({'strSelectedInventorIdsEvt':component.get('v.strSelectedInventorIds'),'strSelectedInventorInfoEvt':component.get('v.strSelectedInventorInfo')});
                cmp.fire();
                //component.set('v.SuccessMsg',true);
                //comp/onent.set('v.ErrorMessageForInventors','Successfully added inventors to the disclosure!');
                
                var navigate = component.get("v.navigateFlow");
                
               // alert('-------'+navigate);
                if(response=='HomeId' || response=='SaveId')
                {	
                    
                   // alert('redirect'+ component.get("v.IDF"));
                    if((component.get("v.IDF")!= null && component.get("v.IDF") != "false") )
                    {
                        window.open('/one/one.app?#/sObject/'+component.get("v.IDF")+'/view',"_self");
                    }
                    navigate("NEXT");
                    if(event.getParam("status") === "FINISHED") 
                    {	alert('-------'+'cde');
                     var toastEvent = $A.get("e.force:showToast");
                     toastEvent.setParams({
                         "title": "Success!",
                         "message": "The record has been updated successfully."
                     }); 
                     
                     toastEvent.fire();
                    }
                    
                    
                }
                component.set("v.navigateFlow",true);
            }
            
        }
        component.set("v.ErrorFields",ErrorList);
       // alert('Error boolean -->'+component.get('v.Error'));
        //alert('Error list -->'+component.get("v.ErrorFields"));
        if(component.get("v.ErrorFields").length > 0)
        {
            component.set("v.ErrorMessage","Please provide input for required question(s): "+component.get("v.ErrorFields"));
        }
        
        // Adding to fire the error msg from cmp1 to cmp2-----
        
        var Err = component.get("v.ErrorMessage");
       // alert(Err);
        var cmpevent = $A.get('e.c:cmpsubmitAndSaveBottom2Event');
        cmpevent.setParams({"ErrorMessage2":Err});
        cmpevent.fire();
        
        // ----------------------------
        
    },
    
    // Events----------------------
    setInventorsSelected : function(component, event, helper)
    {
        var temp = event.getParam("InventorsList");
        //alert('footer ctrl'+temp);
        component.set("v.VDTInventorsSelected",temp); // Setting "InventorRecords" to VDTInventorsSelected
        
        //alert( JSON.stringify(component.get("v.VDTInventorsSelected"))+'aftr fire');
    },
    
    
    setTitle :function(component, event, helper)
    {
        var temp = event.getParam("InventionTitle");
        component.set("v.VDTTitle",temp);
        component.set("v.Title",component.get("v.VDTTitle"));
        //alert( component.get("v.Title")+'aftr fire');
    },
    setSummary :function(component, event, helper)
    {
        var temp = event.getParam("InventionSummary");
        component.set("v.VDTSummary",temp);
        component.set("v.Summary",component.get("v.VDTSummary"));
        //alert( component.get("v.Summary")+'aftr fire');
    },
    setPath :function(component, event, helper)
    {
        var temp = event.getParam("InventionPath");
        component.set("v.VDTPath",temp);
        component.set("v.Path",component.get("v.VDTPath"));
    },
    setCurrentStageOfInvention : function(component, event, helper)
    {
        var temp = event.getParam("CurrentStageOfInvention");
        component.set("v.VDTCurrentStageOfInvention",temp);
        component.set("v.stages",component.get("v.VDTCurrentStageOfInvention"));
    },
    //Managing Segment
    setManagingSegment : function(component, event, helper)
    {
        var temp = event.getParam("ManagingSegment");
        console.log('evemt called=='+temp);
        component.set("v.VDTManagingSegment",temp);
        component.set("v.ManagingSegments",temp);
        component.set("v.BusinessSegment",temp);
        
    },
    /*   setPrimaryInventor :  function(component, event, helper)
    {
        var temp = event.getParam("PrimaryInventor");
        component.set("v.VDTPrimaryInventor",temp);
        component.set("v.primaryInventor",component.get("v.VDTPrimaryInventor"));
        //alert('Primary Inventor value passed to footer'+component.get("v.VDTPrimaryInventor"));
    },*/
    setQ11 :  function(component, event, helper)
    {
        var temp = event.getParam("problemQ11");
        //alert('Question 1'+temp);
        component.set("v.VDTProblemQ11",temp);
        component.set("v.question11",component.get("v.VDTProblemQ11"));
    },
    
    setQ12 :  function(component, event, helper)
    {
        var temp = event.getParam("solutionQ12");
        //alert('Question 2'+temp);
        component.set("v.VDTSolutionQ12",temp);
        component.set("v.question12",component.get("v.VDTSolutionQ12"));
    },
    setQ13 :  function(component, event, helper)
    {
        var temp = event.getParam("FeatureQue13");
        component.set("v.VDTFeatureQ13",temp);
        component.set("v.question13",component.get("v.VDTFeatureQ13"));
    },
    setQ14 :  function(component, event, helper)
    {
        var temp = event.getParam("AlternativeQue14");
        component.set("v.VDTAlternativeQue14",temp);
        component.set("v.question14",component.get("v.VDTAlternativeQue14"));
    }, 
    setQ21 :  function(component, event, helper)
    {
        var temp = event.getParam("PriorsubmissionEvent21");
        //alert('rich text value -->'+temp+'-------------'+component.get("v.VDTPriorsubmissionEvent21"));
        component.set("v.VDTPriorsubmissionEvent21",temp);
        component.set("v.question21Textbox",component.get("v.VDTPriorsubmissionEvent21"));
    }, 
    setQ22 :  function(component, event, helper)
    {
        var temp = event.getParam("PublicDisclosure22");
        component.set("v.VDTPublicDisclosure22",temp);
        //alert('Txt box value at footer >> '+component.get("v.VDTPublicDisclosure22"));
        component.set("v.question22Textbox",component.get("v.VDTPublicDisclosure22"));
    }, 
    setQ23 :  function(component, event, helper)
    {
        var temp = event.getParam("CommercialEvent23");
        //  alert('temp value of txtbox'+temp);
        component.set("v.VDTCommercialEvent23",temp);
        // alert('Footer queston23<>>'+component.get("v.VDTCommercialEvent23"));
        component.set("v.question23Textbox",component.get("v.VDTCommercialEvent23"));
    }, 
    setQ24:  function(component, event, helper)
    {
        var temp = event.getParam("FutureEventQ24");
        //alert('temp>>'+temp);
        component.set("v.VDTFutureEventQ24",temp);
        // alert(component.get("v.VDTFutureEventQ24"));
        component.set("v.question24Textbox",component.get("v.VDTFutureEventQ24"));
    }, 
    setQ25:  function(component, event, helper)
    {
        var temp = event.getParam("productsQ25");
        component.set("v.VDTproductsQ25",temp);
        component.set("v.question25Textbox",component.get("v.VDTproductsQ25"));
    }, 
    setQ26:  function(component, event, helper)
    {
        var temp = event.getParam("ThirdPartyQ26");
        component.set("v.VDTThirdPartyQ26",temp);
        component.set("v.question26Textbox",component.get("v.VDTThirdPartyQ26"));
    }, 
    setQ21check:  function(component, event, helper)
    {
        var temp = event.getParam("IsPriorsubmission21");
        if(temp == 'false')
        {
            component.set("v.VDTPriorsubmissionEvent21",'');           
        }
        // alert('Footer Prior value -->'+temp);
        component.set("v.VDTIsPriorsubmission21Event",temp);
        component.set("v.questioncheckbox21",component.get("v.VDTIsPriorsubmission21Event"));
    }, 
    setQ22check:  function(component, event, helper)
    {
        var temp = event.getParam("ISPublicDisclosureCheckQ22");
        if(temp == 'false'|| temp == 'true' )
        {
            component.set("v.VDTPublicDisclosure22",''); 
            component.set("v.VDTPublicDisclosureDate",'');
        }
        component.set("v.VDTISPublicDisclosureCheckQ22",temp);
        //alert('radio value at footer>> '+component.get("v.VDTISPublicDisclosureCheckQ22"));
        component.set("v.questioncheckbox22",component.get("v.VDTISPublicDisclosureCheckQ22"));
    },
    setQ23check:  function(component, event, helper)
    {
        var temp = event.getParam("IsCommercialCheckQ23");
        if(temp == 'false'|| temp == 'true' )
        {
            component.set("v.VDTCommercialEvent23",''); 	
            component.set("v.VDTEarlierUsedDate",'');
        }
        
        // alert('footer 23 value in temp'+temp);
        component.set("v.VDTIsCommercialCheckQ23",temp);
        // alert('setting to attribute'+component.get("v.VDTIsCommercialCheckQ23"));
        component.set("v.questioncheckbox23",component.get("v.VDTIsCommercialCheckQ23"));
    },
    setQ24check:  function(component, event, helper)
    {
        var temp = event.getParam("Futureimplementation24checkbox");
        if(temp == 'false'|| temp == 'true' )
        {
            component.set("v.VDTFutureEventQ24",''); 
            component.set("v.VDTEarlierPlannedUseDate",'');
            
        }
        
        component.set("v.VDTFutureimplementation24checkbox",temp);
        //alert('Footer event future imp'+component.get("v.VDTFutureimplementation24checkbox"));
        component.set("v.questioncheckbox24",component.get("v.VDTFutureimplementation24checkbox"));
    },
    setQ25check:  function(component, event, helper)
    {
        var temp = event.getParam("IsproductsQ25checkbox");
        if(temp == 'false'|| temp == 'true')
        {
            component.set("v.VDTproductsQ25",'');           
        }
        component.set("v.VDTIsproductsQ25checkbox",temp);
        component.set("v.questioncheckbox25",component.get("v.VDTIsproductsQ25checkbox"));
    },
    setQ26check:  function(component, event, helper)
    {
        var temp = event.getParam("IsThirdparty26checkbox");
        if(temp == 'false' || temp == 'true')
        {
            component.set("v.VDTThirdPartyQ26",'');           
        }
        component.set("v.VDTIsThirdparty26checkbox",temp);
        component.set("v.questioncheckbox26",component.get("v.VDTIsThirdparty26checkbox"));
    },
    setQ23Datecheck : function(component, event, helper)
    {
        var temp = event.getParam("PublicDisclosureDate");
        component.set("v.VDTPublicDisclosureDate",temp);
        //alert('Date field at footer >> '+component.get("v.VDTPublicDisclosureDate"));
        component.set("v.Question22PublicDisDate",component.get("v.VDTPublicDisclosureDate"));
    },
    setQ24Datecheck : function(component, event, helper)
    {
        var temp = event.getParam("Dateofearliestuse");
        component.set("v.VDTEarlierUsedDate",temp);
        component.set("v.Question23earlierUseDate",component.get("v.VDTEarlierUsedDate"));
    }, 
    setQ25Datecheck : function(component, event, helper)
    {
        var temp = event.getParam("DateofEarliestExternalUse");
        component.set("v.VDTEarlierExternalUseDate",temp);
        component.set("v.Question24EarlierExternalUseDate",component.get("v.VDTEarlierExternalUseDate"));
    },
    setQ26Datecheck : function(component, event, helper)
    {
        var temp = event.getParam("EarliestPlanUseDate");
        component.set("v.VDTEarlierPlannedUseDate",temp);
        component.set("v.Question25EarlierPlannedDate",component.get("v.VDTEarlierPlannedUseDate"));
    },
    setExternalChk : function(component, event, helper)
    {
        var temp = event.getParam("ExternalUseChk");
        if(temp=='false'|| temp=='true')
        {
            component.set("v.VDTExternalUse",'');
            component.set("v.VDTEarlierExternalUseDate",'');	  
        }
        component.set("v.VDTExternalUseChk",temp);
        component.set("v.questioncheckbox230",component.get("v.VDTExternalUseChk"));
    },
    setExternalTxt : function(component, event, helper)
    {
        var temp = event.getParam("ExternalTxt230Event");
        component.set("v.VDTExternalUse",temp);
        component.set("v.question230Textbox",component.get("v.VDTExternalUse"));
    },
    setReverseChk : function(component, event, helper)
    {
        var temp = event.getParam("IsReverseDetectionEvent");
        if(temp == false || temp == true)
        {
            component.set("v.VDTReverseDetection",'');           
        }
        component.set("v.VDTIsReverseDetection",temp);
        component.set("v.questioncheckbox27A",component.get("v.VDTIsReverseDetection"));
    },
    setReverseTxt : function(component, event, helper)
    {
        var temp = event.getParam("ReverseDetectionEvent");
        component.set("v.VDTReverseDetection",temp);
        component.set("v.questionTextbox27A",component.get("v.VDTReverseDetection"));
    },
    setTestingChk :  function(component, event, helper)
    {
        var temp = event.getParam("IsTestingcheckboxEvent27b");
        if(temp == false || temp == true )
        {
            component.set("v.VDTTestingtxt",'');           
        }
        
        component.set("v.VDTTestingchk",temp);
        component.set("v.questioncheckbox27B",component.get("v.VDTTestingchk"));
    },
    setTestingTxt : function(component, event, helper)
    {
        var temp = event.getParam("TestingTxtboxEvent27b");
        component.set("v.VDTTestingtxt",temp);
        component.set("v.questionTextbox27B",component.get("v.VDTTestingtxt"));
    },
    setliteratureChk : function(component, event, helper)
    {
        var temp = event.getParam("IsliteraturecheckboxEvent27c");
        if(temp == false || temp == true)
        {
            component.set("v.VDTliteratureTxt",'');           
        }
        component.set("v.VDTliteraturechk",temp);
        component.set("v.questioncheckbox27C",component.get("v.VDTliteraturechk"));
    },
    setliteratureTxt : function(component, event, helper)
    {
        var temp = event.getParam("literatureTxtEvent27c");
        component.set("v.VDTliteratureTxt",temp);
        component.set("v.questionTextbox27C",component.get("v.VDTliteratureTxt"));
    },
    setOtherChk : function(component, event, helper)
    {
        var temp = event.getParam("IsOthercheckboxEvent27f");
        if(temp == false || temp == true)
        {
            component.set("v.VDTOtherTxt",'');           
        }
        
        component.set("v.VDTOtherChk",temp);
        component.set("v.questioncheckbox27F",component.get("v.VDTOtherChk"));
    },
    setOtherTxt : function(component, event, helper)
    {
        var temp = event.getParam("OtherTxtboxEvent27f");
        component.set("v.VDTOtherTxt",temp);
        component.set("v.questionTextbox27F",component.get("v.VDTOtherTxt"));
    },
    setImpossible : function(component, event, helper)
    {
        var temp = event.getParam("ImpossibleEvent");
        component.set("v.VDTImpossible",temp);
        //component.set("v.questionTextbox27F",component.get("v.VDTOtherTxt"));
    },
    setDontKnow : function(component, event, helper)
    {
        var temp = event.getParam("DontknowEvent");
        component.set("v.VDTDontKnow",temp);
        //component.set("v.questionTextbox27F",component.get("v.VDTOtherTxt"));
    },
    
    
    
    
    setConfidentiality : function(component, event, helper)
    {
        var temp = event.getParam("IsThirdPartyConfidentiality");
        if(temp == 'false' || temp == 'true')	
        {
            component.set("v.VDTThirdPartyConfidentiality",'');           
        }
        component.set("v.VDTIsThirdPartyConfidentiality",temp);
        //alert('Footer event third party'+component.get("v.VDTIsThirdPartyConfidentiality"))
        component.set("v.IsConfidentialityadded",component.get("v.VDTIsThirdPartyConfidentiality"));
    },
    
    setConfidentialityTxt : function(component, event, helper)
    {
        var temp = event.getParam("ThirdPartyConfidentiality");
        component.set("v.VDTThirdPartyConfidentiality",temp);
        component.set("v.Confidentialityadded",component.get("v.VDTThirdPartyConfidentiality"));
    },
    
    setQ29 :  function(component, event, helper)
    {
        var temp = event.getParam("businessValueInvention");
        //alert('Question 2.9'+temp);
        component.set("v.VDTBusinessValue",temp);
        component.set("v.quest29",component.get("v.VDTBusinessValue"));
    },
    // End ---------------
    handleStatusChange : function (component, event) {
        if(event.getParam("status") === "FINISHED") {
            $A.get("e.force:closeQuickAction").fire();  
            var outputVariables = event.getParam("outputVariables");
            var outputVar;
            for(var i = 0; i < outputVariables.length; i++) {
                
                outputVar = outputVariables[i];
                if(outputVar.name === "IDF") {
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                        "recordId": outputVar.value,
                        "isredirect": "true"
                    });
                    urlEvent.fire();
                    /* window.open('https://orgurl/one/one.app?#/sObject/'+outputVar.value+'/view')*/
                }
            }
            
        }
        
        
    },
    SetInventorvalidation:function(component, event)
    {
        //alert('Eventfired'+event.getParam("isinventorvalidindex"));
        var RecordPassed = event.getParam("isinventorvalidindex");
        
    },
    
    //-------------------------------------- SAVE BUTTON REPLACMENT ---------
    SetInventorFooter : function(component, event)
    {
        //alert('SetInventor');
        var RecordPassed = event.getParam("InventorRecord");
        //alert('value '+RecordPassed.Name);
        //alert('Name '+RecordPassed.Name);
        //alert('----------Passed record----------------'+JSON.stringify(RecordPassed));
        /*if(RecordPassed.Name == '')
        {
            alert('entered if when name is null');
            RecordPassed.Recid = '';
            RecordPassed.RoleOfConception = '';
            RecordPassed.IsPrimary = false;
            //Added on 4/6/2020
            RecordPassed.EmailId = '';
            RecordPassed.InventorName = '';
            //RecordPassed.IsActive = false;
            //RecordPassed.UserId = ''; 
            //-----------------*/
        component.set('v.InvalidInvSearch','');
        component.set('v.OnsaveValidateInv',false);
        //} 
        //alert('----------Passed record after----------------'+JSON.stringify(RecordPassed));
        var ListOfSelectedInventors = component.get('v.InventorRecords');
        //alert('ListOfSelectedInventors --->'+JSON.stringify(ListOfSelectedInventors));
        var recordchk = false;
        //alert('Record passed after reseting recid--->'+JSON.stringify(RecordPassed));
        for(var i=0; i < ListOfSelectedInventors.length; i++)
        {
            //alert('for '+JSON.stringify(ListOfSelectedInventors[i]));
            //alert('-------Loop index------'+ListOfSelectedInventors[i].IndexVal);
            //alert('-------Passed record Index------'+RecordPassed.IndexVal);
            if(ListOfSelectedInventors[i].IndexVal == RecordPassed.IndexVal)
            {
                //alert('if');
                recordchk = true;
                ListOfSelectedInventors[i].Name = RecordPassed.Name;
                ListOfSelectedInventors[i].Recid = RecordPassed.Recid;
                if(RecordPassed.IndexVal == 0)
                {
                    ListOfSelectedInventors[i].IsPrimary = true;
                }
                else
                {
                    ListOfSelectedInventors[i].IsPrimary = false;
                }
                //Added on 4/6/2020
                ListOfSelectedInventors[i].EmailId = RecordPassed.EmailId;
                ListOfSelectedInventors[i].InventorName = RecordPassed.InventorName;
                //ListOfSelectedInventors[i].IsActive = RecordPassed.IsActive;
                //ListOfSelectedInventors[i].UserId = RecordPassed.UserId; 
                //-----------------
            }
            /*else if(ListOfSelectedInventors[i].IndexVal == RecordPassed.IndexVal && (RecordPassed.Name == '' || RecordPassed.Recid == ''))
            {
                alert('else'); 
                ListOfSelectedInventors[i].Name = '';
                ListOfSelectedInventors[i].Recid = '';
                
            }*/
        }
        if(recordchk == false)
        {
            ListOfSelectedInventors.push(RecordPassed);
        }
        //alert('recordchk '+recordchk);
        component.set('v.InventorRecords',ListOfSelectedInventors);
        //alert('InventorRecords Footer--->'+JSON.stringify(component.get('v.InventorRecords')));
    },
    
    SetRoleOfConceptionFooter :function(component, event)
    {
        var roleofconcep = event.getParam("RoleOfConception");
        var indexval = event.getParam("RowInd");
        var listRecs = component.get('v.InventorRecords');
        var RecordFoundOne = false;
        //alert('----Before ROC---'+JSON.stringify(component.get('v.InventorRecords')));
        for(var i=0; i < listRecs.length; i++)
        {
            if(listRecs[i].IndexVal == indexval)
            {
                listRecs[i].RoleOfConception = roleofconcep;
                RecordFoundOne = true;
            }
        }
        if(RecordFoundOne == false)
        {
            listRecs.push({
                'sobjectType' : 'WrapperInventorInfo',
                'Recid':'',
                'Name' : '',
                'RoleOfConception' : roleofconcep,
                'IsPrimary':false,
                'EmailId':'',
                'InventorName':'',
                
                'IndexVal':indexval
            });
        }
        component.set('v.InventorRecords',listRecs);
        //alert('----After ROC---'+JSON.stringify(component.get('v.InventorRecords')));
    },
    
    SetIsPrimaryFooter :function(component, event)
    {
        var Isprimary = event.getParam("IsPri");
        var Rowindex = event.getParam("RowIndexValue");
        var listRecs = component.get('v.InventorRecords');
        var RecordFoundTwo = false;
        // alert('IsPri'+Isprimary);
        //alert('RowIndexValue'+Rowindex);
        //alert('listRecs---------'+listRecs);
        //alert('listRecs.length--------'+listRecs.length);
        //alert('----Before Ispri---'+JSON.stringify(component.get('v.InventorRecords')));
        //alert('----Before length---'+JSON.stringify(component.get('v.InventorRecords').length));
        for(var i=0; i < listRecs.length; i++)
        {
            var rec = listRecs[i];
            //if(listRecs[i].IndexVal == Rowindex)
            if(rec != null)
            {
                //listRecs[i].IsPrimary = Isprimary;
                RecordFoundTwo = true;
            }
            if(listRecs[i].IndexVal == Rowindex)// && Isprimary == true
            {
                listRecs[i].IsPrimary = Isprimary; //Assigns onchange of checkbox value, if checked - true to the current row,
                //else false to the current row. The remaining rows are by default made false.
            }
            else if(listRecs[i].IndexVal != Rowindex) //&& Isprimary == true
            {
                listRecs[i].IsPrimary = false;
            }
            //alert('>>>>>>>>>>'+JSON.stringify(listRecs[i]));
            
        }
        if(RecordFoundTwo == false)
        {
            listRecs.push({
                'sobjectType' : 'WrapperInventorInfo',
                'Recid':'',
                'Name' : '',
                'RoleOfConception' : '',
                'IsPrimary':Isprimary,
                'EmailId':'',
                'InventorName':'',
                
                'IndexVal':Rowindex
            });
        }
        component.set('v.InventorRecords',listRecs);
        //alert('----After Ispri---'+JSON.stringify(component.get('v.InventorRecords')));
    },
    
    SetInventorsSelectedOnload :function(component, event)
    {
        var selectedids = event.getParam('FinalRecordsLst');
        //alert('Footer final values on load'+JSON.stringify(selectedids));
        //alert('Footer length--'+selectedids.length);
        //var lstRecords = component.get('v.InventorRecords');
        //lstRecords.push(selectedids);
        component.set('v.InventorRecords',selectedids);
    },
    
    DeleteRowElement : function(component, event)
    {
        var DeleteinvsElement = event.getParam('InventorRowAfterDeletion');
        //alert('footer row to dlt'+JSON.stringify(DeleteinvsElement));
        var AllRowsList = component.get("v.InventorRecords");
        //alert('test '+JSON.stringify(AllRowsList));
        AllRowsList.splice(DeleteinvsElement,1);
        //alert('test1111 '+JSON.stringify(AllRowsList));
        //----------
        var chkbool = false;
        for(var i=0; i < AllRowsList.length; i++)
        {
            //alert('---'+AllRowsList[i].IndexVal+'----------'+i);
            AllRowsList[i].IndexVal = i;
            if(AllRowsList[i].Recid=='' || AllRowsList[i].Recid==undefined)
            {
                chkbool = true;
                break;
            }
        }
        
        //alert('records after setting value'+JSON.stringify(AllRowsList));
        component.set('v.InventorRecords',AllRowsList);
        if(chkbool == true) 
        {
            component.set('v.OnsaveValidateInv',true);
            component.set('v.InvalidInvSearch','InvalidInventor');
        }
        if(chkbool == false)
        {
            component.set('v.OnsaveValidateInv',false);
            component.set('v.InvalidInvSearch','');
        }
        //----------
        component.set('v.InventorRecords',AllRowsList);
        //alert('after delete '+JSON.stringify(AllRowsList));
        //alert('On removing the deleted row'+component.get("v.InventorRecords"));
    },
    SetErrormessage2: function(component, event)
    {
        var Errors = event.getParam('ErrorMessageToTop');
        //alert(Errors);
        component.set("v.ErrorMessage",Errors);
        
    },
    OnSaveCheckValidInventormeth:function(component, event)
    {
        var chkvar = event.getParam('InvalidInv');
        //alert('chkvar'+chkvar);
        // component.set('v.OnsaveValidateInv',chkvar);
        if(chkvar === true)
        {
            component.set('v.InvalidInvSearch','InvalidInventor');
            component.set('v.OnsaveValidateInv',chkvar);
        }
        //alert('invalidseacrh '+component.get("v.InvalidInvSearch"));
        //alert('invalidseacrhON Save '+component.get("v.OnsaveValidateInv"));
        /*else //Added on 8/6/2020 to resolve invalid inventor
        {
            component.set('v.InvalidInvSearch','');
        }*/
        /*if(chkvar === false)
        {
            component.set('v.InvalidInvSearch','');
            component.set('v.OnsaveValidateInv',chkvar);
        }*/
    },
    setOtherBusinessSegment:function(component, event){  
        component.set('v.OtherBusinessSegment',event.getParam('ManageSegment'));
    },
    setSelectedInventors:function(component, event){  
        //alert(event.getParam('SelectedinvId'));
        var invList = event.getParam('SelectedinvId');
        if(invList.length === 0){
            component.set('v.isBlankInv',true);
        }
    },
    setOtherContactValues:function(component, event){ 
        console.log('chek othet contact event=='+event.getParam('otherSelectedInventors'));
        component.set('v.ContactFromOtherBusinessSegment',event.getParam('otherSelectedInventors'));
    },
    setIDFOtherContribution:function(component, event){
        component.set('v.otherContribution',event.getParam('otherContribution'));
    },
    setIDFOtherBusinessProblem:function(component, event){
        component.set('v.OtherBusinessProblem',event.getParam('OtherBusinessProblem'));
    },
    setPrimaryContact:function(component, event){
        console.log('check primary con=='+event.getParam('PrimaryContact'));
        component.set('v.primarycontact',event.getParam('PrimaryContact'));
    },
    setDevelopedForOtherSegment:function(component, event){
        console.log('check primary con=='+event.getParam('PrimaryContact'));
        component.set('v.DevelopedForOtherSegment',event.getParam('IDFDevelopedForOtherSegment'));
    }
})
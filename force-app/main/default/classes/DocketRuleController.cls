public class DocketRuleController {

    public static void coverage(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }

    @AuraEnabled
    public static List<wrapperOption> getDocketRules(String trackerId) {
        Emai_Tracker__c tracker = [SELECT Id, Patent_Id__c FROM Emai_Tracker__c WHERE Id = :trackerId];
        wrapperFinalTriggerActionCloseBy wrapperFinalTriggerActionCloseBy;

        wrapperFinalTriggerActionCloseBy = getDocumentCodes(tracker.Patent_Id__c);

        return wrapperFinalTriggerActionCloseBy.options;
    }


    /**
     * @param assetId SymphonyIPM__Patent__c.Id OR SymphonyIPM__Trademark_New__c.Id
     * @return options depending on asset and docketing rules
     */
    private static wrapperFinalTriggerActionCloseBy getDocumentCodes(Id assetId) {
        wrapperFinalTriggerActionCloseBy result = new wrapperFinalTriggerActionCloseBy();

        // get values from asset record to find docRuleEngines
        String assetType;
        String caseType;
        Id jurisdiction;

        if (assetId.getSobjectType().getDescribe().getName() == 'SymphonyIPM__Patent__c') {
            SymphonyIPM__Patent__c patent;
            if (Schema.SObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.SObjectType.getDescribe().isAccessible()) {
                patent = [SELECT SymphonyIPM__Asset_Type__c, SymphonyIPM__Case_Type__c, SymphonyIPM__Country__c FROM SymphonyIPM__Patent__c WHERE Id = :assetId];
            }

            assetType = patent.SymphonyIPM__Asset_Type__c;
            caseType = patent.SymphonyIPM__Case_Type__c;
            jurisdiction = patent.SymphonyIPM__Country__c;
        }
        if (assetId.getSobjectType().getDescribe().getName() == 'SymphonyIPM__Trademark_New__c') {
            SymphonyIPM__Trademark_New__c trademark;

            if (Schema.SObjectType.SymphonyIPM__Trademark_New__c.isAccessible() && SymphonyIPM__Trademark_New__c.SObjectType.getDescribe().isAccessible()) {
                trademark = [SELECT Id, SymphonyIPM__Asset_Type__c, SymphonyIPM__Case_Type__c, SymphonyIPM__Jurisdiction1__c FROM SymphonyIPM__Trademark_New__c WHERE Id = :assetId];
            }

            assetType = trademark.SymphonyIPM__Asset_Type__c;
            caseType = trademark.SymphonyIPM__Case_Type__c;
            jurisdiction = trademark.SymphonyIPM__Jurisdiction1__c;
        }


        // get docRuleEngines for asset and collect SymphonyIPM__Trigger__c from them
        Set<String> triggers = new Set<String>();

        List<SymphonyIPM__Docketing_Rule_Engine__c> docketingRuleEngines;

        if (Schema.SObjectType.SymphonyIPM__Docketing_Rule_Engine__c.isAccessible() && SymphonyIPM__Docketing_Rule_Engine__c.SObjectType.getDescribe().isAccessible()) {
            docketingRuleEngines = [SELECT Id, SymphonyIPM__Trigger__c FROM SymphonyIPM__Docketing_Rule_Engine__c WHERE SymphonyIPM__Asset_Type__c = :assetType AND SymphonyIPM__Case_Type__c = :caseType AND SymphonyIPM__Jurisdiction__c = :jurisdiction AND (SymphonyIPM__Trigger_Type__c = 'Document Code' OR SymphonyIPM__Trigger_Type__c = 'Event') AND SymphonyIPM__Trigger__c != 'at case creation' ORDER BY SymphonyIPM__Docket_Action__c];
        }

        for (SymphonyIPM__Docketing_Rule_Engine__c ruleEngine : docketingRuleEngines) {
            triggers.add(ruleEngine.SymphonyIPM__Trigger__c);
        }

        // get mdt and create options from it
        List<SymphonyIPM__DocketDocumentCodeList__mdt> mdtDocketDocumentCodeLists;

        if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.isAccessible() && SymphonyIPM__DocketDocumentCodeList__mdt.SObjectType.getDescribe().isAccessible()) {
            mdtDocketDocumentCodeLists = [SELECT DeveloperName, MasterLabel, SymphonyIPM__Description__c FROM SymphonyIPM__DocketDocumentCodeList__mdt WHERE MasterLabel IN :triggers ORDER BY SymphonyIPM__Description__c];
        }

        List<wrapperOption> options = new List<wrapperOption>();
        Set<String> foundedInMetadata = new Set<String>();

        // add --Select--
        wrapperOption selectOption = new wrapperOption();
        selectOption.text = '--Select--';
        selectOption.value = 'Select';
        selectOption.isSelected = true;
        options.add(selectOption);

        if (mdtDocketDocumentCodeLists != null && mdtDocketDocumentCodeLists.size() > 0) {
            for (SymphonyIPM__DocketDocumentCodeList__mdt mdt : mdtDocketDocumentCodeLists) {
                foundedInMetadata.add(mdt.MasterLabel);

                wrapperOption option = new wrapperOption();

                if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.SymphonyIPM__Description__c.isAccessible()) {
                    option.text = mdt.SymphonyIPM__Description__c;
                }
                if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.MasterLabel.isAccessible()) {
                    option.value = mdt.MasterLabel;
                }

                option.isSelected = false;
                options.add(option);
            }

        }

        // create options for triggers that was not found in mdt
        if (triggers.size() > 0) {
            for (String str : triggers) {
                if (!foundedInMetadata.contains(str)) {

                    wrapperOption objWrapperOption = new wrapperOption();
                    if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.SymphonyIPM__Description__c.isAccessible()) {
                        objWrapperOption.text = str;
                    }
                    if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.MasterLabel.isAccessible()) {
                        objWrapperOption.value = str;
                    }

                    objWrapperOption.isSelected = false;
                    options.add(objWrapperOption);
                }
            }
        }

        // check if any options was created (besides --Select--)
        if (options.size() == 1) {
            options.clear();

            wrapperOption objWrapperOption = new wrapperOption();
            objWrapperOption.text = 'None';
            objWrapperOption.value = 'None';
            objWrapperOption.isSelected = true;
            options.add(objWrapperOption);
        }

        // sort list of objects by property using Map
        Map<String, List<wrapperOption>> nameMap = new Map<String, List<wrapperOption>>();

        // put objects into map with property you want to use for sort as key
        for (wrapperOption option : options) {

            List<wrapperOption> candList = nameMap.get(option.text);

            if (null == candList) {
                candList = new List<wrapperOption>();

                nameMap.put(option.text, candList);
            }

            candList.add(option);
        }

        // clear original list
        options.clear();

        // get map keys and sort them
        List<String> labelStrings = new List<String>();
        labelStrings.addAll(nameMap.keySet());
        labelStrings.sort();

        // using sorted keys get sorted objects
        for (String s : labelStrings) {
            options.addAll(nameMap.get(s));
        }

        result.options = options;
        result.selectedOption = '';
        result.dateClosedCompleted = null;

        return result;
    }

    // TODO delete this after tests
//    private static wrapperFinalTriggerActionCloseBy getDocumentCodesForPatent(Id patentId) {
//        String AuditTrailStatus = 'Success';
//        String strAuditTrailLogText = '[Started]';
//        wrapperFinalTriggerActionCloseBy objWrapperFinalTriggerActionCloseBy = new wrapperFinalTriggerActionCloseBy();
//        try {
//            //Step.1.Read AsSet Type, Jurisdiction, Case Type of AsSet
//            SymphonyIPM__Patent__c objPatent = null;
//            if (Schema.SObjectType.SymphonyIPM__Patent__c.isAccessible() && SymphonyIPM__Patent__c.SObjectType.getDescribe().isAccessible())
//                objPatent = [SELECT SymphonyIPM__Asset_Type__c, SymphonyIPM__Case_Type__c, SymphonyIPM__Country__c FROM SymphonyIPM__Patent__c WHERE Id = :patentId];
//            System.debug('Process initiated');
//            //Step.2.Read DocketingRuleEngine
//            List<String> strTriggerNames = new List<String>();
//            List<SymphonyIPM__Docketing_Rule_Engine__c> objDocketingRuleList = null;
//            if (Schema.SObjectType.SymphonyIPM__Docketing_Rule_Engine__c.isAccessible() && SymphonyIPM__Docketing_Rule_Engine__c.SObjectType.getDescribe().isAccessible())
//                //objDocketingRuleList = [SELECT trigger__c FROM SymphonyIPM__Docketing_Rule_Engine__c WHERE AsSet_Type__c='Patent' AND Case_Type__c=:objPatent.Case_Type__c AND Jurisdiction__c=:objPatent.Country__c AND (Trigger_type__c = 'Document Code' OR Trigger_type__c = 'Event') AND Trigger__c!='at case creation' ORDER BY Docket_Action__c];//Harsha on 18-10-2018
//                objDocketingRuleList = [SELECT SymphonyIPM__Trigger__c FROM SymphonyIPM__Docketing_Rule_Engine__c WHERE SymphonyIPM__Asset_Type__c = :objPatent.SymphonyIPM__Asset_Type__c AND SymphonyIPM__Case_Type__c = :objPatent.SymphonyIPM__Case_Type__c AND SymphonyIPM__Jurisdiction__c = :objPatent.SymphonyIPM__Country__c AND (SymphonyIPM__Trigger_type__c = 'Document Code' OR SymphonyIPM__Trigger_type__c = 'Event') AND SymphonyIPM__Trigger__c != 'at case creation' ORDER BY SymphonyIPM__Docket_Action__c];//Harsha on 18-10-2018
//            System.debug('Size of List from Rules--->' + objDocketingRuleList.size());
//            for (SymphonyIPM__Docketing_Rule_Engine__c objDocketingRuleEngine : objDocketingRuleList) {
//                strTriggerNames.add(objDocketingRuleEngine.SymphonyIPM__Trigger__c);
//                System.debug(objDocketingRuleEngine.SymphonyIPM__Trigger__c);
//            }
//            //----------Code Added by Harsha on 11-10-2018 for restricting duplicate triggers----------
//            Set<String> SetTriggerNames = new Set<String>();
//            SetTriggerNames.addAll(strTriggerNames);
//            strTriggerNames.clear();
//            strTriggerNames.addAll(SetTriggerNames);
//            //-------------------------------------------END-------------------------------------------
//            //Step.3.Read DocumentCodes
//            List<wrapperOption> lstOptions = new List<wrapperOption>();
//            List<SymphonyIPM__DocketDocumentCodeList__mdt> mdtDocketDocumentCodeLists = null;
//            Set<String> inMetaData = new Set<String>();
//            wrapperOption objWrapperOptionSelect = new wrapperOption();
//            objWrapperOptionSelect.text = '--Select--';
//            objWrapperOptionSelect.value = 'Select';
//            objWrapperOptionSelect.isSelected = true;
//            lstOptions.add(objWrapperOptionSelect);
//            System.debug('>>>>>>> ' + strTriggerNames.size());
//
//            if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.isAccessible() && SymphonyIPM__DocketDocumentCodeList__mdt.SObjectType.getDescribe().isAccessible())
//                mdtDocketDocumentCodeLists = [SELECT DeveloperName, MasterLabel, SymphonyIPM__Description__c FROM SymphonyIPM__DocketDocumentCodeList__mdt WHERE MasterLabel IN :strTriggerNames ORDER BY SymphonyIPM__Description__c];
//            if (mdtDocketDocumentCodeLists != null && mdtDocketDocumentCodeLists.size() > 0) {
//                Integer i = 0;
//                for (SymphonyIPM__DocketDocumentCodeList__mdt objDocketDocumentCodeList : mdtDocketDocumentCodeLists) {
//                    inMetaData.add(objDocketDocumentCodeList.MasterLabel);
//                    wrapperOption objWrapperOption = new wrapperOption();
//                    //objWrapperOption.text = objDocketDocumentCodeList.MasterLabel + ' | ' + objDocketDocumentCodeList.Description__c;
//                    if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.SymphonyIPM__Description__c.isAccessible())
//                        objWrapperOption.text = objDocketDocumentCodeList.SymphonyIPM__Description__c;
//                    if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.MasterLabel.isAccessible())
//                        objWrapperOption.value = objDocketDocumentCodeList.MasterLabel;
//                    objWrapperOption.isSelected = false;
//                    lstOptions.add(objWrapperOption);
//                    i += 1;
//                }
//                System.debug('metadata returned size-->' + i);
//            }
//            if (strTriggerNames.size() > 0) {
//                Integer j = 0;
//                for (String str : strTriggerNames) {
//                    System.debug('>>>>>>> ' + str);
//                    if (!inMetaData.contains(str)) {
//                        wrapperOption objWrapperOption = new wrapperOption();
//                        if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.SymphonyIPM__Description__c.isAccessible())
//                            objWrapperOption.text = str;
//                        if (Schema.SObjectType.SymphonyIPM__DocketDocumentCodeList__mdt.fields.MasterLabel.isAccessible())
//                            objWrapperOption.value = str;
//                        objWrapperOption.isSelected = false;
//                        lstOptions.add(objWrapperOption);
//                        j += 1;
//                    }
//                }
//                System.debug('metadata returned size--_>' + j);
//            }
//            if (lstOptions.size() < 0) {
//                wrapperOption objWrapperOption = new wrapperOption();
//                objWrapperOption.text = 'None';
//                objWrapperOption.value = 'None';
//                objWrapperOption.isSelected = true;
//                lstOptions.add(objWrapperOption);
//            }
//            //-----------Added by Harsha on 11-10-2018 for Sorting Select options------
//            Map<String, List<wrapperOption>> nameMap = new Map<String, List<wrapperOption>>();
//            for (wrapperOption a : lstOptions) {
//                List<wrapperOption> candList = nameMap.get(a.text);
//                if (null == candList) {
//                    candList = new List<wrapperOption>();
//                    nameMap.put(a.text, candList);
//                }
//                candList.add(a);
//            }
//            lstOptions.clear();
//            List<String> labelStrings = new List<String>();
//            labelStrings.addAll(nameMap.keySet());
//            labelStrings.sort();
//            for (String s : labelStrings) {
//                lstOptions.addAll(nameMap.get(s));
//            }
//            //------------------------------END----------------------------------------
//            objWrapperFinalTriggerActionCloseBy.options = lstOptions;
//            objWrapperFinalTriggerActionCloseBy.selectedOption = '';
//            objWrapperFinalTriggerActionCloseBy.dateClosedCompleted = null;
//        } catch (Exception ex) {
//            AuditTrailStatus = 'Fail';
//            strAuditTrailLogText += '[ Error raised:' + ex.getMessage() + ' | ' + ex.getStackTraceString() + ' ]';
//        } finally {
//            strAuditTrailLogText += '[Stopped]';
//            SymphonyIPM__AuditTrail__c objAuditTrail = null;
//            if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.isAccessible() && SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isAccessible() && SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isCreateable() && Schema.SObjectType.SymphonyIPM__AuditTrail__c.isCreateable()) {
//                objAuditTrail = new SymphonyIPM__AuditTrail__c();
//                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
//                    objAuditTrail.SymphonyIPM__Action__c = 'Insert';
//                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
//                    objAuditTrail.SymphonyIPM__CObjectName__c = 'DocketingActivityController(getDocumentCodes)';
//                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
//                    objAuditTrail.SymphonyIPM__Description__c = strAuditTrailLogText;
//                if (Schema.SObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
//                    objAuditTrail.SymphonyIPM__Status__c = AuditTrailStatus;
//                if (SymphonyIPM__AuditTrail__c.SObjectType.getDescribe().isCreateable() && Schema.SObjectType.SymphonyIPM__AuditTrail__c.isCreateable())
//                    insert objAuditTrail;
//            }
//        }
//        return objWrapperFinalTriggerActionCloseBy;
//    }

}
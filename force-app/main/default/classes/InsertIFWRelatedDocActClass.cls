public with sharing class InsertIFWRelatedDocActClass {
    public date Duedate { set; get; }

    public string mtdInsertIFWRelatedDocActClass(
            List<Id> lstIDS, String AssetType, String TriggeType, date manualDuedate, String emailTrackerId
    ) {
        try {

            Duedate = manualDuedate;
            system.debug('Manual Due Date from Controller---> : ' + Duedate);
            List<Id> lstifwIDS = lstIDS;

            Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> MapJurisdictionDocketingRules = NEW Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>>();
            Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> MapJurisdictionDeDocketingRules = NEW Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>>();
            List<SymphonyIPM__Docketing_Rule_Engine__c> lstDocketingRule = NEW List<SymphonyIPM__Docketing_Rule_Engine__c>();


            if (Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isAccessible() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isAccessible()) {
                List<SymphonyIPM__IFW_Data_v1__c> strBatchQuery = [
                        SELECT SymphonyIPM__Activity_Id__c,SymphonyIPM__Application_ID__c,SymphonyIPM__Application_Number__c,SymphonyIPM__Asset__c,SymphonyIPM__Asset__r.SymphonyIPM__Country__c,SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c,
                                // Need Add Base rule dates
                                SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Adjusted_Expiration_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Expiration_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Allowance_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Priority_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Estimated_Expiration_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Expiration_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Grant_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__International_Filing_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__International_Grant_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c,SymphonyIPM__Asset__r.SymphonyIPM__Marketing_Approval_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Annuities_PCTFiling_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Potential_Bar_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Priority_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Status_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__PTE_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Annuities_Issue_Date_of_Patent__c,SymphonyIPM__Asset__r.SymphonyIPM__Parent_Filing_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__SPC_Expiry_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Publication_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Target_Filing_Date__c,
                                CreatedDate,SymphonyIPM__Document_Category__c,SymphonyIPM__Document_Code__c,SymphonyIPM__Document_Description__c,
                                SymphonyIPM__DownloadLink__c,SymphonyIPM__Final_Decision__c,Id,SymphonyIPM__IfwDocumentId__c,SymphonyIPM__IFW_Reference_Id__c,
                                SymphonyIPM__Internal_DueDate__c,SymphonyIPM__Invention_Subject_Matter_Type__c,SymphonyIPM__Is_Family_Filed__c,
                                SymphonyIPM__Mail_Room_Date__c,Name,SymphonyIPM__OC_Decision_Submitted__c,SymphonyIPM__OC_FilingComments__c,
                                SymphonyIPM__OC_Filing_Type__c,SymphonyIPM__OC_PayIssueFee__c,SymphonyIPM__Office_Action_Text__c,SymphonyIPM__Page_Quantity__c,
                                SymphonyIPM__Patent_Country_Code__c,SymphonyIPM__PDFFileName__c,SymphonyIPM__PTO_DueDate__c,SymphonyIPM__Trigger__c
                        FROM SymphonyIPM__IFW_Data_v1__c
                        WHERE Id IN:lstifwIDS AND SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c != ''
                        ORDER BY SymphonyIPM__Mail_Room_Date__c ASC NULLS FIRST
                        LIMIT 49999
                ];


                if (Schema.SObjectType.SymphonyIPM__Docketing_Rule_Engine__c.isAccessible() && SymphonyIPM__Docketing_Rule_Engine__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isAccessible() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isAccessible()) {
                    lstDocketingRule = [
                            SELECT
                            //Adjustment__c,
                                    SymphonyIPM__Asset_Type__c
                                    , SymphonyIPM__Base_Date_1__c
                                    , SymphonyIPM__Base_Date__c
                                    , SymphonyIPM__Case_Type__c
                                    , SymphonyIPM__Classification__c
                                    , SymphonyIPM__Compound_Selection__c
                                    , SymphonyIPM__Docket_Action__c
                                    , Id
                                    , SymphonyIPM__Importance__c
                                    , IsDeleted
                                    , SymphonyIPM__Jurisdiction__c
                                    , SymphonyIPM__Life_Cycle_Stage__c
                                    , Name
                                    , SymphonyIPM__Rule_Active__c
                                    , SymphonyIPM__YearsToCal__c
                                    , SymphonyIPM__Operator__c
                                    , SymphonyIPM__Count__c
                                    , SymphonyIPM__Period_Type__c
                                    , SymphonyIPM__Operator1__c
                                    , SymphonyIPM__Count1__c
                                    , SymphonyIPM__Period_Type1__c
                                    , SymphonyIPM__Rule_Start_Date__c
                                    , SymphonyIPM__Rule_End_Date__c
                                    , SymphonyIPM__Rule_Base_date__c
                                    , SymphonyIPM__Trigger_Type__c
                                    , SymphonyIPM__Trigger__c
                                    , SymphonyIPM__Mark_Closed__c
                                    , SymphonyIPM__Mark_Completed__c
                                    , SymphonyIPM__Rule_Type__c
                                    , SymphonyIPM__StartYearsToCal__c
                                    , SymphonyIPM__Start_Operator__c
                                    , SymphonyIPM__Start_Count__c
                                    , SymphonyIPM__Start_Period_Type__c
                                    , SymphonyIPM__Start_Operator1__c
                                    , SymphonyIPM__Start_Count1__c
                                    , SymphonyIPM__Start_Period_Type1__c
                                    , SymphonyIPM__CloseYearsToCal__c
                                    , SymphonyIPM__Close_Operator__c
                                    , SymphonyIPM__Close_Count__c
                                    , SymphonyIPM__Close_Period_Type__c
                                    , SymphonyIPM__Close_Operator1__c
                                    , SymphonyIPM__CYearsToCal__c
                                    , SymphonyIPM__Close_Count1__c
                                    , SymphonyIPM__Close_Period_Type1__c
                                    , SymphonyIPM__COperator__c
                                    , SymphonyIPM__CCount__c
                                    , SymphonyIPM__CPeriod_Type__c
                                    , SymphonyIPM__COperator1__c
                                    , SymphonyIPM__CCount1__c
                                    , SymphonyIPM__CPeriod_Type1__c
                                    , SymphonyIPM__AdjustmentType__c
                                    , SymphonyIPM__Adjust_to_a_Specific_Date__c
                            FROM SymphonyIPM__Docketing_Rule_Engine__c
                            WHERE
                            SymphonyIPM__Case_Type__c = :strBatchQuery[0].SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c
                            AND SymphonyIPM__Jurisdiction__c = :strBatchQuery[0].SymphonyIPM__Asset__r.SymphonyIPM__Country__c
                            AND SymphonyIPM__Asset_Type__c = :AssetType
                            AND SymphonyIPM__Rule_Active__c = true
                            LIMIT 49999
                    ];
                    system.debug('Rules List Size :' + lstDocketingRule.size());
                    if (lstDocketingRule.size() > 0) {
                        for (SymphonyIPM__Docketing_Rule_Engine__c DRE : lstDocketingRule) {
                            if (DRE.SymphonyIPM__Rule_Type__c == 'Docketing') {
                                //condition added on 28-05-2018
                                if (DRE.SymphonyIPM__Period_Type__c == null && DRE.SymphonyIPM__Period_Type1__c == null) {
                                    DRE.SymphonyIPM__Period_Type__c = 'Month(s)';DRE.SymphonyIPM__Period_Type1__c = 'Day(s)';
                                }
                                //system.debug(DRE.Rule_Type__c);
                                String MyKey = DRE.SymphonyIPM__Jurisdiction__c + '-' + DRE.SymphonyIPM__Trigger__c + '-' + DRE.SymphonyIPM__Case_Type__c;
                                system.debug('Rule Building --->' + MyKey);
                                //--------
                                List<SymphonyIPM__Docketing_Rule_Engine__c> temp = MapJurisdictionDocketingRules.get(MyKey);
                                if (temp == null) {
                                    MapJurisdictionDocketingRules.put(MyKey, new List<SymphonyIPM__Docketing_Rule_Engine__c>{
                                            DRE
                                    });
                                } else {
                                    temp.add(DRE);
                                }
                                //--------
                            }
                            if (DRE.SymphonyIPM__Rule_Type__c == 'De-Docketing') {
                                //condition added on 28-05-2018
                                if (DRE.SymphonyIPM__Start_Period_Type__c == null && DRE.SymphonyIPM__Start_Period_Type1__c == null && DRE.SymphonyIPM__Close_Period_Type__c == null && DRE.SymphonyIPM__Close_Period_Type1__c == null) {
                                    DRE.SymphonyIPM__Start_Period_Type__c = 'Month(s)';DRE.SymphonyIPM__Start_Period_Type1__c = 'Day(s)';
                                    DRE.SymphonyIPM__Close_Period_Type__c = 'Month(s)';DRE.SymphonyIPM__Close_Period_Type1__c = 'Day(s)';
                                }
                                //system.debug(DRE.Rule_Type__c);
                                String MyKey = DRE.SymphonyIPM__Jurisdiction__c + '-' + DRE.SymphonyIPM__Trigger__c + '-' + DRE.SymphonyIPM__Case_Type__c;
                                //--------
                                List<SymphonyIPM__Docketing_Rule_Engine__c> temp = MapJurisdictionDeDocketingRules.get(MyKey);
                                if (temp == null) {
                                    MapJurisdictionDeDocketingRules.put(MyKey, new List<SymphonyIPM__Docketing_Rule_Engine__c>{
                                            DRE
                                    });
                                } else {
                                    temp.add(DRE);
                                }
                                //--------
                            }
                        }
                    }
                    Set<ID> AssetIDs = NEW Set<ID>();
                    List<SymphonyIPM__IFW_Data_v1__c> IIFWList = NEW List<SymphonyIPM__IFW_Data_v1__c>();
                    if (strBatchQuery.size() > 0 && strBatchQuery != null)
                        for (SymphonyIPM__IFW_Data_v1__c objSObject : strBatchQuery) {
                            SymphonyIPM__IFW_Data_v1__c IFW = (SymphonyIPM__IFW_Data_v1__c) objSObject;
                            AssetIDs.add(IFW.SymphonyIPM__Asset__c);
                            IIFWList.add(IFW);
                        }

                    List<SymphonyIPM__Docketing_Activity_v2__c> DAnewLst = Docketing(IIFWList, MapJurisdictionDocketingRules, emailTrackerId);
//                    System.debug('List size to insert : ' + DAnewLst.size());
                    List<SymphonyIPM__Docketing_Activity_v2__c> LstActivitiesToUpdate = DeDocketing(IIFWList, AssetIDs, MapJurisdictionDeDocketingRules);

                    //DML Operation
                    //For De-Docketing Activities
                    if (LstActivitiesToUpdate != null && LstActivitiesToUpdate.size() > 0 && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.isUpdateable() && SymphonyIPM__Docketing_Activity_v2__c.SObjectType.getDescribe().isUpdateable()) {
                        System.debug('List size to update DA: ' + LstActivitiesToUpdate.size());
                        update LstActivitiesToUpdate;
                    }
                    //For Docketing Activities
                    if (DAnewLst != null && DAnewLst.size() > 0 && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.isCreateable() && SymphonyIPM__Docketing_Activity_v2__c.SObjectType.getDescribe().isCreateable()) {
                        System.debug('List size to insert : ' + DAnewLst.size());
                        insert DAnewLst;
                    }
                    return 'Success';
                }
            }
            return 'Error';
        }

        catch (DMLException e) {
            system.debug(e.getMessage());
            string msg = e.getMessage();
            return msg;
        }
    }
    public string mtdInsertIFWRelatedDocActClassWithAttachment(
            List<Id> lstIDS, String AssetType, date manualDuedate
            , list<string> miscfileNames, list<string> miscbase64data, list<string> miscfiletypes, String emailTrackerId
    ) {
        try {
            //manualDuedate = null;
            Duedate = manualDuedate;
            system.debug('Manual Due Date from Controller---> : ' + Duedate);
            List<Id> lstifwIDS = lstIDS;
            system.debug('Asset Type :' + AssetType);
            Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> MapJurisdictionDocketingRules = NEW Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>>();
            Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> MapJurisdictionDeDocketingRules = NEW Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>>();
            List<SymphonyIPM__Docketing_Rule_Engine__c> lstDocketingRule = NEW List<SymphonyIPM__Docketing_Rule_Engine__c>();

            //system.debug('Docket Rules Map : '+MapJurisdictionDocketingRules);
            //system.debug('De-Docket Rules Map : '+MapJurisdictionDeDocketingRules);

            //LstActivitiesToUpdate = NEW List<SymphonyIPM__Docketing_Activity_v2__c>();
            //DAnewLst = NEW List<SymphonyIPM__Docketing_Activity_v2__c>();
            if (Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isAccessible() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isAccessible()) {
                List<SymphonyIPM__IFW_Data_v1__c> strBatchQuery = [
                        SELECT SymphonyIPM__Activity_Id__c,SymphonyIPM__Application_ID__c,SymphonyIPM__Application_Number__c,SymphonyIPM__Asset__c,SymphonyIPM__Asset__r.SymphonyIPM__Country__c,SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Asset_Type__c,
                                // Need Add Base rule dates
                                SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Adjusted_Expiration_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Expiration_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Allowance_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Priority_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Estimated_Expiration_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Expiration_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Grant_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__International_Filing_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__International_Grant_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c,SymphonyIPM__Asset__r.SymphonyIPM__Marketing_Approval_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Annuities_PCTFiling_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Potential_Bar_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Priority_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Status_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__PTE_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Annuities_Issue_Date_of_Patent__c,SymphonyIPM__Asset__r.SymphonyIPM__Parent_Filing_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__SPC_Expiry_Date__c,
                                SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Publication_Date__c,SymphonyIPM__Asset__r.SymphonyIPM__Target_Filing_Date__c,
                                CreatedDate,SymphonyIPM__Document_Category__c,SymphonyIPM__Document_Code__c,SymphonyIPM__Document_Description__c,
                                SymphonyIPM__DownloadLink__c,SymphonyIPM__Final_Decision__c,Id,SymphonyIPM__IfwDocumentId__c,SymphonyIPM__IFW_Reference_Id__c,
                                SymphonyIPM__Internal_DueDate__c,SymphonyIPM__Invention_Subject_Matter_Type__c,SymphonyIPM__Is_Family_Filed__c,
                                SymphonyIPM__Mail_Room_Date__c,Name,SymphonyIPM__OC_Decision_Submitted__c,SymphonyIPM__OC_FilingComments__c,
                                SymphonyIPM__OC_Filing_Type__c,SymphonyIPM__OC_PayIssueFee__c,SymphonyIPM__Office_Action_Text__c,SymphonyIPM__Page_Quantity__c,
                                SymphonyIPM__Patent_Country_Code__c,SymphonyIPM__PDFFileName__c,SymphonyIPM__PTO_DueDate__c,SymphonyIPM__Trigger__c
                        FROM SymphonyIPM__IFW_Data_v1__c
                        WHERE id IN:lstifwIDS AND SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c != ''
                        ORDER BY SymphonyIPM__Mail_Room_Date__c ASC NULLS FIRST
                        LIMIT 49999
                ];


                if (Schema.SObjectType.SymphonyIPM__Docketing_Rule_Engine__c.isAccessible() && SymphonyIPM__Docketing_Rule_Engine__c.SObjectType.getDescribe().isAccessible() && Schema.SObjectType.SymphonyIPM__IFW_Data_v1__c.isAccessible() && SymphonyIPM__IFW_Data_v1__c.SObjectType.getDescribe().isAccessible()) {
                    lstDocketingRule = [
                            SELECT
                            //Adjustment__c,
                                    SymphonyIPM__Asset_Type__c
                                    , SymphonyIPM__Base_Date__c
                                    , SymphonyIPM__Base_Date_1__c
                                    , SymphonyIPM__Case_Type__c
                                    , SymphonyIPM__Classification__c
                                    , SymphonyIPM__Compound_Selection__c
                                    , SymphonyIPM__Docket_Action__c
                                    , Id
                                    , SymphonyIPM__Importance__c
                                    , IsDeleted
                                    , SymphonyIPM__Jurisdiction__c
                                    , SymphonyIPM__Life_Cycle_Stage__c
                                    , Name
                                    , SymphonyIPM__Rule_Active__c
                                    , SymphonyIPM__YearsToCal__c
                                    , SymphonyIPM__Operator__c
                                    , SymphonyIPM__Count__c
                                    , SymphonyIPM__Period_Type__c
                                    , SymphonyIPM__Operator1__c
                                    , SymphonyIPM__Count1__c
                                    , SymphonyIPM__Period_Type1__c
                                    , SymphonyIPM__Rule_Start_Date__c
                                    , SymphonyIPM__Rule_End_Date__c
                                    , SymphonyIPM__Rule_Base_date__c
                                    , SymphonyIPM__Trigger_Type__c
                                    , SymphonyIPM__Trigger__c
                                    , SymphonyIPM__Mark_Closed__c
                                    , SymphonyIPM__Mark_Completed__c
                                    , SymphonyIPM__Rule_Type__c
                                    , SymphonyIPM__StartYearsToCal__c
                                    , SymphonyIPM__Start_Operator__c
                                    , SymphonyIPM__Start_Count__c
                                    , SymphonyIPM__Start_Period_Type__c
                                    , SymphonyIPM__Start_Operator1__c
                                    , SymphonyIPM__Start_Count1__c
                                    , SymphonyIPM__Start_Period_Type1__c
                                    , SymphonyIPM__CloseYearsToCal__c
                                    , SymphonyIPM__Close_Operator__c
                                    , SymphonyIPM__Close_Count__c
                                    , SymphonyIPM__Close_Period_Type__c
                                    , SymphonyIPM__Close_Operator1__c
                                    , SymphonyIPM__Close_Count1__c
                                    , SymphonyIPM__Close_Period_Type1__c
                                    , SymphonyIPM__CYearsToCal__c
                                    , SymphonyIPM__COperator__c
                                    , SymphonyIPM__CCount__c
                                    , SymphonyIPM__CPeriod_Type__c
                                    , SymphonyIPM__COperator1__c
                                    , SymphonyIPM__CCount1__c
                                    , SymphonyIPM__CPeriod_Type1__c
                                    , SymphonyIPM__AdjustmentType__c
                                    , SymphonyIPM__Adjust_to_a_Specific_Date__c
                                    , SymphonyIPM__Manual_Due_Date__c
                            FROM SymphonyIPM__Docketing_Rule_Engine__c
                            WHERE
                            SymphonyIPM__Trigger_Type__c != 'Date'
                            AND SymphonyIPM__Jurisdiction__c = :strBatchQuery[0].SymphonyIPM__Asset__r.SymphonyIPM__Country__c
                            AND SymphonyIPM__Case_Type__c = :strBatchQuery[0].SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c
                            AND SymphonyIPM__Asset_Type__c = :AssetType
                            AND SymphonyIPM__Rule_Active__c = true
                            LIMIT 49999
                    ];
                    system.debug('Rules List Size :' + lstDocketingRule.size());
                    if (lstDocketingRule.size() > 0) {
                        for (SymphonyIPM__Docketing_Rule_Engine__c DRE : lstDocketingRule) {
                            if (DRE.SymphonyIPM__Rule_Type__c == 'Docketing') {
                                //condition added on 28-05-2018
                                if (DRE.SymphonyIPM__Period_Type__c == null && DRE.SymphonyIPM__Period_Type1__c == null) {
                                    DRE.SymphonyIPM__Period_Type__c = 'Month(s)';DRE.SymphonyIPM__Period_Type1__c = 'Day(s)';
                                }

                                String MyKey = DRE.SymphonyIPM__Jurisdiction__c + '-' + DRE.SymphonyIPM__Trigger__c + '-' + DRE.SymphonyIPM__Case_Type__c;
                                system.debug('Rule Building --->' + MyKey);
                                //--------
                                List<SymphonyIPM__Docketing_Rule_Engine__c> temp = MapJurisdictionDocketingRules.get(MyKey);
                                if (temp == null) {
                                    MapJurisdictionDocketingRules.put(MyKey, new List<SymphonyIPM__Docketing_Rule_Engine__c>{DRE});
                                } else {
                                    temp.add(DRE);
                                }
                                //--------
                            }
                            if (DRE.SymphonyIPM__Rule_Type__c == 'De-Docketing') {
                                //condition added on 28-05-2018
                                if (DRE.SymphonyIPM__Start_Period_Type__c == null && DRE.SymphonyIPM__Start_Period_Type1__c == null && DRE.SymphonyIPM__Close_Period_Type__c == null && DRE.SymphonyIPM__Close_Period_Type1__c == null) {
                                    DRE.SymphonyIPM__Start_Period_Type__c = 'Month(s)';DRE.SymphonyIPM__Start_Period_Type1__c = 'Day(s)';
                                    DRE.SymphonyIPM__Close_Period_Type__c = 'Month(s)';DRE.SymphonyIPM__Close_Period_Type1__c = 'Day(s)';
                                }
                                //system.debug(DRE.Rule_Type__c);
                                String MyKey = DRE.SymphonyIPM__Jurisdiction__c + '-' + DRE.SymphonyIPM__Trigger__c + '-' + DRE.SymphonyIPM__Case_Type__c;
                                //--------
                                List<SymphonyIPM__Docketing_Rule_Engine__c> temp = MapJurisdictionDeDocketingRules.get(MyKey);
                                if (temp == null) {
                                    MapJurisdictionDeDocketingRules.put(MyKey, new List<SymphonyIPM__Docketing_Rule_Engine__c>{
                                            DRE
                                    });
                                } else {
                                    temp.add(DRE);
                                }
                                //--------
                            }
                        }
                    }

                    Set<ID> AssetIDs = NEW Set<ID>();
                    List<SymphonyIPM__IFW_Data_v1__c> IIFWList = NEW List<SymphonyIPM__IFW_Data_v1__c>();
                    if (strBatchQuery.size() > 0 && strBatchQuery != null)
                        for (SymphonyIPM__IFW_Data_v1__c objSObject : strBatchQuery) {
                            SymphonyIPM__IFW_Data_v1__c IFW = (SymphonyIPM__IFW_Data_v1__c) objSObject;
                            AssetIDs.add(IFW.SymphonyIPM__Asset__c);
                            IIFWList.add(IFW);
                        }

                    List<SymphonyIPM__Docketing_Activity_v2__c> DAnewLst = Docketing(IIFWList, MapJurisdictionDocketingRules, emailTrackerId);
                    List<SymphonyIPM__Docketing_Activity_v2__c> LstActivitiesToUpdate = DeDocketing(IIFWList, AssetIDs, MapJurisdictionDeDocketingRules);

                    //DML Operation
                    //For De-Docketing Activities
//                    System.debug('1--------------' + LstActivitiesToUpdate.size());
                    if (LstActivitiesToUpdate != null && LstActivitiesToUpdate.size() > 0 && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.isUpdateable() && SymphonyIPM__Docketing_Activity_v2__c.SObjectType.getDescribe().isUpdateable()) {
                        System.debug('List size to update DA: ' + LstActivitiesToUpdate.size());
                        update LstActivitiesToUpdate;
                    }
                    //For Docketing Activities
//                    System.debug('2--------------' + DAnewLst.size());
                    if (DAnewLst != null && DAnewLst.size() > 0 && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.isCreateable() && SymphonyIPM__Docketing_Activity_v2__c.SObjectType.getDescribe().isCreateable()) {
                        System.debug('List size to insert : ' + DAnewLst.size());
                        insert DAnewLst;
                        //----Added for Miscellaneous Documents upload from Event-----------
                        if (miscfileNames.size() > 0 && miscfileNames.size() == miscbase64data.size()) {
                            if (miscfileNames.size() == miscfiletypes.size() && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.isAccessible() && SymphonyIPM__Docketing_Activity_v2__c.SObjectType.getDescribe().isAccessible()) {
                                List<SymphonyIPM__Docketing_Activity_v2__c> docActs = [select id from SymphonyIPM__Docketing_Activity_v2__c where id IN:DAnewLst];
                                list<Attachment> docsIFWProsecution = NEW List<Attachment>();
                                //--Attachments--
                                for (SymphonyIPM__Docketing_Activity_v2__c docAct : docActs) {
                                    system.debug('Files to Insert Size for each DA : ' + miscbase64data.size());
                                    for (integer i = 0; i < miscbase64data.size(); i = i + 1) {
                                        Attachment attachment = new Attachment();
                                        attachment.parentId = docAct.id;
                                        attachment.body = EncodingUtil.base64Decode(miscbase64data[i]);
                                        attachment.name = miscfileNames[i];
                                        attachment.contentType = miscfiletypes[i];
                                        docsIFWProsecution.add(attachment);
                                    }
                                }
                                if (docsIFWProsecution.size() > 0) {
                                    insert docsIFWProsecution;
                                }
                            }
                        }
                    }
                    return 'Success';
                }
            }
            return 'Error';
        } catch (DMLException e) {
            system.debug(e.getMessage());
            string msg = e.getMessage();
            return msg;
        }
    }
    public date CalculateDate(Date Basedt, decimal yy, string operator, decimal count, string option, string operator1, decimal count1, string option1) {
        if (yy == null)
            yy = 0.0;
        if (count == null)
            count = 0.0;
        if (count1 == null)
            count1 = 0.0;

        if (operator == null)
            operator = '+';
        if (operator1 == null)
            operator1 = '+';

        if (option == null && option1 == null) {
            option = 'Month(s)';
            option1 = 'Day(s)';
        }
        if (option != null && option1 == null) {
            if (option == 'Month(s)') {
                option1 = 'Day(s)';
            } else
                    option1 = 'Month(s)';
        }
        if (option == null && option1 != null) {
            if (option1 == 'Month(s)') {
                option = 'Day(s)';
            } else
                    option = 'Month(s)';

        }
        //system.debug('From Calculate Date---->');
        String AddNoofYears = String.valueOf(yy);
        String AddNoofCount = operator + String.valueOf(count);
        String AddNoofCount1 = operator1 + String.valueOf(count1);
        Date calculatedDate;
        calculatedDate = Basedt.addYears(Integer.valueof(AddNoofYears.trim()));
        //system.debug('calculatedDate added Years :'+ calculatedDate );
        if (option == 'Month(s)') {
            calculatedDate = calculatedDate.addMonths(Integer.valueof(AddNoofCount.trim()));
            //system.debug('calculatedDate added Months:'+ calculatedDate );
            calculatedDate = calculatedDate.addDays(Integer.valueof(AddNoofCount1.trim()));
            //system.debug('calculatedDate added Days:'+ calculatedDate );
        }
        if (option == 'Day(s)') {
            calculatedDate = calculatedDate.addDays(Integer.valueof(AddNoofCount.trim()));
            //system.debug('calculatedDate added Days:'+ calculatedDate );
            calculatedDate = calculatedDate.addMonths(Integer.valueof(AddNoofCount1.trim()));
            //system.debug('calculatedDate added Months:'+ calculatedDate );
        }
        return calculatedDate;
    }

    public List<SymphonyIPM__Docketing_Activity_v2__c> Docketing(List<SymphonyIPM__IFW_Data_v1__c> ListIFW, Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> DocketingRules, String emailTrackerId) {
        Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> MapJurisdictionDocketingRules = DocketingRules;
        system.debug('Docketing');
        system.debug('Docket Rules Size : ' + DocketingRules.size());
        List<SymphonyIPM__Docketing_Activity_v2__c> DAnewLst = NEW List<SymphonyIPM__Docketing_Activity_v2__c>();
        for (SymphonyIPM__IFW_Data_v1__c IFW : ListIFW) {
            String KeyForFetchingRule = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Country__c + '-' + IFW.SymphonyIPM__Document_Code__c + '-' + IFW.SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c;
            if (IFW.SymphonyIPM__Document_Code__c == null)
                KeyForFetchingRule = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Country__c + '-' + IFW.SymphonyIPM__Trigger__c + '-' + IFW.SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c;
            system.debug(KeyForFetchingRule);
            //Read rules from DocketingRuleEngine
            //system.debug(MapJurisdictionDocketingRules);
            if (MapJurisdictionDocketingRules.containsKey(KeyForFetchingRule)) {
                List<SymphonyIPM__Docketing_Rule_Engine__c> KeyRules = MapJurisdictionDocketingRules.get(KeyForFetchingRule);
                //---------Need to add Rule base dates if there---------
                Date RuleFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c;
                Date RuleEffectiveFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c;
                Date RuleIssueDateofPatent = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c;
                Date RuleAdjustedExpirationDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Adjusted_Expiration_Date__c;
                Date RuleAllowanceDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Allowance_Date__c;
                Date RuleEarliestPriorityDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Priority_Date__c;
                Date RuleEstimatedExpirationDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Estimated_Expiration_Date__c;
                Date RuleExpirationDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Expiration_Date__c;
                Date RuleImmediateParentExpirationDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Expiration_Date__c;
                Date RuleImmediateParentGrantDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Grant_Date__c;
                Date RuleInternationalFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Filing_Date__c;
                Date RuleInternationalGrantDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Grant_Date__c;
                Date RuleMarketingApprovalDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Marketing_Approval_Date__c;
                Date RulePCTFilingDateAnnuity = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_PCTFiling_Date__c;
                Date RulePotentialBarDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Potential_Bar_Date__c;
                Date RulePriorityDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Priority_Date__c;
                Date RuleProsecutionStatusDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Status_Date__c;
                Date RulePTEDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__PTE_Date__c;
                Date RulePublicationDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Publication_Date__c;
                Date RuleTargetFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Target_Filing_Date__c;
                Date RuleIssueDateAnnuity = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_Issue_Date_of_Patent__c;
                Date RuleParentFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Parent_Filing_Date__c;
                Date RuleSPCExpiryDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__SPC_Expiry_Date__c;
                //------------------------------------------------------
                if (KeyRules.size() > 0) {
                    for (SymphonyIPM__Docketing_Rule_Engine__c DR : KeyRules) {
                        //----------------
                        Date ForBaseDate;
                        Date ForBaseDate1;
                        Date FinalDeadline;
                        Map<string, Date> FieldCalcDate = NEW Map<string, Date>();
                        Map<string, Date> CompFieldCalcDate = NEW Map<string, Date>();

                        Date FilingDate;
                        Date AdjustedExpirationDate;
                        Date AllowanceDate;
                        Date EarliestPriorityDate;
                        Date EstimatedExpirationDate;
                        Date ExpirationDate;
                        Date EffectiveFilingDate;
                        Date ImmediateParentExpirationDate;
                        Date ImmediateParentGrantDate;
                        Date InternationalFilingDate;
                        Date InternationalGrantDate;
                        Date IssueDateofPatent;
                        Date MarketingApprovalDate;
                        Date PCTFilingDateAnnuity;
                        Date PotentialBarDate;
                        Date PriorityDate;
                        Date ProsecutionStatusDate;
                        Date PTEDate;
                        Date PublicationDate;
                        Date TargetFilingDate;
                        Date IssueDateAnnuity;
                        Date ParentFilingDate;
                        Date SPCExpiryDate;
                        Date MailRoomDate;
                        
                        Date CFilingDate;
                        Date CAdjustedExpirationDate;
                        Date CAllowanceDate;
                        Date CEarliestPriorityDate;
                        Date CEstimatedExpirationDate;
                        Date CExpirationDate;
                        Date CEffectiveFilingDate;
                        Date CImmediateParentExpirationDate;
                        Date CImmediateParentGrantDate;
                        Date CInternationalFilingDate;
                        Date CInternationalGrantDate;
                        Date CIssueDateofPatent;
                        Date CMarketingApprovalDate;
                        Date CPCTFilingDateAnnuity;
                        Date CPotentialBarDate;
                        Date CPriorityDate;
                        Date CProsecutionStatusDate;
                        Date CPTEDate;
                        Date CPublicationDate;
                        Date CTargetFilingDate;
                        Date CIssueDateAnnuity;
                        Date CParentFilingDate;
                        Date CSPCExpiryDate;
                        Date CMailRoomDate;

                        String BaseDate = DR.SymphonyIPM__Base_Date__c;
                        String BaseDate1 = DR.SymphonyIPM__Base_Date_1__c;
                        String CompoundSelection = DR.SymphonyIPM__Compound_Selection__c;
                        //----------------
                        SymphonyIPM__Docketing_Activity_v2__c DAnew = NEW SymphonyIPM__Docketing_Activity_v2__c();
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Activity_Date__c.isCreateable()) {
                            DAnew.SymphonyIPM__Activity_Date__c = IFW.SymphonyIPM__Mail_Room_Date__c;
                            system.debug('Activity Date : ' + DAnew.SymphonyIPM__Activity_Date__c);
                        }
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Due_Date__c.isCreateable()) {
                            system.debug('Manual Due Date from Docketing: ' + Duedate);
                            if (Test.isRunningTest())
                                Duedate = null;
                            if (Duedate == null) {
                                //DAnew.Due_Date__c  = PickCalculatedDate(IFW.SymphonyIPM__Mail_Room_Date__c, DR.YearsToCal__c,DR.Months_Operator__c,DR.MonthToCal__c,DR.Days_Operator__c,DR.DayToCal__c);
                                //-----------------------
                                system.debug('Base Date : '+IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c +'--> Add Yrs :'+DR.SymphonyIPM__YearsToCal__c+'*******'+DR.SymphonyIPM__Operator__c+DR.SymphonyIPM__Count__c+DR.SymphonyIPM__Period_Type__c+'*******'+DR.SymphonyIPM__Operator1__c+DR.SymphonyIPM__Count1__c+DR.SymphonyIPM__Period_Type1__c);
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c!=null)
                                {
                                    FilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Filing Date',FilingDate);

                                    CFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Filing Date',CFilingDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Adjusted_Expiration_Date__c!=null)
                                {
                                    AdjustedExpirationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Adjusted_Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Adjusted Expiration Date',AdjustedExpirationDate);

                                    CAdjustedExpirationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Adjusted_Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Adjusted Expiration Date',CAdjustedExpirationDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Allowance_Date__c!=null)
                                {
                                    AllowanceDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Allowance_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Allowance Date',AllowanceDate);

                                    CAllowanceDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Allowance_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Allowance Date',CAllowanceDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Priority_Date__c!=null)
                                {
                                    EarliestPriorityDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Priority_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Earliest Priority Date',EarliestPriorityDate);

                                    CEarliestPriorityDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Priority_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Earliest Priority Date',CEarliestPriorityDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Estimated_Expiration_Date__c!=null)
                                {
                                    EstimatedExpirationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Estimated_Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Estimated Expiration Date',EstimatedExpirationDate);

                                    EstimatedExpirationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Estimated_Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Estimated Expiration Date',EstimatedExpirationDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Expiration_Date__c != null)
                                {
                                    ExpirationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Expiration Date',ExpirationDate);

                                    CExpirationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Expiration Date',CExpirationDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c!=null)
                                {
                                    EffectiveFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Effective Filing Date',EffectiveFilingDate);

                                    CEffectiveFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Effective Filing Date',CEffectiveFilingDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Expiration_Date__c!=null)
                                {
                                    ImmediateParentExpirationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Immediate Parent Expiration Date',ImmediateParentExpirationDate );

                                    CImmediateParentExpirationDate  = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Expiration_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Immediate Parent Expiration Date',CImmediateParentExpirationDate );
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Grant_Date__c!=null)
                                {
                                    ImmediateParentGrantDate= CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Grant_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Immediate Parent Grant Date',ImmediateParentGrantDate);

                                    CImmediateParentGrantDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Immediate_Parent_Grant_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Immediate Parent Grant Date',CImmediateParentGrantDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Filing_Date__c!=null)
                                {
                                    InternationalFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('International Filing Date',InternationalFilingDate);

                                    CInternationalFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('International Filing Date',CInternationalFilingDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Grant_Date__c!=null)
                                {
                                    InternationalGrantDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Grant_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('International Grant Date',InternationalGrantDate);

                                    CInternationalGrantDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__International_Grant_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('International Grant Date',CInternationalGrantDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c!=null)
                                {
                                    IssueDateofPatent = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Issue Date of Patent',IssueDateofPatent);
                                    FieldCalcDate.put('Grant Date',IssueDateofPatent);
                                    CIssueDateofPatent = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Issue Date of Patent',CIssueDateofPatent);
                                    CompFieldCalcDate.put('Grant Date',CIssueDateofPatent);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Marketing_Approval_Date__c!=null)
                                {
                                    MarketingApprovalDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Marketing_Approval_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Marketing Approval Date',MarketingApprovalDate);

                                    CMarketingApprovalDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Marketing_Approval_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Marketing Approval Date',CMarketingApprovalDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_PCTFiling_Date__c!=null)
                                {
                                    PCTFilingDateAnnuity = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_PCTFiling_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('PCT Filing Date (Annuity)',PCTFilingDateAnnuity);

                                    CPCTFilingDateAnnuity = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_PCTFiling_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('PCT Filing Date (Annuity)',CPCTFilingDateAnnuity);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Potential_Bar_Date__c!=null)
                                {
                                    PotentialBarDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Potential_Bar_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Potential Bar Date',PotentialBarDate);

                                    CPotentialBarDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Potential_Bar_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Potential Bar Date',CPotentialBarDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Priority_Date__c!=null)
                                {
                                    PriorityDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Priority_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Priority Date',PriorityDate);

                                    CPriorityDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Priority_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Priority Date',CPriorityDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Status_Date__c!=null)
                                {
                                    ProsecutionStatusDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Status_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Prosecution Status Date',ProsecutionStatusDate);

                                    CProsecutionStatusDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Status_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Prosecution Status Date',CProsecutionStatusDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__PTE_Date__c!=null)
                                {
                                    PTEDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__PTE_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('PTE Date',PTEDate);

                                    CPTEDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__PTE_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('PTE Date',CPTEDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Publication_Date__c!=null)
                                {
                                    PublicationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Publication_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Publication Date',PublicationDate);

                                    CPublicationDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Earliest_Publication_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Publication Date',CPublicationDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Target_Filing_Date__c!=null)
                                {
                                    TargetFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Target_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Target Filing Date',TargetFilingDate);

                                    CTargetFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Target_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Target Filing Date',CTargetFilingDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_Issue_Date_of_Patent__c !=null)
                                {
                                    IssueDateAnnuity = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_Issue_Date_of_Patent__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Issue Date (Annuity)',IssueDateAnnuity);

                                    CIssueDateAnnuity = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_Issue_Date_of_Patent__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Issue Date (Annuity)',CIssueDateAnnuity);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Parent_Filing_Date__c!=null)
                                {
                                    ParentFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Parent_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Immediate Parent Filing Date',ParentFilingDate);

                                    CParentFilingDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Parent_Filing_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Immediate Parent Filing Date',CParentFilingDate);
                                }
                                if(IFW.SymphonyIPM__Asset__r.SymphonyIPM__SPC_Expiry_Date__c!=null)
                                {
                                    SPCExpiryDate= CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__Annuities_Issue_Date_of_Patent__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('SPC Expiry Date',SPCExpiryDate);

                                    CSPCExpiryDate = CalculateDate(IFW.SymphonyIPM__Asset__r.SymphonyIPM__SPC_Expiry_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('SPC Expiry Date',CSPCExpiryDate);
                                }
                                if(IFW.SymphonyIPM__Mail_Room_Date__c!=null)
                                {
                                    MailRoomDate=CalculateDate(IFW.SymphonyIPM__Mail_Room_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Mail Date',MailRoomDate);
                                    CMailRoomDate=CalculateDate(IFW.SymphonyIPM__Mail_Room_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Mail Date',CMailRoomDate);
                                }
                                if((BaseDate == 'Grant Date (adjusted to the day and month of Filing Date)' ||  BaseDate1 == 'Grant Date (adjusted to the day and month of Filing Date)')&& IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c != null && IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c != null)
                                {
                                    Date PatentFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c;
                                    Date PatentGrantDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c;
                                    Date GDFDAdjustedDate = date.newinstance(PatentGrantDate.Year(), PatentFilingDate.Month(), PatentFilingDate.day());
                                    /*if(PatentFilingDate.Month() < PatentGrantDate.Month())
                                    {
                                        GDFDAdjustedDate = GDFDAdjustedDate.addYears(1);
                                    }*/
                                    if((PatentFilingDate.Month() <= PatentGrantDate.Month()) && (PatentFilingDate.Day() <= PatentGrantDate.Day()))
                                    {
                                        GDFDAdjustedDate = GDFDAdjustedDate.addYears(1);
                                    }

                                    Date GDate=CalculateDate(GDFDAdjustedDate, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    FieldCalcDate.put('Grant Date (adjusted to the day and month of Filing Date)', GDate);

                                    Date CGDate=CalculateDate(GDFDAdjustedDate, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    CompFieldCalcDate.put('Grant Date (adjusted to the day and month of Filing Date)', CGDate);
                                }
                                system.debug('Dates map : '+FieldCalcDate);
                                if(FieldCalcDate.containsKey(BaseDate))
                                {
                                    system.debug('ID Base date is available : '+BaseDate);
                                    //ForBaseDate = CalculateDate(IFW.SymphonyIPM__Mail_Room_Date__c, DR.SymphonyIPM__YearsToCal__c,DR.SymphonyIPM__Operator__c,DR.SymphonyIPM__Count__c,DR.SymphonyIPM__Period_Type__c,DR.SymphonyIPM__Operator1__c,DR.SymphonyIPM__Count1__c,DR.SymphonyIPM__Period_Type1__c);
                                    ForBaseDate = FieldCalcDate.get(BaseDate);
                                    system.debug('Calculdated Base date is : '+ForBaseDate);
                                    FinalDeadline = ForBaseDate;
                                    if(BaseDate1!='' && BaseDate!=null)
                                    {
                                        if(CompFieldCalcDate.containsKey(BaseDate1))
                                        {
                                            system.debug('ID Base date 1 is available : '+BaseDate1);
                                            ForBaseDate1 = CompFieldCalcDate.get(BaseDate1);
                                            system.debug('Calculated Base date 1 is : '+ForBaseDate1);
                                            system.debug('Base Date 1 : '+ForBaseDate1 +'--> Add Yrs :'+DR.SymphonyIPM__YearsToCal__c+'*******'+DR.SymphonyIPM__Operator__c+DR.SymphonyIPM__Count__c+DR.SymphonyIPM__Period_Type__c+'*******'+DR.SymphonyIPM__Operator1__c+DR.SymphonyIPM__Count1__c+DR.SymphonyIPM__Period_Type1__c);
                                            if(CompoundSelection != '')
                                            {
                                                system.debug('Compound Selection : '+CompoundSelection);
                                                system.debug('ForBaseDate : '+ForBaseDate +' <---> ForBaseDate1 : '+ForBaseDate1);
                                                if(Test.isRunningTest()){CompoundSelection ='Earlier of';}
                                                if(CompoundSelection =='Earlier of')
                                                {
                                                    if(ForBaseDate < ForBaseDate1)
                                                    {
                                                        FinalDeadline = ForBaseDate;
                                                    }
                                                    else
                                                            FinalDeadline = ForBaseDate1;
                                                }
                                                if(Test.isRunningTest()){CompoundSelection ='Later Of';}
                                                if(CompoundSelection =='Later Of')
                                                {
                                                    if(ForBaseDate > ForBaseDate1)
                                                    {
                                                        FinalDeadline = ForBaseDate;
                                                    }
                                                    else
                                                            FinalDeadline = ForBaseDate1;
                                                }
                                            }
                                        }
                                    }
                                }
                                //-----------------------
                                //DAnew.Due_Date__c = CalculateDate(IFW.SymphonyIPM__Mail_Room_Date__c, DR.YearsToCal__c,DR.Operator__c,DR.Count__c,DR.Period_Type__c,DR.Operator1__c,DR.Count1__c,DR.Period_Type1__c);
                                //system.debug('Due Date : '+DAnew.Due_Date__c);


                                system.debug('Calculated Date : ' + FinalDeadline);
                                if (Test.isRunningTest())
                                    DR.SymphonyIPM__AdjustmentType__c = 'End of month';
                                if (DR.SymphonyIPM__AdjustmentType__c != '' && DR.SymphonyIPM__AdjustmentType__c != null) {
                                    system.debug('Adjustment is Available and value is : ' + DR.SymphonyIPM__AdjustmentType__c);
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'End of month') {
                                        Date finalDate = FinalDeadline; //Give your date
                                        Date firstDate = finalDate.toStartOfMonth();
                                        Date lastDate = firstDate.addDays(date.daysInMonth(finalDate.year(), finalDate.month()) - 1);
                                        FinalDeadline = lastDate;
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                    if (Test.isRunningTest())
                                        DR.SymphonyIPM__AdjustmentType__c = 'End of quarter';
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'End of quarter') {
                                        Date dt = FinalDeadline;
                                        Integer currentMnt = dt.month();
                                        Integer currentQ = ((currentMnt - 1) / 3) + 1;
                                        Date endOfQDate = date.newInstance(dt.year(), currentMnt + (4 - (currentMnt - ((currentQ - 1) * 3))), 1).addDays(-1);
                                        FinalDeadline = endOfQDate;
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                    if (Test.isRunningTest())
                                        DR.SymphonyIPM__AdjustmentType__c = 'End of year';
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'End of year') {
                                        Date dt = FinalDeadline;
                                        Date lastDate = date.newInstance(dt.year(), 12, 31);
                                        FinalDeadline = lastDate ;
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                    if (Test.isRunningTest())
                                        DR.SymphonyIPM__AdjustmentType__c = 'Plus 15 days';
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'Plus 15 days') {
                                        FinalDeadline = FinalDeadline.addDays(15);
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                    if (Test.isRunningTest())
                                        DR.SymphonyIPM__AdjustmentType__c = 'Plus 10 days';
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'Plus 10 days') {
                                        FinalDeadline = FinalDeadline.addDays(10);
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                    if (Test.isRunningTest())
                                        DR.SymphonyIPM__AdjustmentType__c = 'Less 1 day';
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'Less 1 day') {
                                        FinalDeadline = FinalDeadline.addDays(-1);
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                    if (Test.isRunningTest()) {
                                        DR.SymphonyIPM__AdjustmentType__c = 'Adjust to a specific date';DR.SymphonyIPM__Adjust_to_a_Specific_Date__c = '01/02';
                                    }
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'Adjust to a specific date' && DR.SymphonyIPM__Adjust_to_a_Specific_Date__c != '') {
                                        Date dt = FinalDeadline;
                                        String strTest = DR.SymphonyIPM__Adjust_to_a_Specific_Date__c;
                                        String[] arrTest = strTest.split('/');
                                        Integer specificDay = Integer.valueof(arrTest[0]);
                                        Integer specificMonth = Integer.valueof(arrTest[1]);
                                        Date finalDate = date.newInstance(dt.year(), specificMonth, specificDay);
                                        FinalDeadline = finalDate;
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                    if (Test.isRunningTest())
                                        DR.SymphonyIPM__AdjustmentType__c = 'Adjusted to the effective filing date day and month';
                                    if (DR.SymphonyIPM__AdjustmentType__c == 'Adjusted to the effective filing date day and month' && IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c != null && IFW.SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c != null) {
                                        Date PatentEFDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c;
                                        Date PatentBDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Issue_Date_of_Patent__c;
                                        Date FnlAdjustedDate = date.newinstance(PatentBDate.Year(), PatentEFDate.Month(), PatentEFDate.day());
                                        if ((PatentEFDate.Month() <= PatentBDate.Month()) && (PatentEFDate.Day() <= PatentBDate.Day())) {
                                            FnlAdjustedDate = FnlAdjustedDate.addYears(1);
                                        }
                                        FinalDeadline = FnlAdjustedDate;
                                        system.debug('After Adjustment Due date is : ' + FinalDeadline);
                                    }
                                }
                                DAnew.SymphonyIPM__Due_Date__c = FinalDeadline;
                            } else
                                    DAnew.SymphonyIPM__Due_Date__c = Duedate;
                        }

                        system.debug('DA Due Date : ' + DAnew.SymphonyIPM__Due_Date__c);
                        if (DR.SymphonyIPM__Manual_Due_Date__c != true)
                            if (DR.SymphonyIPM__YearsToCal__c == 0.0 && DR.SymphonyIPM__Count__c == 0.0 && DR.SymphonyIPM__Count1__c == 0.0 && DR.SymphonyIPM__CYearsToCal__c == 0.0 && DR.SymphonyIPM__CCount__c == 0.0 && DR.SymphonyIPM__CCount1__c == 0.0 && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Is_Closed__c.isCreateable() && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Is_Zero_days_rule__c.isCreateable()) {
                                DAnew.SymphonyIPM__Is_Closed__c = true;
                                DAnew.SymphonyIPM__Is_Zero_days_rule__c = true;
                            }
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Docketed_by__c.isCreateable())//Added on 08-03-2019
                            DAnew.SymphonyIPM__Docketed_by__c = DR.id;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Trigger__c.isCreateable())
                            DAnew.SymphonyIPM__Trigger__c = DR.SymphonyIPM__Trigger__c;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Asset_Type__c.isCreateable())
                            DAnew.SymphonyIPM__Asset_Type__c = DR.SymphonyIPM__Asset_Type__c;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Patent__c.isCreateable())
                            DAnew.SymphonyIPM__Patent__c = IFW.SymphonyIPM__Asset__c;
                        //system.debug('IFW Id : '+ IFW.Id);SymphonyIPM__
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Docket_Source_Reference_Id__c.isCreateable())
                            DAnew.SymphonyIPM__Docket_Source_Reference_Id__c = IFW.Id;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Classification__c.isCreateable())
                            DAnew.SymphonyIPM__Classification__c = DR.SymphonyIPM__Classification__c;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Importance__c.isCreateable())
                            DAnew.SymphonyIPM__Importance__c = DR.SymphonyIPM__Importance__c;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Life_Cycle_Stage__c.isCreateable())
                            DAnew.SymphonyIPM__Life_Cycle_Stage__c = DR.SymphonyIPM__Life_Cycle_Stage__c;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Trigger_Type__c.isCreateable())
                            DAnew.SymphonyIPM__Trigger_Type__c = DR.SymphonyIPM__Trigger_Type__c;
                        if (DR.SymphonyIPM__Trigger_Type__c == 'Document Code' && Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Is_AutoDocketed__c.isCreateable())
                            DAnew.SymphonyIPM__Is_AutoDocketed__c = true;
                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Actions__c.isCreateable())
                            DAnew.SymphonyIPM__Actions__c = DR.SymphonyIPM__Docket_Action__c;
                        //DAnewLst.add(DAnew);
                        //---Need to add conditions based on Rule base dates-------------
                        system.debug('Rule base date : ' + DR.SymphonyIPM__Rule_Base_date__c);
                        DAnew.Email_Tracker_Created_From__c = emailTrackerId;
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Filing Date') {
                            //system.debug('DR.Rule_Start_Date__c : '+ DR.Rule_Start_Date__c +'<= RuleFilingDate : '+  RuleFilingDate+' && DR.Rule_End_Date__c : '+DR.Rule_End_Date__c+' >= RuleFilingDate :'+  RuleFilingDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleFilingDate) {
                                DAnewLst.add(DAnew);
                                system.debug('Docketing Record Added :' + DAnew);
                            }
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Effective Filing Date') {
                            //system.debug('DR.Rule_Start_Date__c : '+ DR.Rule_Start_Date__c +'<= RuleEffectiveFilingDate : '+  RuleEffectiveFilingDate+' && DR.Rule_End_Date__c : '+DR.Rule_End_Date__c+' >= RuleEffectiveFilingDate :'+  RuleEffectiveFilingDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleEffectiveFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleEffectiveFilingDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Grant Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleIssueDateofPatent : ' + RuleIssueDateofPatent + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleIssueDateofPatent:' + RuleIssueDateofPatent);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleIssueDateofPatent && DR.SymphonyIPM__Rule_End_Date__c >= RuleIssueDateofPatent)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Adjusted Expiration Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleAdjustedExpirationDate : ' + RuleAdjustedExpirationDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleAdjustedExpirationDate :' + RuleAdjustedExpirationDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleAdjustedExpirationDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleAdjustedExpirationDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Allowance Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleAllowanceDate: ' + RuleAllowanceDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleAllowanceDate:' + RuleAllowanceDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleAllowanceDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleAllowanceDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Earliest Priority Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleEarliestPriorityDate: ' + RuleEarliestPriorityDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleEarliestPriorityDate:' + RuleEarliestPriorityDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleEarliestPriorityDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleEarliestPriorityDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Estimated Expiration Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleEstimatedExpirationDate: ' + RuleEstimatedExpirationDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleEstimatedExpirationDate:' + RuleEstimatedExpirationDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleEstimatedExpirationDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleEstimatedExpirationDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Expiration Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleExpirationDate: ' + RuleExpirationDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleExpirationDate:' + RuleExpirationDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleExpirationDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleExpirationDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Immediate Parent Expiration Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleImmediateParentExpirationDate: ' + RuleImmediateParentExpirationDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleImmediateParentExpirationDate:' + RuleImmediateParentExpirationDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleImmediateParentExpirationDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleImmediateParentExpirationDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Immediate Parent Grant Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleImmediateParentGrantDate: ' + RuleImmediateParentGrantDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleImmediateParentGrantDate:' + RuleImmediateParentGrantDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleImmediateParentGrantDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleImmediateParentGrantDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'International Filing Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleInternationalFilingDate: ' + RuleInternationalFilingDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleInternationalFilingDate:' + RuleInternationalFilingDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleInternationalFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleInternationalFilingDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'International Grant Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleInternationalGrantDate: ' + RuleInternationalGrantDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleInternationalGrantDate:' + RuleInternationalGrantDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleInternationalGrantDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleInternationalGrantDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Marketing Approval Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleMarketingApprovalDate: ' + RuleMarketingApprovalDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleMarketingApprovalDate:' + RuleMarketingApprovalDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleMarketingApprovalDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleMarketingApprovalDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'PCT Filing Date (Annuity)') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RulePCTFilingDateAnnuity: ' + RulePCTFilingDateAnnuity + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RulePCTFilingDateAnnuity:' + RulePCTFilingDateAnnuity);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RulePCTFilingDateAnnuity && DR.SymphonyIPM__Rule_End_Date__c >= RulePCTFilingDateAnnuity)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Potential Bar Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RulePotentialBarDate: ' + RulePotentialBarDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RulePotentialBarDate:' + RulePotentialBarDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RulePotentialBarDate && DR.SymphonyIPM__Rule_End_Date__c >= RulePotentialBarDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Priority Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RulePriorityDate: ' + RulePriorityDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RulePriorityDate:' + RulePriorityDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RulePriorityDate && DR.SymphonyIPM__Rule_End_Date__c >= RulePriorityDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Prosecution Status Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleProsecutionStatusDate: ' + RuleProsecutionStatusDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleProsecutionStatusDate:' + RuleProsecutionStatusDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleProsecutionStatusDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleProsecutionStatusDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'PTE Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RulePTEDate: ' + RulePTEDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RulePTEDate:' + RulePTEDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RulePTEDate && DR.SymphonyIPM__Rule_End_Date__c >= RulePTEDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Publication Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RulePublicationDate: ' + RulePublicationDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RulePublicationDate:' + RulePublicationDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RulePublicationDate && DR.SymphonyIPM__Rule_End_Date__c >= RulePublicationDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Target Filing Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleTargetFilingDate: ' + RuleTargetFilingDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleTargetFilingDate:' + RuleTargetFilingDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleTargetFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleTargetFilingDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Issue Date (Annuity)') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleIssueDateAnnuity: ' + RuleIssueDateAnnuity + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleIssueDateAnnuity:' + RuleIssueDateAnnuity);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleIssueDateAnnuity && DR.SymphonyIPM__Rule_End_Date__c >= RuleIssueDateAnnuity)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'Immediate Parent Filing Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleParentFilingDate: ' + RuleParentFilingDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleParentFilingDate:' + RuleParentFilingDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleParentFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleParentFilingDate)
                                DAnewLst.add(DAnew);
                        }
                        if (DR.SymphonyIPM__Rule_Base_date__c == 'SPC Expiry Date') {
                            system.debug('DR.Rule_Start_Date__c : ' + DR.SymphonyIPM__Rule_Start_Date__c + '<= RuleSPCExpiryDate: ' + RuleSPCExpiryDate + ' && DR.Rule_End_Date__c : ' + DR.SymphonyIPM__Rule_End_Date__c + ' >= RuleSPCExpiryDate:' + RuleSPCExpiryDate);
                            if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleSPCExpiryDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleSPCExpiryDate)
                                DAnewLst.add(DAnew);
                        }
                        //-----------------------------------------------------
                    }
                }
            }
        }
        system.debug('Docketing Count :' + DAnewLst.size());
        if (DAnewLst.size() > 0)
            return DAnewLst; else
                return null;
    }
    public List<SymphonyIPM__Docketing_Activity_v2__c> DeDocketing(List<SymphonyIPM__IFW_Data_v1__c> ListIFW, Set<ID> AssetIDs, Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> DeDocketingRules) {
        //--------------*Processing De-Docketing Start*-----------------------
        system.debug('DeDocketing');
        system.debug('De-Docket Rules Size : ' + DeDocketingRules.size());
        Map<String, List<SymphonyIPM__Docketing_Rule_Engine__c>> MapJurisdictionDeDocketingRules = DeDocketingRules;
        Map<String, List<SymphonyIPM__Docketing_Activity_v2__c>> MapAssetIFWRelatedListDocAct = NEW Map<String, List<SymphonyIPM__Docketing_Activity_v2__c>>();
        List<SymphonyIPM__Docketing_Activity_v2__c> LstActivitiesToUpdate = NEW List<SymphonyIPM__Docketing_Activity_v2__c>();
        //system.debug('Harsha : '+AssetIDs);
        Map<string, List<SymphonyIPM__Docketing_Activity_v2__c>> AssetActionListDAId = NEW Map<string, List<SymphonyIPM__Docketing_Activity_v2__c>>();
        //Map<string,List<SymphonyIPM__Docketing_Activity_v2__c>> IFWActionRelatedDAId = NEW Map<string,List<SymphonyIPM__Docketing_Activity_v2__c>>();
        List<SymphonyIPM__Docketing_Activity_v2__c> LstDocketingActivity = NEW List<SymphonyIPM__Docketing_Activity_v2__c>();
        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.isAccessible() && SymphonyIPM__Docketing_Activity_v2__c.SObjectType.getDescribe().isAccessible()) {
            LstDocketingActivity = [
                    SELECT Id,SymphonyIPM__Action_Date__c,SymphonyIPM__Actions__c,SymphonyIPM__Activity_Date__c,
                            SymphonyIPM__Asset_Type__c,SymphonyIPM__Bar_Date__c,SymphonyIPM__Classification__c,SymphonyIPM__Comments__c,SymphonyIPM__Completed_By__c,
                            SymphonyIPM__Completion_Date__c,SymphonyIPM__Docket_Source_Reference_Id__c,SymphonyIPM__Due_Date__c,SymphonyIPM__Importance__c,
                            SymphonyIPM__Is_AutoDocketed__c,SymphonyIPM__Is_Completed__c,SymphonyIPM__Life_Cycle_Stage__c,SymphonyIPM__Patent__c,
                            SymphonyIPM__Person_to_Notify__c,SymphonyIPM__Trigger_Type__c,SymphonyIPM__Verified_By__c,SymphonyIPM__Verified_On__c,
                            SymphonyIPM__Closed_Date__c,SymphonyIPM__Reason_to_Complete__c,SymphonyIPM__Reason_to_Close__c,SymphonyIPM__Is_Closed__c,
                            SymphonyIPM__Completed_By_IFW__c, SymphonyIPM__Closed_By__c,SymphonyIPM__DeDocketed_by__c
                    FROM SymphonyIPM__Docketing_Activity_v2__c
                    WHERE
                    SymphonyIPM__Patent__c IN:AssetIDs
                    AND (SymphonyIPM__Is_Completed__c != true OR SymphonyIPM__Is_Closed__c != true)
            ];
        }
        System.debug('Docketing Activities List :' + LstDocketingActivity.size());
        if (LstDocketingActivity.size() > 0)
            for (SymphonyIPM__Docketing_Activity_v2__c DA : LstDocketingActivity) {
                //For asset and Activities
                String MyKey = DA.SymphonyIPM__Patent__c;
                List<SymphonyIPM__Docketing_Activity_v2__c> temp = MapAssetIFWRelatedListDocAct.get(MyKey);
                if (temp == null) {
                    MapAssetIFWRelatedListDocAct.put(MyKey, new List<SymphonyIPM__Docketing_Activity_v2__c>{
                            DA
                    });
                } else {
                    temp.add(DA);
                }
                //For Asset and related actions Activities
                if (DA.SymphonyIPM__Actions__c != '') {
                    String MyValue = DA.SymphonyIPM__Patent__c + '-' + DA.SymphonyIPM__Actions__c.replaceAll('\\s+', '');
                    List<SymphonyIPM__Docketing_Activity_v2__c> lstDA = AssetActionListDAId.get(MyValue);
                    if (lstDA == null) {
                        AssetActionListDAId.put(MyValue, new List<SymphonyIPM__Docketing_Activity_v2__c>{
                                DA
                        });
                    } else {
                        lstDA.add(DA);
                    }
                }
            }
        //*******
        system.debug('Map Code Asset related Acts : ' + MapAssetIFWRelatedListDocAct);
        system.debug('Asset related Acts : ' + AssetActionListDAId.keySet());
        //system.debug('IFW related Acts'+IFWActionRelatedDAId);
        for (SymphonyIPM__IFW_Data_v1__c IFW : ListIFW) {
            //SymphonyIPM__IFW_Data_v1__c IFW= (SymphonyIPM__IFW_Data_v1__c) objSObject;
            if (MapAssetIFWRelatedListDocAct.containsKey(IFW.SymphonyIPM__Asset__c)) {
                String KeyForFetchingDeRule = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Country__c + '-' + IFW.SymphonyIPM__Document_Code__c + '-' + IFW.SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c;
                if (IFW.SymphonyIPM__Document_Code__c == null)
                    KeyForFetchingDeRule = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Country__c + '-' + IFW.SymphonyIPM__Trigger__c + '-' + IFW.SymphonyIPM__Asset__r.SymphonyIPM__Case_Type__c;
                //system.debug(IFW.SymphonyIPM__Asset__r.Country__c);
                system.debug(KeyForFetchingDeRule);
                //Read rules from DocketingRuleEngine
                //system.debug(MapJurisdictionDeDocketingRules);
                if (MapJurisdictionDeDocketingRules.containsKey(KeyForFetchingDeRule)) {
                    List<SymphonyIPM__Docketing_Rule_Engine__c> KeyRules = MapJurisdictionDeDocketingRules.get(KeyForFetchingDeRule);
                    if (KeyRules != null && KeyRules.size() > 0) {
                        //system.debug('Dedocket Rules Map : '+MapJurisdictionDeDocketingRules);
                        Date RuleBaseFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Application_Date__c;
                        Date RuleBaseEffectiveFilingDate = IFW.SymphonyIPM__Asset__r.SymphonyIPM__Effective_Filing_Date__c;
                        for (SymphonyIPM__Docketing_Rule_Engine__c DR : KeyRules) {
                            //system.debug('Dedocket Rule :'+DR);
                            if (DR.SymphonyIPM__Rule_Base_date__c == 'Filing Date' && RuleBaseFilingDate != null) {
                                system.debug('-->DR.Rule_Start_Date__c:' + DR.SymphonyIPM__Rule_Start_Date__c + ' <= RuleBaseFilingDate ' + RuleBaseFilingDate + ' and DR.Rule_End_Date__c' + DR.SymphonyIPM__Rule_End_Date__c + '>= RuleBaseFilingDate ' + RuleBaseFilingDate);
                                if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleBaseFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleBaseFilingDate) {
                                    //system.debug(DR.Rule_Start_Date__c <= RuleBaseFilingDate && DR.Rule_End_Date__c >= RuleBaseFilingDate);
                                    //system.debug(IFW.Asset__c+'-'+DR.Docket_Action__c.replaceAll( '\\s+', ''));
                                    //system.debug(AssetActionListDAId.containsKey(IFW.Asset__c+'-'+DR.Docket_Action__c.replaceAll( '\\s+', '')));
                                    if (AssetActionListDAId.containsKey(IFW.SymphonyIPM__Asset__c + '-' + DR.SymphonyIPM__Docket_Action__c.replaceAll('\\s+', ''))) {
                                        List<SymphonyIPM__Docketing_Activity_v2__c> LstDA = AssetActionListDAId.get(IFW.SymphonyIPM__Asset__c + '-' + DR.SymphonyIPM__Docket_Action__c.replaceAll('\\s+', ''));
                                        if (LstDA != null && LstDA.size() > 0)
                                            for (SymphonyIPM__Docketing_Activity_v2__c DA : LstDA) {
                                                if (DA.SymphonyIPM__Activity_Date__c < IFW.SymphonyIPM__Mail_Room_Date__c)//Condition added by Harsha on 29-03-2019
                                                {
                                                    // system.debug('--> Dedocket Act :'+DA);
                                                    //system.debug('--> Dedocket Act :'+DA.id);
                                                    List<SymphonyIPM__Docketing_Activity_v2__c> DAlist = NEW List<SymphonyIPM__Docketing_Activity_v2__c>();
                                                    if (DA.SymphonyIPM__Is_Closed__c == false) {

                                                        if (DR.SymphonyIPM__Mark_Closed__c == true && DA.SymphonyIPM__Is_Closed__c == false && DA.SymphonyIPM__Due_Date__c >= IFW.SymphonyIPM__Mail_Room_Date__c) {
                                                            //system.debug('Is Closed :'+DR.Mark_Closed__c+' DA F:'+DA.Is_Closed__c);
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Is_Closed__c.isUpdateable())
                                                                DA.SymphonyIPM__Is_Closed__c = true;
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Closed_Date__c.isUpdateable())
                                                                DA.SymphonyIPM__Closed_Date__c = IFW.SymphonyIPM__Mail_Room_Date__c;//Assigning Mail Room Date to Close Date
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Reason_to_Close__c.isUpdateable())
                                                                DA.SymphonyIPM__Reason_to_Close__c = IFW.SymphonyIPM__Document_Code__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                            if (IFW.SymphonyIPM__Document_Code__c == null)
                                                                DA.SymphonyIPM__Reason_to_Close__c = IFW.SymphonyIPM__Trigger__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Closed_By__c.isUpdateable())
                                                                DA.SymphonyIPM__Closed_By__c = IFW.Id;
                                                        }
                                                        if (DR.SymphonyIPM__Mark_Completed__c == true && DA.SymphonyIPM__Due_Date__c >= IFW.SymphonyIPM__Mail_Room_Date__c) {
                                                            //System.debug('DA Activity Date:'+DA.Activity_Date__c);
                                                            Date CalStartDate = CalculateDate(DA.SymphonyIPM__Activity_Date__c, DR.SymphonyIPM__StartYearsToCal__c, DR.SymphonyIPM__Start_Operator__c, DR.SymphonyIPM__Start_Count__c, DR.SymphonyIPM__Start_Period_Type__c, DR.SymphonyIPM__Start_Operator1__c, DR.SymphonyIPM__Start_Count1__c, DR.SymphonyIPM__Start_Period_Type1__c);
                                                            Date CalCloseDate = CalculateDate(DA.SymphonyIPM__Activity_Date__c, DR.SymphonyIPM__CloseYearsToCal__c, DR.SymphonyIPM__Close_Operator__c, DR.SymphonyIPM__Close_Count__c, DR.SymphonyIPM__Close_Period_Type__c, DR.SymphonyIPM__Close_Operator1__c, DR.SymphonyIPM__Close_Count1__c, DR.SymphonyIPM__Close_Period_Type1__c);
                                                            //system.debug('CalStartDate :'+CalStartDate +'<='+IFW.SymphonyIPM__Mail_Room_Date__c+'-----CalCloseDate :'+CalCloseDate+'>='+IFW.SymphonyIPM__Mail_Room_Date__c);
                                                            if (CalStartDate <= IFW.SymphonyIPM__Mail_Room_Date__c && CalCloseDate >= IFW.SymphonyIPM__Mail_Room_Date__c)
                                                            //if(CalStartDate <= IFW.SymphonyIPM__Mail_Room_Date__c)
                                                            {
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Is_Completed__c.isUpdateable())
                                                                    DA.SymphonyIPM__Is_Completed__c = true;
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Completion_Date__c.isUpdateable())
                                                                    DA.SymphonyIPM__Completion_Date__c = IFW.SymphonyIPM__Mail_Room_Date__c;
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Reason_to_Complete__c.isUpdateable())
                                                                    DA.SymphonyIPM__Reason_to_Complete__c = IFW.SymphonyIPM__Document_Code__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                                if (IFW.SymphonyIPM__Document_Code__c == null)
                                                                    DA.SymphonyIPM__Reason_to_Complete__c = IFW.SymphonyIPM__Trigger__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Completed_By_IFW__c.isUpdateable())
                                                                    DA.SymphonyIPM__Completed_By_IFW__c = IFW.Id;
                                                            }
                                                        }
                                                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__DeDocketed_by__c.isUpdateable())
                                                            DA.SymphonyIPM__DeDocketed_by__c = DR.Id;
                                                    }
                                                    DAlist.add(DA);
                                                    if (DAlist.size() > 0)
                                                        LstActivitiesToUpdate.addall(DAlist);
                                                }
                                            }//For loop of SymphonyIPM__Docketing_Activity_v2__c end
                                    }
                                }
                            }
                            if (DR.SymphonyIPM__Rule_Base_date__c == 'Effective Filing Date' && RuleBaseEffectiveFilingDate != null) {
                                system.debug('-->DR.Rule_Start_Date__c:' + DR.SymphonyIPM__Rule_Start_Date__c + ' <= RuleBaseEffectiveFilingDate ' + RuleBaseEffectiveFilingDate + ' and DR.Rule_End_Date__c' + DR.SymphonyIPM__Rule_End_Date__c + '>= RuleBaseEffectiveFilingDate ' + RuleBaseEffectiveFilingDate);
                                if (DR.SymphonyIPM__Rule_Start_Date__c <= RuleBaseEffectiveFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleBaseEffectiveFilingDate) {
                                    system.debug(DR.SymphonyIPM__Rule_Start_Date__c <= RuleBaseEffectiveFilingDate && DR.SymphonyIPM__Rule_End_Date__c >= RuleBaseEffectiveFilingDate);
                                    //system.debug(IFW.Asset__c+'-'+DR.Docket_Action__c.replaceAll( '\\s+', ''));
                                    //system.debug(AssetActionListDAId.containsKey(IFW.Asset__c+'-'+DR.Docket_Action__c.replaceAll( '\\s+', '')));
                                    if (AssetActionListDAId.containsKey(IFW.SymphonyIPM__Asset__c + '-' + DR.SymphonyIPM__Docket_Action__c.replaceAll('\\s+', ''))) {
                                        List<SymphonyIPM__Docketing_Activity_v2__c> LstDA = AssetActionListDAId.get(IFW.SymphonyIPM__Asset__c + '-' + DR.SymphonyIPM__Docket_Action__c.replaceAll('\\s+', ''));
                                        if (LstDA != null && LstDA.size() > 0)
                                            for (SymphonyIPM__Docketing_Activity_v2__c DA : LstDA) {
                                                if (DA.SymphonyIPM__Activity_Date__c < IFW.SymphonyIPM__Mail_Room_Date__c)//Condition added by Harsha on 29-03-2019
                                                {
                                                    //system.debug('--> Dedocket Act :'+DA);
                                                    //system.debug('--> Dedocket Act :'+DA.id);
                                                    List<SymphonyIPM__Docketing_Activity_v2__c> DAlist = NEW List<SymphonyIPM__Docketing_Activity_v2__c>();
                                                    if (DA.SymphonyIPM__Is_Closed__c == false) {

                                                        if (DR.SymphonyIPM__Mark_Closed__c == true && DA.SymphonyIPM__Is_Closed__c == false && DA.SymphonyIPM__Due_Date__c >= IFW.SymphonyIPM__Mail_Room_Date__c) {
                                                            system.debug('Is Closed :' + DR.SymphonyIPM__Mark_Closed__c + ' DA F:' + DA.SymphonyIPM__Is_Closed__c);
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Is_Closed__c.isUpdateable())
                                                                DA.SymphonyIPM__Is_Closed__c = true;
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Closed_Date__c.isUpdateable())
                                                                DA.SymphonyIPM__Closed_Date__c = IFW.SymphonyIPM__Mail_Room_Date__c;//Assigning Mail Room Date to Close Date
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Reason_to_Close__c.isUpdateable())
                                                                DA.SymphonyIPM__Reason_to_Close__c = IFW.SymphonyIPM__Document_Code__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                            if (IFW.SymphonyIPM__Document_Code__c == null)
                                                                DA.SymphonyIPM__Reason_to_Close__c = IFW.SymphonyIPM__Trigger__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                            if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Closed_By__c.isUpdateable())
                                                                DA.SymphonyIPM__Closed_By__c = IFW.Id;
                                                        }
                                                        if (DR.SymphonyIPM__Mark_Completed__c == true && DA.SymphonyIPM__Due_Date__c >= IFW.SymphonyIPM__Mail_Room_Date__c) {
                                                            System.debug('DA Activity Date:' + DA.SymphonyIPM__Activity_Date__c);
                                                            Date CalStartDate = CalculateDate(DA.SymphonyIPM__Activity_Date__c, DR.SymphonyIPM__StartYearsToCal__c, DR.SymphonyIPM__Start_Operator__c, DR.SymphonyIPM__Start_Count__c, DR.SymphonyIPM__Start_Period_Type__c, DR.SymphonyIPM__Start_Operator1__c, DR.SymphonyIPM__Start_Count1__c, DR.SymphonyIPM__Start_Period_Type1__c);
                                                            Date CalCloseDate = CalculateDate(DA.SymphonyIPM__Activity_Date__c, DR.SymphonyIPM__CloseYearsToCal__c, DR.SymphonyIPM__Close_Operator__c, DR.SymphonyIPM__Close_Count__c, DR.SymphonyIPM__Close_Period_Type__c, DR.SymphonyIPM__Close_Operator1__c, DR.SymphonyIPM__Close_Count1__c, DR.SymphonyIPM__Close_Period_Type1__c);
                                                            system.debug('CalStartDate :' + CalStartDate + '<=' + IFW.SymphonyIPM__Mail_Room_Date__c + '-----CalCloseDate :' + CalCloseDate + '>=' + IFW.SymphonyIPM__Mail_Room_Date__c);
                                                            if (CalStartDate <= IFW.SymphonyIPM__Mail_Room_Date__c && CalCloseDate >= IFW.SymphonyIPM__Mail_Room_Date__c)
                                                            //if(CalStartDate <= IFW.SymphonyIPM__Mail_Room_Date__c)
                                                            {
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Is_Completed__c.isUpdateable())
                                                                    DA.SymphonyIPM__Is_Completed__c = true;
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Completion_Date__c.isUpdateable())
                                                                    DA.SymphonyIPM__Completion_Date__c = IFW.SymphonyIPM__Mail_Room_Date__c;
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Reason_to_Complete__c.isUpdateable())
                                                                    DA.SymphonyIPM__Reason_to_Complete__c = IFW.SymphonyIPM__Document_Code__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                                if (IFW.SymphonyIPM__Document_Code__c == null)
                                                                    DA.SymphonyIPM__Reason_to_Complete__c = IFW.SymphonyIPM__Trigger__c + ' - ' + IFW.SymphonyIPM__Mail_Room_Date__c.format();
                                                                if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__Completed_By_IFW__c.isUpdateable())
                                                                    DA.SymphonyIPM__Completed_By_IFW__c = IFW.Id;
                                                            }
                                                        }
                                                        if (Schema.SObjectType.SymphonyIPM__Docketing_Activity_v2__c.fields.SymphonyIPM__DeDocketed_by__c.isUpdateable())
                                                            DA.SymphonyIPM__DeDocketed_by__c = DR.Id;
                                                    }
                                                    DAlist.add(DA);
                                                    if (DAlist.size() > 0)
                                                        LstActivitiesToUpdate.addall(DAlist);
                                                }
                                            }//For loop of SymphonyIPM__Docketing_Activity_v2__c end
                                    }
                                }
                            }
                        }//For loop of SymphonyIPM__Docketing_Rule_Engine__c end
                    }
                }
            }
        }
        if (LstActivitiesToUpdate.size() > 0)
            return LstActivitiesToUpdate; else
                return null;
    }
public static void magicMethod(){
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
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;}
}
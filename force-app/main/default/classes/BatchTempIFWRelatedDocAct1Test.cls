@isTest
private class BatchTempIFWRelatedDocAct1Test
{
    static testMethod void positiveTesting()
    {
        DAReport__c dr = NEW DAReport__c();
        dr.ExecuteBatchInFinish__c = true;
        insert dr;
        //Need to comment below lines for v1.5 or lower
        /**************************/
        /*SymphonyIPM__AdminTriggerConfigSettings__c admc = NEW SymphonyIPM__AdminTriggerConfigSettings__c();
        admc.Name='Admin Trigger Config';
        admc.SymphonyIPM__Patent_Trigger__c = false;
        admc.SymphonyIPM__Docketing_Rules_Trigger__c= true;
        insert admc;
        
        SymphonyIPM__MPatent_PAIR_Analytics__mdt setting = new SymphonyIPM__MPatent_PAIR_Analytics__mdt();
        setting.MasterLabel = 'Prerequisite';
        setting.SymphonyIPM__All_IFW_code__c = 'NOA,RXNIRC,RXCERT,SE.CRT.SNQ.N,SE.CRT.SNQ.Y,';
        setting.SymphonyIPM__First_Allowance_IFW_Code__c ='NOA,RXNIRC,RXCERT,SE.CRT.SNQ.N';
        setting.SymphonyIPM__First_Action_IFW_code__c ='CTFR,CTNF,RXR.NF,RXFR..,CTRS,NOA';
        */
        /**************************/
        SymphonyIPM__Country__c country = new SymphonyIPM__Country__c(SymphonyIPM__Country_Id__c = 1, SymphonyIPM__Country_Code__c = 'US', Name = 'USA');
        insert country;
        System.AssertEquals(country.SymphonyIPM__Country_Code__c ,'US');
        
        List<SymphonyIPM__Docketing_Rule_Engine__c> dreLst = new List<SymphonyIPM__Docketing_Rule_Engine__c>();
        
        List<String> ruleBaseDateStr = new List<String>{'Effective Filing Date','Filing Date','Grant Date','Expiration Date','Next Renewal Date'};
            integer i = 0;
        string ucid = 'ruleBaseDateStr';
        for(String s : ruleBaseDateStr)   
            {
                SymphonyIPM__Docketing_Rule_Engine__c dre = NEW SymphonyIPM__Docketing_Rule_Engine__c();
                dre.SymphonyIPM__Asset_Type__c = 'Design';
                dre.SymphonyIPM__Base_Date_1__c =  'Mail Date';
                dre.SymphonyIPM__Base_Date__c = 'Mail Date';
                dre.SymphonyIPM__Case_Type__c = 'Primary';
                dre.SymphonyIPM__Classification__c = 'Action';
                dre.SymphonyIPM__Compound_Selection__c = 'Later Of';
                dre.SymphonyIPM__Docket_Action__c = 'Action';
                dre.SymphonyIPM__Importance__c = 'High';
                dre.SymphonyIPM__Jurisdiction__c = country.id;
                dre.SymphonyIPM__Life_Cycle_Stage__c = 'Application Filing';
                dre.Name = 'Test Rule'+s;
                dre.SymphonyIPM__Rule_Active__c = true;
                dre.SymphonyIPM__YearsToCal__c = 0.0;
                dre.SymphonyIPM__Operator__c = '+';
                dre.SymphonyIPM__Count__c = 0.0;
                dre.SymphonyIPM__Period_Type__c = 'Month(s)';
                dre.SymphonyIPM__Operator1__c = '+';
                dre.SymphonyIPM__Count1__c = 0.0;
                dre.SymphonyIPM__Period_Type1__c = 'Day(s)';
                dre.SymphonyIPM__Rule_Start_Date__c = date.newinstance(1995, 06, 08);
                dre.SymphonyIPM__Rule_End_Date__c = date.newinstance(2100, 12, 31);
                dre.SymphonyIPM__Rule_Base_date__c = s;
                dre.SymphonyIPM__Trigger_Type__c = 'Document Code';
                dre.SymphonyIPM__Trigger__c  = 'A...';
                dre.SymphonyIPM__Mark_Closed__c = false;
                dre.SymphonyIPM__Mark_Completed__c = false;
                dre.SymphonyIPM__Rule_Type__c = 'Docketing';
                dre.SymphonyIPM__StartYearsToCal__c = 0.0;
                dre.SymphonyIPM__Start_Operator__c = '+';
                dre.SymphonyIPM__Start_Count__c = 0.0;
                dre.SymphonyIPM__Start_Period_Type__c = 'Month(s)';
                dre.SymphonyIPM__Start_Operator1__c = '+';
                dre.SymphonyIPM__Start_Count1__c = 0.0;
                dre.SymphonyIPM__Start_Period_Type1__c = 'Day(s)';
                dre.SymphonyIPM__CloseYearsToCal__c = 0.0;
                dre.SymphonyIPM__Close_Operator__c = '+';
                dre.SymphonyIPM__Close_Count__c = 0.0;
                dre.SymphonyIPM__Close_Period_Type__c = 'Month(s)';
                dre.SymphonyIPM__Close_Operator1__c = '+';
                dre.SymphonyIPM__Close_Count1__c = 0.0;
                dre.SymphonyIPM__Close_Period_Type1__c = 'Day(s)';
                dre.SymphonyIPM__CYearsToCal__c = 0.0;
                dre.SymphonyIPM__COperator__c = '+';
                dre.SymphonyIPM__CCount__c = 0.0;
                dre.SymphonyIPM__CPeriod_Type__c = 'Month(s)';
                dre.SymphonyIPM__COperator1__c = '+';
                dre.SymphonyIPM__CCount1__c = 0.0;
                dre.SymphonyIPM__CPeriod_Type1__c = 'Day(s)';
                i= i+1;
                dre.Unique_ID__c = ucid+'-'+ i;
                dreLst.add(dre);    
            }
        insert dreLst;       
        
        SymphonyIPM__Patent__c asset = new SymphonyIPM__Patent__c(SymphonyIPM__Asset_Type__c = 'Design',SymphonyIPM__Country__c= country.id,SymphonyIPM__Adjusted_Expiration_Date__c=Date.newInstance(2011,01,01),
                                        SymphonyIPM__Patent_Number__c='US123123123',SymphonyIPM__Earliest_Publication_No__c='USD123123',
                                        SymphonyIPM__Application_Number__c = 'US12245686',SymphonyIPM__Title_of_Invention__c='mobile phone',
                                        SymphonyIPM__Application_Date__c=Date.Today(), SymphonyIPM__Country_Code__c = 'US',SymphonyIPM__Case_Type__c='Primary',
                                        SymphonyIPM__Allowance_Date__c = Date.newInstance(2011,01,01),SymphonyIPM__Earliest_Priority_Date__c = Date.newInstance(2011,01,01),
                                        SymphonyIPM__Estimated_Expiration_Date__c = Date.newInstance(2011,01,01),SymphonyIPM__Expiration_Date__c = Date.newInstance(2011,01,01),
                                        SymphonyIPM__Effective_Filing_Date__c = Date.Today(),SymphonyIPM__Immediate_Parent_Expiration_Date__c=Date.Today(),
                                        SymphonyIPM__Immediate_Parent_Grant_Date__c = Date.Today(),SymphonyIPM__International_Filing_Date__c =Date.Today(),
                                        SymphonyIPM__International_Grant_Date__c = Date.newInstance(2011,01,01),SymphonyIPM__Issue_Date_of_Patent__c = Date.newInstance(2011,01,01),
                                        SymphonyIPM__Marketing_Approval_Date__c = Date.newInstance(2011,01,01),SymphonyIPM__Annuities_PCTFiling_Date__c = Date.newInstance(2011,01,01),
                                        SymphonyIPM__Potential_Bar_Date__c = Date.newInstance(2011,01,01),SymphonyIPM__Priority_Date__c = Date.newInstance(2011,01,01),
                                        SymphonyIPM__Status_Date__c = Date.newInstance(2011,01,01),SymphonyIPM__PTE_Date__c = Date.newInstance(2011,01,01),SymphonyIPM__Earliest_Publication_Date__c= Date.newInstance(2011,01,01),
                                        SymphonyIPM__Target_Filing_Date__c= Date.newInstance(2011,01,01),SymphonyIPM__Annuities_Issue_Date_of_Patent__c= Date.newInstance(2011,01,01),
                                        SymphonyIPM__Parent_Filing_Date__c= Date.newInstance(2011,01,01),SymphonyIPM__SPC_Expiry_Date__c= Date.newInstance(2011,01,01));
        insert asset;
        SymphonyIPM__Patent__c p = [select id,SymphonyIPM__Asset_Type__c,SymphonyIPM__Case_Type__c from SymphonyIPM__Patent__c where id =: asset.id];
        system.debug('>> AssetType : '+p.SymphonyIPM__Asset_Type__c+' |Case Type:'+p.SymphonyIPM__Case_Type__c);
        SymphonyIPM__IFW_Data_v1__c IFW = NEW SymphonyIPM__IFW_Data_v1__c(SymphonyIPM__asset__c = asset.id,SymphonyIPM__Document_Code__c='A...',SymphonyIPM__Document_Description__c='Amendment/Req. Reconsideration-After Non-Final Reject',SymphonyIPM__Mail_Room_Date__c=Date.newInstance(2013, 3, 6));
        Insert IFW;
        List<id> lstIDSdre = NEW List<id>{IFW.id};
        SymphonyIPM__Docketing_Activity_v2__c newDockActivity = new SymphonyIPM__Docketing_Activity_v2__c(SymphonyIPM__Actions__c='Test Action', SymphonyIPM__Activity_Date__c = date.today(), 
                                                                                    SymphonyIPM__Closed_Date__c = date.today(), SymphonyIPM__Completion_Date__c = date.today(),
                                                                                    SymphonyIPM__Due_Date__c = date.today(), 
                                                                                    SymphonyIPM__Is_Closed__c = false, SymphonyIPM__Is_Completed__c = false, SymphonyIPM__Is_Zero_days_rule__c = false,
                                                                                    SymphonyIPM__Life_Cycle_Stage__c = 'Renewals', SymphonyIPM__Trigger__c = 'Filing Date',
                                                                                    SymphonyIPM__Trigger_Type__c = 'Date',  SymphonyIPM__Patent__c = asset.Id);
        insert newDockActivity; 
        
        //dre.AdjustmentType__c = 
        //dre.Adjust_to_a_Specific_Date__c = 
        //Patent
        //IFW
        
        //List<Id> lstIDSdre.String AssetTypedre.String TriggeType
        SymphonyIPM__IFW_Data_v1__c IFW1 = [select createddate from SymphonyIPM__IFW_Data_v1__c where id =: IFW.id Limit 1];
        delete newDockActivity;
        test.starttest();
        BatchTempIFWRelatedDocAct1 batchClass = NEW BatchTempIFWRelatedDocAct1(IFW1.createddate.addHours(-1),IFW1.createddate);
        DataBase.executeBatch(batchClass,1);
        BatchTempIFWRelatedDocAct1 batchClass1 = NEW BatchTempIFWRelatedDocAct1(true);
        DataBase.executeBatch(batchClass1,1);
        BatchTempIFWRelatedDocAct1 batchClass2 = NEW BatchTempIFWRelatedDocAct1(new list<id>{IFW1.id});
        DataBase.executeBatch(batchClass2,1);
        test.stoptest();
        List<SymphonyIPM__IFW_Data_v1__c> listIFW = NEW List<SymphonyIPM__IFW_Data_v1__c>{IFW};
            // batchClass.Docketing(listIFW);
            //Date Basedt, decimal yy, string operator,decimal count,string option, string operator1, decimal count1, string option1
            
        
        system.assertEquals('US123123123', asset.SymphonyIPM__Patent_Number__c);
    }
}
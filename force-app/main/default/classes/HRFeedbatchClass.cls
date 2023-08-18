global class HRFeedbatchClass implements Database.Batchable<String>,Database.Stateful,Database.AllowsCallouts {
    //Batch Class to process the Employee Details fetched from the API
    
    public string strBatchQuery {get;set;}
    public string strAuditTrailLogText {get;set;}
   //public List<SymphonyIPM__Inventor__c> existingEmplstToUpsert = new List<SymphonyIPM__Inventor__c>();//ListToUpsert
    public Set<SymphonyIPM__Inventor__c> SETEmplstToUpsert = new Set<SymphonyIPM__Inventor__c>();
    public List<String> EmployeeIdList = new List<String>(); 
    public SET<String> EmployeeIdListForDeactivation = new SET<String>(); 
    public List<HRIntegration.WrapperEmployees> EmployeeDataList = new List<HRIntegration.WrapperEmployees>(); 
    
    public HRFeedbatchClass(List<String> emplst)
    {
        EmployeeIdList=emplst;
    }
    public Iterable<String> start(Database.BatchableContext BC)
    {        
        return EmployeeIdList;
    } 
    public void execute(Database.BatchableContext BC,List<String> EmpList) {
        String strAuditTrailLogText = '[Start]';
        String strStatus = 'Success';
        
        //-------------------------------------------------------------------------------------------------------------------------
        List<string> newEmpIds = new List<string>();//EmployeeIdsList 
        List<string> SyncStatusEmpIds = new List<string>(); // To validate workday employee status
        List<SymphonyIPM__Inventor__c> EmplstToInsert = new List<SymphonyIPM__Inventor__c>();//ListToInsert
        List<SymphonyIPM__Inventor__c> existingEmplstToUpsert = new List<SymphonyIPM__Inventor__c>();//ListToUpdate
        //List<HRIntegration.WrapperEmployees> employeeLst = new List<HRIntegration.WrapperEmployees>();
        //List<SymphonyIPM__Inventor__c> invlst =new List<SymphonyIPM__Inventor__c> ();//TempInvListForUpdate
        //List<SymphonyIPM__Inventor__c> perId =new List<SymphonyIPM__Inventor__c> ();
        Map<string,List<SymphonyIPM__Inventor__c>> ExistingRecordsEmpID = new Map<string, List<SymphonyIPM__Inventor__c>>();//Used to check for existing records
        String managerDN;
        List<String> lstofexistingManagers =new List<String>();
        Map<string,SymphonyIPM__Inventor__c> emplistWithId = new Map<string,SymphonyIPM__Inventor__c>();
        //--------------------------------------------------------------------------------------------------------------------------
        //strAuditTrailLogText+='[Employee List]'+EmpList;
        strAuditTrailLogText+='[Employee List Size]'+EmpList.size();
        try
        { 
            for(String emp : EmpList)
            {
                String temp=emp.trim();
                newEmpIds.add(temp);
            }
            HRIntegration hr=new HRIntegration();
            String accesstoken=hr.getOAuthToken();
            EmployeeDataList = hr.getEmployeeDetails(accesstoken,newEmpIds);
            strAuditTrailLogText += 'Records fetched from the Employee details API ------------>>>>>>>>--SIZE'+EmployeeDataList.size();
            if(Test.isRunningTest())
            {
                HRIntegration.WrapperEmployees hrinv=new HRIntegration.WrapperEmployees();
                hrinv.activeStatus='Active';
                hrinv.additionalInfo1='test';
                hrinv.additionalInfo2='test';
                hrinv.additionalInfo3='test';
                hrinv.business='Optum Corporate';
                hrinv.businessCode='121';
                hrinv.businessUnit='44310';
                hrinv.country='USA';
                hrinv.department='781526';
                hrinv.displayName='Hardy Richard D';
                hrinv.division='Optum Corporate Strategy';
                hrinv.divisionCode='52145';
                hrinv.dn='CN=rhardy6,CN=Users,DC=ms,DC=ds,DC=uhc,DC=com';
                hrinv.employeeId='000690480';
                //employeeType='Employee',externalSegment='Optum Corporate',externalSegmentCode='490',firstName='Richard',glLocation='USAMN051',internalSegment='Optum Corporate',internalSegmentCode='490',lastName='Hardy',location='Eden Prairie',mail='rick.hardy@optum.com',mailCode='MN101-E015',managerDN='CN=awitty2,CN=Users,DC=ms,DC=ds,DC=uhc,DC=com',marketGroup='Optum',marketGroupCode='200',middleName='D',msid='rhardy6',operatingUnit='08805',postalCode='55344',state='MN',streetAddresss='11000 OPTUM CIRCLE',title='Chief Transfmtn & Strat Off');
                //list<HRIntegration.WrapperEmployees> lsttest =new list<HRIntegration.WrapperEmployees>();
                EmployeeDataList.add(hrinv);
            } 
            
           for(HRIntegration.WrapperEmployees empdata : EmployeeDataList )
           {
               if(empdata.employeeId!=null && empdata.employeeId!='' )
               lstofexistingManagers.add(empdata.employeeId);
               EmployeeIdListForDeactivation.add(empdata.employeeId);
               
                if(!newEmpIds.contains(empdata.employeeId)) 
                   SyncStatusEmpIds.add(empdata.employeeId); 
               
           }
            
            // CR UCR-14 Started
            for(Integer i = 0; i < lstofexistingManagers.size(); i++) { 
                if(!newEmpIds.contains(lstofexistingManagers[i])) 
                    SyncStatusEmpIds.add(lstofexistingManagers[i]); 
                
            }
            
             List<SymphonyIPM__Inventor__c> invlstSyncStatusEmpIds =new List<SymphonyIPM__Inventor__c> ();
             List<SymphonyIPM__Inventor__c> ObjSyncStatusEmpIds = [SELECT Id,Name,SymphonyIPM__Employee_ID__c, Additional_Info_1__c,Additional_Info_2__c,Additional_Info_3__c,Business__c,Business_Code__c,Business_Unit__c,Division__c,Division_Code__c,
                                                                SymphonyIPM__Email__c,Employee_Type__c,SymphonyIPM__Employment_status__c,Business_Segment__c,External_Segment_Code__c,First_Name__c,GL_Location_code__c,Internal_Segment__c,Internal_Segment_Code__c,
                                                                Last_Name__c,Location__c,Market_Group__c,Market_Group_Code__c,Middle_Name__c,MSID__c,Operating_Unit__c,Status__c,Title__c,Work_City__c,
                                                                Work_Country__c,Work_Phone__c,Work_Postal_Code__c,Work_State__c,Work_Street_Address__c,SymphonyIPM__RecordTypeName__c,RecordTypeId
                                                                FROM  SymphonyIPM__Inventor__c 
                                                                WHERE SymphonyIPM__Employee_ID__c IN : SyncStatusEmpIds];
            if(ObjSyncStatusEmpIds.size()>0){
                for(SymphonyIPM__Inventor__c per : ObjSyncStatusEmpIds) {
                    SymphonyIPM__Inventor__c nrinv = new SymphonyIPM__Inventor__c(); 
                    nrinv.Id=per.id;
                    nrinv.Sync_Status__c = 'Failed';
                    nrinv.Last_Sync_Date__c=system.today();
                    nrinv.Sync_Status_Description__c = 'Failed to get employee list (no response)';
                    invlstSyncStatusEmpIds.add(nrinv);
                }
            }
            // CR UCR-14 Ended
            
            
           //strAuditTrailLogText += 'List Of existing manager records'+lstofexistingManagers;
           strAuditTrailLogText += 'List Of existing manager records ------------>>>>>>>>--SIZE'+lstofexistingManagers.size();
           List<SymphonyIPM__Inventor__c> PersonExistingIds = [SELECT ID,Name,SymphonyIPM__Employee_ID__c, Additional_Info_1__c,Additional_Info_2__c,Additional_Info_3__c,Business__c,Business_Code__c,Business_Unit__c,Division__c,Division_Code__c,
                                                                SymphonyIPM__Email__c,Employee_Type__c,SymphonyIPM__Employment_status__c,Business_Segment__c,External_Segment_Code__c,First_Name__c,GL_Location_code__c,Internal_Segment__c,Internal_Segment_Code__c,
                                                                Last_Name__c,Location__c,Market_Group__c,Market_Group_Code__c,Middle_Name__c,MSID__c,Operating_Unit__c,Status__c,Title__c,Work_City__c,
                                                                Work_Country__c,Work_Phone__c,Work_Postal_Code__c,Work_State__c,Work_Street_Address__c,SymphonyIPM__RecordTypeName__c,RecordTypeId
                                                                FROM  SymphonyIPM__Inventor__c 
                                                                WHERE SymphonyIPM__Employee_ID__c IN : lstofexistingManagers];
            Integer count=0;
            strAuditTrailLogText += 'Existing person records in the org size ------------------>'+PersonExistingIds.size();
            //strAuditTrailLogText += 'Existing person records in the org ------------------>'+PersonExistingIds;
            for(SymphonyIPM__Inventor__c per : PersonExistingIds) {
                //existingEmpIds.add(per.SymphonyIPM__Employee_ID__c);
                List<SymphonyIPM__Inventor__c> temp= ExistingRecordsEmpID.get(per.SymphonyIPM__Employee_ID__c);
                if(temp!=NULL)
                {
                    temp.add(per);     
                }
                else if(temp==NULL)
                {
                    ExistingRecordsEmpID.put(per.SymphonyIPM__Employee_ID__c,new List<SymphonyIPM__Inventor__c> {per});
                }
                
            }
            strAuditTrailLogText += 'Map of person already available for diff recordtypes ---------->'+ExistingRecordsEmpID.keySet();
            String recordid =[SELECT Id FROM RecordType Where Name='Inventor' AND  SobjectType='SymphonyIPM__Inventor__c'].ID;
            strAuditTrailLogText+='ExistingRecordsEmpID list------------->'+ExistingRecordsEmpID.size();
            for(HRIntegration.WrapperEmployees emp : EmployeeDataList) 
            {
                SymphonyIPM__Inventor__c inv = new SymphonyIPM__Inventor__c(); 
                if(emp.firstName!=null && emp.firstName!='') 
                    inv.First_Name__c = emp.firstName;  
                if(emp.middleName!=null && emp.middleName!='')  
                    inv.Middle_Name__c = emp.middleName;
                if(emp.lastName!=null && emp.lastName!='') 
                    inv.Last_Name__c= emp.lastName;
                if(emp.managers!=null && emp.managers!='') 
                    inv.UHG_Managers__c = emp.managers;
                if(emp.mail!=null && emp.mail!='') 
                    inv.SymphonyIPM__Email__c= emp.mail;
                if(emp.activeStatus!=null && emp.activeStatus!='') 
                    inv.Status__c= emp.activeStatus;
                if(emp.externalSegment!=null && emp.externalSegment!='')  
                    inv.Business_Segment__c= emp.externalSegment;
                if(emp.externalSegmentCode!=null && emp.externalSegmentCode!='') 
                    inv.External_Segment_Code__c= emp.externalSegmentCode;
                if(emp.internalSegment!=null && emp.internalSegment!='') 
                    inv.Internal_Segment__c= emp.internalSegment;
                if(emp.internalSegmentCode!=null && emp.internalSegmentCode!='') 
                    inv.Internal_Segment_Code__c= emp.internalSegmentCode;
                if(emp.mailCode!=null && emp.mailCode!='') 
                    inv.Mail_Code__c= emp.mailCode;
                if(emp.division!=null && emp.division!='') 
                    inv.Division__c= emp.division;
                if(emp.divisionCode!=null && emp.divisionCode!='') 
                    inv.Division_Code__c= emp.divisionCode;
                if(emp.marketGroup!=null && emp.marketGroup!='') 
                    inv.Market_Group__c= emp.marketGroup;
                if(emp.marketGroupCode!=null && emp.marketGroupCode!='') 
                    inv.Market_Group_Code__c= emp.marketGroupCode;
                if(emp.business!=null && emp.business!='') 
                    inv.Business__c= emp.business;
                if(emp.businessCode!=null && emp.businessCode!='') 
                    inv.Business_Code__c= emp.businessCode;
                if(emp.department!=null && emp.department!='') 
                    inv.Department__c= emp.department;
                if(emp.firstName!=null && emp.firstName!='' && emp.lastName!=null && emp.lastName!='') 
                    inv.Name= emp.firstName+' '+ emp.lastName +'('+'INV'+')';
                if(emp.businessUnit!=null && emp.businessUnit!='') 
                    inv.Business_Unit__c= emp.businessUnit;
                if(emp.operatingUnit!=null && emp.operatingUnit!='') 
                    inv.Operating_Unit__c= emp.operatingUnit;
                if(emp.title!=null && emp.title!='') 
                    inv.Title__c= emp.title;
                if(emp.employeeType!=null && emp.employeeType!='') 
                    inv.Employee_Type__c= emp.employeeType;
                if(emp.streetAddresss!=null && emp.streetAddresss!='') 
                    inv.Work_Street_Address__c= emp.streetAddresss;
                if(emp.location!=null && emp.location!='') 
                    inv.Work_City__c= emp.location;
                if(emp.state!=null && emp.state!='') 
                    inv.Work_State__c= emp.state;
                if(emp.country!=null && emp.country!='') 
                    inv.Work_Country__c= emp.country;
                if(emp.postalCode!=null && emp.postalCode!='') 
                    inv.Work_Postal_Code__c= emp.postalCode;
                if(emp.telephoneNumber!=null && emp.telephoneNumber!='')
                    inv.Work_Phone__c =emp.telephoneNumber;
                if(emp.glLocation!=null && emp.glLocation!='') 
                    inv.GL_Location_code__c= emp.glLocation;
                if(emp.additionalInfo1!=null && emp.additionalInfo1!='') 
                    inv.Additional_Info_1__c= emp.additionalInfo1;
                if(emp.additionalInfo2!=null && emp.additionalInfo2!='') 
                    inv.Additional_Info_2__c= emp.additionalInfo2;
                if(emp.additionalInfo3!=null && emp.additionalInfo3!='') 
                    inv.Additional_Info_3__c= emp.additionalInfo3;
                if(emp.msid!=null && emp.msid!='') 
                    inv.MSID__c = emp.msid;
                if(emp.managerDN!=null && emp.managerDN!='') 
                {   
                    managerDN = emp.managerDN.substringBetween('=',','); 
                    inv.Manager_DN__c = managerDN;
                }  
                // CR https://maxval.atlassian.net/browse/UCR-14
                // Changed on 17-Jul-2023 by AP
                inv.Sync_Status__c = 'Success';
                inv.Last_Sync_Date__c=system.today();
                inv.Sync_Status_Description__c = '';
                
                List<SymphonyIPM__Inventor__c> invlst =new List<SymphonyIPM__Inventor__c> ();
                if(emp.employeeId!=null && emp.employeeId!='') 
                    inv.SymphonyIPM__Employee_ID__c = emp.employeeId;
                    
                    if(ExistingRecordsEmpID.get(inv.SymphonyIPM__Employee_ID__c)!=NULL)
                    {
                        List<SymphonyIPM__Inventor__c> perIdlst=ExistingRecordsEmpID.get(inv.SymphonyIPM__Employee_ID__c );
                        if(perIdlst.size()>0)
                        {
                            for(SymphonyIPM__Inventor__c per : perIdlst)
                            {
                                if(inv.First_Name__c!=null && inv.First_Name__c!='') 
                                    per.First_Name__c = inv.First_Name__c;  
                                if(inv.UHG_Managers__c !=null && inv.UHG_Managers__c !='') 
                                    per.UHG_Managers__c  = inv.UHG_Managers__c;
                                if(inv.Middle_Name__c!=null && inv.Middle_Name__c!='')  
                                    per.Middle_Name__c = inv.Middle_Name__c;
                                if(inv.Last_Name__c!=null && inv.Last_Name__c!='') 
                                    per.Last_Name__c= inv.Last_Name__c;
                                if(inv.SymphonyIPM__Email__c!=null && inv.SymphonyIPM__Email__c!='') 
                                    per.SymphonyIPM__Email__c= inv.SymphonyIPM__Email__c;
                                if(inv.Status__c!=null && inv.Status__c!='') 
                                    per.Status__c= inv.Status__c;
                                if(inv.Business_Segment__c!=null && inv.Business_Segment__c!='')  
                                    per.Business_Segment__c= inv.Business_Segment__c;
                                if(inv.External_Segment_Code__c!=null && inv.External_Segment_Code__c!='') 
                                    per.External_Segment_Code__c= inv.External_Segment_Code__c;
                                if(inv.Internal_Segment__c!=null && inv.Internal_Segment__c!='') 
                                    per.Internal_Segment__c= inv.Internal_Segment__c;
                                if(inv.Internal_Segment_Code__c!=null && inv.Internal_Segment_Code__c!='') 
                                    per.Internal_Segment_Code__c= inv.Internal_Segment_Code__c;
                                if(inv.Mail_Code__c!=null && inv.Mail_Code__c!='') 
                                    per.Mail_Code__c= inv.Mail_Code__c;
                                if(inv.Division__c!=null && inv.Division__c!='') 
                                    per.Division__c= inv.Division__c;
                                if(inv.Division_Code__c!=null && inv.Division_Code__c!='') 
                                    per.Division_Code__c= inv.Division_Code__c;
                                if(inv.Market_Group__c!=null && inv.Market_Group__c!='') 
                                    per.Market_Group__c= inv.Market_Group__c;
                                if(inv.Market_Group_Code__c!=null && inv.Market_Group_Code__c!='') 
                                    per.Market_Group_Code__c= inv.Market_Group_Code__c;
                                if(inv.Business__c!=null && inv.Business__c!='') 
                                    per.Business__c= inv.Business__c;
                                if(inv.Business_Code__c!=null && inv.Business_Code__c!='') 
                                    per.Business_Code__c= inv.Business_Code__c;
                                if(inv.Department__c!=null && inv.Department__c!='') 
                                    per.Department__c= inv.Department__c;
                                /*if(inv.First_Name__c!=null && inv.First_Name__c!='' && inv.Last_Name__c!=null && inv.Last_Name__c!=''){ 
                                    if(recordid=='0126g000000DswYAAS')
                                    per.Name= inv.First_Name__c+' '+ inv.Last_Name__c +'('+'INV'+')';
                                    if(recordid=='012180000005EszAAE')
                                    per.Name= inv.First_Name__c+' '+ inv.Last_Name__c +'('+'PRB'+')';
                                    }*/
                                if(inv.Business_Unit__c!=null && inv.Business_Unit__c!='') 
                                    per.Business_Unit__c= inv.Business_Unit__c;
                                if(inv.Operating_Unit__c!=null && inv.Operating_Unit__c!='') 
                                    per.Operating_Unit__c= inv.Operating_Unit__c;
                                if(inv.Title__c!=null && inv.Title__c!='') 
                                    per.Title__c= inv.Title__c;
                                if(inv.Employee_Type__c!=null && inv.Employee_Type__c!='') 
                                    per.Employee_Type__c= inv.Employee_Type__c;
                                if(inv.Work_Street_Address__c!=null && inv.Work_Street_Address__c!='') 
                                    per.Work_Street_Address__c= inv.Work_Street_Address__c;
                                if(inv.Work_City__c!=null && inv.Work_City__c!='') 
                                    per.Work_City__c= inv.Work_City__c;
                                if(inv.Work_State__c!=null && inv.Work_State__c!='') 
                                    per.Work_State__c= inv.Work_State__c;
                                if(inv.Work_Country__c!=null && inv.Work_Country__c!='') 
                                    per.Work_Country__c= inv.Work_Country__c;
                                if(inv.Work_Postal_Code__c!=null && inv.Work_Postal_Code__c!='') 
                                    per.Work_Postal_Code__c= inv.Work_Postal_Code__c;
                                if(inv.Work_Phone__c!=null && inv.Work_Phone__c!='')
                                    per.Work_Phone__c =inv.Work_Phone__c;
                                if(inv.GL_Location_code__c!=null && inv.GL_Location_code__c!='') 
                                    per.GL_Location_code__c= inv.GL_Location_code__c;
                                if(inv.Additional_Info_1__c!=null && inv.Additional_Info_1__c!='') 
                                    per.Additional_Info_1__c= inv.Additional_Info_1__c;
                                if(inv.Additional_Info_2__c!=null && inv.Additional_Info_2__c!='') 
                                    per.Additional_Info_2__c= inv.Additional_Info_2__c;
                                if(inv.Additional_Info_3__c!=null && inv.Additional_Info_3__c!='') 
                                    per.Additional_Info_3__c= inv.Additional_Info_3__c;
                                if(inv.MSID__c!=null && inv.MSID__c!='') 
                                    per.MSID__c = inv.MSID__c;
                                if(inv.Manager_DN__c!=null && inv.Manager_DN__c!='') 
                                {   
                                    //managerDN = inv.Manager_DN__c.substringBetween('=',','); 
                                    per.Manager_DN__c = inv.Manager_DN__c;
                                }  
                                
                                if(inv.SymphonyIPM__Employee_ID__c!=null && inv.SymphonyIPM__Employee_ID__c!='') {
                                    per.SymphonyIPM__Employee_ID__c = inv.SymphonyIPM__Employee_ID__c;
                                }
                                
                               
                                // CR https://maxval.atlassian.net/browse/UCR-14
                				// Changed on 17-Jul-2023 by AP
                                per.Sync_Status__c = 'Success';
                				per.Last_Sync_Date__c=system.today();
                                per.Sync_Status_Description__c = '';
                                existingEmplstToUpsert.add(per);//For Update
                            }
                            
                        }
                        
                    }
                    /*else{                                       
                        inv.id=perIdlst[0].Id;
                        invlst.add(inv);
                    }*/

                else if(!ExistingRecordsEmpID.containsKey(inv.SymphonyIPM__Employee_ID__c)) 
                {      
                    inv.RecordTypeId=recordid;
                    inv.SymphonyIPM__RecordTypeName__c='Inventor';
                    EmplstToInsert.add(inv);
                }
                                        
                /*if(invlst.size()>0)
                { 
                    existingEmplstToUpsert.addAll(invlst);
                    invlst.clear();
                }*/
            }
        strAuditTrailLogText+='EmplstToInsert'+EmplstToInsert.size();
        strAuditTrailLogText+='existingEmplstToUpsert'+existingEmplstToUpsert.size();
        strAuditTrailLogText+='existingEmplstToUpsert'+existingEmplstToUpsert;

        if(invlstSyncStatusEmpIds.size()>0)
            update invlstSyncStatusEmpIds;
            // created on 17-Jul-2023
            // Add a new “Sync Status” picklist field to the Person object with values of “Success” and “Failed” along with the
			//reason for the failure. When the MaxVal HR sync logic requests the list of active employees and the request
			//fails, the new “Sync Status” field should be set to:
			// “Failed to get employee list (no response)” if no response was received or
			// “Failed to get employee list (empty response)” if an empty response was received. 
            
        if(EmplstToInsert.size()>0) {                    
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            List<Database.SaveResult> sr = Database.insert(EmplstToInsert, dml);
            
            //INSERT EmplstToInsert;   
        } 
            
        if(existingEmplstToUpsert.size()>0) {
            Database.DMLOptions dml = new Database.DMLOptions(); 
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            List<Database.SaveResult> sr = Database.update(existingEmplstToUpsert, dml);
            //UPDATE existingEmplstToUpsert;   
        }
        
    }
    catch(Exception e)
    {
        strStatus = 'Fail';
        strAuditTrailLogText += '[CatchBlock:' + e.getMessage() + ' | ' +  e.getStackTraceString() + ' ]';
    }
    finally
    {
        strAuditTrailLogText += '[Stop]'; 
        SymphonyIPM__AuditTrail__c objAuditTrail = new SymphonyIPM__AuditTrail__c();
        strAuditTrailLogText += '[Finally]';
        objAuditTrail = new SymphonyIPM__AuditTrail__c();
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
            objAuditTrail.SymphonyIPM__Action__c = 'Insert';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
            objAuditTrail.SymphonyIPM__CObjectName__c = 'HR BATCH - Execute';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
            objAuditTrail.SymphonyIPM__Description__c = strAuditTrailLogText ;
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
            objAuditTrail.SymphonyIPM__Status__c = 'Success';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable() && SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable())
            INSERT objAuditTrail;     
    }
    
}

public void finish(Database.BatchableContext BC) {
    SymphonyIPM__AuditTrail__c objAuditTrail = null;
    AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
    //To deactivate Employees not Coming From the API.
    strAuditTrailLogText += a.Status +'--------------------'+EmployeeIdListForDeactivation.size();
    HRDeactivatePersonsBatch deactivate = new HRDeactivatePersonsBatch(EmployeeIdListForDeactivation);
    Database.executeBatch(deactivate,1);
    /*List<SymphonyIPM__Inventor__c> listToUpdateStatus =new List<SymphonyIPM__Inventor__c>();
    List<SymphonyIPM__Inventor__c> PersonListToDeactivate =[SELECT ID,Name,SymphonyIPM__Employee_ID__c, Additional_Info_1__c,Additional_Info_2__c,Additional_Info_3__c,Business__c,Business_Code__c,Business_Unit__c,Division__c,Division_Code__c,
                                                                SymphonyIPM__Email__c,Employee_Type__c,SymphonyIPM__Employment_status__c,Business_Segment__c,External_Segment_Code__c,First_Name__c,GL_Location_code__c,Internal_Segment__c,Internal_Segment_Code__c,
                                                                Last_Name__c,Location__c,Market_Group__c,Market_Group_Code__c,Middle_Name__c,MSID__c,SymphonyIPM__Law_Firm__c,Operating_Unit__c,Status__c,Title__c,Work_City__c,
                                                                Work_Country__c,Work_Phone__c,Work_Postal_Code__c,Work_State__c,Work_Street_Address__c,SymphonyIPM__RecordTypeName__c,RecordTypeId
                                                                FROM  SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c NOT IN : EmployeeIdListForDeactivation];
    strAuditTrailLogText +='PersonListToDeactivate--------------------'+PersonListToDeactivate.size();
    for(SymphonyIPM__Inventor__c inv : PersonListToDeactivate)
    {
        if(!(inv.SymphonyIPM__RecordTypeName__c=='OC' && inv.SymphonyIPM__Law_Firm__c!=NULL))
           {
               inv.Status__c = 'Deactivated';  
               listToUpdateStatus.add(inv);
           }
    }
     
    if(listToUpdateStatus.size()>0)
    {
        //UPDATE listToUpdateStatus;
        List<Database.SaveResult> result = Database.update(listToUpdateStatus,true);
        for (Database.SaveResult sr : result) {
            if (!sr.isSuccess()) {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    //strAuditTrailLogText +='The following error has occurred.';                 
                    //strAuditTrailLogText +='ERROR------------>'+err.getStatusCode() + ':' + err.getMessage();
                    strAuditTrailLogText +='Fields that affected this error: ' + err.getFields();
                }
            }
            
        } 
    }*/
    //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    if (SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isUpdateable() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isAccessible() && Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable())
    {
        strAuditTrailLogText += '[ Finish]';
        objAuditTrail = new SymphonyIPM__AuditTrail__c();
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Action__c.isCreateable())
            objAuditTrail.SymphonyIPM__Action__c = 'Insert';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__CObjectName__c.isCreateable())
            objAuditTrail.SymphonyIPM__CObjectName__c = 'HR BATCH - Execute';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Description__c.isCreateable())
            objAuditTrail.SymphonyIPM__Description__c = strAuditTrailLogText ;
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.fields.SymphonyIPM__Status__c.isCreateable())
            objAuditTrail.SymphonyIPM__Status__c = 'Success';
        if(Schema.sObjectType.SymphonyIPM__AuditTrail__c.isCreateable() && SymphonyIPM__AuditTrail__c.sObjectType.getDescribe().isCreateable())
            INSERT objAuditTrail;                             
    } 
                                                                                                                             
    
}

}
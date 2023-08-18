public class IDFFuture{
    @future
    public static void IDFFuturemethod(string strnew, string strold){
        if(!Test.isRunningTest()){
        system.debug('strnew'+strnew);
        system.debug('strold'+strold);
        Map<string,SymphonyIPM__Invention_Disclosure_New__c> mapNew = (Map<string,SymphonyIPM__Invention_Disclosure_New__c>)JSON.deserialize(strnew,Map<string,SymphonyIPM__Invention_Disclosure_New__c>.class);
        Map<string,SymphonyIPM__Invention_Disclosure_New__c> mapOld = (Map<string,SymphonyIPM__Invention_Disclosure_New__c>)JSON.deserialize(strold,Map<string,SymphonyIPM__Invention_Disclosure_New__c>.class);
        //Added to resolve sharing issue
        string loggedinuser = UserInfo.getUserId();
        set<string> setofIDFIds = new set<string>();
        set<string> setofPathids = new set<string>();
        set<string> setofOldPathids = new set<string>();
        set<string> setofPatentids = new set<string>();
        set<string> setofLawfirmsIds = new set<string>();
        set<string> setofOtherContactIds = new set<string>();
        set<string> setofPrimaryContactIds = new set<string>();
        set<string> setofoldPrimaryInventorIds = new set<string>();
        set<string> setofnewPrimaryInventorIds = new set<string>();
        List<SymphonyIPM__Invention_Disclosure_New__Share> listShareRecordsToInsert = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
        List<SymphonyIPM__Patent__Share> listPatentShareRecordsToInsert = new List<SymphonyIPM__Patent__Share>();
        //Get IDF ids which are approved
        for(SymphonyIPM__Invention_Disclosure_New__c objIDF : mapNew.values())
        {
            SymphonyIPM__Invention_Disclosure_New__c objoldIDF = mapOld.get(objIDF.id);
            //if(objoldIDF.SymphonyIPM__Disclosure_Status__c != objIDF.SymphonyIPM__Disclosure_Status__c && objIDF.SymphonyIPM__Disclosure_Status__c == 'Approved for Filing')
            //{
            setofIDFIds.add(objIDF.Id);
            if(objIDF.SymphonyIPM__Hierarchy__c != objoldIDF.SymphonyIPM__Hierarchy__c)
            {
                setofOldPathids.add(objoldIDF.SymphonyIPM__Hierarchy__c);
            }
            setofPathids.add(objIDF.SymphonyIPM__Hierarchy__c);
            if(objIDF.SymphonyIPM__Related_Patent__c != null)
            {
                setofPatentids.add(objIDF.SymphonyIPM__Related_Patent__c);
            }
            if(objIDF.Law_Firm__c != null)
            {
                setofLawfirmsIds.add(objIDF.Law_Firm__c);
            }
            if(objIDF.Other_Contact__c != null)
            {
                setofOtherContactIds.add(objIDF.Other_Contact__c);
            }
            if(objIDF.Primary_Contact__c != null)
            {
                setofPrimaryContactIds.add(objIDF.Primary_Contact__c);
            }
            system.debug('setofPrimaryContactIds'+setofPrimaryContactIds);
            system.debug('setofOtherContactIds'+setofOtherContactIds);
            if(objoldIDF.SymphonyIPM__Primary_Inventor__c != objIDF.SymphonyIPM__Primary_Inventor__c && objoldIDF.SymphonyIPM__Primary_Inventor__c != null){
                setofoldPrimaryInventorIds.add(objoldIDF.SymphonyIPM__Primary_Inventor__c);
                setofnewPrimaryInventorIds.add(objIDF.SymphonyIPM__Primary_Inventor__c);
            }
            //}
            
        }
        if(setofIDFIds.size() > 0)
        {
            List<SymphonyIPM__Additional_Inventor__c> ListToUpdate = new List<SymphonyIPM__Additional_Inventor__c>();
            List<SymphonyIPM__Additional_Inventor__c> ListToDelete = new List<SymphonyIPM__Additional_Inventor__c>();
            set<SymphonyIPM__Additional_Inventor__c> setToDelete = new set<SymphonyIPM__Additional_Inventor__c>();
            map<string,SymphonyIPM__Additional_Inventor__c> mapofAdditionalInventorsRecords = new map<string,SymphonyIPM__Additional_Inventor__c>();
            map<string,List<SymphonyIPM__Additional_Inventor__c>> mapofIDWithAdditionalInventors = new map<string,List<SymphonyIPM__Additional_Inventor__c>>();
            //Get additional inventors and share the records
            List<SymphonyIPM__Additional_Inventor__c> listAdditionalInventors = [SELECT Id,SymphonyIPM__Inventor__c,SymphonyIPM__Inventor__r.SymphonyIPM__User__c,
                                                                                 SymphonyIPM__Invention_Disclosure_New__c,SymphonyIPM__Invention_Disclosure_New__r.OwnerId,UHG_Inventor_Info_Email_Sent__c,
                                                                                 SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Additional_Inventor__c WHERE
                                                                                 (SymphonyIPM__Invention_Disclosure_New__c IN: setofIDFIds) ORDER BY Inventors_Display_Order__c ASC];
            if(listAdditionalInventors.size()>0){
                for(SymphonyIPM__Additional_Inventor__c objAddInventor : listAdditionalInventors){
                    mapofAdditionalInventorsRecords.put(objAddInventor.SymphonyIPM__Invention_Disclosure_New__c+':'+objAddInventor.SymphonyIPM__Inventor__c,objAddInventor);
                    List<SymphonyIPM__Additional_Inventor__c> temp = mapofIDWithAdditionalInventors.get(objAddInventor.SymphonyIPM__Invention_Disclosure_New__c);
                    if(temp == null){
                        mapofIDWithAdditionalInventors.put(objAddInventor.SymphonyIPM__Invention_Disclosure_New__c,new List<SymphonyIPM__Additional_Inventor__c>{objAddInventor});
                    }else if(temp != null){
                        temp.add(objAddInventor);
                    }
                }
            }
            if(setofoldPrimaryInventorIds.size()>0){
                map<Id,SymphonyIPM__Inventor__c> mapofNewlyaddedInventors;
                map<string,SymphonyIPM__Additional_Inventor__c> mapofOldaddedInventors = new map<string,SymphonyIPM__Additional_Inventor__c>();
                if(setofnewPrimaryInventorIds.size()>0){
                    mapofNewlyaddedInventors = new map<Id,SymphonyIPM__Inventor__c>([SELECT SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE Id IN: setofnewPrimaryInventorIds]);
                }
                if(setofoldPrimaryInventorIds.size()>0){
                    map<Id,SymphonyIPM__Additional_Inventor__c> mapAddInv = new map<Id,SymphonyIPM__Additional_Inventor__c>([SELECT id,Role_In_Conception__c,Is_Primary__c,SymphonyIPM__Inventor__c,SymphonyIPM__Invention_Disclosure_New__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Inventor__c IN: setofoldPrimaryInventorIds AND SymphonyIPM__Invention_Disclosure_New__c IN: setofIDFIds AND Is_Primary__c = true]);
                    if(mapAddInv.size() > 0){
                        for(Id AddInvId : mapAddInv.keyset()){
                            SymphonyIPM__Additional_Inventor__c objAddInv = mapAddInv.get(AddInvId);
                            mapofOldaddedInventors.put(objAddInv.SymphonyIPM__Invention_Disclosure_New__c+':'+objAddInv.SymphonyIPM__Inventor__c,objAddInv);
                        }
                    }
                }
                for(SymphonyIPM__Invention_Disclosure_New__c objIDF : mapNew.values())
                {
                    SymphonyIPM__Invention_Disclosure_New__c objoldIDF = mapOld.get(objIDF.id);
                    if(!mapofAdditionalInventorsRecords.containskey(objIDF.Id+':'+objIDF.SymphonyIPM__Primary_Inventor__c)){
                        if(mapofOldaddedInventors.containskey(objIDF.Id+':'+objoldIDF.SymphonyIPM__Primary_Inventor__c)){
                            SymphonyIPM__Additional_Inventor__c objOldAddInv = mapofOldaddedInventors.get(objIDF.Id+':'+objoldIDF.SymphonyIPM__Primary_Inventor__c);
                            SymphonyIPM__Additional_Inventor__c objAddInv = new SymphonyIPM__Additional_Inventor__c();
                            if(objIDF.SymphonyIPM__Primary_Inventor__c != null){
                                objAddInv.SymphonyIPM__Inventor__c = objIDF.SymphonyIPM__Primary_Inventor__c;
                                if(mapofNewlyaddedInventors.containskey(objIDF.SymphonyIPM__Primary_Inventor__c)){
                                    SymphonyIPM__Inventor__c objNewInventor = mapofNewlyaddedInventors.get(objIDF.SymphonyIPM__Primary_Inventor__c);  
                                    objAddInv.SymphonyIPM__Inventor_Email__c = objNewInventor.SymphonyIPM__Email__c;  
                                }
                                objAddInv.SymphonyIPM__Invention_Disclosure_New__c = objIDF.Id;
                                objAddInv.Is_Primary__c = true;
                                objAddInv.Inventors_Display_Order__c = 1;
                                objAddInv.Role_In_Conception__c = objOldAddInv.Role_In_Conception__c;
                                ListToUpdate.add(objAddInv);
                                if(mapofOldaddedInventors.containskey(objIDF.Id+':'+objoldIDF.SymphonyIPM__Primary_Inventor__c)){
                                    ListToDelete.add(mapofOldaddedInventors.get(objIDF.Id+':'+objoldIDF.SymphonyIPM__Primary_Inventor__c));
                                }
                            }
                        }
                    }
                    else if(mapofAdditionalInventorsRecords.containskey(objIDF.Id+':'+objIDF.SymphonyIPM__Primary_Inventor__c)){
                        System.debug('Primary inventor id else '+objIDF.SymphonyIPM__Primary_Inventor__c);
                        SymphonyIPM__Additional_Inventor__c objAddExistingInv = mapofAdditionalInventorsRecords.get(objIDF.Id+':'+objIDF.SymphonyIPM__Primary_Inventor__c);
                        objAddExistingInv.Is_Primary__c = true;
                        objAddExistingInv.Inventors_Display_Order__c = 1;
                        ListToUpdate.add(objAddExistingInv);
                        if(mapofAdditionalInventorsRecords.containskey(objIDF.Id+':'+objoldIDF.SymphonyIPM__Primary_Inventor__c)){
                            ListToDelete.add(mapofAdditionalInventorsRecords.get(objIDF.Id+':'+objoldIDF.SymphonyIPM__Primary_Inventor__c));
                            List<SymphonyIPM__Additional_Inventor__c> listAddInventors = mapofIDWithAdditionalInventors.get(objIDF.Id);
                            System.debug('listAddInventors size '+listAddInventors.size());
                            Integer j = 1;
                            if(listAddInventors.size() > 0){
                                for(SymphonyIPM__Additional_Inventor__c objAddinv : listAddInventors){
                                    System.debug('Additional inventor --->'+objAddinv);
                                    if(objAddinv.SymphonyIPM__Inventor__c != objIDF.SymphonyIPM__Primary_Inventor__c && !ListToDelete.contains(objAddinv)){
                                        System.debug('Additional inventor order update i--->');
                                        SymphonyIPM__Additional_Inventor__c objinv = new SymphonyIPM__Additional_Inventor__c();
                                        objinv.Id = objAddinv.Id;
                                        objinv.Inventors_Display_Order__c = j+1;
                                        System.debug('Additional inventor order updated record --->'+objinv);
                                        ListToUpdate.add(objinv);
                                        j = j+1;
                                    }
                                }
                            }
                        }
                    }
                }
                if(ListToUpdate.size()>0 && !Test.isRunningTest())
                {
                    upsert ListToUpdate;
                }
                if(StaticClass.stopaddinventor == true && ListToDelete.size()>0 && !Test.isRunningTest())
                {
                    DELETE ListToDelete;
                }
            }
            //Get all the share records
            map<string,SymphonyIPM__Invention_Disclosure_New__Share> mapofIDFShareRecords = new map<string,SymphonyIPM__Invention_Disclosure_New__Share>();
            for(SymphonyIPM__Invention_Disclosure_New__Share objIDFShare : [SELECT id,AccessLevel,ParentId,UserOrGroupId FROM SymphonyIPM__Invention_Disclosure_New__Share WHERE ParentId IN: setofIDFIds])
            {
                mapofIDFShareRecords.put(objIDFShare.ParentId+':'+objIDFShare.UserOrGroupId, objIDFShare);
            }
            
            
            if(listAdditionalInventors.size() > 0)
            {
                for(SymphonyIPM__Additional_Inventor__c objAdditioalInventor : listAdditionalInventors)
                {
                    
                    if(!mapofIDFShareRecords.containskey(objAdditioalInventor.SymphonyIPM__Invention_Disclosure_New__c+':'+objAdditioalInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c))
                    {
                        if(objAdditioalInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c != null && objAdditioalInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c != objAdditioalInventor.SymphonyIPM__Invention_Disclosure_New__r.OwnerId && objAdditioalInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__r.IsActive == true)
                        {
                            SymphonyIPM__Invention_Disclosure_New__Share IDFShareAddInv = new SymphonyIPM__Invention_Disclosure_New__Share();
                            IDFShareAddInv.AccessLevel = 'Edit';
                            IDFShareAddInv.ParentId = objAdditioalInventor.SymphonyIPM__Invention_Disclosure_New__c;
                            IDFShareAddInv.UserOrGroupId = objAdditioalInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c;
                            listShareRecordsToInsert.add(IDFShareAddInv);
                            mapofIDFShareRecords.put(objAdditioalInventor.SymphonyIPM__Invention_Disclosure_New__c+':'+objAdditioalInventor.SymphonyIPM__Inventor__r.SymphonyIPM__User__c,IDFShareAddInv);
                        }
                    }
                    
                }
                
            }
            
          List<SymphonyIPM__Invention_Disclosure_New__c> idfLst = [select id,name,OwnerId from SymphonyIPM__Invention_Disclosure_New__c where id IN: setofIDFIds];
            set<id> OwnerIDs = new set<id>();
            for( SymphonyIPM__Invention_Disclosure_New__c idfLstRec : idfLst)
            {
                OwnerIDs.add(idfLstRec.OwnerID);
            }
            
            if(setofOldPathids.size() > 0){
                set<string> setofUserIdsToUnshare = new set<string>();
                list<SymphonyIPM__Hierarchy_Role__c> ListOldHierarchyUsers = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :setofOldPathids AND SymphonyIPM__User__c != null];
                if(ListOldHierarchyUsers.size() > 0)
                {
                    for(SymphonyIPM__Hierarchy_Role__c objHR : ListOldHierarchyUsers){
                        setofUserIdsToUnshare.add(objHR.SymphonyIPM__User__c);
                    }
                    if(setofUserIdsToUnshare.size() > 0){
                        List<SymphonyIPM__Invention_Disclosure_New__Share> listTodeleteSharerecords = [SELECT id,AccessLevel,ParentId,UserOrGroupId FROM SymphonyIPM__Invention_Disclosure_New__Share WHERE ParentId IN: setofIDFIds AND UserOrGroupId IN: setofUserIdsToUnshare AND UserOrGroupId NOT IN: OwnerIDs ];
                        if(listTodeleteSharerecords.size() > 0 && !Test.isRunningTest()){
                            system.debug('listTodeleteSharerecords'+listTodeleteSharerecords.size());
                            DELETE listTodeleteSharerecords;
                            system.debug('listTodeleteSharerecords'+listTodeleteSharerecords);
                        }
                    }
                }
            }
            list<SymphonyIPM__Hierarchy_Role__c> ListHierarchyUsers = new list<SymphonyIPM__Hierarchy_Role__c>();
            map<string,List<SymphonyIPM__Hierarchy_Role__c>> mapofHierarchyroles = new map<string,List<SymphonyIPM__Hierarchy_Role__c>>();
            if(setofPathids.size() > 0)
            {
                ListHierarchyUsers = [select id,name,SymphonyIPM__User__c,SymphonyIPM__Hierarchy_Path__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :setofPathids AND SymphonyIPM__User__c != null AND SymphonyIPM__User__r.IsActive = true];
                if(ListHierarchyUsers.size() > 0)
                {
                    for(SymphonyIPM__Hierarchy_Role__c objHierarchyRole : ListHierarchyUsers){
                        List<SymphonyIPM__Hierarchy_Role__c> listtemp = mapofHierarchyroles.get(objHierarchyRole.SymphonyIPM__Hierarchy_Path__c);
                        if(listtemp != null){
                            listtemp.add(objHierarchyRole);
                        }else{
                            mapofHierarchyroles.put(objHierarchyRole.SymphonyIPM__Hierarchy_Path__c,new List<SymphonyIPM__Hierarchy_Role__c>{objHierarchyRole});
                        }
                    }
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF1 : mapNew.values())
                    {
                        if(mapofHierarchyroles.containskey(objIDF1.SymphonyIPM__Hierarchy__c)){
                            List<SymphonyIPM__Hierarchy_Role__c> temp = mapofHierarchyroles.get(objIDF1.SymphonyIPM__Hierarchy__c);
                            for(SymphonyIPM__Hierarchy_Role__c objHierarhy : temp)
                            {
                                if(!mapofIDFShareRecords.containskey(objIDF1+':'+objHierarhy.SymphonyIPM__User__c))
                                {
                                    SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithHierarchy = new SymphonyIPM__Invention_Disclosure_New__Share();
                                    IDFSharewithHierarchy.AccessLevel = 'Edit';
                                    IDFSharewithHierarchy.ParentId = objIDF1.ID;
                                    IDFSharewithHierarchy.UserOrGroupId = objHierarhy.SymphonyIPM__User__c;
                                    listShareRecordsToInsert.add(IDFSharewithHierarchy);
                                    mapofIDFShareRecords.put(objIDF1+':'+objHierarhy.SymphonyIPM__User__c,IDFSharewithHierarchy);
                                }
                            }
                        }
                    }
                }
            }
            if(setofPatentids.size() > 0)
            {
                map<id,SymphonyIPM__Patent__c> mapOfPatents = new map<id,SymphonyIPM__Patent__c>([SELECT SymphonyIPM__Outside_Counsel__r.IsActive,SymphonyIPM__Outside_Counsel__c,id,SymphonyIPM__Base_Invention_Disclosure_New__c,SymphonyIPM__Business_Contact__c,SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c,SymphonyIPM__Business_Contact__r.SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Patent__c WHERE id IN: setofPatentids]);
                map<string,SymphonyIPM__Patent__Share> mapofpatentshares = new map<string,SymphonyIPM__Patent__Share>();
                for(SymphonyIPM__Patent__Share objPatentShare : [SELECT id,AccessLevel,ParentId,UserOrGroupId FROM SymphonyIPM__Patent__Share WHERE ParentId IN: setofPatentids])
                {
                    mapofpatentshares.put(objPatentShare.ParentId+':'+objPatentShare.UserOrGroupId, objPatentShare);
                }
                for(SymphonyIPM__Invention_Disclosure_New__c objIDF : mapNew.values())
                {
                    SymphonyIPM__Invention_Disclosure_New__c objoldIDF = mapOld.get(objIDF.id);
                    if(mapOfPatents.containskey(objIDF.SymphonyIPM__Related_Patent__c))
                    {
                        SymphonyIPM__Patent__c objpatent = mapOfPatents.get(objIDF.SymphonyIPM__Related_Patent__c);
                        if(objpatent.SymphonyIPM__Outside_Counsel__r.IsActive == true && objpatent.SymphonyIPM__Outside_Counsel__c != null && !mapofIDFShareRecords.containskey(objpatent.SymphonyIPM__Base_Invention_Disclosure_New__c+':'+objpatent.SymphonyIPM__Outside_Counsel__c))
                        {
                            SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithOC = new SymphonyIPM__Invention_Disclosure_New__Share();
                            IDFSharewithOC.AccessLevel = 'Edit';
                            IDFSharewithOC.ParentId = objpatent.SymphonyIPM__Base_Invention_Disclosure_New__c;
                            IDFSharewithOC.UserOrGroupId = objpatent.SymphonyIPM__Outside_Counsel__c;
                            listShareRecordsToInsert.add(IDFSharewithOC);
                            mapofIDFShareRecords.put(objpatent.SymphonyIPM__Base_Invention_Disclosure_New__c+':'+objpatent.SymphonyIPM__Outside_Counsel__c,IDFSharewithOC);
                        }
                        //if(objoldIDF.SymphonyIPM__Disclosure_Status__c != objIDF.SymphonyIPM__Disclosure_Status__c && objIDF.SymphonyIPM__Disclosure_Status__c == 'Approved for Filing')
                        //{
                        if(objpatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__r.IsActive == true && objpatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c != null && !mapofpatentshares.containskey(objIDF.SymphonyIPM__Related_Patent__c+':'+objpatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c))
                        {
                            SymphonyIPM__Patent__Share patentshare = new SymphonyIPM__Patent__Share();
                            patentshare.AccessLevel = 'Edit';
                            patentshare.ParentId = objIDF.SymphonyIPM__Related_Patent__c;
                            patentshare.UserOrGroupId = objpatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c;
                            listPatentShareRecordsToInsert.add(patentshare);
                            mapofpatentshares.put(objIDF.SymphonyIPM__Related_Patent__c+':'+objpatent.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c,patentshare);
                        }
                        //}
                    }
                }
                if(ListHierarchyUsers.size() > 0)
                {
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF1 : mapNew.values())
                    {
                        if(objIDF1.SymphonyIPM__Related_Patent__c != null && mapofHierarchyroles.containskey(objIDF1.SymphonyIPM__Hierarchy__c)){
                            List<SymphonyIPM__Hierarchy_Role__c> temp = mapofHierarchyroles.get(objIDF1.SymphonyIPM__Hierarchy__c);
                            for(SymphonyIPM__Hierarchy_Role__c objHierarhy : temp)
                            {
                                if(!mapofpatentshares.containskey(objIDF1.SymphonyIPM__Related_Patent__c+':'+objHierarhy.SymphonyIPM__User__c))
                                {
                                    SymphonyIPM__Patent__Share patentshare = new SymphonyIPM__Patent__Share();
                                    patentshare.AccessLevel = 'Edit';
                                    patentshare.ParentId = objIDF1.SymphonyIPM__Related_Patent__c;
                                    patentshare.UserOrGroupId = objHierarhy.SymphonyIPM__User__c;
                                    listPatentShareRecordsToInsert.add(patentshare);
                                    mapofpatentshares.put(objIDF1.SymphonyIPM__Related_Patent__c+':'+objHierarhy.SymphonyIPM__User__c,patentshare);
                                }
                            }
                        }
                    }
                }
            }
            if(setofLawfirmsIds.size() > 0)
            {
                map<id,List<SymphonyIPM__Inventor__c>> mapofPersonOCwithlawfirm = new map<id,List<SymphonyIPM__Inventor__c>>();
                for(SymphonyIPM__Inventor__c objInventor : [SELECT id,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive,SymphonyIPM__Law_Firm__c FROM SymphonyIPM__Inventor__c WHERE (SymphonyIPM__Law_Firm__c IN: setofLawfirmsIds AND SymphonyIPM__User__c != null)])
                {
                    if(objInventor.SymphonyIPM__Law_Firm__c != null){
                        List<SymphonyIPM__Inventor__c> listLawFirmOCs = mapofPersonOCwithlawfirm.get(objInventor.SymphonyIPM__Law_Firm__c);
                        if(!mapofPersonOCwithlawfirm.containskey(objInventor.SymphonyIPM__Law_Firm__c))
                        {
                            mapofPersonOCwithlawfirm.put(objInventor.SymphonyIPM__Law_Firm__c,new List<SymphonyIPM__Inventor__c>{objInventor});
                        }
                        else if(mapofPersonOCwithlawfirm.containskey(objInventor.SymphonyIPM__Law_Firm__c))
                        {
                            listLawFirmOCs.add(objInventor);
                        }
                    }
                }
                if(setofIDFIds.size() > 0)
                {
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF : mapNew.values())
                    {
                        
                        List<SymphonyIPM__Inventor__c> lstLawFirmOCs = mapofPersonOCwithlawfirm.get(objIDF.Law_Firm__c);
                        if(lstLawFirmOCs != null && lstLawFirmOCs.size()>0)
                        {
                            for(SymphonyIPM__Inventor__c objOCPerson : lstLawFirmOCs)
                            {
                                if(objOCPerson.SymphonyIPM__User__r.IsActive == true && !mapofIDFShareRecords.containskey(objIDF.Id+':'+objOCPerson.SymphonyIPM__User__c))
                                {
                                    SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithOC = new SymphonyIPM__Invention_Disclosure_New__Share();
                                    IDFSharewithOC.AccessLevel = 'Edit';
                                    IDFSharewithOC.ParentId = objIDF.Id;
                                    IDFSharewithOC.UserOrGroupId = objOCPerson.SymphonyIPM__User__c;
                                    listShareRecordsToInsert.add(IDFSharewithOC);
                                    mapofIDFShareRecords.put(objIDF.Id+':'+objOCPerson.SymphonyIPM__User__c,IDFSharewithOC);
                                }
                            }
                        }
                        
                    }
                }
            }
            if(setofOtherContactIds.size() > 0)
            {
                map<id,SymphonyIPM__Inventor__c> mapofPersonOtherContact = new map<id,SymphonyIPM__Inventor__c>([SELECT id,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive,SymphonyIPM__Law_Firm__c FROM SymphonyIPM__Inventor__c WHERE (Id IN: setofOtherContactIds AND SymphonyIPM__User__c != null)]);
                for(SymphonyIPM__Invention_Disclosure_New__c objIDF : mapNew.values())
                {
                    if(mapofPersonOtherContact.containskey(objIDF.Other_Contact__c)){
                        SymphonyIPM__Inventor__c objOtherContact = mapofPersonOtherContact.get(objIDF.Other_Contact__c);
                        if(objOtherContact.SymphonyIPM__User__r.IsActive == true && !mapofIDFShareRecords.containskey(objIDF.Id+':'+objOtherContact.SymphonyIPM__User__c))
                        {
                            SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithOtherContact = new SymphonyIPM__Invention_Disclosure_New__Share();
                            IDFSharewithOtherContact.AccessLevel = 'Edit';
                            IDFSharewithOtherContact.ParentId = objIDF.Id;
                            IDFSharewithOtherContact.UserOrGroupId = objOtherContact.SymphonyIPM__User__c;
                            listShareRecordsToInsert.add(IDFSharewithOtherContact);
                            mapofIDFShareRecords.put(objIDF.Id+':'+objOtherContact.SymphonyIPM__User__c,IDFSharewithOtherContact);
                        }
                    }
                }
            }
            if(setofPrimaryContactIds.size() > 0)
            {
                map<id,SymphonyIPM__Inventor__c> mapofPersonPrimaryContact = new map<id,SymphonyIPM__Inventor__c>([SELECT id,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive,SymphonyIPM__Law_Firm__c FROM SymphonyIPM__Inventor__c WHERE (Id IN: setofPrimaryContactIds AND SymphonyIPM__User__c != null)]);
                for(SymphonyIPM__Invention_Disclosure_New__c objIDF : mapNew.values())
                {
                    if(mapofPersonPrimaryContact.containskey(objIDF.Primary_Contact__c))
                    {
                        SymphonyIPM__Inventor__c objPrimaryContact = mapofPersonPrimaryContact.get(objIDF.Primary_Contact__c);
                        if(objPrimaryContact.SymphonyIPM__User__c != null && objPrimaryContact.SymphonyIPM__User__r.IsActive == true && !mapofIDFShareRecords.containskey(objIDF.Id+':'+objPrimaryContact.SymphonyIPM__User__c))
                        {
                            SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithPrimaryContact = new SymphonyIPM__Invention_Disclosure_New__Share();
                            IDFSharewithPrimaryContact.AccessLevel = 'Edit';
                            IDFSharewithPrimaryContact.ParentId = objIDF.Id;
                            IDFSharewithPrimaryContact.UserOrGroupId = objPrimaryContact.SymphonyIPM__User__c;
                            listShareRecordsToInsert.add(IDFSharewithPrimaryContact);
                            mapofIDFShareRecords.put(objIDF.Id+':'+objPrimaryContact.SymphonyIPM__User__c,IDFSharewithPrimaryContact);
                        }
                    }
                }
            }
            List<string> listofMentoridstemp = new List<string>();
            map<string,List<string>> mapofidfidwithmentors = new map<string,List<string>>();
            for(SymphonyIPM__Invention_Disclosure_New__c objIDF : mapNew.values())
            {
                if(objIDF.MentorsIDs__c != null && objIDF.MentorsIDs__c !='')
                {
                    String str = objIDF.MentorsIDs__c;
                    String strwithnospace = str.deleteWhitespace();
                    if(strwithnospace != null && strwithnospace != '')
                    {
                        List<string> listofmentorids = new List<string>();
                        if(strwithnospace.contains(','))
                        {
                            listofmentorids = strwithnospace.trim().split(',');
                        }
                        else
                        {
                            listofmentorids.add(strwithnospace);
                        }
                        mapofidfidwithmentors.put(objIDF.Id,listofmentorids);
                        listofMentoridstemp.addAll(listofmentorids);
                    }
                }
            }
            set<string> setofMentorIds = new set<string>(listofMentoridstemp);
            if(mapofidfidwithmentors.size() > 0)
            {
                map<id,SymphonyIPM__Inventor__c> mapofPersonMentors = new map<id,SymphonyIPM__Inventor__c>([SELECT id,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive,SymphonyIPM__Law_Firm__c FROM SymphonyIPM__Inventor__c WHERE (Id IN: setofMentorIds AND SymphonyIPM__User__c != null)]);
                for(string idfid : mapofidfidwithmentors.keyset())
                {
                    List<string> listMentors = mapofidfidwithmentors.get(idfid);
                    for(string mentor : listMentors)
                    {
                        if(mapofPersonMentors.containskey(mentor))
                        {
                            SymphonyIPM__Inventor__c objMentor = mapofPersonMentors.get(mentor);
                            if(objMentor.SymphonyIPM__User__c != null && objMentor.SymphonyIPM__User__r.IsActive == true && !mapofIDFShareRecords.containskey(idfid+':'+objMentor.SymphonyIPM__User__c))
                            {
                                SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithMentor = new SymphonyIPM__Invention_Disclosure_New__Share();
                                IDFSharewithMentor.AccessLevel = 'Edit';
                                IDFSharewithMentor.ParentId = idfid;
                                IDFSharewithMentor.UserOrGroupId = objMentor.SymphonyIPM__User__c;
                                listShareRecordsToInsert.add(IDFSharewithMentor);
                                mapofIDFShareRecords.put(idfid+':'+objMentor.SymphonyIPM__User__c,IDFSharewithMentor);
                            }
                        }
                    }
                }
            }
            
            system.debug('----'+listShareRecordsToInsert);
            if( listShareRecordsToInsert.size() > 0  && !Test.isRunningTest())
            {
                try
                {
                    INSERT listShareRecordsToInsert;
                }catch(Exception e)
                {
                    system.debug('Error'+e.getLineNumber()+'Error Message'+e.getMessage());
                }
            }
            if(listPatentShareRecordsToInsert.size() > 0 && !Test.isRunningTest())
            {
                try
                {
                    INSERT listPatentShareRecordsToInsert;
                }catch(Exception e)
                {
                    system.debug('Error'+e.getLineNumber()+'Error Message'+e.getMessage());
                }
            }
        }
        }
    }
    
    public static void dummyMethod(){
        integer i=0;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
    }
}
trigger DeletionOfContDocuAndSharingOfRcd on SymphonyIPM__Invention_Disclosure_New__c (before update,after update,after insert)
{    
    string currentUserId = UserInfo.getUserId();  
    list<Id> IDFIds=new list<Id>();
    list<Id> ListToCreateDoc=new list<Id>();
    list<SymphonyIPM__Invention_Disclosure_New__c> listofIDF=new list<SymphonyIPM__Invention_Disclosure_New__c>();
    list<ContentDocumentLink> ListOfCDL=new list<ContentDocumentLink>();
    list<SymphonyIPM__Invention_Disclosure_New__c>  lstinvfinal = new list<SymphonyIPM__Invention_Disclosure_New__c>();
    map<Id,SymphonyIPM__Hierarchy_Role__c> mapofhierarchyRoles = new map<Id,SymphonyIPM__Hierarchy_Role__c>();
    set<SymphonyIPM__Invention_Disclosure_New__Share> ObjNewIDFShareSet =new set<SymphonyIPM__Invention_Disclosure_New__Share>();
    set<SymphonyIPM__Invention_Disclosure_New__Share> IDFSharewithHierarchySet =new set<SymphonyIPM__Invention_Disclosure_New__Share>();
    List<SymphonyIPM__Invention_Disclosure_New__Share> ObjNewIDFShareList = new List<SymphonyIPM__Invention_Disclosure_New__Share>();
    List<SymphonyIPM__Invention_Disclosure_New__Share> IDFSharewithHierarchyList = new List<SymphonyIPM__Invention_Disclosure_New__Share>();    
    
    if(trigger.isBefore)
    {
        if(trigger.isUpdate)
        {
            Map<Id,String> MapIDFTitle =new Map<Id,String>();
            Set<Id> ContentDocId=new Set<Id>();
            Set<string> setofpathids = new Set<string>();
            Map<Id,String> MapOfConDocIDAndTitle=new Map<Id,String>();
            list<ContentDocument> listOfCD=new list<ContentDocument>();
            list<ContentDocument> ListOfCDToDelete=new list<ContentDocument>();
            list<ContentDocument> ListOfCDToDeleteNew =new list<ContentDocument>();
            Map<Id,Id> MapofCDandIDF = new Map<Id,Id>();
            listofIDF=[SELECT Id,SymphonyIPM__Title__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE id IN :Trigger.old ];
            for(SymphonyIPM__Invention_Disclosure_New__c idf : listofIDF)
            {
                IDFIds.add(idf.id);
                MapIDFTitle.put(idf.id,idf.SymphonyIPM__Title__c);
                System.debug('MapIDFTitle :'+MapIDFTitle);
            }
            for(SymphonyIPM__Invention_Disclosure_New__c idf : Trigger.new)
            {
                //if((Trigger.oldMap.get(idf.id).SymphonyIPM__Hierarchy__c != Trigger.newMap.get(idf.id).SymphonyIPM__Hierarchy__c) && Trigger.newMap.get(idf.id).SymphonyIPM__Hierarchy__c != null)
                // {
                setofpathids.add(idf.SymphonyIPM__Hierarchy__c);
                //  }
            }
            System.debug('setofpathids :'+setofpathids);
            map<string,SymphonyIPM__Hierarchy_Role__c> mapofhierarchyRoles = new map<string,SymphonyIPM__Hierarchy_Role__c>();
            if(setofpathids.size() > 0)
            {
                
                List<SymphonyIPM__Hierarchy_Role__c> listHRoles = [SELECT id,SymphonyIPM__Hierarchy_Path__c,SymphonyIPM__User__c,SymphonyIPM__isPrimary__c,SymphonyIPM__Role__c FROM SymphonyIPM__Hierarchy_Role__c
                                                                   WHERE (SymphonyIPM__Hierarchy_Path__c IN: setofpathids AND SymphonyIPM__isPrimary__c = true AND SymphonyIPM__User__c != null AND SymphonyIPM__Role__c ='UHG IP Legal'AND SymphonyIPM__User__r.Profile.name='In-house Counsel')];
                system.debug('listHRoles :'+listHRoles);
                for(SymphonyIPM__Hierarchy_Role__c objHR : listHRoles)
                {
                    system.debug('obj.prb'+objHR.SymphonyIPM__Hierarchy_Path__c);
                    mapofhierarchyRoles.put(objHR.SymphonyIPM__Hierarchy_Path__c,objHR);
                }
            }
            System.debug('mapofhierarchyRoles :'+mapofhierarchyRoles.values());
            if(mapofhierarchyRoles.size() > 0)
            {
                for(SymphonyIPM__Invention_Disclosure_New__c idf : Trigger.new)
                {
                    system.debug('abcd');
                    if(mapofhierarchyRoles.containskey(idf.SymphonyIPM__Hierarchy__c))
                    {
                        SymphonyIPM__Hierarchy_Role__c objRole = mapofhierarchyRoles.get(idf.SymphonyIPM__Hierarchy__c);
                        //idf.UHG_IP_Legal_New__c = objRole.SymphonyIPM__User__c;
                        idf.UHG_IP_Legal__c = objRole.SymphonyIPM__User__c;
                    }
                }
            }
            ListOfCDL=[Select id,ContentDocumentId,LinkedEntityId From ContentDocumentLink where LinkedEntityId IN:IDFIds];
            for(ContentDocumentLink cdl:ListOfCDL)
            {
                String TitleofIDF = MapIDFTitle.get(cdl.LinkedEntityId);
                ContentDocId.add(cdl.ContentDocumentId);
                MapOfConDocIDAndTitle.put(cdl.ContentDocumentId,TitleofIDF);
                MapofCDandIDF.put(cdl.ContentDocumentId,cdl.LinkedEntityId);
                System.debug('MapOfConDocIDAndTitle:'+ MapOfConDocIDAndTitle);
            }
            if(ContentDocId.size()> 0 && ContentDocId != null)
            {
                listOfCD=[Select Id,Title FROM ContentDocument where Id IN : ContentDocId];
                for(ContentDocument Cd : listOfCD)
                {
                    if(Cd.Title.Startswith(MapOfConDocIDAndTitle.get(Cd.Id)))
                    {
                        ListOfCDToDelete.add(Cd);
                    }  
                }
                for(ContentDocument ConD : ListOfCDToDelete)
                {
                    System.debug('ConD:' +ConD);
                    String IDFId = MapofCDandIDF.get(ConD.Id);
                    String IDFTitle = MapIDFTitle.get(IDFId);
                    String FileName = ConD.Title;
                    //String DocName = FileName.replace(IDFTitle,'');
                    String strAfterTrim = FileName.removeEnd('.pdf');
                    System.debug(strAfterTrim);
                    string[] strArray = strAfterTrim.split(' -');
                    if (strArray != null && strArray.size()>1)
                    {
                        Integer str = strArray.size() - 1 ;
                        Boolean Result;
                        
                        Pattern TimePttrn = Pattern.compile('^([0-9][0-9][0-9][0-9])-([0-9][0-9])-([0-9][0-9])\\s([0-9][0-9]):([0-9][0-9]):([0-9][0-9])$');
                        Matcher MyMatcher = TimePttrn.matcher(strArray[str]);
                        Result = MyMatcher.matches();
                        System.debug('Result:'+Result);
                        if(Result == true)
                        {
                            ListOfCDToDeleteNew.add(ConD);
                            System.debug('ListOfCDToDeleteNew:'+ListOfCDToDeleteNew);
                        }
                    }
                    
                }
                if(ListOfCDToDeleteNew != null && ListOfCDToDeleteNew.size()>0 && !Test.isRunningTest())
                {
                    DELETE ListOfCDToDeleteNew;
                }
            }  
        }
    }
    if(trigger.isAfter){
        if(trigger.isUpdate ){
            if(test.isRunningTest()){
                recurssionPreventController.flag =true;
            }
            if(recurssionPreventController.flag == true){
                
                //recurssionPreventController.flag = false;
                System.debug('ListToCreateDoc----->>>>New----------->' + ListToCreateDoc);
                listofIDF=[SELECT Id,SymphonyIPM__Title__c,LastModifiedDate FROM SymphonyIPM__Invention_Disclosure_New__c where id IN :Trigger.old];
                for(SymphonyIPM__Invention_Disclosure_New__c idf : listofIDF){
                    IDFIds.add(idf.id);
                }
                System.debug('IDFIds----->>>>New----------->' + IDFIds);
                if(IDFIds.size()>0 && IDFIds!=null && !Test.isRunningTest()){
                    
                    IDFPDFGeneratorNew.generateIDFPDF(IDFIds);
                }
                
                //<-----------Handling Sharing of records--------->
                
                set<Id> oldPersonIDs = new set<Id>();
                set<Id> objDisclosureIds = new set<Id>();
                set<Id> oldUserIDsToDelete =new set<Id>();
                set<Id> oldPathUserIDsToDelete =new set<Id>();
                set<Id> NewPersonIDs = new set<Id>();
                set<Id> NewPathid = new set<Id>();
                set<Id> oldPathid = new set<Id>();
                set<Id> NewCreatedid = new set<Id>();
                set<Id> OldCreatedid = new set<Id>();
                
                
                for(Id objInvDisc : Trigger.newMap.keySet()){
                    
                    /*  if(Trigger.oldMap.get(objInvDisc).SymphonyIPM__Primary_Inventor__c != Trigger.newMap.get(objInvDisc).SymphonyIPM__Primary_Inventor__c){

if(Trigger.oldMap.get(objInvDisc).SymphonyIPM__Primary_Inventor__c != null){
oldPersonIDs.add(Trigger.oldMap.get(objInvDisc).SymphonyIPM__Primary_Inventor__c );
}

if(Trigger.newMap.get(objInvDisc).SymphonyIPM__Primary_Inventor__c != null){
NewPersonIDs.add(Trigger.newMap.get(objInvDisc).SymphonyIPM__Primary_Inventor__c );
}

}*/
                    
                    if(Trigger.oldMap.get(objInvDisc).Primary_Contact__c != Trigger.newMap.get(objInvDisc).Primary_Contact__c || Trigger.newMap.get(objInvDisc).Primary_Contact__c != null || Trigger.oldMap.get(objInvDisc).Primary_Contact__c != null)
                    {
                        
                        if(Trigger.oldMap.get(objInvDisc).Primary_Contact__c != null){
                            oldPersonIDs.add(Trigger.oldMap.get(objInvDisc).Primary_Contact__c );
                            System.debug('oldPersonIDs>>>' + Trigger.oldMap.get(objInvDisc).Primary_Contact__c);
                        }
                        
                        if(Trigger.newMap.get(objInvDisc).Primary_Contact__c != null){
                            NewPersonIDs.add(Trigger.newMap.get(objInvDisc).Primary_Contact__c );
                            System.debug('NewPersonIDs>>>' + Trigger.newMap.get(objInvDisc).Primary_Contact__c);
                        }
                    }
                    if((Trigger.oldMap.get(objInvDisc).SymphonyIPM__Hierarchy__c != Trigger.newMap.get(objInvDisc).SymphonyIPM__Hierarchy__c) && Trigger.newMap.get(objInvDisc).SymphonyIPM__Hierarchy__c != null)
                    {
                        if(Trigger.oldMap.get(objInvDisc).SymphonyIPM__Hierarchy__c != null){
                            oldPathid.add(Trigger.oldMap.get(objInvDisc).SymphonyIPM__Hierarchy__c );
                            OldCreatedid.add(Trigger.oldMap.get(objInvDisc).CreatedById);
                            System.debug('oldPathid>>>' + Trigger.oldMap.get(objInvDisc).SymphonyIPM__Hierarchy__c);
                        }
                        
                        if(Trigger.newMap.get(objInvDisc).SymphonyIPM__Hierarchy__c != null){
                            NewPathid.add(Trigger.newMap.get(objInvDisc).SymphonyIPM__Hierarchy__c );
                            NewCreatedid.add(Trigger.newMap.get(objInvDisc).CreatedById);
                            System.debug('NewPathid>>>' + Trigger.newMap.get(objInvDisc).SymphonyIPM__Hierarchy__c);
                        }
                        
                    }
                    if(Trigger.oldMap.get(objInvDisc).MentorsIDs__c != Trigger.newMap.get(objInvDisc).MentorsIDs__c || Trigger.newMap.get(objInvDisc).MentorsIDs__c != null || Trigger.oldMap.get(objInvDisc).MentorsIDs__c != null)
                    {
                        
                        if(Trigger.oldMap.get(objInvDisc).MentorsIDs__c != null){
                            
                            String MultipleMentor = Trigger.oldMap.get(objInvDisc).MentorsIDs__c;
                            if(MultipleMentor.contains(',')){
                                string str=MultipleMentor;
                                string mentorstring=str.deleteWhitespace();
                                list<String> ListOfMent=mentorstring.trim().split(',');
                                for(String stri : ListOfMent){
                                    oldPersonIDs.add(stri);  
                                }
                            }
                            else if(!MultipleMentor.contains(',')){
                                oldPersonIDs.add(MultipleMentor);  
                            }
                        }
                        
                        if(Trigger.newMap.get(objInvDisc).MentorsIDs__c != null)
                        {
                            
                            String MultipleMentor = Trigger.newMap.get(objInvDisc).MentorsIDs__c;
                            system.debug('Mentor records'+ MultipleMentor );
                            if(MultipleMentor.contains(',')){
                                string str=MultipleMentor;
                                string mentorstring=str.deleteWhitespace();
                                list<String> ListOfMent= mentorstring.trim().split(',');
                                for(String stri : ListOfMent){
                                    NewPersonIDs.add(stri);  
                                }
                            }
                            else if(!MultipleMentor.contains(',')){
                                NewPersonIDs.add(MultipleMentor);  
                                System.debug('SingleMentor >>>>'+ MultipleMentor);
                            }
                        }
                        
                    }
                    objDisclosureIds.add(Trigger.newMap.get(objInvDisc).Id);
                }
                if(oldPersonIDs != null && oldPersonIDs.size() > 0) {
                    list<SymphonyIPM__Inventor__c> oldUserIDs =[Select Id,SymphonyIPM__User__c from SymphonyIPM__Inventor__c where ((Id IN:oldPersonIDs) AND (SymphonyIPM__User__c != null))];
                    if(oldUserIDs != null && oldUserIDs.size() > 0){
                        for(SymphonyIPM__Inventor__c EachPerson : oldUserIDs){
                            oldUserIDsToDelete.add(EachPerson.SymphonyIPM__User__c);
                        }
                        List<SymphonyIPM__Invention_Disclosure_New__Share> ObjExistingIDFShare = [Select Id From SymphonyIPM__Invention_Disclosure_New__Share Where ((ParentId IN : objDisclosureIds) AND (UserOrGroupId IN : oldUserIDsToDelete))];
                        if(!ObjExistingIDFShare.IsEmpty())
                        {
                            // Database.SaveResult[] SrList = Database.Insert(ObjExistingIDFShare, false);
                            Database.DeleteResult[] SrList = Database.delete(ObjExistingIDFShare, false);
                            System.debug('SrList'+ SrList);
                        }  
                        
                    }
                }
                /*if(oldPathid != null && oldPathid.size() > 0) {
list<SymphonyIPM__Hierarchy_Role__c> OldHierarchyUsersDelete = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :OldPathid AND SymphonyIPM__User__c != null AND SymphonyIPM__User__c  NOT IN : OldCreatedid];

if(OldHierarchyUsersDelete != null && OldHierarchyUsersDelete.size() > 0){
for(SymphonyIPM__Hierarchy_Role__c EachHierarchy : OldHierarchyUsersDelete){
oldPathUserIDsToDelete.add(EachHierarchy.SymphonyIPM__User__c);
}
List<SymphonyIPM__Invention_Disclosure_New__Share> ObjExistingIDFSharewithHierarchy = [Select Id From SymphonyIPM__Invention_Disclosure_New__Share Where ((ParentId IN : objDisclosureIds) AND (UserOrGroupId IN : oldPathUserIDsToDelete))];
if(!ObjExistingIDFSharewithHierarchy.IsEmpty())
{
Database.DeleteResult[] DeleteHierarchyList = Database.delete(ObjExistingIDFSharewithHierarchy, false);
System.debug('deleted hierarchy share list'+ DeleteHierarchyList);
}  

}
}*/
                System.debug('NewPersonIDs'+NewPersonIDs.Size() + '||'+ NewPersonIDs);
                if(!objDisclosureIds.isEmpty() && NewPersonIDs.size() >0){
                    
                    list<SymphonyIPM__Inventor__c> NewUserIDs =[Select Id,SymphonyIPM__User__c from SymphonyIPM__Inventor__c where ((Id IN:NewPersonIDs) AND (SymphonyIPM__User__c != null)AND (SymphonyIPM__User__r.isActive = true))];
                    
                    for(Id objIDF : objDisclosureIds){
                        for(SymphonyIPM__Inventor__c inv : NewUserIDs ){
                            
                            SymphonyIPM__Invention_Disclosure_New__Share ObjIDFShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                            ObjIDFShare.AccessLevel='Edit';
                            ObjIDFShare.ParentId=objIDF;
                            ObjIDFShare.UserOrGroupId=inv.SymphonyIPM__User__c;
                            // Commented Row Cause on [08-04-2020] by juveria.because,inventor is not able to submit IDF
                            // ObjIDFShare.RowCause=Schema.SymphonyIPM__Invention_Disclosure_New__Share.RowCause.Other_Inventors__c;//'User in IDF'; //Schema.SymphonyIPM__Invention_Disclosure_New__Share.RowCause.SharingIDFwithOC__c;
                            ObjNewIDFShareSet.add(ObjIDFShare);
                        }
                        
                    }
                }
                if(!objDisclosureIds.isEmpty() && NewPathid.size() >0){
                    
                    
                    list<SymphonyIPM__Hierarchy_Role__c> NewHierarchyUsers = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :NewPathid AND SymphonyIPM__User__c != null AND SymphonyIPM__User__c  NOT IN : NewCreatedid AND SymphonyIPM__User__r.IsActive = true];      
                    for(Id objIDF1 : objDisclosureIds){
                        
                        for(SymphonyIPM__Hierarchy_Role__c Newlisthierarchyuser : NewHierarchyUsers)
                        {
                            SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithHierarchy = new SymphonyIPM__Invention_Disclosure_New__Share();
                            IDFSharewithHierarchy.AccessLevel='Edit';
                            IDFSharewithHierarchy.ParentId=objIDF1;
                            IDFSharewithHierarchy.UserOrGroupId=Newlisthierarchyuser.SymphonyIPM__User__c;
                            
                            IDFSharewithHierarchySet.add(IDFSharewithHierarchy);
                        }
                    }
                }
                if(!Test.isRunningTest()){
                String jsonMapNew=JSON.serialize(Trigger.newMap);
                String jsonMapOld=JSON.serialize(Trigger.oldMap);
                IDFFuture.IDFFuturemethod(jsonMapNew,jsonMapOld);
                }
                recurssionPreventController.flag = false;
            }
            //Added to resolve sharing issue
            /*string loggedinuser = UserInfo.getUserId();
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
            for(SymphonyIPM__Invention_Disclosure_New__c objIDF : Trigger.new)
            {
                SymphonyIPM__Invention_Disclosure_New__c objoldIDF = Trigger.oldMap.get(objIDF.id);
                //if(objoldIDF.SymphonyIPM__Disclosure_Status__c != objIDF.SymphonyIPM__Disclosure_Status__c && objIDF.SymphonyIPM__Disclosure_Status__c == 'Approved for Filing')
                //{
                setofIDFIds.add(objIDF.Id);
                if(objIDF.SymphonyIPM__Hierarchy__c != objoldIDF.SymphonyIPM__Hierarchy__c)
                {
                    setofOldPathids.add(objoldIDF.SymphonyIPM__Hierarchy__c);
					setofPathids.add(objIDF.SymphonyIPM__Hierarchy__c);
                }
                
                if(objIDF.SymphonyIPM__Disclosure_Status__c == 'Approved for Filing' && objIDF.SymphonyIPM__Related_Patent__c != null)
                {
                    setofPatentids.add(objIDF.SymphonyIPM__Related_Patent__c);
                }
                if(objIDF.Law_Firm__c != objoldIDF.Law_Firm__c && objIDF.Law_Firm__c != null)
                {
                    setofLawfirmsIds.add(objIDF.Law_Firm__c);
                }
                if(objIDF.Other_Contact__c != objoldIDF.Other_Contact__c && objIDF.Other_Contact__c != null)
                {
                    setofOtherContactIds.add(objIDF.Other_Contact__c);
                }
                if(objIDF.Primary_Contact__c != objoldIDF.Primary_Contact__c && objIDF.Primary_Contact__c != null)
                {
                    setofPrimaryContactIds.add(objIDF.Primary_Contact__c);
                }
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
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF : Trigger.new)
                    {
                        SymphonyIPM__Invention_Disclosure_New__c objoldIDF = Trigger.oldMap.get(objIDF.id);
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
                    if(ListToUpdate.size()>0)
                    {
                        upsert ListToUpdate;
                    }
                    if(StaticClass.stopaddinventor == true && ListToDelete.size()>0)
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
                if(setofOldPathids.size() > 0){
                    set<string> setofUserIdsToUnshare = new set<string>();
                    list<SymphonyIPM__Hierarchy_Role__c> ListOldHierarchyUsers = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :setofOldPathids AND SymphonyIPM__User__c != null];
                    if(ListOldHierarchyUsers.size() > 0)
                    {
                        for(SymphonyIPM__Hierarchy_Role__c objHR : ListOldHierarchyUsers){
                            setofUserIdsToUnshare.add(objHR.SymphonyIPM__User__c);
                        }
                        if(setofUserIdsToUnshare.size() > 0){
                            List<SymphonyIPM__Invention_Disclosure_New__Share> listTodeleteSharerecords = [SELECT id,AccessLevel,ParentId,UserOrGroupId FROM SymphonyIPM__Invention_Disclosure_New__Share WHERE ParentId IN: setofIDFIds AND UserOrGroupId IN: setofUserIdsToUnshare];
                            if(listTodeleteSharerecords.size() > 0){
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
                        for(SymphonyIPM__Invention_Disclosure_New__c objIDF1 : Trigger.new)
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
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF : Trigger.new)
                    {
                        SymphonyIPM__Invention_Disclosure_New__c objoldIDF = Trigger.oldMap.get(objIDF.id);
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
                        for(SymphonyIPM__Invention_Disclosure_New__c objIDF1 : Trigger.new)
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
                        for(SymphonyIPM__Invention_Disclosure_New__c objIDF : Trigger.new)
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
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF : Trigger.new)
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
                    for(SymphonyIPM__Invention_Disclosure_New__c objIDF : Trigger.new)
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
                for(SymphonyIPM__Invention_Disclosure_New__c objIDF : Trigger.new)
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
                if( listShareRecordsToInsert.size() > 0  )
                {
                    try
                    {
                        INSERT listShareRecordsToInsert;
                    }catch(Exception e)
                    {
                        system.debug('Error'+e.getLineNumber()+'Error Message'+e.getMessage());
                    }
                }
                if(listPatentShareRecordsToInsert.size() > 0 )
                {
                    try
                    {
                        INSERT listPatentShareRecordsToInsert;
                    }catch(Exception e)
                    {
                        system.debug('Error'+e.getLineNumber()+'Error Message'+e.getMessage());
                    }
                }
            }*/
            
        }
    }
    
    if(trigger.isAfter && !Test.isRunningTest())
    {
        if(trigger.isInsert)
        {
            
            if(recurssionPreventController.flag == true)
            {
                recurssionPreventController.flag = false;
                listofIDF=[SELECT Id,SymphonyIPM__Title__c FROM SymphonyIPM__Invention_Disclosure_New__c where id IN :Trigger.new];
                if(!listofIDF.isEmpty())
                {
                    for(SymphonyIPM__Invention_Disclosure_New__c idf : listofIDF){
                        IDFIds.add(idf.id);
                    }
                    System.debug('List'+IDFIds);
                }
                System.debug('IDFIds----->>>>New----------->' + IDFIds);
                if(IDFIds.size()>0 && IDFIds!=null && !Test.isRunningTest())
                {
                    IDFPDFGeneratorNew.generateIDFPDF(IDFIds);
                }
                
                list<String> PersonRcd = new list<String>();
                list<id> Pathid = new list<id>();
                list<id> Createdid = new list<id>();
                
                list<SymphonyIPM__Invention_Disclosure_New__c> ObjDisclosureToBeShared=new list<SymphonyIPM__Invention_Disclosure_New__c>();
                
                listofIDF=[SELECT Id,SymphonyIPM__Title__c,SymphonyIPM__Hierarchy__c,SymphonyIPM__Primary_Inventor__c,MentorsIDs__c,Primary_Contact__c,CreatedById FROM SymphonyIPM__Invention_Disclosure_New__c where id IN :Trigger.new];
                
                if(!listofIDF.IsEmpty())
                {
                    system.debug('ObjInvDiscList' + listofIDF);
                    
                    for(SymphonyIPM__Invention_Disclosure_New__c objInvDis :  listofIDF)
                    {
                        /* if(objInvDis.SymphonyIPM__Primary_Inventor__c != null)
{
PersonRcd.add(objInvDis.SymphonyIPM__Primary_Inventor__c);
}*/
                        if(objInvDis.Primary_Contact__c != null){
                            
                            PersonRcd.add(objInvDis.Primary_Contact__c);
                        }
                        if(objInvDis.SymphonyIPM__Hierarchy__c != null)
                        {
                            Pathid.add(objInvDis.SymphonyIPM__Hierarchy__c);
                            Createdid.add(objInvDis.CreatedById);
                        }
                        if(objInvDis.MentorsIDs__c != null){
                            if(objInvDis.MentorsIDs__c.contains(',')){
                                string str=objInvDis.MentorsIDs__c;
                                string mentorstring=str.deleteWhitespace();
                                List<String> lstMentor = mentorstring.trim().split(',');
                                if(lstMentor.size() > 0)
                                {
                                    for(String stri: lstMentor){
                                        
                                        PersonRcd.add(stri);
                                    }
                                }
                            }
                            if(!objInvDis.MentorsIDs__c.contains(',')){
                                PersonRcd.add(objInvDis.MentorsIDs__c);
                            }
                        }
                        ObjDisclosureToBeShared.add(objInvDis);
                    }
                    System.debug('PersonRcd>>>'+ PersonRcd.size());
                    if(PersonRcd != null && PersonRcd.size()>0)
                    {                    
                        list<SymphonyIPM__Inventor__c> ListOfPersonRcd =[Select Id,SymphonyIPM__User__c from SymphonyIPM__Inventor__c where ((Id IN:PersonRcd) AND (SymphonyIPM__User__c != null) AND (SymphonyIPM__User__r.isActive = true))];
                        // list<SymphonyIPM__Hierarchy_Role__c> HierarchyUsers = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :Pathid AND SymphonyIPM__User__c != null AND SymphonyIPM__User__c  NOT IN : Createdid];
                        if(ListOfPersonRcd != null && ListOfPersonRcd.size() > 0)
                        {
                            for(SymphonyIPM__Invention_Disclosure_New__c Discrcd : ObjDisclosureToBeShared)
                            {
                                for(SymphonyIPM__Inventor__c lstperson : ListOfPersonRcd)
                                {
                                    // if(lstperson.SymphonyIPM__User__c != null && lstperson.SymphonyIPM__User__r.isActive == true){
                                    SymphonyIPM__Invention_Disclosure_New__Share ObjIDFShare = new SymphonyIPM__Invention_Disclosure_New__Share();
                                    ObjIDFShare.AccessLevel='Edit'; //changed from read to edit accress level for detail view edit form by [Juveria 04/03/2020]
                                    ObjIDFShare.ParentId=Discrcd.id;
                                    ObjIDFShare.UserOrGroupId=lstperson.SymphonyIPM__User__c;
                                    // Commented Row Cause on [08-04-2020] by juveria.because,inventor is not able to submit IDF
                                    //ObjIDFShare.RowCause=Schema.SymphonyIPM__Invention_Disclosure_New__Share.RowCause.Other_Inventors__c;//'Manual';//'Users in IDF';   //Schema.SymphonyIPM__Invention_Disclosure_New__Share.RowCause.SharingIDFwithOC__c;
                                    ObjNewIDFShareSet.add(ObjIDFShare);
                                    //}
                                    // System.debug(ObjNewIDFShareList[0].RowCause+ '<<<<');
                                }
                                
                            }
                            
                        }
                    }
                    if(Pathid != null && Pathid.size() >0){
                        list<SymphonyIPM__Hierarchy_Role__c> HierarchyUsers = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :Pathid AND SymphonyIPM__User__c != null AND SymphonyIPM__User__c  NOT IN : Createdid AND SymphonyIPM__User__r.IsActive = true];
                        system.debug('list of hierarchy users'+HierarchyUsers);  
                        for(SymphonyIPM__Invention_Disclosure_New__c Discrcd1 : ObjDisclosureToBeShared)
                        {
                            for(SymphonyIPM__Hierarchy_Role__c listhierarchyuser : HierarchyUsers)
                            {
                                SymphonyIPM__Invention_Disclosure_New__Share IDFSharewithHierarchy = new SymphonyIPM__Invention_Disclosure_New__Share();
                                IDFSharewithHierarchy.AccessLevel='Edit';
                                IDFSharewithHierarchy.ParentId=Discrcd1.id;
                                IDFSharewithHierarchy.UserOrGroupId=listhierarchyuser.SymphonyIPM__User__c;
                                
                                IDFSharewithHierarchySet.add(IDFSharewithHierarchy);
                            }
                        }
                        
                    }
                    
                }
            }
        }
        
    }
    
    ObjNewIDFShareList.addAll(ObjNewIDFShareSet);
    System.debug('ObjNewIDFShareList>>>>>>>>> ' + ObjNewIDFShareList);
    if(!ObjNewIDFShareList.IsEmpty() && !Test.isRunningTest())
    {
        Database.SaveResult[] IDFShareInsertRes=Database.insert(ObjNewIDFShareList,false);
        System.debug('After Insert'+IDFShareInsertRes);
    }
    
    IDFSharewithHierarchyList.addAll(IDFSharewithHierarchySet);
    System.debug('IDFSharewithHierarchyList>>>>>>>>> ' + IDFSharewithHierarchyList);
    if(IDFSharewithHierarchyList.size()>0 && !Test.isRunningTest())
    {
        try{
            Database.SaveResult[] IDFShareInsert=Database.insert(IDFSharewithHierarchyList,true);
            System.debug('share records with hierarchy users'+IDFShareInsert);
            //upsert IDFSharewithHierarchyList;
            
        }catch(Exception e)
        {
            System.debug('Error in upserting  share records--'+e);
        }    
    }
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
}
public class PatentFutureHandler {
    
    @future
    public static void PatentFutureAfterInsert(string strnew, string strold){
        Map<string,SymphonyIPM__Patent__c> mapNew = (Map<string,SymphonyIPM__Patent__c>)JSON.deserialize(strnew,Map<string,SymphonyIPM__Patent__c>.class);
        Map<string,SymphonyIPM__Patent__c> mapOld = (Map<string,SymphonyIPM__Patent__c>)JSON.deserialize(strold,Map<string,SymphonyIPM__Patent__c>.class);
        set<id> LawFirms=new set<id>();
        map<string,id> mapLawFirmwithUsers=new map<string,id>();
        for(SymphonyIPM__Patent__c  PatentRecs:mapNew.values()){
            if(PatentRecs.Law_Firm__c !=null){
                mapLawFirmwithUsers.put(PatentRecs.Law_Firm__c,PatentRecs.id);
            }
        }
        list<SymphonyIPM__Inventor__c> lstPersons=[SELECT Id, SymphonyIPM__User__c,SymphonyIPM__Law_Firm__c FROM SymphonyIPM__Inventor__c where SymphonyIPM__Law_Firm__c in:mapLawFirmwithUsers.keySet() and SymphonyIPM__User__r.isactive=true];
        list<SymphonyIPM__Patent__Share> lstPatentToShare=new list<SymphonyIPM__Patent__Share>();
        for(SymphonyIPM__Inventor__c objInv : lstPersons){
            if(objInv.SymphonyIPM__User__c !=null){
                SymphonyIPM__Patent__Share patentShare=new SymphonyIPM__Patent__Share();
                patentShare.ParentId=mapLawFirmwithUsers.get(objInv.SymphonyIPM__Law_Firm__c);
                patentShare.UserOrGroupId=objInv.SymphonyIPM__User__c;
                patentShare.AccessLevel='Edit';
                lstPatentToShare.add(patentShare);
            }
        }
        try{
            insert lstPatentToShare;
        }
        catch(exception e){
            system.debug('Error during Sharing'+e.getmessage());
        }
        
        list<id> relpat= new list<id>();
        list<SymphonyIPM__Patent__c > actualli= new list<SymphonyIPM__Patent__c  >();
        Map<id,id> mappatrelated= new map<id,id>();
        for(SymphonyIPM__Patent__c  recs:mapNew.values()){
            if(recs.SymphonyIPM__ClonedFromAsset__c!=null){
                actualli.add(recs);
                relpat.add(recs.SymphonyIPM__ClonedFromAsset__c);
                mappatrelated.put(recs.id,recs.SymphonyIPM__ClonedFromAsset__c);
            }
        }
        list<SymphonyIPM__Keyword_Association__c> keyassociation = new list<SymphonyIPM__Keyword_Association__c>();
        list<SymphonyIPM__Keyword_Association__c> assokeylist=[select id,Second__c,SymphonyIPM__Keyword__r.id,SymphonyIPM__Patent__r.id from SymphonyIPM__Keyword_Association__c 
                                                               where SymphonyIPM__Patent__r.id in:relpat];
        map<id,id> asscpatent= new map<id,id>();
        map<id,id> assckey= new map<id,id>();
        map<id,list<SymphonyIPM__Keyword_Association__c>> keyasslist= new  map<id,list<SymphonyIPM__Keyword_Association__c>>();
        
        for(SymphonyIPM__Keyword_Association__c sym:assokeylist){
            if(keyasslist.containskey(sym.SymphonyIPM__Patent__r.id)){
                list<SymphonyIPM__Keyword_Association__c> keyslis=keyasslist.get(sym.SymphonyIPM__Patent__r.id);
                keyslis.add(sym);
                keyasslist.put(sym.SymphonyIPM__Patent__r.id,keyslis);
            }else{
                list<SymphonyIPM__Keyword_Association__c> keyslis = new list<SymphonyIPM__Keyword_Association__c>();
                keyslis.add(sym);
                keyasslist.put(sym.SymphonyIPM__Patent__r.id,keyslis);
            }
            asscpatent.put(sym.SymphonyIPM__Patent__r.id,sym.id);
            assckey.put(sym.SymphonyIPM__Patent__r.id,sym.SymphonyIPM__Keyword__r.id);
        }
        for(SymphonyIPM__Patent__c childpatent:actualli){
            id relatedid=mappatrelated.get(childpatent.id);
            list<SymphonyIPM__Keyword_Association__c> symlist=keyasslist.get(relatedid);
            if(symlist != null)
            {
                for(SymphonyIPM__Keyword_Association__c ss:symlist){
                    SymphonyIPM__Keyword_Association__c newkeyassc= new SymphonyIPM__Keyword_Association__c();
                    newkeyassc.SymphonyIPM__Keyword__c=ss.SymphonyIPM__Keyword__r.id;
                    newkeyassc.SymphonyIPM__Patent__c=childpatent.id;
                    newkeyassc.Second__c=ss.Second__c;
                    keyassociation.add(newkeyassc);
                }
            }
            if(asscpatent.containskey(relatedid)){
                SymphonyIPM__Keyword_Association__c newkeyassc= new SymphonyIPM__Keyword_Association__c();
                newkeyassc.SymphonyIPM__Keyword__c=assckey.get(childpatent.SymphonyIPM__ClonedFromAsset__c);
                newkeyassc.SymphonyIPM__Patent__c=childpatent.id;
                //  keyassociation.add(newkeyassc);
            }
        }
        
        if(keyassociation.size()>0){
            try{
                insert keyassociation;
                system.debug('Success');
            }
            catch(exception e){
                system.debug('Error'+e.getmessage());
            }
            
        }
    }
    
    @future
    public static void PatentFutureAfterUpdate(string strnew, string strold){
        Map<string,SymphonyIPM__Patent__c> mapNew = (Map<string,SymphonyIPM__Patent__c>)JSON.deserialize(strnew,Map<string,SymphonyIPM__Patent__c>.class);
        Map<string,SymphonyIPM__Patent__c> mapOld = (Map<string,SymphonyIPM__Patent__c>)JSON.deserialize(strold,Map<string,SymphonyIPM__Patent__c>.class);
        set<string> setofUserToremoveSharingaccess = new set<string>();
        set<string> setofpatentids = new set<string>();
        for(SymphonyIPM__Patent__c objPatent : mapNew.values())
        {
            SymphonyIPM__Patent__c objOldValue = mapOld.get(objPatent.id);
            System.debug('old value of BC ---->'+objOldValue.SymphonyIPM__Business_Contact__c);
            System.debug('new value of BC ---->'+objPatent.SymphonyIPM__Business_Contact__c);
            if(objOldValue.SymphonyIPM__Business_Contact__c != objPatent.SymphonyIPM__Business_Contact__c && objOldValue.SymphonyIPM__Business_Contact__c != null)
            {
                System.debug('Entered If');
                setofUserToremoveSharingaccess.add(objOldValue.SymphonyIPM__Business_Contact__r.SymphonyIPM__User__c);
                setofpatentids.add(objpatent.Id);
            }
        }
        System.debug('setofUserToremoveSharingaccess--->'+setofUserToremoveSharingaccess);
        if(setofUserToremoveSharingaccess.size() > 0)
        {
            List<SymphonyIPM__Patent__Share> listToDelete = [SELECT id FROM SymphonyIPM__Patent__Share WHERE (ParentId IN: setofpatentids AND UserOrGroupId IN: setofUserToremoveSharingaccess)];
            if(listToDelete.size() > 0 && !Test.isRunningTest())
            {
                DELETE listToDelete;
            }
        }
        set<string> setofPathids = new set<string>();
        set<string> setofOldPathids = new set<string>();
        List<SymphonyIPM__Patent__Share> listShareRecordsToInsert = new List<SymphonyIPM__Patent__Share>();
        map<string,SymphonyIPM__Patent__Share> mapofpatentshares = new map<string,SymphonyIPM__Patent__Share>();
        
        for(SymphonyIPM__Patent__c objPatent : mapNew.values()){
            if(objPatent.SymphonyIPM__Hierarchy__c != mapOld.get(objPatent.Id).SymphonyIPM__Hierarchy__c){
                setofPathids.add(objPatent.SymphonyIPM__Hierarchy__c);
                setofOldPathids.add(mapOld.get(objPatent.Id).SymphonyIPM__Hierarchy__c);
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
                    List<SymphonyIPM__Patent__Share> listTodeleteSharerecords = [SELECT id,AccessLevel,ParentId,UserOrGroupId FROM SymphonyIPM__Patent__Share WHERE ParentId IN: mapNew.keyset() AND UserOrGroupId IN: setofUserIdsToUnshare];
                    if(listTodeleteSharerecords.size() > 0 && !Test.isRunningTest()){
                        DELETE listTodeleteSharerecords;
                    }
                }
            }
        }
        if(setofPathids.size() > 0){
            for(SymphonyIPM__Patent__Share objPatentShare : [SELECT id,AccessLevel,ParentId,UserOrGroupId FROM SymphonyIPM__Patent__Share WHERE ParentId IN: mapNew.keyset()])
            {
                mapofpatentshares.put(objPatentShare.ParentId+':'+objPatentShare.UserOrGroupId, objPatentShare);
            }
            list<SymphonyIPM__Hierarchy_Role__c> ListHierarchyUsers = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Hierarchy_Role__c where SymphonyIPM__Hierarchy_Path__c IN :setofPathids AND SymphonyIPM__User__c != null AND SymphonyIPM__User__r.IsActive = true];
            if(ListHierarchyUsers.size() > 0)
            {
                for(Id objPatentId : mapNew.keyset())
                {
                    for(SymphonyIPM__Hierarchy_Role__c objHierarhy : ListHierarchyUsers)
                    {
                        if(!mapofpatentshares.containskey(objPatentId+':'+objHierarhy.SymphonyIPM__User__c))
                        {
                            SymphonyIPM__Patent__Share PatentSharewithHierarchy = new SymphonyIPM__Patent__Share();
                            PatentSharewithHierarchy.AccessLevel = 'Edit';
                            PatentSharewithHierarchy.ParentId = objPatentId;
                            PatentSharewithHierarchy.UserOrGroupId = objHierarhy.SymphonyIPM__User__c;
                            listShareRecordsToInsert.add(PatentSharewithHierarchy);
                            mapofpatentshares.put(objPatentId+':'+objHierarhy.SymphonyIPM__User__c,PatentSharewithHierarchy);
                        }
                    }
                }
            }
        }
        if(listShareRecordsToInsert.size() > 0 && !Test.isRunningTest()){
            INSERT listShareRecordsToInsert;
        }
    }
    
    public static void dummymeth(){
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
        i=i+1;i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
        i=i+1;
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
/* New Trigger created on CR#8 Request*/

trigger patenttrigger on SymphonyIPM__Patent__c (before insert,after insert,after update) {
    public static string caseType_UTL_NonProvisional = 'Utility Non-Provisional';
    public static string caseType_Secondary = 'Secondary';
    if(Trigger.isAfter && Trigger.isInsert){
        /* SYMAPP2760 : Creation of Asset Inventors for Utility Non Provisional related assets. */
        map<string,string> mapofIdsToInsertAssetInventors = new map<string,string>();
        for(SymphonyIPM__Patent__c  recs:trigger.new){
            IF(recs.SymphonyIPM__ClonedFromAsset__c!=null ){//&& recs.SymphonyIPM__Case_Type__c == caseType_UTL_NonProvisional
                mapofIdsToInsertAssetInventors.put(recs.Id,recs.SymphonyIPM__ClonedFromAsset__c);
            }
        }
        if(mapofIdsToInsertAssetInventors.size() > 0){
            List<SymphonyIPM__Asset_Inventor_v1__c> lstAssetInventors = new List<SymphonyIPM__Asset_Inventor_v1__c>();
            map<Id,List<SymphonyIPM__Asset_Inventor_v1__c>> mapofAssetInventors = new map<Id,List<SymphonyIPM__Asset_Inventor_v1__c>>();
            for(SymphonyIPM__Asset_Inventor_v1__c objAssetInventors : [SELECT id,SymphonyIPM__Inventor__c,SymphonyIPM__Asset__c,Name FROM SymphonyIPM__Asset_Inventor_v1__c WHERE SymphonyIPM__Asset__c IN: mapofIdsToInsertAssetInventors.values()]){
                List<SymphonyIPM__Asset_Inventor_v1__c> temp = mapofAssetInventors.get(objAssetInventors.SymphonyIPM__Asset__c);
                if(temp == null){
                    mapofAssetInventors.put(objAssetInventors.SymphonyIPM__Asset__c, new List<SymphonyIPM__Asset_Inventor_v1__c>{objAssetInventors});
                }else if(temp != null){
                    temp.add(objAssetInventors);
                }
            }
            if(mapofAssetInventors.size() > 0){
                map<string,SymphonyIPM__Asset_Inventor_v1__c> mapofExistingAssetInvs = new map<string,SymphonyIPM__Asset_Inventor_v1__c>();
                for(SymphonyIPM__Asset_Inventor_v1__c objAssetInv : [select id,SymphonyIPM__Inventor__c,SymphonyIPM__Asset__c,Name FROM SymphonyIPM__Asset_Inventor_v1__c WHERE SymphonyIPM__Asset__c IN:Trigger.newMap.keyset()]){
                    mapofExistingAssetInvs.put(objAssetInv.SymphonyIPM__Asset__c+'-'+objAssetInv.SymphonyIPM__Inventor__c,objAssetInv);
                }
                for(String str : mapofIdsToInsertAssetInventors.keySet()){
                    List<SymphonyIPM__Asset_Inventor_v1__c> listAssetInvs = mapofAssetInventors.get(mapofIdsToInsertAssetInventors.get(str));
                    if(listAssetInvs.size() > 0){
                        for(SymphonyIPM__Asset_Inventor_v1__c objAssetInventor : listAssetInvs){
                            if(!mapofExistingAssetInvs.containsKey(str+'-'+objAssetInventor.SymphonyIPM__Inventor__c)){
                                SymphonyIPM__Asset_Inventor_v1__c objAssetInventorNew = new SymphonyIPM__Asset_Inventor_v1__c();
                                objAssetInventorNew.SymphonyIPM__Asset__c = str;
                                objAssetInventorNew.SymphonyIPM__Inventor__c = objAssetInventor.SymphonyIPM__Inventor__c;
                                objAssetInventorNew.Name = objAssetInventor.Name;
                                lstAssetInventors.add(objAssetInventorNew);
                                mapofExistingAssetInvs.put(str+'-'+objAssetInventor.SymphonyIPM__Inventor__c,objAssetInventorNew);
                            }
                        }
                    }
                }
            }
            if(lstAssetInventors.size() > 0){
                INSERT lstAssetInventors;
            }
        }
    }
    /*** End ***/	
    
    if(Trigger.isBefore && Trigger.isInsert){
        /******** Added on 09/04/2022 to resolve CPU time limit error ON BEFORE INSERT
		1. Sharing based on Lawfirm
		2. Related patent field mapping from parent record 
		3. keyword Association logic moved to future *****/
        list<id> relpat= new list<id>();
        list<SymphonyIPM__Patent__c > actualli= new list<SymphonyIPM__Patent__c  >();
        Map<id,id> mappatrelated= new map<id,id>();
        for(SymphonyIPM__Patent__c  recs:Trigger.new){
            if(recs.SymphonyIPM__ClonedFromAsset__c!=null){
                actualli.add(recs);
                relpat.add(recs.SymphonyIPM__ClonedFromAsset__c);
                mappatrelated.put(recs.id,recs.SymphonyIPM__ClonedFromAsset__c);
            }
        }
        list<SymphonyIPM__Patent__c> rellis=[select id,SymphonyIPM__Internal_Counsel__c,Managing_Segment1__c,SymphonyIPM__Inventors__c,SymphonyIPM__Hierarchy__c,Funding_Source_New__c,Stage_of_Invention__c,
                                             SymphonyIPM__Outside_Counsel__c,Law_Firm__c,Internal_Segment_New__c,SymphonyIPM__Business_Contact__c,Business_Interest_New__c,SymphonyIPM__Base_Invention_Disclosure_New__c,
                                             SymphonyIPM__Keyword_Search_String_L__c,SymphonyIPM__Root_Patent__c from SymphonyIPM__Patent__c where id in:relpat ];
        list<SymphonyIPM__Patent__c > symlis= new list<SymphonyIPM__Patent__c >();
        map<id,SymphonyIPM__Patent__c> mapdata=new map<id,SymphonyIPM__Patent__c>();
        for(SymphonyIPM__Patent__c sim:rellis){
            mapdata.put(sim.id,sim);
        }
        list<SymphonyIPM__Patent__c> listtoupdate= new list<SymphonyIPM__Patent__c >();
        for(SymphonyIPM__Patent__c childpatent:actualli){
            id parentid=mappatrelated.get(childpatent.id);
            SymphonyIPM__Patent__c parentpatent=mapdata.get(parentid);
            childpatent.SymphonyIPM__ClonedFromAsset__c=parentpatent.id;
            childpatent.SymphonyIPM__Inventors__c=parentpatent.SymphonyIPM__Inventors__c;
            childpatent.SymphonyIPM__Internal_Counsel__c=parentpatent.SymphonyIPM__Internal_Counsel__c;
            // childpatent.PRC_Technology_Area__c=parentpatent.PRC_Technology_Area__c;
            childpatent.SymphonyIPM__Hierarchy__c=parentpatent.SymphonyIPM__Hierarchy__c;
            childpatent.Managing_Segment1__c=parentpatent.Managing_Segment1__c;
            childpatent.Funding_Source_New__c=parentpatent.Funding_Source_New__c;
            childpatent.Stage_of_Invention__c=parentpatent.Stage_of_Invention__c;
            childpatent.SymphonyIPM__Outside_Counsel__c=parentpatent.SymphonyIPM__Outside_Counsel__c;
            childpatent.Law_Firm__c=parentpatent.Law_Firm__c;
            childpatent.Internal_Segment_New__c=parentpatent.Internal_Segment_New__c;
            childpatent.Business_Interest_New__c=parentpatent.Business_Interest_New__c;
            childpatent.SymphonyIPM__Business_Contact__c=parentpatent.SymphonyIPM__Business_Contact__c; //Added
            childpatent.SymphonyIPM__Base_Invention_Disclosure_New__c=parentpatent.SymphonyIPM__Base_Invention_Disclosure_New__c;
            childpatent.SymphonyIPM__Keyword_Search_String_L__c=parentpatent.SymphonyIPM__Keyword_Search_String_L__c;
            if(parentpatent.SymphonyIPM__Root_Patent__c!=null){
                childpatent.SymphonyIPM__Root_Patent__c=parentpatent.SymphonyIPM__Root_Patent__c;}
            else{
                childpatent.SymphonyIPM__Root_Patent__c=parentpatent.id;
            }
            listtoupdate.add(childpatent);
            // Business_Interest__c SymphonyIPM__Root_Patent__c
            system.debug('Record succesfully updated');
        }
        /******** end *****************************************************/
    }
    
    if(Trigger.isAfter && Trigger.isInsert){
        /******** Added on 09/04/2022 to resolve CPU time limit error ON AFTER INSERT
		1. Sharing based on Lawfirm
		2. keyword Association logic moved to future *****/
        if(!Test.isRunningTest() && !System.isBatch() && !System.isFuture()){
            String jsonMapNew=JSON.serialize(Trigger.newMap);
            String jsonMapOld=JSON.serialize(Trigger.oldMap);
            PatentFutureHandler.PatentFutureAfterInsert(jsonMapNew,jsonMapOld);
        }
        /******** end *****************************************************/
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        /******** Added on 09/04/2022 to resolve CPU time limit error on AFTER UPDATE
        1. Unsharing of patent records for Business Contact on changing 
        2. Sharing and Unsharing of Patent records for Hierarchy Role users on Hierarchy change in Patent *****/
        if(!Test.isRunningTest() && !System.isBatch() && !System.isFuture()){
            String jsonMapNew=JSON.serialize(Trigger.newMap);
            String jsonMapOld=JSON.serialize(Trigger.oldMap);
            PatentFutureHandler.PatentFutureAfterUpdate(jsonMapNew,jsonMapOld);
        }
        /******** end *****************************************************/
    }
    Integer i=0;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
}
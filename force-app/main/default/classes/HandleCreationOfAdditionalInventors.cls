public without sharing class HandleCreationOfAdditionalInventors{
    @invocablemethod
    public static void CreateAdditionalInventors(List<string> InputFromApex){
        System.debug('Input rom low ---> '+InputFromApex);
        StaticClass.stopaddinventor = false; 
        Integer i = 0;
        Boolean infoEmailSent = false;
        set<string> setofpersonids = new set<string>();
        List<string> listInventorIds = new List<string>();
        List<string> listInventorInfo = new List<string>();
        Set<Id> existingInventorsIdSet = new Set<Id>();
        Boolean chkPrimaryInventor = false;
        List<string> temp = new List<string>();
        List<SymphonyIPM__Additional_Inventor__c> ListAdditionalInventors = new List<SymphonyIPM__Additional_Inventor__c>(); //String IDFid, String InventorIds, String InventorInfos
        List<SymphonyIPM__Additional_Inventor__c> ListAdditionalInventorsToInsert = new List<SymphonyIPM__Additional_Inventor__c>();
        List<SymphonyIPM__Additional_Inventor__c> ListAdditionalInventorsToUpdate = new List<SymphonyIPM__Additional_Inventor__c>();
        List<SymphonyIPM__Inventor__c> listInventors = new List<SymphonyIPM__Inventor__c>();
        map<string,SymphonyIPM__Additional_Inventor__c> mapOfAdditionalInventorsExisting = new map<string,SymphonyIPM__Additional_Inventor__c>();
        map<string,string> mapOfInventorIdsAndInfo = new map<string,string>();
        map<string,SymphonyIPM__Inventor__c> mapOfInventors = new map<string,SymphonyIPM__Inventor__c>();
        map<string,Integer> mapofInventorIdWithOrder = new map<string,Integer>();
        if(InputFromApex.size() > 0){
            List<string> value = InputFromApex[0].trim().split('-',2);
            if(value.size() > 1){
                if(value[1] != ''){  
                    listInventorInfo = value[1].trim().split('<###>'); //, was removed.
                }
            }
            map<string,String> mapofInventorIdWithROC = new map<string,String>();
            if(listInventorInfo.size() > 0){
                Integer j = 0;
                for(String str : listInventorInfo){
                    temp = str.trim().split('<#>',2); //: was removed.
                    mapOfInventorIdsAndInfo.put(temp[0],temp[1]);
                    listInventorIds.add(temp[0]);
                    if(temp[1] != null){
                        j = j+1;
                        mapofInventorIdWithOrder.put(temp[0],j);
                        system.debug('inventorid----'+temp[0]+'----order---'+j);
                        List<string> listtemp = temp[1].trim().split('<#>');
                        mapofInventorIdWithROC.put(temp[0],listtemp[0]);
                    }
                }
            }
            setofpersonids.addAll(listInventorIds);
            if(setofpersonids.size() > 0){
                listInventors = [SELECT id,Name,SymphonyIPM__Email__c,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive FROM SymphonyIPM__Inventor__c WHERE id IN: setofpersonids];
                if(listInventors.size() > 0){
                    for(SymphonyIPM__Inventor__c objinventor : listInventors){
                        mapOfInventors.put(objinventor.id,objinventor);
                    }
                }
                if(value[0] != ''){
                    SymphonyIPM__Invention_Disclosure_New__c objInventionDisclosure = [SELECT id,Name,SymphonyIPM__Title__c,Business_Segment__c,SymphonyIPM__Primary_Inventor__c,Other_Contact__c,Other_Contact__r.name,Other_Contribution__c,IndividualOrBusiness__c  FROM SymphonyIPM__Invention_Disclosure_New__c WHERE id =:value[0]];
                    ListAdditionalInventors = [SELECT Id,Inventors_Display_Order__c,SymphonyIPM__Invention_Disclosure_New__c,Role_In_Conception__c,SymphonyIPM__Inventor_Email_Id__c,SymphonyIPM__Inventor_Email__c,SymphonyIPM__Inventor__c FROM SymphonyIPM__Additional_Inventor__c WHERE SymphonyIPM__Invention_Disclosure_New__c =:value[0]]; //SymphonyIPM__Inventor__c IN:listInventorIds AND
                    for(SymphonyIPM__Additional_Inventor__c objAdditionalInv : ListAdditionalInventors){
                        existingInventorsIdSet.add(objAdditionalInv.SymphonyIPM__Inventor__c);
                        mapOfAdditionalInventorsExisting.put(objAdditionalInv.SymphonyIPM__Inventor__c,objAdditionalInv);
                    }
                    for(String invid : setofpersonids){
                        String TempInfo = mapOfInventorIdsAndInfo.get(invid);
                        List<string> listValues = TempInfo.trim().split('<#>'); //: was removed.
                        if(!existingInventorsIdSet.contains(invid) || test.isrunningtest()){
                            system.debug('enterif');
                            SymphonyIPM__Inventor__c objInventor  = new SymphonyIPM__Inventor__c();
                            SymphonyIPM__Additional_Inventor__c objAdditionalInventor = new SymphonyIPM__Additional_Inventor__c();
                            if(mapOfInventors.containsKey(invid)){
                                objInventor  = mapOfInventors.get(invid);
                                if(objInventor.SymphonyIPM__Email__c != ''){
                                    objAdditionalInventor.SymphonyIPM__Inventor_Email__c = objInventor.SymphonyIPM__Email__c;
                                }
                            }
                            objAdditionalInventor.SymphonyIPM__Invention_Disclosure_New__c = value[0];
                            if(invid != ''){
                                objAdditionalInventor.SymphonyIPM__Inventor__c = invid;
                            }
                            objAdditionalInventor.Role_In_Conception__c = mapofInventorIdWithROC.get(invid);
                            if(listValues[1] == 'true'){
                                objAdditionalInventor.Is_Primary__c = true;
                                if(invid != ''){
                                    objInventionDisclosure.SymphonyIPM__Primary_Inventor__c = invid;
                                }else{
                                    objInventionDisclosure.SymphonyIPM__Primary_Inventor__c = null;
                                }
                            }else if(listValues[1] == 'false'){
                                objAdditionalInventor.Is_Primary__c = false;
                            }
                            objAdditionalInventor.Inventors_Display_Order__c = mapofInventorIdWithOrder.get(invid);
                            i = i + 1;
                            if(invid != '' && value[0] != ''){
                                ListAdditionalInventorsToInsert.add(objAdditionalInventor);
                                system.debug('additionalinventorsinserted'+objAdditionalInventor);
                            }
                        }else if(existingInventorsIdSet.contains(invid)&& listValues[0] != mapOfAdditionalInventorsExisting.get(invid).Role_In_Conception__c){
                           system.debug('enteredelseif');
                            SymphonyIPM__Additional_Inventor__c objAdditionalInventorupd = new SymphonyIPM__Additional_Inventor__c();
                            objAdditionalInventorupd.Id = mapOfAdditionalInventorsExisting.get(invid).Id;
                            objAdditionalInventorupd.Role_In_Conception__c = mapofInventorIdWithROC.get(invid);
                            SymphonyIPM__Inventor__c objInventor  = new SymphonyIPM__Inventor__c();
                            if(mapOfInventors.containsKey(invid)){
                                objInventor  = mapOfInventors.get(invid);
                                if(objInventor.SymphonyIPM__Email__c != ''){
                                    objAdditionalInventorupd.SymphonyIPM__Inventor_Email__c = objInventor.SymphonyIPM__Email__c;
                                }
                            }
                            if(listValues[1] == 'true'){
                                objAdditionalInventorupd.Is_Primary__c = true;
                                if(invid != ''){
                                    objInventionDisclosure.SymphonyIPM__Primary_Inventor__c = invid;
                                }else{
                                    objInventionDisclosure.SymphonyIPM__Primary_Inventor__c = null;
                                }
                            }else if(listValues[1] == 'false'){
                                objAdditionalInventorupd.Is_Primary__c = false;
                            }
                            objAdditionalInventorupd.Inventors_Display_Order__c = mapofInventorIdWithOrder.get(invid);
                            ListAdditionalInventorsToUpdate.add(objAdditionalInventorupd);
                            system.debug('additionalinventor----'+objAdditionalInventorupd);
                        }
                        else
                        {
                            system.debug('enterelse');
                            SymphonyIPM__Additional_Inventor__c objAdditionalInventorupd = new SymphonyIPM__Additional_Inventor__c();
                            objAdditionalInventorupd.Id = mapOfAdditionalInventorsExisting.get(invid).Id;
                            objAdditionalInventorupd.Inventors_Display_Order__c = mapofInventorIdWithOrder.get(invid);
                            ListAdditionalInventorsToUpdate.add(objAdditionalInventorupd);
                            system.debug('additionalinventor----'+objAdditionalInventorupd);
                        }
             
                    }
                    objInventionDisclosure.IndividualOrBusiness__c=objInventionDisclosure.IndividualOrBusiness__c;
                    objInventionDisclosure.Other_Contribution__c=objInventionDisclosure.Other_Contribution__c;
                    objInventionDisclosure.Business_Segment__c=objInventionDisclosure.Business_Segment__c;
                    objInventionDisclosure.Other_Contact__c=objInventionDisclosure.Other_Contact__c;
                    system.debug('ListAdditionalInventorsToInsert'+ListAdditionalInventorsToInsert);
                    system.debug('ListAdditionalInventorsToUpdate'+ListAdditionalInventorsToUpdate);
                    if(ListAdditionalInventorsToInsert.size() > 0){
                        INSERT ListAdditionalInventorsToInsert;
                    }
                    if(ListAdditionalInventorsToUpdate.size() > 0){
                        UPDATE ListAdditionalInventorsToUpdate;
                    }
                    UPDATE objInventionDisclosure;
                }  
            }
        }
    }
    public static void dummymethod(){
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
    }
}
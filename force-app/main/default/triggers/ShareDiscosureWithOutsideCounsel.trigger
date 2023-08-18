trigger ShareDiscosureWithOutsideCounsel on SymphonyIPM__Invention_Disclosure_New__c  (after update, after insert) 
{
set<Id> OC = new set<Id>();
        set<Id> newOC = new set<Id>();
        list<SymphonyIPM__Inventor__c> SharewithOc = new list<SymphonyIPM__Inventor__c>();
        set<SymphonyIPM__Invention_Disclosure_New__Share>  idfShare = new set<SymphonyIPM__Invention_Disclosure_New__Share>(); 
    list<SymphonyIPM__Invention_Disclosure_New__Share> deleteShare = new list<SymphonyIPM__Invention_Disclosure_New__Share>();
    list<SymphonyIPM__Invention_Disclosure_New__Share> disclosureShare = new list<SymphonyIPM__Invention_Disclosure_New__Share>();
if(trigger.isAfter){
    
        if(trigger.isUpdate ){
 for (SymphonyIPM__Invention_Disclosure_New__c idf : trigger.new) 
    {
    
       SymphonyIPM__Invention_Disclosure_New__c  oldIdf = Trigger.oldMap.get(idf.Id);
        system.debug('old lawfirm'+oldIdf.Law_Firm__c);
        system.debug('new lawfirm'+idf.Law_Firm__c);
      
        if (idf.Law_Firm__c != oldIdf.Law_Firm__c) 
        {
        
            
        if(oldIdf.Law_Firm__c != null)
            {
               list<SymphonyIPM__Inventor__c> OcDetail = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Inventor__c where SymphonyIPM__Law_Firm__c =: oldIdf.Law_Firm__c AND SymphonyIPM__User__c != null];
               if(OcDetail.size()>0)
               {
                  for(SymphonyIPM__Inventor__c loopOc : OcDetail)
                   {
               OC.add(loopOc.SymphonyIPM__User__c);
                   }
                deleteShare = [select id from SymphonyIPM__Invention_Disclosure_New__Share where UserOrGroupId IN : OC AND ParentId =: idf.Id];
               }
                system.debug('Delete share records'+deleteShare);
               if(deleteShare.size()>0)
                {
                delete deleteShare;
                }
            }
        if(idf.Law_Firm__c != null)
            {
            SharewithOc = [select id,name,SymphonyIPM__User__c,SymphonyIPM__User__r.IsActive from SymphonyIPM__Inventor__c where SymphonyIPM__Law_Firm__c =: idf.Law_Firm__c AND SymphonyIPM__User__c != null AND SymphonyIPM__RecordTypeName__c='OC' AND SymphonyIPM__User__r.IsActive=true];
              for(SymphonyIPM__Inventor__c addOc : SharewithOc)
              {
              newOC.add(addOc.SymphonyIPM__User__c);
              }
              
              for(id shareidfid : newOC)
                {
            SymphonyIPM__Invention_Disclosure_New__Share createshare = new SymphonyIPM__Invention_Disclosure_New__Share();
                                createshare.parentId = idf.id;
                                createshare.UserOrGroupId=shareidfid;
                                createshare.AccessLevel='Edit';
                                idfShare.add(createshare);
                }
            }
            
              
        } 
        disclosureShare.addAll(idfShare);
        system.debug('Disclosure share after update'+disclosureShare);
              if(disclosureShare.size()>0) 
              {
              insert disclosureShare;
              }         
    }
}
if(trigger.isInsert ){
    for (SymphonyIPM__Invention_Disclosure_New__c idf : trigger.new) 
    {
if(idf.Law_Firm__c != null)
            {
            SharewithOc = [select id,name,SymphonyIPM__User__c from SymphonyIPM__Inventor__c where SymphonyIPM__Law_Firm__c =: idf.Law_Firm__c AND SymphonyIPM__User__c != null AND SymphonyIPM__RecordTypeName__c='OC'];
              for(SymphonyIPM__Inventor__c addOc : SharewithOc)
              {
              newOC.add(addOc.SymphonyIPM__User__c);
              }
              if(newOC.size()>0)
              {
              for(id shareidfid : newOC)
                {
            SymphonyIPM__Invention_Disclosure_New__Share createshare = new SymphonyIPM__Invention_Disclosure_New__Share();
                                createshare.parentId = idf.id;
                                createshare.UserOrGroupId=shareidfid;
                                createshare.AccessLevel='Edit';
                                idfShare.add(createshare);
                }
            }
            }

}
disclosureShare.addAll(idfShare);
              if(disclosureShare.size()>0)
{
insert disclosureShare;
}
}
}
}
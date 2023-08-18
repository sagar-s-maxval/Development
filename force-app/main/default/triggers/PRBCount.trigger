trigger PRBCount on SymphonyIPM__IDF_Review__c (after insert,after update) {
    Map<Id, Set<Id>> Asset_Ratings = new Map<Id, Set<Id>>();
    integer Prbsize;
for(SymphonyIPM__IDF_Review__c Asset: Trigger.new){
      if (!Asset_Ratings.containsKey(Asset.SymphonyIPM__Base_Invention_Disclosure__c)) {
          Asset_Ratings.put(Asset.SymphonyIPM__Base_Invention_Disclosure__c, new Set<Id>());
      }
      Asset_Ratings.get(Asset.SymphonyIPM__Base_Invention_Disclosure__c).add(Asset.PRC_Meeting_ID__c);
    
    
}
Map<Id, set<id>> All_Asset = new Map<Id, set<id>>();
for(SymphonyIPM__IDF_Review__c review : [select id,PRC_Meeting_ID__c,SymphonyIPM__Base_Invention_Disclosure__c from SymphonyIPM__IDF_Review__c where SymphonyIPM__Base_Invention_Disclosure__c IN : Asset_Ratings.keySet()])
    {
        if(review.PRC_Meeting_ID__c != null){
	if (!All_Asset.containsKey(review.SymphonyIPM__Base_Invention_Disclosure__c)) {
          All_Asset.put(review.SymphonyIPM__Base_Invention_Disclosure__c, new Set<Id>());
      }
      All_Asset.get(review.SymphonyIPM__Base_Invention_Disclosure__c).add(review.PRC_Meeting_ID__c);
	}
    }
    system.debug('all asset ratings'+All_Asset);
    list<SymphonyIPM__Invention_Disclosure_New__c> idflist = new list<SymphonyIPM__Invention_Disclosure_New__c>();
system.debug('Map values'+Asset_Ratings);
    for(SymphonyIPM__Invention_Disclosure_New__c idf : [select id,Review_Count__c from SymphonyIPM__Invention_Disclosure_New__c where id IN: All_Asset.keySet()])
    {
        
        idf.Review_Count__c = All_Asset.get(idf.id).size();
        idflist.add(idf);
    }
    system.debug('List of disclosures to be updated'+idflist);
    update idflist;
}
public class AssetRatingtriggerHelper {
    public static void updateRatingField(List<SymphonyIPM__IDF_Review__c> ratinglist) {
         Set<Id> IdfIds = new Set<Id>();
        for (SymphonyIPM__IDF_Review__c ra : ratinglist) {
            if(ra.SymphonyIPM__Base_Invention_Disclosure__c!=null)
            IdfIds.add(ra.SymphonyIPM__Base_Invention_Disclosure__c);
        }
      Map<String, List<String>> mapratingToUserIds = new Map<String, List<String>>(); 
      // List<SymphonyIPM__IDF_Review__c> allRatings = ;
        for(SymphonyIPM__IDF_Review__c allRatings:[SELECT Id, CreatedBy.id,SymphonyIPM__Base_Invention_Disclosure__c FROM SymphonyIPM__IDF_Review__c WHERE SymphonyIPM__Base_Invention_Disclosure__c IN:IdfIds ]){
            List<String> temp;
            if(mapratingToUserIds.containskey(allRatings.SymphonyIPM__Base_Invention_Disclosure__c)){
                 temp = mapratingToUserIds.get(allRatings.SymphonyIPM__Base_Invention_Disclosure__c);
            }else{ temp = new List<String>();}
            temp.add(allRatings.CreatedBy.id);
            mapratingToUserIds.put(allRatings.SymphonyIPM__Base_Invention_Disclosure__c,temp);
        }    
      List<SymphonyIPM__Invention_Disclosure_New__c> invdislist=[select id,Ratings_Provided_By__c from SymphonyIPM__Invention_Disclosure_New__c where id in:mapratingToUserIds.keyset()];
       List<SymphonyIPM__Invention_Disclosure_New__c> updateidflist= new List<SymphonyIPM__Invention_Disclosure_New__c>();
        for(SymphonyIPM__Invention_Disclosure_New__c idf:invdislist){
            clearIdfRatingField(idf.id);
            idf.Ratings_Provided_By__c=String.join(mapratingToUserIds.get(idf.id),';');
            updateidflist.add(idf);
        }
        if(updateidflist.size()>0)
        update updateidflist;
        
    }
    
       private static SymphonyIPM__Invention_Disclosure_New__c clearIdfRatingField(Id Idfif) {
        return new SymphonyIPM__Invention_Disclosure_New__c(
                Id = Idfif,
                Ratings_Provided_By__c = '');
    }
}
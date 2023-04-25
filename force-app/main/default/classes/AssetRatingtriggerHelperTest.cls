@istest
public class AssetRatingtriggerHelperTest {
     @IsTest
    public static  void testRating() {
          SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test');
        insert idf;

        insert new SymphonyIPM__IDF_Review__c(SymphonyIPM__Base_Invention_Disclosure__c = idf.Id);
       SymphonyIPM__IDF_Review__c idfreview=[select id from SymphonyIPM__IDF_Review__c limit 1];
        delete idfreview;
    }

}
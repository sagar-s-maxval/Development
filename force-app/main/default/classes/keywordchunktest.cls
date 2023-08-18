@isTest
public class keywordchunktest {
   static testMethod void testmeth(){
       SymphonyIPM__Keyword__c objkey = new SymphonyIPM__Keyword__c();
objkey.Name = 'Keyword';
INSERT objkey;

       Test.startTest();
       Keywordchunk objKeywordchunk = new Keywordchunk(new List<SymphonyIPM__Keyword__c>{objkey});
Database.executeBatch(objKeywordchunk );
       Test.stopTest();
       
   }
}
@istest(seealldata=false)
public class Patenttriggertest {
@istest
    public static void met1(){
        
        test.startTest();
        
        SymphonyIPM__Hierarchy__c objhierarchy = new SymphonyIPM__Hierarchy__c(Name='Name');
        INSERT objhierarchy;
        
        //SymphonyIPM__Hierarchy__c ss=[select id from SymphonyIPM__Hierarchy__c limit 1];
        /*user out=[select id from user limit 1];
        
        SymphonyIPM__Law_Firm__c objLawfirm = new SymphonyIPM__Law_Firm__c(Name='Name');
        INSERT objLawfirm;
        //SymphonyIPM__Law_Firm__c law=[select id from SymphonyIPM__Law_Firm__c limit 1];
         SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
       
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',
                 SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id  );
        insert keyWord1;
       list<SymphonyIPM__Keyword__c> listkey = new list<SymphonyIPM__Keyword__c>();
        listkey.add(keyWord);*/
                    SymphonyIPM__Patent__c pat1= new SymphonyIPM__Patent__c();
                    pat1.Name='test 1';
                    pat1.SymphonyIPM__Title_of_Invention__c='trst tile 1';
                    insert pat1;
         /*SymphonyIPM__Keyword_Association__c assoc1=new SymphonyIPM__Keyword_Association__c();
        assoc1.SymphonyIPM__Patent__c =pat1.Id;
        assoc1.SymphonyIPM__Keyword__c =keyWord1.Id;
        insert assoc1;*/
                    SymphonyIPM__Patent__c pat= new SymphonyIPM__Patent__c();
                    pat.Name='test';
                    pat.SymphonyIPM__Hierarchy__c= objhierarchy.id;
                    pat.Managing_Segment1__c='Amil';
                    pat.SymphonyIPM__ClonedFromAsset__c=pat1.id;
                    //pat.Funding_Source__c='PRB/Central Budget';
                    //pat.SymphonyIPM__Outside_Counsel__c=out.id;
                    pat.SymphonyIPM__Title_of_Invention__c='trst tile';
                    //pat.SymphonyIPM__ClonedFromAsset__c=pat1.id;
                    //pat.Law_Firm__c=objLawfirm.id;
                    insert pat;
         /*SymphonyIPM__Keyword_Association__c assoc=new SymphonyIPM__Keyword_Association__c();
        assoc.SymphonyIPM__Patent__c =pat.Id;
        assoc.SymphonyIPM__Keyword__c =keyWord1.Id;
        insert assoc;*/
         PatentFutureHandler.dummymeth();
        test.stopTest();
        
    }
  
}
@isTest
private class TaxonomyHierarchyControllerTest {
     @isTest
    static void testkeychunk(){
        
         SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id);
        insert keyWord1;
       list<SymphonyIPM__Keyword__c> listkey = new list<SymphonyIPM__Keyword__c>();
        listkey.add(keyWord);
        // listkey.add(keyWord1);
        test.startTest();
         Database.executeBatch(new Keywordchunk(listkey), 1);
        test.stopTest();
    }
       @isTest
    static void triggerupdatetest(){
        
         SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id);
        insert keyWord1;
        keyWord.name='test update';
        update keyWord;
        delete keyWord1;
    }
    @isTest
    static void testsecondfalse(){
         SymphonyIPM__Patent__c  objPatent = new SymphonyIPM__Patent__c();
        objPatent.SymphonyIPM__Title_of_Invention__c = 'Patent';
        objPatent.SymphonyIPM__Inventors__c = 'Inventor 1';
        INSERT objPatent;
        
        SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id);
        insert keyWord1;
            
        SymphonyIPM__Keyword_Association__c assoc=new SymphonyIPM__Keyword_Association__c();
        assoc.SymphonyIPM__Patent__c =objPatent.Id;
        assoc.SymphonyIPM__Keyword__c =keyWord.Id;
        insert assoc;
         string str=TaxonomyHierarchyController.updatefalsewords(assoc.Id);
         string str1=TaxonomyHierarchyController.updatefalsewords(keyWord1.Id);
    }
      @isTest
    static void testsecondtrue(){
         SymphonyIPM__Patent__c  objPatent = new SymphonyIPM__Patent__c();
        objPatent.SymphonyIPM__Title_of_Invention__c = 'Patent';
        objPatent.SymphonyIPM__Inventors__c = 'Inventor 1';
        INSERT objPatent;
        
        SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id);
        insert keyWord1;
            
        SymphonyIPM__Keyword_Association__c assoc=new SymphonyIPM__Keyword_Association__c();
        assoc.SymphonyIPM__Patent__c =objPatent.Id;
        assoc.SymphonyIPM__Keyword__c =keyWord.Id;
        insert assoc;
         string str=TaxonomyHierarchyController.updateKeywords(assoc.Id);
         string str1=TaxonomyHierarchyController.updateKeywords(keyWord1.Id);
    }
    @isTest
    static void loadData(){
        SymphonyIPM__Patent__c  objPatent = new SymphonyIPM__Patent__c();
        objPatent.SymphonyIPM__Title_of_Invention__c = 'Patent';
        objPatent.SymphonyIPM__Inventors__c = 'Inventor 1';
        INSERT objPatent;
        
        SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id);
        insert keyWord1;
            
        SymphonyIPM__Keyword_Association__c assoc=new SymphonyIPM__Keyword_Association__c();
        assoc.SymphonyIPM__Patent__c =objPatent.Id;
        assoc.SymphonyIPM__Keyword__c =keyWord.Id;
        insert assoc;
        
        SymphonyIPM__Keyword__c keyWord2=new SymphonyIPM__Keyword__c(Name ='A:1:B',SymphonyIPM__Keyword_Hierarchy__c=keyWord1.Id);
        List<SymphonyIPM__Keyword__c> lstKeyword=new List<SymphonyIPM__Keyword__c>();
        lstKeyword.add(keyWord2);
        
        SymphonyIPM__Keyword_Association__c assoc1=new SymphonyIPM__Keyword_Association__c();
        assoc1.SymphonyIPM__Patent__c =objPatent.Id;
        assoc1.SymphonyIPM__Keyword__c =keyWord1.Id;
        insert assoc1;
        
        /*SymphonyIPM__Keyword_Association__c assoc2=new SymphonyIPM__Keyword_Association__c();
        assoc2.SymphonyIPM__Patent__c =objPatent.Id;
        assoc2.SymphonyIPM__Keyword__c =keyWord1.Id;
        insert assoc2;*/
        
        TaxonomyHierarchyController.fetchKeywords(objPatent.Id);
        TaxonomyHierarchyController.getKeyword(keyWord1.Id);
        TaxonomyHierarchyController.fetchHierarchyKeywords();
        TaxonomyHierarchyController.fetchAllKeywords();
        TaxonomyHierarchyController.fetchLookUpValues('A');
        TaxonomyHierarchyController.saveRecords(objPatent.Id,lstKeyword);
        TaxonomyHierarchyController.fetchKeywords(objPatent.Id);
        TaxonomyHierarchyController.deleteKeywords(objPatent.Id,'A:1:B');
            
    }
    
    @isTest
    static void loadData1(){
        SymphonyIPM__Patent__c  objPatent = new SymphonyIPM__Patent__c();
        objPatent.SymphonyIPM__Title_of_Invention__c = 'Patent';
        objPatent.SymphonyIPM__Inventors__c = 'Inventor 1';
        INSERT objPatent;
        
        SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id);
        insert keyWord1;
            
        SymphonyIPM__Keyword__c keyWord2=new SymphonyIPM__Keyword__c(Name ='A:1:B',SymphonyIPM__Keyword_Hierarchy__c=keyWord1.Id);
        List<SymphonyIPM__Keyword__c> lstKeyword=new List<SymphonyIPM__Keyword__c>();
        lstKeyword.add(keyWord2);
        
        SymphonyIPM__Keyword_Association__c assoc2=new SymphonyIPM__Keyword_Association__c();
        assoc2.SymphonyIPM__Patent__c =objPatent.Id;
        assoc2.SymphonyIPM__Keyword__c =keyWord1.Id;
        insert assoc2;
        
        TaxonomyHierarchyController.fetchKeywords(objPatent.Id);
            
    }
    
    @isTest
    static void loadData2(){
        SymphonyIPM__Patent__c  objPatent = new SymphonyIPM__Patent__c();
        objPatent.SymphonyIPM__Title_of_Invention__c = 'Patent';
        objPatent.SymphonyIPM__Inventors__c = 'Inventor 1';
        INSERT objPatent;
        
        SymphonyIPM__Keyword__c keyWord=new SymphonyIPM__Keyword__c(Name ='A');
        insert keyWord;
        
        SymphonyIPM__Keyword__c keyWord1=new SymphonyIPM__Keyword__c(Name ='A:1',SymphonyIPM__Keyword_Hierarchy__c=keyWord.Id);
        insert keyWord1;
        
        SymphonyIPM__Keyword__c keyWord2=new SymphonyIPM__Keyword__c(Name ='A:1:B',SymphonyIPM__Keyword_Hierarchy__c=keyWord1.Id);
        List<SymphonyIPM__Keyword__c> lstKeyword=new List<SymphonyIPM__Keyword__c>();
        lstKeyword.add(keyWord2);
        
        
        SymphonyIPM__Keyword_Association__c assoc2=new SymphonyIPM__Keyword_Association__c();
        assoc2.SymphonyIPM__Patent__c =objPatent.Id;
        assoc2.SymphonyIPM__Keyword__c =keyWord1.Id;
        insert assoc2;
        
        TaxonomyHierarchyController.fetchKeywords(objPatent.Id);
            
    }

}
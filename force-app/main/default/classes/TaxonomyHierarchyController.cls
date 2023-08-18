public class TaxonomyHierarchyController {

    public class Hierarchy{
        @auraEnabled public String level1;
        @auraEnabled public String level2;
        @auraEnabled public String level3;
        @auraEnabled public String level4;
		 @auraEnabled public String level5;
    }
    //new Method
      @auraEnabled
    public static String updatefalsewords(Id recordId){ 
        try{
            SymphonyIPM__Keyword_Association__c keyAsscoidated=[select id,Second__c from SymphonyIPM__Keyword_Association__c
                                                               where id=:recordId];
            keyAsscoidated.Second__c=false;
            update keyAsscoidated;
            return 'success';
        }
        catch(Exception e){
            system.debug('Exception Occcured'+e.getMessage());
            string retstr=e.getMessage();
            return retstr;
        }
        
    }

     @auraEnabled
    public static String updateKeywords(Id recordId){ 
        try{
            SymphonyIPM__Keyword_Association__c keyAsscoidated=[select id,Second__c from SymphonyIPM__Keyword_Association__c
                                                               where id=:recordId];
            keyAsscoidated.Second__c=true;
            update keyAsscoidated;
            return 'success';
        }
        catch(Exception e){
            system.debug('Exception Occcured'+e.getMessage());
            string retstr=e.getMessage();
            return retstr;
        }
        
    }
    
    @auraEnabled
    public static String fetchKeywords(Id recordId){ //Map<String,Map<String,Map<String,String>>>
        Map<String,Map<String,Map<String,Map<String,String>>>> mapResponse=new Map<String,Map<String,Map<String,Map<String,String>>>>();
        Set<Id> setkeyWord=new Set<Id>();
         String sobjectType = recordId.getSObjectType().getDescribe().getName();
                if(sobjectType=='SymphonyIPM__Invention_Disclosure_New__c'){
        for(SymphonyIPM__Keyword_Association__c keyassoc:[SELECT Id,SymphonyIPM__Keyword_Name__c,SymphonyIPM__Keyword__c,SymphonyIPM__Invention_Disclosure__c FROM SymphonyIPM__Keyword_Association__c WHERE SymphonyIPM__Invention_Disclosure__c = : recordId AND SymphonyIPM__Keyword__c != null])
        {
            setkeyWord.add(keyassoc.SymphonyIPM__Keyword__c);
        }
                }
        else{
             for(SymphonyIPM__Keyword_Association__c keyassoc:[SELECT Id,SymphonyIPM__Keyword_Name__c,SymphonyIPM__Keyword__c,SymphonyIPM__Patent__c FROM SymphonyIPM__Keyword_Association__c WHERE SymphonyIPM__Patent__c = : recordId AND SymphonyIPM__Keyword__c != null])
        {
            setkeyWord.add(keyassoc.SymphonyIPM__Keyword__c);
        } 
            
        }
        if(!setkeyWord.isEmpty()){
            list<SymphonyIPM__Keyword__c> keylis;
            if(sobjectType=='SymphonyIPM__Invention_Disclosure_New__c'){
                keylis=[SELECT Comments__c,Description__c,Id,Name,Secondary__c,SymphonyIPM__Keyword_Hierarchy__c,(select id,Second__c from SymphonyIPM__Keyword_Association__r where SymphonyIPM__Invention_Disclosure__c=:recordId) FROM SymphonyIPM__Keyword__c Where Id IN : setkeyWord];
            }
            else{
              keylis=[SELECT Comments__c,Description__c,Id,Name,Secondary__c,SymphonyIPM__Keyword_Hierarchy__c,(select id,Second__c from SymphonyIPM__Keyword_Association__r where SymphonyIPM__Patent__c=:recordId) FROM SymphonyIPM__Keyword__c Where Id IN : setkeyWord];
            
            }
            
            
            for(SymphonyIPM__Keyword__c keyWord:keylis){
                Hierarchy hierarchy=new Hierarchy();
                List<String> lstNames=new List<String>();
                hierarchy.level1 =keyWord.Name+'--' +keyWord.Comments__c + '**' +  keyWord.Description__c;
                for(SymphonyIPM__Keyword_Association__c Assoc:keyWord.SymphonyIPM__Keyword_Association__r){
                    hierarchy.level1=hierarchy.level1+'&&'+Assoc.id+'%%'+Assoc.Second__c;
                }
                
                if(keyWord.SymphonyIPM__Keyword_Hierarchy__c != null){
                    SymphonyIPM__Keyword__c child=TaxonomyHierarchyController.getKeyword(keyWord.SymphonyIPM__Keyword_Hierarchy__c);
                    
					hierarchy.level2 =child.Name +'--' +child.Comments__c + '**' + child.Description__c;
                  if(child.SymphonyIPM__Keyword_Hierarchy__c != null){
                        SymphonyIPM__Keyword__c child1=TaxonomyHierarchyController.getKeyword(child.SymphonyIPM__Keyword_Hierarchy__c);
					hierarchy.level3 =child1.Name+'--' +child1.Comments__c + '**' + child1.Description__c;
					  if(child1.SymphonyIPM__Keyword_Hierarchy__c != null){
                            SymphonyIPM__Keyword__c child2=TaxonomyHierarchyController.getKeyword(child1.SymphonyIPM__Keyword_Hierarchy__c);
					   hierarchy.level4 =child2.Name+'--' +child2.Comments__c + '**' + child2.Description__c;
			
							
							
							
                        }
                    }
                }
                if(hierarchy.level4 != null){
                    Map<String,String> mapNames=new Map<String,String>();
                    mapNames.put(hierarchy.level2,hierarchy.level1);
                    Map<String,Map<String,String>> map1Names=new Map<String,Map<String,String>>();
                    map1Names.put(hierarchy.level3,mapNames);
                    Map<String,Map<String,Map<String,String>>> map2Names=new Map<String,Map<String,Map<String,String>>>();
                    map2Names.put(hierarchy.level4,map1Names);
                    //mapResponse.putAll(map2Names);
                    mapResponse.put(hierarchy.level1,map2Names);
                }else if(hierarchy.level3 != null){
                    Map<String,String> mapNames=new Map<String,String>();
                    mapNames.put(hierarchy.level1,'');
                    Map<String,Map<String,String>> map1Names=new Map<String,Map<String,String>>();
                    map1Names.put(hierarchy.level2,mapNames);
                    Map<String,Map<String,Map<String,String>>> map2Names=new Map<String,Map<String,Map<String,String>>>();
                    map2Names.put(hierarchy.level3,map1Names);
                    mapResponse.put(hierarchy.level1,map2Names);
                    //mapResponse.putAll(map2Names);
                }else if(hierarchy.level2 != null){
                    Map<String,String> mapNames=new Map<String,String>();
                    mapNames.put('','');
                    Map<String,Map<String,String>> map1Names=new Map<String,Map<String,String>>();
                    map1Names.put(hierarchy.level1,mapNames);
                    Map<String,Map<String,Map<String,String>>> map2Names=new Map<String,Map<String,Map<String,String>>>();
                    map2Names.put(hierarchy.level2,map1Names);
                    mapResponse.put(hierarchy.level1,map2Names);
                    //mapResponse.putAll(map2Names);
                }else if(hierarchy.level1 != null){
                    Map<String,String> mapNames=new Map<String,String>();
                    mapNames.put('','');
                    Map<String,Map<String,String>> map1Names=new Map<String,Map<String,String>>();
                    map1Names.put('',mapNames);
                    Map<String,Map<String,Map<String,String>>> map2Names=new Map<String,Map<String,Map<String,String>>>();
                    map2Names.put(hierarchy.level1,map1Names);
                    mapResponse.put(hierarchy.level1,map2Names);
                    //mapResponse.putAll(map2Names);
                }
            }
            
        }
        System.debug(JSON.serialize(mapResponse));
        return JSON.serialize(mapResponse);
    }
    
    public static SymphonyIPM__Keyword__c getKeyword(Id recordId){
        //return null;
        return [SELECT Comments__c,Description__c,Id,Name,SymphonyIPM__Keyword_Hierarchy__c FROM SymphonyIPM__Keyword__c Where Id = : recordId];
    }
    
    public class WrapKeyword {
        @auraEnabled
        public string label;
        @auraEnabled
        public SymphonyIPM__Keyword__c keyword;
    }
    
    @AuraEnabled
    public static Map<Id,String> fetchHierarchyKeywords() {       
        Map<Id,String> mapchildHierarchy=new Map<Id,String>();
        for(SymphonyIPM__Keyword__c keyword:[SELECT Comments__c,Description__c,Id,Name,SymphonyIPM__Keyword_Hierarchy__c FROM SymphonyIPM__Keyword__c WHERE SymphonyIPM__Keyword_Hierarchy__c != null order by Name ASC]){
            mapchildHierarchy.put(keyword.SymphonyIPM__Keyword_Hierarchy__c,keyword.Name+'--'+keyword.Id);
        }
        return mapchildHierarchy;
    }
    
    @AuraEnabled
    public static List<WrapKeyword> fetchAllKeywords() {       
        List<WrapKeyword> lstWrapKeyword=new List<WrapKeyword>();
        for(SymphonyIPM__Keyword__c keyword:[SELECT Comments__c,Description__c,Id,Name,SymphonyIPM__Keyword_Hierarchy__c FROM SymphonyIPM__Keyword__c WHERE SymphonyIPM__Keyword_Hierarchy__c = null order by Name ASC Limit 50000]){
            WrapKeyword wrap=new WrapKeyword();
            wrap.label =keyword.Name + '-' +keyword.Description__c;
            wrap.keyword=keyword;
            lstWrapKeyword.add(wrap);
        }
        return lstWrapKeyword;
    }
    
    @AuraEnabled
    public static List<WrapKeyword> fetchLookUpValues(String searchKeyWord) {       
        String searchKey = '%' + searchKeyWord.toUpperCase() + '%';
        List<WrapKeyword> lstWrapKeyword=new List<WrapKeyword>();
        for(SymphonyIPM__Keyword__c keyword:[SELECT Comments__c,Description__c,Id,Name,SymphonyIPM__Keyword_Hierarchy__c FROM SymphonyIPM__Keyword__c where (Name LIKE: searchKey OR Comments__c LIKE: searchKey OR Description__c LIKE: searchKey)  order by Name ASC LIMIT 100]){
            WrapKeyword wrap=new WrapKeyword();
            wrap.label =keyword.Name + '-' +keyword.Description__c;
            wrap.keyword=keyword;
            lstWrapKeyword.add(wrap);
        }
        return lstWrapKeyword;
    }
    
    @AuraEnabled
    public static String saveRecords(Id recordId,List<SymphonyIPM__Keyword__c> lstkeywords) {      
        try{
            System.debug(lstkeywords);
            
            List<SymphonyIPM__Keyword_Association__c> lstKeywordAssoc=new List<SymphonyIPM__Keyword_Association__c>(); 
            for(SymphonyIPM__Keyword__c keyword:lstkeywords){
                SymphonyIPM__Keyword_Association__c assoc=new SymphonyIPM__Keyword_Association__c();
                assoc.SymphonyIPM__Keyword__c =keyword.Id;
                assoc.Second__c=false;
                String sobjectType = recordId.getSObjectType().getDescribe().getName();
                if(sobjectType=='SymphonyIPM__Invention_Disclosure_New__c'){
                 assoc.SymphonyIPM__Invention_Disclosure__c =recordId;
                  }
                else{
                    assoc.SymphonyIPM__Patent__c =recordId;}
                lstKeywordAssoc.add(assoc);
                  }
            insert lstKeywordAssoc;
        }catch(Exception e){
            System.debug(e.getMessage());
            return e.getMessage() + '--' + e.getstacktracestring();
        }
        return 'Success';
    }
    
    @auraEnabled
    public static string deleteKeywords(Id recordId,String keywordName){
        try{
            System.debug('keywordName::'+keywordName);
            List<SymphonyIPM__Keyword_Association__c> lstKeywordAssoc=[Select Id from SymphonyIPM__Keyword_Association__c Where SymphonyIPM__Patent__c = : recordId AND SymphonyIPM__Keyword__r.Name = : keywordName]; 
            delete lstKeywordAssoc;
            return 'Success';
        }catch(exception e){
            System.debug(e.getMessage());
            return e.getMessage() + '--' + e.getstacktracestring();
        }
    }
}
public class IDFPatenttablecntrl {
    
     public class idflist
    {  
    @AuraEnabled
        public string Doclink{get;set;}
        @AuraEnabled
        public string inventorid{get;set;}
        @AuraEnabled
        public string recid{get;set;}
        @AuraEnabled
        public string RelatedPatentname{get;set;}
         @AuraEnabled
        public string RelatedPatentID{get;set;}
         @AuraEnabled
        public string ParentIDFname{get;set;}
        @AuraEnabled
        public string ParentIDFID{get;set;}
        @AuraEnabled
        public string docketno{get;set;}
        @AuraEnabled
        public string title{get;set;}
        @AuraEnabled
        public string bu{get;set;}
         @AuraEnabled
        public string buname{get;set;}
        @AuraEnabled
        public string inventor{get;set;}
        @AuraEnabled
        public string ic{get;set;}
        @AuraEnabled
        public date Createddate{get;set;}
      }  

    @AuraEnabled
    public static list<idflist> getidfinfo(string recordId) {
        string patid='';
        list<id> idfreclist= new list<id>();
        SymphonyIPM__Patent__c  pat=[select id,SymphonyIPM__Family_ID__c,SymphonyIPM__Root_Patent__c,SymphonyIPM__ClonedFromAsset__c  from SymphonyIPM__Patent__c  where id =:recordId];
        list<idflist> idfliswraplist= new list<idflist>();
    if(pat.SymphonyIPM__Family_ID__c!=null){      
    List<SymphonyIPM__Invention_Disclosure_New__c > idflist=[select id,SymphonyIPM__Hierarchy__r.name,SymphonyIPM__Combined_With__r.name,SymphonyIPM__Related_Patent__r.name,SymphonyIPM__Primary_Inventor__c,SymphonyIPM__Title__c,name,CreatedDate,SymphonyIPM__Inventors__c,InHouseCounsel__c,Business_Unit__c,SymphonyIPM__Related_Patent__c, SymphonyIPM__Combined_With__c    
      ,SymphonyIPM__Hierarchy__c    from SymphonyIPM__Invention_Disclosure_New__c where SymphonyIPM__Related_Patent__r.SymphonyIPM__Family_ID__c =:Pat.SymphonyIPM__Family_ID__c];    
      
        for(SymphonyIPM__Invention_Disclosure_New__c idf:idflist){
            idflist ewrap= new idflist();
            ewrap.Doclink='/'+idf.id;
            ewrap.ParentIDFname=idf.SymphonyIPM__Combined_With__r.name;
             ewrap.ParentIDFID=idf.SymphonyIPM__Combined_With__c;
            ewrap.RelatedPatentname=idf.SymphonyIPM__Related_Patent__r.name;
             ewrap.RelatedPatentID=idf.SymphonyIPM__Related_Patent__c;
            ewrap.recid=idf.id;
            ewrap.docketno=idf.name;
            ewrap.ic=idf.InHouseCounsel__c; //InHouseCounsel__c
            ewrap.title=idf.SymphonyIPM__Title__c;
            ewrap.bu=idf.SymphonyIPM__Hierarchy__c;
           ewrap.buname=idf.SymphonyIPM__Hierarchy__r.name; 
            ewrap.CreatedDate=date.valueof(idf.CreatedDate);
            ewrap.inventor=idf.SymphonyIPM__Inventors__c;
            ewrap.inventorid='/'+idf.SymphonyIPM__Primary_Inventor__c;
            idfliswraplist.add(ewrap);
        }}
        if(idfliswraplist.size()>0)
            return idfliswraplist;
            else 
            return null;
    }
}
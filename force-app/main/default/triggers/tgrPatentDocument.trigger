trigger tgrPatentDocument on Patent_Document__c (before insert,before update) {
List<id> patentids= new List<id>();
List<id> DPoppids= new List<id>();
List<id> TMids= new List<id>();
Map<id,string> PatentDocnumberMap = new Map<id,string>();
Map<id,string> DisoppMap = new Map<id,string>();
Map<id,string> TMMap = new Map<id,string>();
for(Patent_Document__c  pat:trigger.new){
patentids.add(pat.Patent__c);
}
for(SymphonyIPM__Patent__c pat:[select id,SymphonyIPM__Docket_No__c from SymphonyIPM__Patent__c where id in:patentids]){
PatentDocnumberMap.put(pat.id,pat.SymphonyIPM__Docket_No__c );
}
for(SymphonyIPMExt__Dispute_Opposition__c DP:[select id,name from SymphonyIPMExt__Dispute_Opposition__c  where id in:DPoppids]){
DisoppMap .put(DP.id,DP.name);
}

for(SymphonyIPM__Trademark_New__c TM:[select id,SymphonyIPM__Docket_Number__c from SymphonyIPM__Trademark_New__c where id in:TMids ]){
TMMap.put(TM.id,TM.SymphonyIPM__Docket_Number__c);
}

for(Patent_Document__c  pat:trigger.new){

if(pat.Patent__c!=null)
pat.Document_NameText__c=PatentDocnumberMap.get(pat.Patent__c)+'_'+pat.File_Name_Big__c+string.valueof(pat.Upload_Date__c);
else if(pat.Dispute_Opposition__c!=null)
pat.Document_NameText__c=DisoppMap.get(pat.Dispute_Opposition__c)+'_'+pat.File_Name_Big__c+string.valueof(pat.Upload_Date__c);
else
pat.Document_NameText__c=TMMap.get(pat.Trademark__c)+'_'+pat.File_Name_Big__c+string.valueof(pat.Upload_Date__c);


}
}
trigger tgrTrademarkdocektActivity on SymphonyIPM__Trademark_Docketing_Activity__c (before insert,before update) {

 for(SymphonyIPM__Trademark_Docketing_Activity__c doc:trigger.new){
 if(doc.SymphonyIPM__Comments__c!=null && doc.SymphonyIPM__Comments__c!=''){
    string comm='';
        if(doc.Comments__c!=null && doc.Comments__c!=''){
    comm=doc.Comments__c+'\r\n';
     doc.Comments__c=comm+doc.SymphonyIPM__Comments__c;}
        else
         doc.Comments__c= doc.SymphonyIPM__Comments__c;  
      doc.SymphonyIPM__Comments__c='';
    }
 
 }
/*if(Trigger.isBefore){
    
    for(SymphonyIPM__Docketing_Activity_v2__c  doc:trigger.new){
    if(doc.SymphonyIPM__Comments__c!=null && doc.SymphonyIPM__Comments__c!=''){
    string comm='';
        if(doc.Comments__c!=null && doc.Comments__c!=''){
    comm=doc.Comments__c+'\r\n';
     // ==doc.Comments__c!=null ? doc.Comments__c+'/n' : '';
            doc.Comments__c=comm+doc.SymphonyIPM__Comments__c;}
        else
         doc.Comments__c= doc.SymphonyIPM__Comments__c;  
      doc.SymphonyIPM__Comments__c='';
    }}}*/

}
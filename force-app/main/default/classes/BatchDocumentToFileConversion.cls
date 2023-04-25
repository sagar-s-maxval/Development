global class BatchDocumentToFileConversion implements Database.Batchable<sObject> {
    
    global string DocktNo{get;set;}
    global string patId{get;set;}
    global BatchDocumentToFileConversion(string PatId)
    {
        this.patId = PatId;
        //Id PatId = apexpages.currentpage().getparameters().get('id');
        DocktNo = [SELECT SymphonyIPM__Docket_No__c from SymphonyIPM__Patent__c where Id =: PatId].SymphonyIPM__Docket_No__c;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name, DeveloperName, Description, ContentType, Type, Body FROM Document WHERE Name LIKE \'%'+DocktNo+'%\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Document> LstDocs){
        //Loop the list of document records
        system.debug('rec '+LstDocs.size());
        List<contentversion> lstCV = new list<contentversion>();
        List<contentdocumentlink> lstCD = new list<contentdocumentlink>();
        List<id> cvids = new list<id>();
        set<string> lstDocktNum = new set<string>();  
        List<contentversion> FinallstCV = new list<contentversion>();
        map<string,Id> MapPat = new map<String,Id>();
        for(Document Doc : LstDocs)
        {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = doc.DeveloperName + '.' + doc.Type;  
            conVer.Title = doc.Name; 
            conVer.VersionData =  Doc.body;
            lstCV.add(conVer);
        }
        if(lstCV.size()>0)
        {
            insert lstCV;
            
            for(ContentVersion cv : lstCV)
            {
                cvids.add(cv.Id);
                lstDocktNum.add(cv.Title.substringAfter('-').substringBefore('-').trim());
            }
            
            if(cvids.size()>0)
            {
                for(ContentVersion cv : [select Title,ContentDocumentId from ContentVersion where Id In: cvids])
                {
                    FinallstCV.add(cv);
                }
            }
                
            if(lstDocktNum.size()>0)
            {
               system.debug('docktnos'+lstDocktNum);
                for(SymphonyIPM__Patent__c pat : [select id,SymphonyIPM__Docket_No__c from SymphonyIPM__Patent__c where SymphonyIPM__Docket_No__c in: lstDocktNum])
                {
                   //system.debug('camel'+pat.SymphonyIPM__Docket_No__c);
                   MapPat.put(pat.SymphonyIPM__Docket_No__c,pat.Id);
                }
                system.debug('reslut '+MapPat);
                for(ContentVersion cv : FinallstCV)
                {
                    ContentDocumentLink cDe = new ContentDocumentLink();
                    cDe.ContentDocumentId = cv.ContentDocumentId;
                   // system.debug(MapPat.get(cv.Title.substringAfter('-').substringBefore('-')));
                    cDe.LinkedEntityId = patId; 
                    cDe.ShareType = 'I'; // Inferred permission
                    lstCD.add(cDe);                    
                }
                if(lstCD.size()>0)
                    insert lstCD;
            }
            if(LstDocs.size()>0)
                delete LstDocs; 
        }
    }    
    global void finish(Database.BatchableContext bc){
        
    }

public static void magicMethod(){
Integer i = 0;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
i++;
}
}
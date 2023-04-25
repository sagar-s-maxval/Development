global class cmpAPBatchPatentFamilyCtrl implements Database.Batchable <sObject>, Database.AllowsCallouts, Database.Stateful  {
    public string query{set;get;}
    
    
    global cmpAPBatchPatentFamilyCtrl(string limits, string IsValidation) {
        List<SymphonyIPM__Patent__c> PatentsFamilies = new List<SymphonyIPM__Patent__c>();
        List<SymphonyIPM__Patent__c> Patentsrecords = new List<SymphonyIPM__Patent__c>();
        query = 'SELECT Id,SymphonyIPM__Earliest_Priority_Date__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Family_ID__c';
        query += ' FROM SymphonyIPM__Patent__c';
        query += ' Where Last_Comments__c !=null LIMIT ' + limits + '';
        
        
        PatentsFamilies=Database.query(query);
         if(PatentsFamilies.size()>0) { 
             for(SymphonyIPM__Patent__c  Reviewers : PatentsFamilies) {
                 SymphonyIPM__Patent__c objOption = new SymphonyIPM__Patent__c();
                 objOption.Id=Reviewers.Id;
                 objOption.Last_Comments__c=null;
                 Patentsrecords.add(objOption);
             }
         }
        if (IsValidation=='Yes'){
            if(Patentsrecords.size()>0)
                update Patentsrecords;
        } 
        
        
        query = 'SELECT Id,SymphonyIPM__Earliest_Priority_Date__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Family_ID__c';
        query += ' FROM SymphonyIPM__Patent__c';
        query += ' Where Last_Comments__c=null LIMIT ' + limits + '';
        
        
    }
    
	global Database.QueryLocator start(Database.BatchableContext bc)  {
        System.debug('getQueryLocator' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<SymphonyIPM__Patent__c> records) {
        system.debug('records' + records);
        Set <String> PatentId = new Set <String>();
        List<SymphonyIPM__Patent__c> PatentsData = new List<SymphonyIPM__Patent__c>();
        
        for(SymphonyIPM__Patent__c evp : records) {
            SymphonyIPM__Patent__c ObjPatent = new SymphonyIPM__Patent__c();
            string Title = '%' + evp.SymphonyIPM__Title_of_Invention__c + '%';
        	List<SymphonyIPM__Patent__c> Patents = new List<SymphonyIPM__Patent__c>();
        	query = 'SELECT Id,SymphonyIPM__Earliest_Priority_Date__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__Family_ID__c';
        	query += ' FROM SymphonyIPM__Patent__c';
        	query += ' WHERE (SymphonyIPM__Title_of_Invention__c LIKE \'' + Title + '\')';
            query += ' AND (Id !=\'' + evp.Id + '\')';
        	Patents=Database.query(query);
            system.debug('query' + query);
            if(Patents.size()>0) { 
        	for(SymphonyIPM__Patent__c  Reviewers : Patents) {
                SymphonyIPM__Patent__c objOption = new SymphonyIPM__Patent__c();
                
                if (Reviewers.SymphonyIPM__Earliest_Priority_Date__c == evp.SymphonyIPM__Earliest_Priority_Date__c){
                     System.debug('Reviewers ' + Reviewers.SymphonyIPM__Earliest_Priority_Date__c);
                	 System.debug('evp ' + evp.SymphonyIPM__Earliest_Priority_Date__c);
                    
                     objOption.Id=Reviewers.Id;
                     objOption.Last_Comments__c=evp.SymphonyIPM__Family_ID__c;
                    if(!PatentId.contains(Reviewers.Id))
                        PatentsData.add(objOption);
                    
                     PatentId.add(Reviewers.Id); 
                    
                } else {
                    
                    objOption.Id=Reviewers.Id;
                    objOption.Last_Comments__c='Title & FamilyId not matched';
                    if(!PatentId.contains(Reviewers.Id))
                        PatentsData.add(objOption);
                    
                    PatentId.add(Reviewers.Id);
                }
                System.debug('Reviewers ' + Reviewers.Id);
            }
                
           		
            } else {
                ObjPatent.Id=evp.Id;
                ObjPatent.Last_Comments__c='Title & FamilyId not Found';
                
                if(!PatentId.contains(evp.Id))
                    PatentsData.add(ObjPatent);
                
                PatentId.add(evp.Id);
            }
            
            
        }
        
        if(PatentsData.size()>0)
            update PatentsData;
    
        
    }
    
    
    global void finish(Database.BatchableContext bc){
        System.debug('Finished');
         
    }  
}
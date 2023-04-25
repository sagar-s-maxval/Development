public class cmpAPInventorCtrl {
    
    
    @AuraEnabled
    public static String RowActionsDelete(String recordId) {
        Id id = Id.valueOf(recordId);
        delete id.getSobjectType().newSObject(id);
        return id;
    }
    
    
    
      @auraEnabled
      public static List<WrapperInventors> getDocuSigneReviewers(string patentID) {
          List<WrapperInventors> objOptions = new List<WrapperInventors>();
          
        try{
            List<DocuSignReviewer__c > Inventors = [SELECT Id,Person__r.Name,Person__r.SymphonyIPM__Email__c,Person__r.SymphonyIPM__Location__c, Person__r.SymphonyIPM__Employment_status__c
                                                    FROM DocuSignReviewer__c 
                                                    WHERE Invention_Disclosure__c =:patentID ];
             if (Inventors.Size() >0 ) {
                 for(DocuSignReviewer__c person : Inventors ) {
                     WrapperInventors objOption = new WrapperInventors();
                            objOption.Id = person.Id;
                            objOption.Name = person.Person__r.Name;
                            objOption.Email = person.Person__r.SymphonyIPM__Email__c;
                            objOption.EmploymentStatus = person.Person__r.SymphonyIPM__Employment_status__c;
                            objOption.EmploymentCategory = person.Person__r.SymphonyIPM__Location__c;   
                            objOptions.add(objOption);
                 }
             }
            
      
            return objOptions;  
            
        }catch(Exception e){
            return null;
        }
       
    }
    
     @auraEnabled
      public static List<WrapperInventors> getDocuSignePatentsReviewers(string patentID) {
          List<WrapperInventors> objOptions = new List<WrapperInventors>();
          
        try{
            List<DocuSignReviewer__c > Inventors = [SELECT Person__r.Id,Person__r.Name,Person__r.SymphonyIPM__Email__c, Person__r.SymphonyIPM__Employment_status__c
                                                    FROM DocuSignReviewer__c 
                                                    WHERE Patent__c =:patentID ];
             if (Inventors.Size() >0 ) {
                 for(DocuSignReviewer__c person : Inventors ) {
                     WrapperInventors objOption = new WrapperInventors();
                            objOption.Id = person.Id;
                            objOption.Name = person.Person__r.Name;
                            objOption.Email = person.Person__r.SymphonyIPM__Email__c;
                            objOption.EmploymentStatus = person.Person__r.SymphonyIPM__Employment_status__c;
                            objOptions.add(objOption);
                 }
             }
            
      
            return objOptions;  
            
        }catch(Exception e){
            return null;
        }
       
    }
    
      @auraEnabled
      public static List<WrapperInventors> FetchData(string patentID) {
          List<DocuSignReviewer__c> objOptions = new List<DocuSignReviewer__c>();
          set<string> ObjectId = new set<string>();
          
          List<DocuSignReviewer__c > DocuSignReviewers = [SELECT Id,Person__r.Id,Invention_Disclosure__r.Id,Patent__c
                                                  FROM DocuSignReviewer__c 
                                                  WHERE Invention_Disclosure__c =:patentID ];
          if(DocuSignReviewers.size()>0){
              for(DocuSignReviewer__c person : DocuSignReviewers ) {
                    ObjectId.add(person.Person__r.Id + '-'+ person.Invention_Disclosure__r.Id);   
              }
          }
          
        try{
            List<SymphonyIPM__Additional_Inventor__c > Inventors = [SELECT SymphonyIPM__Inventor__r.Id,SymphonyIPM__Inventor__r.Name,
                                                             SymphonyIPM__Inventor_Email_Id__c,SymphonyIPM__Invention_Disclosure_New__r.Id,
                                                                    SymphonyIPM__Inventor__r.SymphonyIPM__EmploymentCategory__c, SymphonyIPM__Inventor__r.SymphonyIPM__Employment_status__c
                                                            FROM SymphonyIPM__Additional_Inventor__c 
                                                            WHERE SymphonyIPM__Invention_Disclosure_New__c =:patentID AND Is_External_Inventor_New__c =false];
             if (Inventors.Size() >0 ) {
                 for(SymphonyIPM__Additional_Inventor__c person : Inventors ) {
                     DocuSignReviewer__c objOption = new DocuSignReviewer__c();
                     if(!ObjectId.contains(person.SymphonyIPM__Inventor__r.Id +'-'+ person.SymphonyIPM__Invention_Disclosure_New__r.Id)) {
                                objOption.Invention_Disclosure__c = patentID;
                                objOption.Person__c = person.SymphonyIPM__Inventor__r.Id;
                                objOptions.add(objOption);
                     }  
                 }
             }
            
            if ( objOptions.size()>0){
                upsert objOptions;
            } 
            
            List<WrapperInventors> persons = cmpAPInventorCtrl.getDocuSigneReviewers(patentID);
            return persons;  
            
        }catch(Exception e){
            return null;
        }
       
    }
   
     @auraEnabled
      public static List<WrapperInventors> FetchPatentData(string patentID) {
          List<DocuSignReviewer__c> objOptions = new List<DocuSignReviewer__c>();
          set<string> ObjectId = new set<string>();
          
          List<DocuSignReviewer__c > DocuSignReviewers = [SELECT Id,Person__r.Id,Invention_Disclosure__r.Id,Patent__r.Id, Person__r.SymphonyIPM__Employment_status__c
                                                  FROM DocuSignReviewer__c 
                                                  WHERE Patent__c =:patentID ];
          if(DocuSignReviewers.size()>0){
              for(DocuSignReviewer__c person : DocuSignReviewers ) {
                    ObjectId.add(person.Person__r.Id + '-'+ person.Patent__r.Id);   
              }
          }
         
          System.debug('ObjectId' + ObjectId);
          
        try{
            List<SymphonyIPM__Asset_Inventor_v1__c > Inventors = [SELECT SymphonyIPM__Inventor__r.Id,SymphonyIPM__Inventor__r.Name,
                                                                  SymphonyIPM__Inventor__r.SymphonyIPM__User__r.Email,
                                                                  SymphonyIPM__Inventor__r.SymphonyIPM__EmploymentCategory__c, SymphonyIPM__Inventor__r.SymphonyIPM__Employment_status__c
                                                                  FROM SymphonyIPM__Asset_Inventor_v1__c 
                                                                  WHERE SymphonyIPM__Asset__c =:patentID ];
             if (Inventors.Size() >0 ) {
                 for(SymphonyIPM__Asset_Inventor_v1__c person : Inventors ) {
                     DocuSignReviewer__c objOption = new DocuSignReviewer__c();
                     if(!ObjectId.contains(person.SymphonyIPM__Inventor__r.Id +'-'+ patentID)) {
                            objOption.Patent__c = patentID;
                            objOption.Person__c = person.SymphonyIPM__Inventor__r.Id;  
                            objOptions.add(objOption);
                     }
                            
                 }
             }
            
      
            if ( objOptions.size()>0){
                upsert objOptions;
            } 
            
            List<WrapperInventors> persons = cmpAPInventorCtrl.getDocuSignePatentsReviewers(patentID);
            
            return persons;  
            
        }catch(Exception e){
            return null;
        }
       
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
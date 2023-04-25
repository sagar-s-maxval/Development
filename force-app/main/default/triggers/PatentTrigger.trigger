trigger PatentTrigger on SymphonyIPM__Patent__c (before insert, before update, after update, after insert) {
    if (Trigger.isinsert && Trigger.isAfter) {
        Map<id,id> mapparenttochild= new Map<id,id>();
        list<id> parenasstids= new list<id>();
        List<id> parentids= new List<id>();
        List<SymphonyIPM__Patent__c> newpatentslst= new List<SymphonyIPM__Patent__c>();
        for(SymphonyIPM__Patent__c patent : Trigger.new){
            if(!patent.Litigation_on_hold__c)
                newpatentslst.add(patent);
             if(patent.SymphonyIPM__ClonedFromAsset__c!=null)
                parenasstids.add(patent.SymphonyIPM__ClonedFromAsset__c); 
            if(patent.SymphonyIPM__ClonedFromAsset__c!=null && patent.SymphonyIPM__Root_Patent__c!=null && patent.SymphonyIPM__Case_Type__c=='Utility Non-Provisional'){
              parentids.add(patent.SymphonyIPM__Root_Patent__c);  
            }
         }
          if(newpatentslst.size()>0)
     //       ExpiredPatentPurgingService.manageDocketingActivities(newpatentslst, null);
        if(parenasstids.size()>0){
            Map<id,List<Patent_Assignee__c>> pamap= new Map<id,List<Patent_Assignee__c>>();
            for(Patent_Assignee__c patass:[select id,Patent__c,Entity__c,Matter_ID__c,Is_Current_Assignee__c from Patent_Assignee__c where Patent__c in:parenasstids]){
               list<Patent_Assignee__c> patasinge= new List<Patent_Assignee__c>();
                if(pamap.containskey(patass.Patent__c)) 
                    patasinge=pamap.get(patass.Patent__c);
                  patasinge.add(patass);
                pamap.put(patass.Patent__c,patasinge);
            }
            List<Patent_Assignee__c> Palist= new List<Patent_Assignee__c>();
            for(SymphonyIPM__Patent__c patent : Trigger.new){
               if(patent.SymphonyIPM__ClonedFromAsset__c!=null){
                   if(pamap.containskey(patent.SymphonyIPM__ClonedFromAsset__c))  {
                for(Patent_Assignee__c pa:pamap.get(patent.SymphonyIPM__ClonedFromAsset__c))  {
                  Patent_Assignee__c pat= new Patent_Assignee__c();
                    pat.Entity__c=pa.Entity__c;
                    pat.Is_Current_Assignee__c=pa.Is_Current_Assignee__c;
                    pat.Matter_ID__c=pa.Matter_ID__c;
                    pat.Patent__c=patent.id;
                    Palist.add(pat);
                }
                   }
               }
                
            }   
            if(Palist.size()>0)
                insert Palist;
        }
        if(parentids.size()>0){
            List<id> patentids= new List<id>();
        Map<id,SymphonyIPM__Patent__c> parentpatmap=new Map<id,SymphonyIPM__Patent__c>([select id,SymphonyIPM__Case_Type__c from SymphonyIPM__Patent__c where id in:parentids]);
        for(SymphonyIPM__Patent__c patent : Trigger.new){
            if(patent.SymphonyIPM__ClonedFromAsset__c!=null && patent.SymphonyIPM__Root_Patent__c!=null && patent.SymphonyIPM__Case_Type__c=='Utility Non-Provisional' && parentpatmap.get(patent.SymphonyIPM__Root_Patent__c).SymphonyIPM__Case_Type__c=='Provisional' ){
               patentids.add(patent.SymphonyIPM__Root_Patent__c );
                mapparenttochild.put(patent.SymphonyIPM__Root_Patent__c,patent.id);
            }
        }
            if(patentids.size()>0){
                Map<id,List<SymphonyIPM__Asset_Inventor_v1__c>> patenttoinvmap= new Map<id,List<SymphonyIPM__Asset_Inventor_v1__c>>();
                List<SymphonyIPM__Asset_Inventor_v1__c> assetinv=[select id,SymphonyIPM__Primary_Inventor__c,Name,CurrencyIsoCode,Is_External_Inventor__c,SymphonyIPM__Exception_Inventor__c,SymphonyIPM__Inventor__c,SymphonyIPM__Asset__c from SymphonyIPM__Asset_Inventor_v1__c where SymphonyIPM__Asset__c in:patentids ];
                for(SymphonyIPM__Asset_Inventor_v1__c inv:assetinv){
                    List<SymphonyIPM__Asset_Inventor_v1__c> invlist;
                    if(patenttoinvmap.containsKey(inv.SymphonyIPM__Asset__c)){
                      invlist=patenttoinvmap.get(inv.SymphonyIPM__Asset__c);
                    }else{
                       invlist= new List<SymphonyIPM__Asset_Inventor_v1__c>();
                    }
                    invlist.add(inv);
                    patenttoinvmap.put(inv.SymphonyIPM__Asset__c,invlist);
                }
                if(patenttoinvmap!=null){
                    list<SymphonyIPM__Asset_Inventor_v1__c> Assinv= new list<SymphonyIPM__Asset_Inventor_v1__c>();
                    for(id parentid:patenttoinvmap.keyset()){
                        for(SymphonyIPM__Asset_Inventor_v1__c inv:patenttoinvmap.get(parentid)){
                            SymphonyIPM__Asset_Inventor_v1__c inventor= new SymphonyIPM__Asset_Inventor_v1__c();
                            inventor.SymphonyIPM__Inventor__c=inv.SymphonyIPM__Inventor__c;
                            inventor.SymphonyIPM__Primary_Inventor__c=inv.SymphonyIPM__Primary_Inventor__c;
                             inventor.Name=inv.Name;
                             inventor.CurrencyIsoCode=inv.CurrencyIsoCode;
                             inventor.SymphonyIPM__Exception_Inventor__c=inv.SymphonyIPM__Exception_Inventor__c;
                            inventor.Is_External_Inventor__c=inv.Is_External_Inventor__c;
                            inventor.SymphonyIPM__Asset__c=mapparenttochild.get(inv.SymphonyIPM__Asset__c);
                       Assinv.add(inventor);
                        }   
                        if(Assinv.size()>0)
                            insert Assinv;
                    }
                    
                }    
                
                
            } 
            
            
        }
    } 
    
    
    if (Trigger.isUpdate && Trigger.isAfter) {
        Set<Id> patentsWithLitigationOnHold = new Set<Id>();
        Set<Id> patentsWithLitigationOnHoldDeselect = new Set<Id>();
        Set<Id> patentsExpiredAbandoned = new Set<Id>();
        Set<Id> patentsToCloseFilingActivity = new Set<Id>();

        for (SymphonyIPM__Patent__c patent : Trigger.new) {
            if (PatentService.checkStatusExpiredAbandoned(patent, Trigger.oldMap.get(patent.Id)) && patent.Last_In_Family_Expired__c) {
                patentsExpiredAbandoned.add(patent.Id);
            }
            if (PatentService.isLitigationChecked(patent, Trigger.oldMap.get(patent.Id))) {
                patentsWithLitigationOnHold.add(patent.Id);
            } else if (PatentService.isLitigationDeselect(patent, Trigger.oldMap.get(patent.Id))) {
                patentsWithLitigationOnHoldDeselect.add(patent.Id);
            }
            if (PatentService.checkIfStatusFromDrafting(patent, Trigger.oldMap.get(patent.Id))) {
                patentsToCloseFilingActivity.add(patent.Id);
            }
        }

        PatentService.createPurgingExpiredDocketingActivity(patentsExpiredAbandoned);
        PatentService.putLitigationOnHoldInRelatedPatents(patentsWithLitigationOnHold, true);
        PatentService.putLitigationOnHoldInRelatedPatents(patentsWithLitigationOnHoldDeselect, false);
        PatentService.closeFilingActivities(patentsToCloseFilingActivity);
    } else if (Trigger.isInsert && Trigger.isBefore) {
        PatentService.UpdateEpcountries(Trigger.new); 
    PatentService.UpdateAuditFields(Trigger.new);
     for(SymphonyIPM__Patent__c pat : Trigger.new)
        {
         if(pat.SymphonyIPM__Country_Code__c!='US' && pat.SymphonyIPM__Asset_Type__c=='Design')
        pat.SymphonyIPM__Restricted_From_Overriding__c='SymphonyIPM__Application_Date__c,SymphonyIPM__Issue_Date_of_Patent__c,SymphonyIPM__Application_Number__c,SymphonyIPM__Asset_Image_Count__c,SymphonyIPM__Adjusted_Expiration_Date__c,SymphonyIPM__Earliest_Publication_No__c,SymphonyIPM__Earliest_Publication_Date__c,SymphonyIPM__Patent_Number__c,SymphonyIPM__Earliest_Priority_Date__c,SymphonyIPM__Effective_Filing_Date__c,SymphonyIPM__Case_Type__c,SymphonyIPM__Priority_Dates__c,SymphonyIPM__Title_of_Invention__c,SymphonyIPM__First_Named_Applicant__c,SymphonyIPM__Attorney_Docket_Number__c,SymphonyIPM__Examiner_Name__c,SymphonyIPM__Group_Art_Unit__c,SymphonyIPM__Inventors__c,SymphonyIPM__First_Named_Inventor__c,SymphonyIPM__Priority_Number__c,SymphonyIPM__Confirmation_Number__c,SymphonyIPM__Allowance_Date__c,SymphonyIPM__ForeignFilingDeadlineDate__c,SymphonyIPM__Foreign_Filing_Decision_Deadline_Date__c,SymphonyIPM__AssigneeData__c,SymphonyIPM__Attorney__c,SymphonyIPM__Class_Subclass__c,SymphonyIPM__Claim_Count__c,SymphonyIPM__Correspondence_Address_Customer_Number__c,SymphonyIPM__First_OA_Date__c,SymphonyIPM__IPC__c,SymphonyIPM__Is_TD__c,SymphonyIPM__Location__c,SymphonyIPM__PreTD_ExpirationDate__c,SymphonyIPM__PTA_Days_Fetched__c,SymphonyIPM__PTA_Days_Manual__c,SymphonyIPM__PTATDStatus__c,SymphonyIPM__ShowPTAFetched__';
        
        }
        PatentService.setLitigation(Trigger.new);
       if( TFconstant.firsttime==true)
         PatentService.setfilingandissuedate(Trigger.new);
    } else if (Trigger.isBefore && Trigger.isUpdate) {
        PatentService.UpdateAuditFields(Trigger.new);
       for(SymphonyIPM__Patent__c patent : Trigger.new){
         SymphonyIPM__Patent__c oldpatent=Trigger.oldMap.get(patent.Id);
         SymphonyIPM__Patent__c newpatent=Trigger.newmap.get(patent.Id);
         
           if(oldpatent.SymphonyIPM__Hierarchy__c!=newpatent.SymphonyIPM__Hierarchy__c){
               list<id> patid= new list<id>();
               for(SymphonyIPM__Patent__c pat : Trigger.new){
                  patid.add(pat .SymphonyIPM__Hierarchy__c); 
               }
               Map<id,string> hiermapgroup= new Map<id,string>();
               for(SymphonyIPM__Hierarchy__c shier:[select id,Group__c from SymphonyIPM__Hierarchy__c where id in:patid ]){
                  hiermapgroup.put(shier.id,shier.Group__c); 
               }
               for(SymphonyIPM__Patent__c pt : Trigger.new){
                patent.Group__c= hiermapgroup.get(pt.SymphonyIPM__Hierarchy__c);
               }
         }
         
         
           /*if(oldpatent.SymphonyIPM__Status__c==newpatent.SymphonyIPM__Status__c) {
           if(oldpatent.SymphonyIPM__Status__c=='Pending' &&( (newpatent.SymphonyIPM__Application_Date__c==null || newpatent.SymphonyIPM__Application_Number__c==null )|| (newpatent.SymphonyIPM__Earliest_Publication_Date__c==null || newpatent.SymphonyIPM__Earliest_Publication_No__c==null ) ))
         patent.SymphonyIPM__Status__c ='Drafting';
         //      if(newpatent.SymphonyIPM__Status__c!='Issued'&& newpatent.SymphonyIPM__Status__c!='Pending' &&oldpatent.SymphonyIPM__Status__c =='Drafting'&& (( newpatent.SymphonyIPM__Application_Date__c!=null ) &&(newpatent.SymphonyIPM__Application_Number__c!=null ) ||( newpatent.SymphonyIPM__Earliest_Publication_Date__c!=null  &&newpatent.SymphonyIPM__Earliest_Publication_No__c!=null )   ) ){
             if(newpatent.SymphonyIPM__Status__c=='Drafting'&& (( newpatent.SymphonyIPM__Application_Date__c!=null &&newpatent.SymphonyIPM__Application_Number__c!=null )|| ( newpatent.SymphonyIPM__Earliest_Publication_Date__c!=null  &&newpatent.SymphonyIPM__Earliest_Publication_No__c!=null ) )){
              patent.SymphonyIPM__Status__c ='Pending';
               }
           }*/
       if(oldpatent.SymphonyIPM__Application_Date__c==null && newpatent.SymphonyIPM__Application_Date__c!=null && 
          newpatent.SymphonyIPM__Issue_Date_of_Patent__c==null)
       {
           patent.SymphonyIPM__Status__c ='Pending';
       }
           if(oldpatent.SymphonyIPM__Application_Date__c!=null && newpatent.SymphonyIPM__Application_Date__c==null &&
            newpatent.SymphonyIPM__Issue_Date_of_Patent__c==null)
           {
              patent.SymphonyIPM__Status__c ='Drafting'; 
           }
           if(oldpatent.SymphonyIPM__Status__c!='Drafting' && newpatent.SymphonyIPM__Status__c=='Drafting' && newpatent.SymphonyIPM__Application_Date__c!=null &&
             newpatent.SymphonyIPM__Issue_Date_of_Patent__c==null)
           {
              patent.SymphonyIPM__Status__c ='Pending'; 
           }
           if(oldpatent.SymphonyIPM__Issue_Date_of_Patent__c==null && newpatent.SymphonyIPM__Issue_Date_of_Patent__c!=null)
           {
              patent.SymphonyIPM__Status__c ='Issued';  
           }
           if(oldpatent.SymphonyIPM__Issue_Date_of_Patent__c!=null && newpatent.SymphonyIPM__Issue_Date_of_Patent__c==null &&
             newpatent.SymphonyIPM__Application_Date__c==null)
           {
              patent.SymphonyIPM__Status__c ='Drafting';  
           }
           if((oldpatent.SymphonyIPM__Issue_Date_of_Patent__c!=null ||oldpatent.SymphonyIPM__Issue_Date_of_Patent__c==null) && newpatent.SymphonyIPM__Issue_Date_of_Patent__c==null &&
             newpatent.SymphonyIPM__Application_Date__c!=null &&(newpatent.SymphonyIPM__Status__c=='Drafting'||newpatent.SymphonyIPM__Status__c=='Issued'))
           {
               patent.SymphonyIPM__Status__c ='Pending';
           }
           if(oldpatent.SymphonyIPM__Status__c=='Issued' && (newpatent.SymphonyIPM__Status__c=='Pending'||newpatent.SymphonyIPM__Status__c=='Drafting')&&
            newpatent.SymphonyIPM__Issue_Date_of_Patent__c!=null)
           {
               patent.SymphonyIPM__Status__c ='Issued';  
           }
           if(oldpatent.SymphonyIPM__Status__c!='Drafting'&& oldpatent.SymphonyIPM__Status__c!='Pending' && oldpatent.SymphonyIPM__Status__c!='Issued')
           {
               if(newpatent.SymphonyIPM__Status__c=='Drafting'|| newpatent.SymphonyIPM__Status__c=='Pending' || newpatent.SymphonyIPM__Status__c=='Issued')
               {
                   
               
               if(newpatent.SymphonyIPM__Application_Date__c!=null && newpatent.SymphonyIPM__Issue_Date_of_Patent__c==null)
               {
                   patent.SymphonyIPM__Status__c ='Pending'; 
               }
               else if(newpatent.SymphonyIPM__Application_Date__c!=null && newpatent.SymphonyIPM__Issue_Date_of_Patent__c!=null)
               {
                  patent.SymphonyIPM__Status__c ='Issued'; 
               }
                   else if(newpatent.SymphonyIPM__Application_Date__c==null && newpatent.SymphonyIPM__Issue_Date_of_Patent__c!=null)
               {
                  patent.SymphonyIPM__Status__c ='Issued'; 
               }
              }
           }
       }
    
        if( TFconstant.firsttime==true){
           list<SymphonyIPM__Patent__c> patentlist= new list<SymphonyIPM__Patent__c>();
            for(SymphonyIPM__Patent__c patent : Trigger.new){
                SymphonyIPM__Patent__c oldpatent=Trigger.oldMap.get(patent.Id);
                 SymphonyIPM__Patent__c newpatent=Trigger.newmap.get(patent.Id);
                if((oldpatent.SymphonyIPM__Application_Date__c!=newpatent.SymphonyIPM__Application_Date__c)||(oldpatent.SymphonyIPM__Issue_Date_of_Patent__c!=newpatent.SymphonyIPM__Issue_Date_of_Patent__c) ){
                   patentlist.add(patent); 
                }
            }
            if(patentlist.size()>0)
           PatentService.setfilingandissuedate(patentlist);
        }
        Set<Id> patentsExpiredAbandoned = new Set<Id>();
        for (SymphonyIPM__Patent__c patent : Trigger.new) {
            if (PatentService.checkStatusExpiredAbandoned(patent, Trigger.oldMap.get(patent.Id))) {
                patentsExpiredAbandoned.add(patent.Id);
            }
        }
        PatentService.setIfLastExpired(patentsExpiredAbandoned, Trigger.new);
    } else if (Trigger.isAfter && Trigger.isInsert) {
        Set<Id> patentsIds = new Set<Id>();
        for (SymphonyIPM__Patent__c patent: Trigger.new) {
            if (patent.SymphonyIPM__Status__c == 'Drafting' && (patent.SymphonyIPM__Case_Type__c == 'Primary' || patent.SymphonyIPM__Case_Type__c == 'Utility Original')) {
                patentsIds.add(patent.Id);
            }
        }
        PatentService.createFilingDocketingActivity(patentsIds);
    }

}
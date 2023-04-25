trigger trgDisputeOppositionrole on Dispute_Opposition_Role__c (after insert, after update, after delete) 
{
    if((Trigger.isInsert&&Trigger.isAfter) || (Trigger.isUpdate&&Trigger.isAfter))
    {
        map<id,id> doKeyMap = new map<id,id>();
        map<id,String> doParalegalMap = new map<id,String>();
        map<id,String> doOutsideCounselMap = new map<id,String>();
         map<id,String> doOutsideCounselRefNoMap = new map<id,String>();
        map<id,String> doAttorneyMap = new map<id,String>();
        map<id,String> doAttorney2Map = new map<id,String>();
        map<id,String> doAssosciateMap = new map<id,String>();
        map<id,String> doAssosciate2Map = new map<id,String>();
        map<id,String> doDocketerMap = new map<id,String>();
        map<id,String> doIPResponsibleManager = new map<id,String>();
        map<id,String> doAgentMap = new map<id,String>();
        map<id,String> doIPPartnerMap = new map<id,String>();
        for(Dispute_Opposition_Role__c doRole : Trigger.new)
        {
            
            doKeyMap.put(doRole.Dispute_Opposition__c,doRole.id);
            
        }
        List<Dispute_Opposition_Role__c> doRoles = [SELECT Person__r.name,Dispute_Opposition__c,Law_Firm__r.name,Law_Firm__r.Ref_No__c,Trademark_Role__c FROM Dispute_Opposition_Role__c WHERE Dispute_Opposition__c IN: doKeyMap.keyset()];
        for(Dispute_Opposition_Role__c doRole :doRoles)
        {     
            if(doRole.Trademark_Role__c == 'TM IP Paralegal')
            {
                if(doParalegalMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doParalegalMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doParalegalMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doParalegalMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'CN TM Attorney 1')
            {
                if(doAttorneyMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAttorneyMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAttorneyMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAttorneyMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'CN TM Attorney 2')
            {
                if(doAttorney2Map.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAttorney2Map.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAttorney2Map.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAttorney2Map.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Associate 1')
            {
                if(doAssosciateMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAssosciateMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAssosciateMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAssosciateMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Associate 2')
            {
                if(doAssosciate2Map.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAssosciate2Map.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAssosciate2Map.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAssosciate2Map.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM Docketer')
            {
                if(doDocketerMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doDocketerMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doDocketerMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doDocketerMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Responsible Manager')
            {
                if(doIPResponsibleManager.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doIPResponsibleManager.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doIPResponsibleManager.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doIPResponsibleManager.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'Agent')
            {
                if(doAgentMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAgentMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAgentMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAgentMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Partner')
            {
                if(doIPPartnerMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doIPPartnerMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doIPPartnerMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doIPPartnerMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'Outside Counsel Firm')
            {
                if(doOutsideCounselMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string LawFirmName =doOutsideCounselMap.get(doRole.Dispute_Opposition__c)+','+doRole.Law_Firm__r.name;
                    doOutsideCounselMap.put(doRole.Dispute_Opposition__c,LawFirmName);
                    if(!String.IsBlank(doRole.Law_Firm__r.Ref_No__c))
                    {
                    string LawFirmRefName =doOutsideCounselRefNoMap.get(doRole.Dispute_Opposition__c)+','+doRole.Law_Firm__r.Ref_No__c;
                    doOutsideCounselRefNoMap.put(doRole.Dispute_Opposition__c,LawFirmRefName);
                    }
                }
                else
                {
                    string LawFirmName= doRole.Law_Firm__r.name;
                    doOutsideCounselMap.put(doRole.Dispute_Opposition__c,LawFirmName);
                    string LawFirmRefName= doRole.Law_Firm__r.Ref_No__c;
                    doOutsideCounselRefNoMap.put(doRole.Dispute_Opposition__c,LawFirmRefName);
                }
        }
            
            
        }
        List<SymphonyIPMExt__Dispute_Opposition__c> listDOUpdate = new List<SymphonyIPMExt__Dispute_Opposition__c>();
        for(id recId : doKeyMap.keyset())
        {
            SymphonyIPMExt__Dispute_Opposition__c disputeOpposition = new SymphonyIPMExt__Dispute_Opposition__c();
            disputeOpposition.TM_IP_Paralegal__c = doParalegalMap.get(recId);
            disputeOpposition.Outside_Counsel_Firm__c = doOutsideCounselMap.get(recId);
            disputeOpposition.Outside_Counsel_Reference_Number__c = String.isBlank( doOutsideCounselRefNoMap.get(recId) ) ? '' : doOutsideCounselRefNoMap.get(recId);
            disputeOpposition.CN_TM_Attorney_I__c = doAttorneyMap.get(recId);
            disputeOpposition.CN_TM_Attorney_2__c = doAttorney2Map.get(recId);
            disputeOpposition.TM_IP_Associate__c = doAssosciateMap.get(recId);
            disputeOpposition.TM_IP_Associate_2__c = doAssosciate2Map.get(recId);
            disputeOpposition.TM_Docketer__c = doDocketerMap.get(recId);
            disputeOpposition.TM_IP_Responsiblle_Manager__c = doIPResponsibleManager.get(recId);
            disputeOpposition.Agent__c = doAgentMap.get(recId);
            disputeOpposition.TM_IP_Partner__c = doIPPartnerMap.get(recId);
            disputeOpposition.Id = recId;
            listDOUpdate.add(disputeOpposition);
        }
        if(listDOUpdate.size()>0)
        {
            update listDOUpdate;
        }
    }
    if(Trigger.isAfter&&Trigger.isDelete)
    {
        map<id,id> doKeyMap = new map<id,id>();
        map<id,String> doParalegalMap = new map<id,String>();
        map<id,String> doOutsideCounselMap = new map<id,String>();
         map<id,String> doOutsideCounselRefNoMap = new map<id,String>();
        map<id,String> doAttorneyMap = new map<id,String>();
        map<id,String> doAttorney2Map = new map<id,String>();
        map<id,String> doAssosciateMap = new map<id,String>();
        map<id,String> doAssosciate2Map = new map<id,String>();
        map<id,String> doDocketerMap = new map<id,String>();
        map<id,String> doIPResponsibleManager = new map<id,String>();
        map<id,String> doAgentMap = new map<id,String>();
        map<id,String> doIPPartnerMap = new map<id,String>();
        for(Dispute_Opposition_Role__c doRole : Trigger.old)
        {
            if(doRole.Trademark_Role__c == 'TM IP Paralegal' || doRole.Trademark_Role__c == 'Outside Counsel Firm' || doRole.Trademark_Role__c == 'TM IP Partner' || doRole.Trademark_Role__c == 'Agent' || doRole.Trademark_Role__c == 'TM IP Responsible Manager' || doRole.Trademark_Role__c == 'TM Docketer' || doRole.Trademark_Role__c == 'TM IP Associate 2' || doRole.Trademark_Role__c == 'TM IP Associate 1' || doRole.Trademark_Role__c == 'CN TM Attorney 2' || doRole.Trademark_Role__c == 'CN TM Attorney 1')
            {
                doKeyMap.put(doRole.Dispute_Opposition__c,doRole.id);
            }
            
        }
       List<Dispute_Opposition_Role__c> doRoles = [SELECT Person__r.name,Dispute_Opposition__c,Law_Firm__r.name,Law_Firm__r.Ref_No__c,Trademark_Role__c FROM Dispute_Opposition_Role__c WHERE Dispute_Opposition__c IN: doKeyMap.keyset()];
        for(Dispute_Opposition_Role__c doRole :doRoles)
        {     
            if(doRole.Trademark_Role__c == 'TM IP Paralegal')
            {
                if(doParalegalMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doParalegalMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doParalegalMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doParalegalMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'CN TM Attorney 1')
            {
                if(doAttorneyMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAttorneyMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAttorneyMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAttorneyMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'CN TM Attorney 2')
            {
                if(doAttorney2Map.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAttorney2Map.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAttorney2Map.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAttorney2Map.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Associate 1')
            {
                if(doAssosciateMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAssosciateMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAssosciateMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAssosciateMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Associate 2')
            {
                if(doAssosciate2Map.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAssosciate2Map.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAssosciate2Map.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAssosciate2Map.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM Docketer')
            {
                if(doDocketerMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doDocketerMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doDocketerMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doDocketerMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Responsible Manager')
            {
                if(doIPResponsibleManager.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doIPResponsibleManager.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doIPResponsibleManager.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doIPResponsibleManager.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'Agent')
            {
                if(doAgentMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doAgentMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doAgentMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doAgentMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'TM IP Partner')
            {
                if(doIPPartnerMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string personName =doIPPartnerMap.get(doRole.Dispute_Opposition__c)+','+doRole.Person__r.name;
                    doIPPartnerMap.put(doRole.Dispute_Opposition__c,personName);
                } 
                else{
                    string personName= doRole.Person__r.name;
                    doIPPartnerMap.put(doRole.Dispute_Opposition__c,personName);
                }
            }
            if(doRole.Trademark_Role__c == 'Outside Counsel Firm')
            {
                if(doOutsideCounselMap.containskey(doRole.Dispute_Opposition__c))
                {
                    string LawFirmName =doOutsideCounselMap.get(doRole.Dispute_Opposition__c)+','+doRole.Law_Firm__r.name;
                    doOutsideCounselMap.put(doRole.Dispute_Opposition__c,LawFirmName);
                    if(!String.IsBlank(doRole.Law_Firm__r.Ref_No__c))
                    {
                    string LawFirmRefName =doOutsideCounselRefNoMap.get(doRole.Dispute_Opposition__c)+','+doRole.Law_Firm__r.Ref_No__c;
                    doOutsideCounselRefNoMap.put(doRole.Dispute_Opposition__c,LawFirmRefName);
                    }
                }
                else
                {
                    string LawFirmName= doRole.Law_Firm__r.name;
                    doOutsideCounselMap.put(doRole.Dispute_Opposition__c,LawFirmName);
                    string LawFirmRefName= doRole.Law_Firm__r.Ref_No__c;
                    doOutsideCounselRefNoMap.put(doRole.Dispute_Opposition__c,LawFirmRefName);
                }
        }
            
            
        }
        List<SymphonyIPMExt__Dispute_Opposition__c> listDelDOUpdate = new List<SymphonyIPMExt__Dispute_Opposition__c>();
        for(id recId : doKeyMap.keyset())
        {
             SymphonyIPMExt__Dispute_Opposition__c disputeOpposition = new SymphonyIPMExt__Dispute_Opposition__c();
            disputeOpposition.TM_IP_Paralegal__c = doParalegalMap.get(recId);
            disputeOpposition.Outside_Counsel_Firm__c = doOutsideCounselMap.get(recId);
            disputeOpposition.Outside_Counsel_Reference_Number__c = String.isBlank( doOutsideCounselRefNoMap.get(recId) ) ? '' : doOutsideCounselRefNoMap.get(recId);
            disputeOpposition.CN_TM_Attorney_I__c = doAttorneyMap.get(recId);
            disputeOpposition.CN_TM_Attorney_2__c = doAttorney2Map.get(recId);
            disputeOpposition.TM_IP_Associate__c = doAssosciateMap.get(recId);
            disputeOpposition.TM_IP_Associate_2__c = doAssosciate2Map.get(recId);
            disputeOpposition.TM_Docketer__c = doDocketerMap.get(recId);
            disputeOpposition.TM_IP_Responsiblle_Manager__c = doIPResponsibleManager.get(recId);
            disputeOpposition.Agent__c = doAgentMap.get(recId);
            disputeOpposition.TM_IP_Partner__c = doIPPartnerMap.get(recId);
            disputeOpposition.Id = recId;
            listDelDOUpdate.add(disputeOpposition);
        }
        if(listDelDOUpdate.size()>0)
        {
            update listDelDOUpdate;
        }
    }

}
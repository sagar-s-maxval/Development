trigger trgTrademarkRole on Trademark_Role__c (after insert,after update,after delete) 
{
    if((Trigger.isInsert&&Trigger.isAfter) || (Trigger.isUpdate&&Trigger.isAfter))
    {
        map<id,id> trademarkKeyMap = new map<id,id>();
        map<id,String> TMParalegalMap = new map<id,String>();
        map<id,String> TMOutsideCounselMap = new map<id,String>();
         map<id,String> TMOutsideCounselRefNoMap = new map<id,String>();
        map<id,String> TMAttorneyMap = new map<id,String>();
        map<id,String> TMAttorney2Map = new map<id,String>();
        map<id,String> TMAssosciateMap = new map<id,String>();
        map<id,String> TMAssosciate2Map = new map<id,String>();
        map<id,String> TMDocketerMap = new map<id,String>();
        map<id,String> TMIPRespManagerMap = new map<id,String>();
        map<id,String> TMAgentMap = new map<id,String>();
        map<id,String> TMIPPartnerMap = new map<id,String>();
        for(Trademark_Role__c trademarkRole : Trigger.new)
        {
            
            trademarkKeyMap.put(trademarkRole.Trademark__c,trademarkRole.id);
            
        }
        List<Trademark_Role__c> trademarkRoles = [SELECT Person__r.name,Trademark__c,Law_Firm__r.name,Law_Firm__r.Ref_No__c,Trademark_Roles__c FROM Trademark_Role__c WHERE Trademark__c IN: trademarkKeyMap.keyset()];
        for(Trademark_Role__c trademarkRole :trademarkRoles)
        {
            if(trademarkRole.Trademark_Roles__c == 'TM IP Paralegal')
            {
                if(TMParalegalMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMParalegalMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMParalegalMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMParalegalMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'CN TM Attorney 1')
            {
                if(TMAttorneyMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAttorneyMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAttorneyMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAttorneyMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'CN TM Attorney 2')
            {
                if(TMAttorney2Map.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAttorney2Map.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAttorney2Map.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAttorney2Map.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Associate 1')
            {
                if(TMAssosciateMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAssosciateMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAssosciateMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAssosciateMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Associate 2')
            {
                if(TMAssosciate2Map.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAssosciate2Map.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAssosciate2Map.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAssosciate2Map.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM Docketer')
            {
                if(TMDocketerMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMDocketerMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMDocketerMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMDocketerMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Responsible Manager')
            {
                if(TMIPRespManagerMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMIPRespManagerMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMIPRespManagerMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMIPRespManagerMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'Agent')
            {
                if(TMAgentMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAgentMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAgentMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAgentMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Partner')
            {
                if(TMIPPartnerMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMIPPartnerMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMIPPartnerMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMIPPartnerMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'Outside Counsel Firm')
            {
                if(TMOutsideCounselMap.containskey(trademarkRole.Trademark__c))
                {
                    string LawFirmName =TMOutsideCounselMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Law_Firm__r.name;
                    TMOutsideCounselMap.put(trademarkRole.Trademark__c,LawFirmName);
                    if(!String.IsBlank(trademarkRole.Law_Firm__r.Ref_No__c))
                    {
                    string LawFirmRefName =TMOutsideCounselRefNoMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Law_Firm__r.Ref_No__c;
                    TMOutsideCounselRefNoMap.put(trademarkRole.Trademark__c,LawFirmRefName);
                    }
                }
                else
                {
                    string LawFirmName= trademarkRole.Law_Firm__r.name;
                    TMOutsideCounselMap.put(trademarkRole.Trademark__c,LawFirmName);
                    string LawFirmRefName= trademarkRole.Law_Firm__r.Ref_No__c;
                    TMOutsideCounselRefNoMap.put(trademarkRole.Trademark__c,LawFirmRefName);
                }
        }
            
            
        }
        List<SymphonyIPM__Trademark_New__c> listTrademarkUpdate = new List<SymphonyIPM__Trademark_New__c>();
        for(id recId : trademarkKeyMap.keyset())
        {
            SymphonyIPM__Trademark_New__c tradeMark = new SymphonyIPM__Trademark_New__c();
            tradeMark.TM_IP_Paralegal__c = TMParalegalMap.get(recId);
            tradeMark.Outside_Counsel_Firm__c = TMOutsideCounselMap.get(recId);
            tradeMark.Outside_Counsel_Reference_Number__c = String.isBlank( TMOutsideCounselRefNoMap.get(recId) ) ? '' : TMOutsideCounselRefNoMap.get(recId);
            tradeMark.CN_TM_Attorney_I__c = TMAttorneyMap.get(recId);
            tradeMark.CN_TM_Attorney_2__c = TMAttorney2Map.get(recId);
            tradeMark.TM_IP_Assosciate__c = TMAssosciateMap.get(recId);
            tradeMark.TM_IP_Associate_2__c = TMAssosciate2Map.get(recId);
            tradeMark.TM_Docketer__c = TMDocketerMap.get(recId);
            tradeMark.TM_IP_Responsiblle_Manager__c = TMIPRespManagerMap.get(recId);
            tradeMark.Agent__c = TMAgentMap.get(recId);
            tradeMark.TM_IP_Partner__c = TMIPPartnerMap.get(recId);
            tradeMark.Id = recId;
            listTrademarkUpdate.add(tradeMark);
        }
        if(listTrademarkUpdate.size()>0)
        {
            update listTrademarkUpdate;
        }
    }
    if(Trigger.isAfter&&Trigger.isDelete)
    {
        map<id,id> trademarkKeyMap = new map<id,id>();
        map<id,String> TMParalegalMap = new map<id,String>();
        map<id,String> TMOutsideCounselMap = new map<id,String>();
         map<id,String> TMOutsideCounselRefNoMap = new map<id,String>();
        map<id,String> TMAttorneyMap = new map<id,String>();
        map<id,String> TMAttorney2Map = new map<id,String>();
        map<id,String> TMAssosciateMap = new map<id,String>();
        map<id,String> TMAssosciate2Map = new map<id,String>();
        map<id,String> TMDocketerMap = new map<id,String>();
        map<id,String> TMIPRespManagerMap = new map<id,String>();
        map<id,String> TMAgentMap = new map<id,String>();
        map<id,String> TMIPPartnerMap = new map<id,String>();
        for(Trademark_Role__c trademarkRole : Trigger.old)
        {
            if(trademarkRole.Trademark_Roles__c == 'TM IP Paralegal' || trademarkRole.Trademark_Roles__c == 'Outside Counsel Firm' || trademarkRole.Trademark_Roles__c == 'TM IP Partner' || trademarkRole.Trademark_Roles__c == 'Agent' || trademarkRole.Trademark_Roles__c == 'TM IP Responsible Manager' || trademarkRole.Trademark_Roles__c == 'TM Docketer' || trademarkRole.Trademark_Roles__c == 'TM IP Associate 2' || trademarkRole.Trademark_Roles__c == 'TM IP Associate 1' || trademarkRole.Trademark_Roles__c == 'CN TM Attorney 2' || trademarkRole.Trademark_Roles__c == 'CN TM Attorney 1')
            {
                trademarkKeyMap.put(trademarkRole.Trademark__c,trademarkRole.id);
            }
            
        }
        List<Trademark_Role__c> trademarkRoles = [SELECT Person__r.name,Trademark__c,Trademark_Roles__c,Law_Firm__r.name,Law_Firm__r.Ref_No__c FROM Trademark_Role__c WHERE Trademark__c IN: trademarkKeyMap.keyset()];
        for(Trademark_Role__c trademarkRole :trademarkRoles)
        {
            if(trademarkRole.Trademark_Roles__c == 'TM IP Paralegal')
            {
                if(TMParalegalMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMParalegalMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMParalegalMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMParalegalMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'CN TM Attorney 1')
            {
                if(TMAttorneyMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAttorneyMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAttorneyMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAttorneyMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'CN TM Attorney 2')
            {
                if(TMAttorney2Map.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAttorney2Map.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAttorney2Map.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAttorney2Map.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Associate 1')
            {
                if(TMAssosciateMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAssosciateMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAssosciateMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAssosciateMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Associate 2')
            {
                if(TMAssosciate2Map.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAssosciate2Map.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAssosciate2Map.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAssosciate2Map.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM Docketer')
            {
                if(TMDocketerMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMDocketerMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMDocketerMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMDocketerMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Responsible Manager')
            {
                if(TMIPRespManagerMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMIPRespManagerMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMIPRespManagerMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMIPRespManagerMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'Agent')
            {
                if(TMAgentMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMAgentMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMAgentMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMAgentMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'TM IP Partner')
            {
                if(TMIPPartnerMap.containskey(trademarkRole.Trademark__c))
                {
                    string personName =TMIPPartnerMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Person__r.name;
                    TMIPPartnerMap.put(trademarkRole.Trademark__c,personName);
                } 
                else{
                    string personName= trademarkRole.Person__r.name;
                    TMIPPartnerMap.put(trademarkRole.Trademark__c,personName);
                }
            }
            if(trademarkRole.Trademark_Roles__c == 'Outside Counsel Firm')
            {
                if(TMOutsideCounselMap.containskey(trademarkRole.Trademark__c))
                {
                    string LawFirmName =TMOutsideCounselMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Law_Firm__r.name;
                    TMOutsideCounselMap.put(trademarkRole.Trademark__c,LawFirmName);
                    string LawFirmRefName =TMOutsideCounselRefNoMap.get(trademarkRole.Trademark__c)+','+trademarkRole.Law_Firm__r.Ref_No__c;
                    TMOutsideCounselRefNoMap.put(trademarkRole.Trademark__c,LawFirmRefName);
                }
                else
                {
                    string LawFirmName= trademarkRole.Law_Firm__r.name;
                    TMOutsideCounselMap.put(trademarkRole.Trademark__c,LawFirmName);
                    string LawFirmRefName= trademarkRole.Law_Firm__r.Ref_No__c;
                    TMOutsideCounselRefNoMap.put(trademarkRole.Trademark__c,LawFirmRefName);
                }
        }
            
            
        }
        List<SymphonyIPM__Trademark_New__c> listDelTrademarkUpdate = new List<SymphonyIPM__Trademark_New__c>();
        for(id recId : trademarkKeyMap.keyset())
        {
            SymphonyIPM__Trademark_New__c tradeMark = new SymphonyIPM__Trademark_New__c();
            tradeMark.TM_IP_Paralegal__c = TMParalegalMap.get(recId);
            tradeMark.Outside_Counsel_Firm__c = TMOutsideCounselMap.get(recId);
            tradeMark.Outside_Counsel_Reference_Number__c =TMOutsideCounselRefNoMap.get(recId);
            tradeMark.CN_TM_Attorney_I__c = TMAttorneyMap.get(recId);
            tradeMark.CN_TM_Attorney_2__c = TMAttorney2Map.get(recId);
            tradeMark.TM_IP_Assosciate__c = TMAssosciateMap.get(recId);
            tradeMark.TM_IP_Associate_2__c = TMAssosciate2Map.get(recId);
            tradeMark.TM_Docketer__c = TMDocketerMap.get(recId);
            tradeMark.TM_IP_Responsiblle_Manager__c = TMIPRespManagerMap.get(recId);
            tradeMark.Agent__c = TMAgentMap.get(recId);
            tradeMark.TM_IP_Partner__c = TMIPPartnerMap.get(recId);
            tradeMark.Id = recId;
            listDelTrademarkUpdate.add(tradeMark);
        }
        if(listDelTrademarkUpdate.size()>0)
        {
            update listDelTrademarkUpdate;
        }
    }
}
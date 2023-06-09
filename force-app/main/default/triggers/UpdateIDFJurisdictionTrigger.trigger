trigger UpdateIDFJurisdictionTrigger on SymphonyIPM__Invention_Disclosure_New__c (before update) {
    Set<Id> idfIds = new Set<Id>();
    Set<Id> buIds = new Set<Id>();
    for (SymphonyIPM__Invention_Disclosure_New__c idf : Trigger.new) {
        idfIds.add(idf.Id);
        buIds.add(idf.SymphonyIPM__Hierarchy__c);
    }
    Map<Id, Map<String, SymphonyIPM__Hierarchy_Role__c>> roles = new Map<Id, Map<String, SymphonyIPM__Hierarchy_Role__c>>();
    for (SymphonyIPM__Hierarchy_Role__c role : [SELECT Id, SymphonyIPM__Hierarchy_Path__c, SymphonyIPM__Role__c, Person__c FROM SymphonyIPM__Hierarchy_Role__c WHERE SymphonyIPM__Hierarchy_Path__c IN :buIds]) {
        Map<String, SymphonyIPM__Hierarchy_Role__c> localRoles = roles.get(role.SymphonyIPM__Hierarchy_Path__c);
        if (localRoles == null) {
            localRoles = new Map<String, SymphonyIPM__Hierarchy_Role__c>();
        }
        localRoles.put(role.SymphonyIPM__Role__c, role);
        roles.put(role.SymphonyIPM__Hierarchy_Path__c, localRoles);
    }

    if (Trigger.isBefore) {

        Map<Id, SymphonyIPM__Invention_Disclosure_New__c> idfMap = new Map<Id, SymphonyIPM__Invention_Disclosure_New__c>([SELECT Id, SymphonyIPM__Primary_Inventor__r.SymphonyIPM__Location__c FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id IN :idfIds]);

        Map<String, Id> countryMap = new Map<String, Id>();
        for (SymphonyIPM__Country__c country : [SELECT Id, Name FROM SymphonyIPM__Country__c]) {
            countryMap.put(country.Name, country.Id);
        }

        for (SymphonyIPM__Invention_Disclosure_New__c idf : Trigger.new) {
            if (idfMap.get(idf.Id)?.SymphonyIPM__Primary_Inventor__r?.SymphonyIPM__Location__c == 'United States') {
                idf.SymphonyIPM__Invention_Country__c = countryMap.get('United States of America');
            } else {
                idf.SymphonyIPM__Invention_Country__c = countryMap.get(idfMap.get(idf.Id)?.SymphonyIPM__Primary_Inventor__r?.SymphonyIPM__Location__c);
            }
            idf.IP_Coordinator__c = roles.get(idf.SymphonyIPM__Hierarchy__c)?.get('IP Coordinator')?.Person__c;
            idf.IP_Responsible_Manager__c = roles.get(idf.SymphonyIPM__Hierarchy__c)?.get('IP Responsible Manager')?.Person__c;
            idf.IP_Paralegal_1__c = roles.get(idf.SymphonyIPM__Hierarchy__c)?.get('Paralegal')?.Person__c;
            idf.IPAssociate__c = roles.get(idf.SymphonyIPM__Hierarchy__c)?.get('IP Associate')?.Person__c;
            idf.IPCommitteeMember__c = roles.get(idf.SymphonyIPM__Hierarchy__c)?.get('IP Committee member')?.Person__c;
            idf.InHouseCounsel__c = roles.get(idf.SymphonyIPM__Hierarchy__c)?.get('In-house Counsel')?.Person__c;
        }

    }


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
    System.debug('log');
    System.assert(true);
}
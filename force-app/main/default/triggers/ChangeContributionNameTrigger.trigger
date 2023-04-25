trigger ChangeContributionNameTrigger on Remuneration__c (before insert, before update) {

    Set<Id> idfIds = new Set<Id>();
    Set<Id> userIds = new Set<Id>();
    Set<String> inventorsEmails = new Set<String>();

    for (Remuneration__c remuneration : Trigger.new) {
        idfIds.add(remuneration.Invention_Disclosure__c);
        userIds.add(remuneration.User__c);
    }

    Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Email FROM User WHERE Id IN : userIds]);

    for (Remuneration__c remuneration : Trigger.new) {
        if (userMap.get(remuneration.User__c)?.Email != null) {
            inventorsEmails.add(userMap.get(remuneration.User__c)?.Email);
        }
    }

    Map<Id, SymphonyIPM__Invention_Disclosure_New__c> inventionDisclosures = new Map<Id, SymphonyIPM__Invention_Disclosure_New__c>([SELECT Id, Name FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id IN :idfIds]);
    List<SymphonyIPM__Inventor__c> inventors = [SELECT Id, Name, SymphonyIPM__Location__c, SymphonyIPM__Email__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c IN :inventorsEmails];

    Map<String, SymphonyIPM__Inventor__c> emailToInventorMap = new Map<String, SymphonyIPM__Inventor__c>();
    for(SymphonyIPM__Inventor__c inventor: inventors) {
        emailToInventorMap.put(inventor.SymphonyIPM__Email__c, inventor);
    }

    Map<String, String> countryNameToCodeMap = new Map<String, String>();
    for (SymphonyIPM__Country__c country : [SELECT SymphonyIPM__Country_Code__c, Name FROM SymphonyIPM__Country__c]) {
        countryNameToCodeMap.put( country.Name, country.SymphonyIPM__Country_Code__c);
    }

    for (Remuneration__c remuneration : Trigger.new) {
        remuneration.Country__c = emailToInventorMap.get(userMap.get(remuneration.User__c)?.Email)?.SymphonyIPM__Location__c;
        remuneration.Person__c = emailToInventorMap.get(userMap.get(remuneration.User__c)?.Email)?.Id;
    }
}
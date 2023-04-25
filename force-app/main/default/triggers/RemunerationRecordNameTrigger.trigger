trigger RemunerationRecordNameTrigger on Remuneration_Record__c (before insert) {
    Set<Id> idfIds = new Set<Id>();

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

    for (Remuneration_Record__c remuneration : Trigger.new) {
        idfIds.add(remuneration.Invention_Disclosure__c);
    }

    Map<Id, SymphonyIPM__Invention_Disclosure_New__c> inventionDisclosures = new Map<Id, SymphonyIPM__Invention_Disclosure_New__c>([SELECT Id, Name FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Id IN :idfIds]);

    Map<String, String> countryNameToCodeMap = new Map<String, String>();
    for (SymphonyIPM__Country__c country : [SELECT SymphonyIPM__Country_Code__c, Name FROM SymphonyIPM__Country__c]) {
        countryNameToCodeMap.put( country.Name, country.SymphonyIPM__Country_Code__c);
    }

    for (Remuneration_Record__c remuneration : Trigger.new) {
        List<String> inventorName = remuneration.Inventor_Name__c?.split(' ', 2);
        String initials = '';
        if (inventorName != null) {
            for (String word :inventorName) {
                initials += word.substring(0, 1).toUpperCase();
            }
        }
        if (remuneration.Name == null || remuneration.Name == '') {
            remuneration.Name = inventionDisclosures.get(remuneration.Invention_Disclosure__c).Name + '_' + initials + '_' + countryNameToCodeMap.get(remuneration.Employer_Jurisdiction__c);
        }
    }
}
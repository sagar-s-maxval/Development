trigger IFWDataTrigger on SymphonyIPM__IFW_Data_v1__c (before insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        List<SymphonyIPM__IFW_Data_v1__c> documentsCode_892 = new List<SymphonyIPM__IFW_Data_v1__c>();

        for (SymphonyIPM__IFW_Data_v1__c data : Trigger.new) {
            if (data.SymphonyIPM__Document_Code__c == '892') {
                documentsCode_892.add(data);
            }
        }
        PatentService.createSIDSDocketActivity(documentsCode_892);
    }

}
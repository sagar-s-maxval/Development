@IsTest
global with sharing class HRDeactivatePersonsBatchTest {

    @IsTest
    global static void test() {

        List<String> ids = new List<String>{
                '000550798', '000061946', '000111303', '000014565', '000070728', '000005198', '000053042', '000004978', '000036581', '000332569', '000009204', '000134158', '000236203', '000053036', '000360934', '000102723', '000100633', '000009418', '000251015', '000066614', '000317096', '000067835', '000003349', '000013951', '000373379', '000202719', '000016045', '000013265', '000376012', '000003895', '000178433', '000038227', '000067601', '000198879', '000130706', '000096533', '000361815', '000040469', '000006592', '000053872', '000035175', '000354262', '000257376', '000134006', '000121760', '000069733', '000036540', '000346428', '000094727', '000094900'
        };

        SymphonyIPM__Law_Firm__c lawFirm = new SymphonyIPM__Law_Firm__c(Name = 'law');
        insert lawFirm;

        List<SymphonyIPM__Inventor__c> inventors = new List<SymphonyIPM__Inventor__c>();

        for (Integer i = 0; i < 200; i++) {
            inventors.add(new SymphonyIPM__Inventor__c(
                    Status__c = 'Active',
                    First_Name__c = 'inv ' + i,
                    Last_Name__c = 'l ' + i,
                    SymphonyIPM__Email__c = 'mail' + i + '@csv.vom.invalid',
                    MSID__c = 'SID ' + i,
                    SymphonyIPM__Employee_ID__c = i < 50 ? ids.get(i) : null));
        }

        insert inventors;

        System.debug('inventors ' + inventors.size() + ' ' + inventors);


        Test.startTest();

        HRDeactivatePersonsBatch batch = new HRDeactivatePersonsBatch(new Set<String>(ids));
        Database.executeBatch(batch);

        Test.stopTest();

        List<SymphonyIPM__Inventor__c> updated = [SELECT Id, Status__c FROM SymphonyIPM__Inventor__c WHERE Status__c = 'Deactivated'];
        List<SymphonyIPM__Inventor__c> notUpdated = [SELECT Id, Status__c FROM SymphonyIPM__Inventor__c WHERE Status__c = 'Active'];

        System.debug('updated ' + updated);
        System.debug('notUpdated ' + notUpdated);

        System.assertEquals(150, updated.size());
        System.assertEquals(50, notUpdated.size());
    }
}
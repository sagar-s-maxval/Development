@IsTest
private class RemunerationControllerTest {

    @TestSetup
    public static void testSetup() {
        SymphonyIPM__Invention_Disclosure_New__c idf = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test', SymphonyIPM__Title__c = 'Test');
        insert idf;

        SymphonyIPM__Inventor__c primary = new SymphonyIPM__Inventor__c(Name = 'Test Inventor', SymphonyIPM__Email__c = 'test1@test.com');
        insert primary;

        SymphonyIPM__Inventor__c additional = new SymphonyIPM__Inventor__c(Name = 'Additional Inventor', SymphonyIPM__Email__c = 'test2@test.com');
        insert additional;

        SymphonyIPM__Additional_Inventor__c idInventors = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Inventor__c = additional.Id, SymphonyIPM__Invention_Disclosure_New__c = idf.Id);
        insert idInventors;

        insert new Remuneration__c(Inventor_Full_Name__c = 'TEST1', Invention_Disclosure__c = idf.Id, User__c = UserInfo.getUserId());
        insert new Remuneration__c(Inventor_Full_Name__c = 'TEST2', Invention_Disclosure__c = idf.Id);

        SymphonyIPM__Invention_Disclosure_New__c idf2 = new SymphonyIPM__Invention_Disclosure_New__c(Name = 'Test2', SymphonyIPM__Title__c = 'Test2');
        insert idf2;
        insert new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Inventor__c = additional.Id, SymphonyIPM__Invention_Disclosure_New__c = idf2.Id);

    }

    @IsTest
    public static void testGetRemunerations() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Name = 'Test' LIMIT 1]?.Id;

        Test.startTest();
        List<Remuneration__c> result = RemunerationController.getRemunerations(idfId, UserInfo.getUserId());
        Test.stopTest();

        System.assertEquals(1, result.size());
    }

    @IsTest
    public static void testGetInventorsForRemuneration() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Name = 'Test' LIMIT 1]?.Id;

        Test.startTest();
        List<SymphonyIPM__Additional_Inventor__c> result = RemunerationController.getInventorsForRemuneration(idfId, new List<String> {'NAME'});
        Test.stopTest();

        System.assertEquals(1, result.size());
    }

    @IsTest
    public static void testGetRemuneration() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Name = 'Test' LIMIT 1]?.Id;

        Test.startTest();
        Remuneration__c result = RemunerationController.getRemuneration(UserInfo.getUserId(), idfId);
        Test.stopTest();

        System.assertEquals('TEST1', result.Inventor_Full_Name__c);
    }

    @IsTest
    public static void testCountRemuneration() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Name = 'Test2' LIMIT 1]?.Id;

        Test.startTest();
        Decimal result = RemunerationController.countRemuneration(idfId);
        Test.stopTest();

        System.assertEquals(100, result);
    }

    @IsTest
    public static void testGetMaximumAllowedContribution() {
        Id idfId = [SELECT Id FROM SymphonyIPM__Invention_Disclosure_New__c WHERE Name = 'Test2' LIMIT 1]?.Id;

        Test.startTest();
        Decimal result = RemunerationController.getMaximumAllowedContribution(idfId, UserInfo.getUserId());
        Test.stopTest();

        System.assertEquals(100, result);
    }

}
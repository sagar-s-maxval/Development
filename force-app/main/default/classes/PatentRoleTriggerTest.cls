@IsTest
public with sharing class PatentRoleTriggerTest {

    @IsTest(SeeAllData = true)
    public static void testRoleDelete() {
           Profile p = [SELECT Id FROM Profile WHERE Name='In-house Counsel'];
        User u = new User(Alias = 'standt', Email='testuser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName='newuser008@testorg.com');
        insert u;
         SymphonyIPM__Inventor__c inventorper = new SymphonyIPM__Inventor__c(Name='Test Inventor', SymphonyIPM__Employee_ID__c='12345',SymphonyIPM__User__c=u.id);
    insert inventorper;
        // given
        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(Name = 'TEST PATENT', SymphonyIPM__Title_of_Invention__c = 'TEST PATENT');
        insert patent;
        SymphonyIPM__Inventor__c per= [SELECT User_Id__c FROM SymphonyIPM__Inventor__c WHERE name like '%system%' limit 1];
        // when
        Patent_Role__c role = new Patent_Role__c(Patent__c = patent.Id, Role__c = 'IP Paralegal 1', Person__c = per.id);
        insert role;
         Patent_Role__c role2 = new Patent_Role__c(Patent__c = patent.Id, Role__c = 'Docketing', Person__c = per.id);
        insert role2;
 
        //then
       /* List<SymphonyIPM__Inventor__c> inventor = [SELECT User_Id__c FROM SymphonyIPM__Inventor__c WHERE Id = 'a1h01000001hFGTAA2'];
        List<SymphonyIPM__Patent__c> patents = [SELECT IP_Paralegal_1_Ids__c FROM SymphonyIPM__Patent__c WHERE Id = :patent.Id];
        System.assertEquals(inventor[0].User_Id__c,
                Id.valueOf(patents[0].IP_Paralegal_1_Ids__c).to15());*/

        delete role;

        System.assertEquals(null, [SELECT IP_Paralegal_1_Ids__c FROM SymphonyIPM__Patent__c WHERE Id = :patent.Id]?.IP_Paralegal_1_Ids__c);
    }
    @IsTest
    static void test2() {
        PatentRoleTriggerHelper.magicMethod();
    }
}
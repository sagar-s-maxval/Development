@IsTest
private class SDocTriggerTest {

    @IsTest
    static void testBehavior() {
        SymphonyIPM__Inventor__c inv = new SymphonyIPM__Inventor__c(Name = 'Person');
        insert inv;

        RecordType type = [SELECT Id, Name FROM RecordType WHERE Name = 'OC' LIMIT 1];
        System.debug('type ' + type);

        SymphonyIPM__Inventor__c function = new SymphonyIPM__Inventor__c(Name = 'function', RecordTypeId = type.Id);
        insert function;

        SymphonyIPM__Hierarchy__c hierarchy = new SymphonyIPM__Hierarchy__c(Name = 'TestBU');
        insert hierarchy;

        SymphonyIPM__Hierarchy_Role__c role = new SymphonyIPM__Hierarchy_Role__c(SymphonyIPM__Hierarchy_Path__c = hierarchy.Id, Person__c = function.Id, Function_Role__c = 'Head of R&D');
        insert role;

        SymphonyIPM__Invention_Disclosure_New__c inventionDisclosureNew = new SymphonyIPM__Invention_Disclosure_New__c(SymphonyIPM__Hierarchy__c = hierarchy.Id);
        insert inventionDisclosureNew;

        SymphonyIPM__Additional_Inventor__c addInv = new SymphonyIPM__Additional_Inventor__c(SymphonyIPM__Inventor__c = inv.Id, SymphonyIPM__Invention_Disclosure_New__c = inventionDisclosureNew.Id);
        insert addInv;

        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'TestPatent');
        insert patent;

        SymphonyIPM__Asset_Inventor_v1__c assetInventor = new SymphonyIPM__Asset_Inventor_v1__c(SymphonyIPM__Asset__c = patent.Id, SymphonyIPM__Inventor__c = inv.Id);
        insert assetInventor;

        SDOC__SDTemplate__c template = new SDOC__SDTemplate__c(SDOC__Template_Format__c = 'PDF', SDOC__Base_Object__c = 'SymphonyIPM__Additional_Inventor__c', Sign_Type__c = 'All Inventors and Function');
        insert template;

        SDOC__SDoc__c doc = new SDOC__SDoc__c(SDOC__SDTemplate__c = template.Id, SDOC__ObjectID18__c = addInv.Id, SDOC__ObjectType__c = 'SymphonyIPM__Additional_Inventor__c');

        SDOC__SDTemplate__c template2 = new SDOC__SDTemplate__c(SDOC__Template_Format__c = 'PDF', SDOC__Base_Object__c = 'SymphonyIPM__Patent__c', Sign_Type__c = 'All Inventors');
        insert template2;

        SDOC__SDoc__c doc2 = new SDOC__SDoc__c(SDOC__SDTemplate__c = template2.Id, SDOC__ObjectID18__c = patent.Id, SDOC__ObjectType__c = 'SymphonyIPM__Patent__c');

        Test.startTest();

        insert doc;
        insert doc2;

        Test.stopTest();

        SDOC__SDoc__c sDoc1 = [SELECT Id, Related_Patent_Or_ID__c, RelatedIds__c FROM SDOC__SDoc__c WHERE SDOC__ObjectType__c = 'SymphonyIPM__Additional_Inventor__c'];
        SDOC__SDoc__c sDoc2 = [SELECT Id, Related_Patent_Or_ID__c, RelatedIds__c FROM SDOC__SDoc__c WHERE SDOC__ObjectType__c = 'SymphonyIPM__Patent__c'];

        System.debug('SDoc1 ' + sDoc1);
        System.debug('SDoc2 ' + sDoc2);

        System.assertEquals(true, sDoc1.RelatedIds__c.contains(String.valueOf(inv.Id)));
        System.assertEquals(true, sDoc1.RelatedIds__c.contains(String.valueOf(function.Id)));
        System.assertEquals(inventionDisclosureNew.Id, sDoc1.Related_Patent_Or_ID__c);

        System.assertEquals(true, sDoc2.RelatedIds__c.contains(String.valueOf(inv.Id)));
    }
}
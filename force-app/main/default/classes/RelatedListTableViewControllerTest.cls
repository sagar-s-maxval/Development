@IsTest
private class RelatedListTableViewControllerTest {
    @TestSetup
    static void setup() {

        SymphonyIPM__Patent__c patent = new SymphonyIPM__Patent__c(SymphonyIPM__Title_of_Invention__c = 'test');
        insert patent;

        List<SymphonyIPM__Docketing_Activity_v2__c> activities = new List<SymphonyIPM__Docketing_Activity_v2__c>();

        for (Integer i = 0; i < 10; i++) {
            activities.add(
                    new SymphonyIPM__Docketing_Activity_v2__c(
                            SymphonyIPM__Patent__c = patent.Id
                    )
            );
        }

        insert activities;
    }

    @IsTest
    static void getTablePositive() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();
        RelatedListTableViewController.Table table = RelatedListTableViewController.getTable(
                patents.get(0).Id,
                'SymphonyIPM__Docketing_Activity_v2__c',
                'SymphonyIPM__Patent__c',
                'table_view'
        );
        Test.stopTest();

        System.debug('table ' + table);

        FieldSet fS = FieldSetHelper.getFieldSetBySObjectAndName('SymphonyIPM__Docketing_Activity_v2__c', 'table_view');
        List<SymphonyIPM__Docketing_Activity_v2__c> activities = [SELECT Id FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Patent__c = :patents.get(0).Id];

        System.assertEquals(fS.getFields().size(), table.columns.size());
        System.assertEquals(activities.size(), table.records.size());

    }

    @IsTest
    static void getTableNegativeNoRecordId() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();
        try {
            RelatedListTableViewController.getTable(
                    null,
                    'SymphonyIPM__Docketing_Activity_v2__c',
                    'SymphonyIPM__Patent__c',
                    'table_view'
            );
        } catch (Exception e) {
            System.debug('exc ' + e);
            System.assertEquals(true, e instanceof AuraHandledException);
        }

        Test.stopTest();

    }

    @IsTest
    static void getTableNegativeNoSObjectApiName() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();

        try {
            RelatedListTableViewController.getTable(
                    patents.get(0).Id,
                    null,
                    'SymphonyIPM__Patent__c',
                    'table_view'
            );
        } catch (Exception e) {
            System.debug('exc ' + e);
            System.assertEquals(true, e instanceof AuraHandledException);
        }

        Test.stopTest();

    }

    @IsTest
    static void getTableNegativeNoParentLookupField() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();

        try {
            RelatedListTableViewController.getTable(
                    patents.get(0).Id,
                    'SymphonyIPM__Docketing_Activity_v2__c',
                    null,
                    'table_view'
            );
        } catch (Exception e) {
            System.debug('exc ' + e);
            System.assertEquals(true, e instanceof AuraHandledException);
        }

        Test.stopTest();

    }

    @IsTest
    static void getTableNegativeNoFieldSet() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();


        try {
            RelatedListTableViewController.getTable(
                    patents.get(0).Id,
                    'SymphonyIPM__Docketing_Activity_v2__c',
                    'SymphonyIPM__Patent__c',
                    null
            );
        } catch (Exception e) {
            System.debug('exc ' + e);
            System.assertEquals(true, e instanceof AuraHandledException);
        }

        Test.stopTest();

    }

    @IsTest
    static void getTableNegativeWrongFieldSet() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();

        try {
            RelatedListTableViewController.getTable(
                    patents.get(0).Id,
                    'SymphonyIPM__Docketing_Activity_v2__c',
                    'SymphonyIPM__Patent__c',
                    'wrong set'
            );
        } catch (Exception e) {
            System.debug('exc ' + e);
            System.assertEquals(true, e instanceof AuraHandledException);
        }

        Test.stopTest();

    }

    @IsTest
    static void getTableNegativeWrongSObjectApiName() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();

        try {
            RelatedListTableViewController.getTable(
                    patents.get(0).Id,
                    'wrong_object',
                    'SymphonyIPM__Patent__c',
                    'table_view'
            );
        } catch (Exception e) {
            System.debug('exc ' + e);
            System.assertEquals(true, e instanceof AuraHandledException);
        }

        Test.stopTest();

    }

    @IsTest
    static void getTableNegativeWrongParentLookupField() {

        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        Test.startTest();

        try {
            RelatedListTableViewController.getTable(
                    patents.get(0).Id,
                    'SymphonyIPM__Docketing_Activity_v2__c',
                    'wrong_field',
                    'table_view'
            );
        } catch (Exception e) {
            System.debug('exc ' + e);
            System.assertEquals(true, e instanceof AuraHandledException);
        }

        Test.stopTest();

    }

    @IsTest
    static void updatePositive() {
        List<SymphonyIPM__Patent__c> patents = [SELECT Id FROM SymphonyIPM__Patent__c];

        List<SymphonyIPM__Docketing_Activity_v2__c> activities = [SELECT Id, SymphonyIPM__Is_Closed__c FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Patent__c = :patents.get(0).Id];

        for (SymphonyIPM__Docketing_Activity_v2__c activity : activities) {
            activity.SymphonyIPM__Is_Closed__c = true;
        }

        Test.startTest();

        RelatedListTableViewController.updateRecords(activities);
        QueryBuilder.magicMethod();

        Test.stopTest();

        List<SymphonyIPM__Docketing_Activity_v2__c> res = [SELECT Id, SymphonyIPM__Is_Closed__c FROM SymphonyIPM__Docketing_Activity_v2__c WHERE SymphonyIPM__Patent__c = :patents.get(0).Id];

        for (SymphonyIPM__Docketing_Activity_v2__c activity : res) {
            System.assertEquals(true, activity.SymphonyIPM__Is_Closed__c);
        }
    }
}
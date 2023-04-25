@IsTest
private class FieldSetHelperTest {
    @IsTest
    static void getFieldSetPositive() {

        Test.startTest();

        FieldSet fS = FieldSetHelper.getFieldSetBySObjectAndName('SymphonyIPMExt__D_O_Docketing_Activity__c', 'table_view');

        Test.stopTest();

        System.assertNotEquals(null, fS);
    }

    @IsTest
    static void getFieldSetNegative() {

        Test.startTest();
        try {
            FieldSetHelper.getFieldSetBySObjectAndName('SymphonyIPMExt__D_O_Docketing_Activity__c', '');
        } catch (Exception e) {

            System.assertEquals('No Field Set Found', e.getMessage());
        }
        Test.stopTest();

    }

    @IsTest
    static void testGetApiNames() {

        FieldSet fS = FieldSetHelper.getFieldSetBySObjectAndName('SymphonyIPMExt__D_O_Docketing_Activity__c', 'table_view');

        Set<String> names;
        Test.startTest();

        names = FieldSetHelper.getApiNames(fS.getFields());

        Test.stopTest();

        System.assertNotEquals(null, names);
        System.assertEquals(fS.getFields().size(), names.size());
    }

}
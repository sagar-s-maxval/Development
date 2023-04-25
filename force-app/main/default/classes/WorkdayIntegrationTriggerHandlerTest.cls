@IsTest
public with sharing class WorkdayIntegrationTriggerHandlerTest {

    @TestSetup
    public static void testSetup() {
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(Preferred_Name__c = 'Test Inventor', SymphonyIPM__Employee_ID__c = '12345');
        insert inventor;

        SymphonyIPM__Country__c jursidiction = new SymphonyIPM__Country__c(Name = 'Ukraine', Is_Remuneration_Applicable__c = false);
        insert jursidiction;
    }

    @IsTest
    public static void nonRemunerationActiveUser(){
        Test.startTest();
        {
            Temp_Workday_Int__c workday = new Temp_Workday_Int__c(Email__c = 'testuser@gmail.com',employee_first_name__c = 'James', EmployeeLastName__c = 'Bond', Employee_Id__c = '12345',Employer_Country__c = 'Ukraine');
            insert workday;
        }
        Test.stopTest();
        SymphonyIPM__Inventor__c person = [SELECT Id,SymphonyIPM__Is_Eligible_for_Inventor_Award__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c = 'testuser@gmail.com' LIMIT 1];
        System.assert(person.SymphonyIPM__Is_Eligible_for_Inventor_Award__c);

    }
    @IsTest
    public static void activeUserEmploymentStatusActive(){

        Test.startTest();

        Temp_Workday_Int__c workday = new Temp_Workday_Int__c(Email__c = 'testuser@gmail.com',employee_first_name__c = 'James', EmployeeLastName__c = 'Bond', Employee_Id__c = '12345');
        insert workday;

        SymphonyIPM__Inventor__c person = [SELECT Id,SymphonyIPM__Email__c,SymphonyIPM__User__c, SymphonyIPM__Employment_status__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Email__c = 'testuser@gmail.com' LIMIT 1];

        Test.stopTest();

        System.assertEquals('Active',person.SymphonyIPM__Employment_status__c);
    }


    @IsTest
    public static void testBusinessUnit() {
        SymphonyIPM__Hierarchy__c bu = new SymphonyIPM__Hierarchy__c(Name = 'TEST BU', Group__c = 'AIG', Division__c = 'CMD', Business_Unit__c = 'AIG-CMD-CMD Division Office');
        insert bu;

        Test.startTest();
        Temp_Workday_Int__c workday = new Temp_Workday_Int__c(employee_first_name__c = 'test name', EmployeeLastName__c = 'test last name', Employee_Id__c = '12345', Group_Code__c = 'AIG', Division_Code__c = 'CMD', Business_Unit__c = 'AIG-CMD-CMD Division Office');
        insert workday;
        Test.stopTest();

        List<SymphonyIPM__Inventor__c> inventors = [SELECT Id, Hierarchy__c FROM SymphonyIPM__Inventor__c];
        System.assertEquals(bu.Id, inventors.get(0).Hierarchy__c);

        //to overpass update trigger local run
        update workday;
    }

    @IsTest
    public static void testDateWithHyphens() {
        Test.startTest();
        insert new Temp_Workday_Int__c(employee_first_name__c = 'test name', EmployeeLastName__c = 'test last name', Employee_Id__c = '12345', Start_Date__c = '2020-05-06', Termination_Date__c = '2020-07-08');
        Test.stopTest();

        List<SymphonyIPM__Inventor__c> inventors = [SELECT Id, Start_Date__c, Termination_Date__c FROM SymphonyIPM__Inventor__c];
        System.assertNotEquals(null, inventors.get(0).Start_Date__c);
        System.assertNotEquals(null, inventors.get(0).Termination_Date__c);
    }

    @IsTest
    public static void testDateWithSlash() {
        Test.startTest();
        insert new Temp_Workday_Int__c(employee_first_name__c = 'test name', EmployeeLastName__c = 'test last name', Employee_Id__c = '12345', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
        Test.stopTest();

        List<SymphonyIPM__Inventor__c> inventors = [SELECT Id, Start_Date__c, Termination_Date__c FROM SymphonyIPM__Inventor__c];
        System.assertNotEquals(null, inventors.get(0).Start_Date__c);
        System.assertNotEquals(null, inventors.get(0).Termination_Date__c);
    }

    @IsTest
    public static void testDateFormatsEmpty() {

        Test.startTest();
        insert new Temp_Workday_Int__c(employee_first_name__c = 'test name', EmployeeLastName__c = 'test last name', Employee_Id__c = '12345', Start_Date__c = '', Termination_Date__c = '');
        Test.stopTest();

        List<SymphonyIPM__Inventor__c> inventors = [SELECT Id, Start_Date__c, Termination_Date__c FROM SymphonyIPM__Inventor__c];
        System.assertEquals(null, inventors.get(0).Start_Date__c);
        System.assertEquals(null, inventors.get(0).Termination_Date__c);
    }

    @IsTest
    public static void testUpdatingExistingPerson() {

        Test.startTest();

        insert new Temp_Workday_Int__c(employee_first_name__c = 'Albus', EmployeeLastName__c = '', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
        Temp_Workday_Int__c tmp = [SELECT Id, employee_first_name__c, EmployeeLastName__c FROM Temp_Workday_Int__c WHERE employee_first_name__c = 'Albus' LIMIT 1];

        SymphonyIPM__Inventor__c person = [SELECT Name, SymphonyIPM__Employee_ID__c, Source__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        tmp.employee_first_name__c = 'Severus';
        tmp.EmployeeLastName__c = 'Snape';
        update tmp;
        Test.stopTest();

        person = [SELECT Preferred_Name__c, SymphonyIPM__Employee_ID__c, Source__c, Name FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321'];

        System.assert(person != null);
        System.assertEquals('Severus Snape',person.Name);


    }

    @IsTest
    public static void blankFirstName() {

        Test.startTest();

        insert new Temp_Workday_Int__c(employee_first_name__c = '', EmployeeLastName__c = 'Dambldoor', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');

        Test.stopTest();
        SymphonyIPM__Inventor__c person = [SELECT Preferred_Name__c, SymphonyIPM__Employee_ID__c, Source__c, Name FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assertEquals('Dambldoor',person.Name);
    }

    @IsTest
    public static void blankLastName() {
        Test.startTest();
        {
            insert new Temp_Workday_Int__c(employee_first_name__c = 'Albus', EmployeeLastName__c = '', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
        }
        Test.stopTest();

        SymphonyIPM__Inventor__c person = [SELECT Preferred_Name__c, SymphonyIPM__Employee_ID__c, Source__c, Name FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assertEquals('Albus',person.Name);
    }

    @IsTest
    public static void firstAndLastNameBlank(){
        Test.startTest();
        {
            insert new Temp_Workday_Int__c(employee_first_name__c = '', EmployeeLastName__c = '', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
        }
        Test.stopTest();

        SymphonyIPM__Inventor__c person = [SELECT Preferred_Name__c, SymphonyIPM__Employee_ID__c, Source__c, Name FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.debug(person.Name);
        System.assert(!String.isBlank(person.Name));
    }

    @IsTest
    public static void testSource() {

        Test.startTest();
        {
            insert new Temp_Workday_Int__c(employee_first_name__c = 'Albus', EmployeeLastName__c = '', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
        }
        Test.stopTest();
        Temp_Workday_Int__c tmp = [SELECT Id, employee_first_name__c, EmployeeLastName__c FROM Temp_Workday_Int__c WHERE employee_first_name__c = 'Albus' LIMIT 1];

        SymphonyIPM__Inventor__c person = [SELECT Preferred_Name__c, SymphonyIPM__Employee_ID__c, Source__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assert(person.Source__c == tmp.Id);
    }

    @IsTest
    public static void testGroupText() {

        Test.startTest();
        {
            insert new Temp_Workday_Int__c(employee_first_name__c = 'Albus', EmployeeLastName__c = '', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020', Group_Code__c = 'testGroup');
        }
        Test.stopTest();

        SymphonyIPM__Inventor__c person = [SELECT SymphonyIPM__Employee_ID__c, Group_Text__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assert(person.Group_Text__c == 'testGroup');
    }

    @IsTest
    public static void testDivisionText() {

        Test.startTest();
        {
            insert new Temp_Workday_Int__c(employee_first_name__c = 'Albus', EmployeeLastName__c = '', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020', Division_Code__c = 'testDivision');
        }
        Test.stopTest();

        SymphonyIPM__Inventor__c person = [SELECT SymphonyIPM__Employee_ID__c, Division_Text__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assert(person.Division_Text__c == 'testDivision');
    }

    @IsTest
    public static void testBusinessUnitText() {

        Test.startTest();
        {
            insert new Temp_Workday_Int__c(employee_first_name__c = 'Albus', EmployeeLastName__c = '', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020', Business_Unit__c = 'testBU');
        }
        Test.stopTest();

        SymphonyIPM__Inventor__c person = [SELECT SymphonyIPM__Employee_ID__c, Business_Unit_Text__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assert(person.Business_Unit_Text__c == 'testBU');
    }

    @IsTest
    public static void preferedName() {

        Test.startTest();
        {
            insert new Temp_Workday_Int__c(Preferred_Name__c = 'prefered', Employee_First_Name__c = 'Albus', EmployeeLastName__c = 'Dambledore', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
        }
        Test.stopTest();

        SymphonyIPM__Inventor__c person = [SELECT SymphonyIPM__Employee_ID__c, Preferred_Name__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assertEquals('prefered', person.Preferred_Name__c);
    }
    @IsTest
    public static void preferedNameBlank() {

        Test.startTest();
        {
            insert new Temp_Workday_Int__c(Preferred_Name__c = '', Employee_First_Name__c = 'Albus', EmployeeLastName__c = 'Dambledore', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
        }
        Test.stopTest();

        SymphonyIPM__Inventor__c person = [SELECT SymphonyIPM__Employee_ID__c, Preferred_Name__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];

        System.assertEquals(null, person.Preferred_Name__c);
    }

    @IsTest
    public static void testResidentCountry() {

        Test.startTest();
        {
            insert new Temp_Workday_Int__c(Home_Country__c = 'Germany', Employee_First_Name__c = 'Albus', EmployeeLastName__c = 'Dambledore', Employee_Id__c = '54321', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');
            insert new Temp_Workday_Int__c(Home_Country__c = 'test', Employee_First_Name__c = 'Albus', EmployeeLastName__c = 'Dambledore', Employee_Id__c = '54322', Start_Date__c = '05/06/2020', Termination_Date__c = '07/08/2020');

        }

        Test.stopTest();
        SymphonyIPM__Inventor__c person1 = [SELECT SymphonyIPM__Employee_ID__c, Resident_Country__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54321' LIMIT 1];
        SymphonyIPM__Inventor__c person2 = [SELECT SymphonyIPM__Employee_ID__c, Resident_Country__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c = '54322' LIMIT 1];

        System.assertEquals('Germany', person1.Resident_Country__c);
        System.assertEquals(null, person2.Resident_Country__c);
    }
}
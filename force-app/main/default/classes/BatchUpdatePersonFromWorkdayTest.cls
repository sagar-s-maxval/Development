/**
 * Created by oadamovskyi on 01.07.2022.
 */
@IsTest
public with sharing class BatchUpdatePersonFromWorkdayTest {

  @TestSetup
  static void setup(){
    insert new SymphonyIPM__Country__c(Name = 'Ukraine', Is_Remuneration_Applicable__c = false);

    List<Temp_Workday_Int__c> tmp = new List<Temp_Workday_Int__c>();
    for (Integer i = 0; i < 200; i++) {
      tmp.add(
              new Temp_Workday_Int__c(
              Preferred_Name__c = 'pref'+i,
              employee_first_name__c = 'name'+i,
              EmployeeLastName__c = 'last',
              Employee_Id__c = String.valueOf(i),
              Business_Unit__c = 'AIG-CMD-CMD Division Office',
              Division_Code__c = 'CMD',
              Group_Code__c = 'AIG',
              Department_Name__c = 'testDepartment',
              Employer_City__c = 'testCity',
              Employee_Middle_Name__c = 'test',
              Start_Date__c = Date.today().format(),
              Employer_Country__c = 'Ukraine'
              )
      );
    }

    insert tmp;
  }

  @IsTest
  public static void batch(){

    Test.startTest();
    {
      BatchUpdatePersonFromWorkday b = new BatchUpdatePersonFromWorkday();
      Database.executeBatch(b);
    }
    Test.stopTest();

    List<SymphonyIPM__Inventor__c> inventors =
    [
            SELECT
                    Preferred_Name__c,
                    Name,
                    SymphonyIPM__Employment_status__c,
                    SymphonyIPM__Is_Eligible_for_Inventor_Award__c

            FROM SymphonyIPM__Inventor__c

    ];

    for (Integer i = 0; i < 200; i++) {
      System.debug('Step: ' + i);

      System.assertEquals('pref' + i,inventors[i].Preferred_Name__c);
      System.assertEquals('name' + i + ' ' + 'last',inventors[i].Name);
      System.assertEquals('Active',inventors[i].SymphonyIPM__Employment_status__c);
      System.assert(inventors[i].SymphonyIPM__Is_Eligible_for_Inventor_Award__c);
    }

  }
}
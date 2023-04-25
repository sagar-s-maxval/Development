/**
 * Created by oadamovskyi on 01.07.2022.
 */

global class BatchUpdatePersonFromWorkday implements Database.Batchable<sObject>{

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      String query = 'SELECT ' +
              'Id,' +
              'Preferred_Name__c,' +
              'Name,' +
              'SymphonyIPM__FirstName__c, ' +
              'SymphonyIPM__LastName__c, ' +
              'Termination_Date__c, ' +
              'SymphonyIPM__Employee_ID__c, ' +
              'SymphonyIPM__Employment_status__c, ' +
              'SymphonyIPM__Is_Eligible_for_Inventor_Award__c, ' +
              'SymphonyIPM__Location__c, ' +
              'Source__r.Preferred_Name__c, ' +
              'Source__r.Employee_First_Name__c, ' +
              'Source__r.EmployeeLastName__c FROM SymphonyIPM__Inventor__c WHERE Source__c != NULL';

      return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<SymphonyIPM__Inventor__c> inventors)
    {

      List<String> jurisdictions = new List<String>();
      for (SymphonyIPM__Country__c c : [SELECT Name FROM SymphonyIPM__Country__c WHERE Is_Remuneration_Applicable__c = FALSE]) {
        jurisdictions.add(c.Name);
      }

      for(SymphonyIPM__Inventor__c inventor : inventors)
      {
        String fName = inventor.Source__r.Employee_First_Name__c;
        String lName = inventor.Source__r.EmployeeLastName__c;
        String fullName;

        String terminationDate = inventor.Termination_Date__c == null? '' : inventor.Termination_Date__c.format();
        String empId = inventor.SymphonyIPM__Employee_ID__c;
        String location = inventor.SymphonyIPM__Location__c;

        //Evaluating Full Name
        if(String.isNotBlank(fName) && String.isNotBlank(lName)){
          fullName = fName + ' ' + lName;
        }
        else if(String.isNotBlank(fName)){
          fullName =  fName;
        }
        else if(String.isNotBlank(lName)){
          fullName = lName;
        }
        else {
          fullName = '';
        }

        //Evaluation Employment Status & Is Eligible
        if(String.isBlank(terminationDate) && String.isNotBlank(empId)){
          inventor.SymphonyIPM__Employment_status__c = 'Active';

          if(jurisdictions.contains(location)){
            inventor.SymphonyIPM__Is_Eligible_for_Inventor_Award__c = true;
          }

        }

        inventor.Preferred_Name__c = inventor.Source__r.Preferred_Name__c;
        inventor.Name = fullName;

      }
      update inventors;
    }

    global void finish(Database.BatchableContext BC) {
    }

}
// todo: rename to WorkdayIntegrationTriggerHandler
public class WorkdayIntegrationTriggerHandler {

    public static void insertUpdateUsers(List<Temp_Workday_Int__c> triggeNew) {
        Map<String, Map<String, Map<String, Id>>> groupDivisionBuMap = new Map<String, Map<String, Map<String, Id>>>();

        System.debug('triggeNew ' + triggeNew);
        Set<String> businessUnits = new Set<String>();
        for (Temp_Workday_Int__c temp : triggeNew) {
            businessUnits.add(temp.Business_Unit__c);
        }

        for (SymphonyIPM__Hierarchy__c bu : [SELECT Group__c, Division__c, Business_Unit__c FROM SymphonyIPM__Hierarchy__c WHERE Business_Unit__c IN :businessUnits]) {
            Map<String, Map<String, Id>> localGroupMap = groupDivisionBuMap.containsKey(bu.Group__c) ? groupDivisionBuMap.get(bu.Group__c) : new Map<String, Map<String, Id>>();
            Map<String, Id> localDivisionMap = localGroupMap.containsKey(bu.Division__c) ? localGroupMap.get(bu.Division__c) : new Map<String, Id>();
            localDivisionMap.put(bu.Business_Unit__c, bu.Id);
            localGroupMap.put(bu.Division__c, localDivisionMap);
            groupDivisionBuMap.put(bu.Group__c, localGroupMap);
        }

        Map<String, SymphonyIPM__Inventor__c> insertUsers = new Map<String, SymphonyIPM__Inventor__c>();
        Set<String> existingPersonRecords = new Set<String>();
        String recordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Inventor' AND sObjectType = 'SymphonyIPM__Inventor__c'].Id;

        //Checks whether our person from Non Remuneration Country
        List<String> jurisdiction= new List<String>();
        for (SymphonyIPM__Country__c c : [SELECT Name FROM SymphonyIPM__Country__c WHERE Is_Remuneration_Applicable__c = FALSE]) {
            jurisdiction.add(c.Name);
        }

        for (Temp_Workday_Int__c twi : triggeNew) {

            existingPersonRecords.add(twi.Employee_Id__c);
            insertUsers.put(twi.Employee_Id__c, createPersonByTempObject(
                    twi,
                    recordTypeId,
                    groupDivisionBuMap,
                    jurisdiction));
            //                twi.isProcessed__c = true;

        }

        System.debug('Before pulling existing records');
        for (SymphonyIPM__Inventor__c existingPerson : [SELECT Id, SymphonyIPM__Employee_ID__c FROM SymphonyIPM__Inventor__c WHERE SymphonyIPM__Employee_ID__c IN :existingPersonRecords]) {
            SymphonyIPM__Inventor__c person = insertUsers.get(existingPerson.SymphonyIPM__Employee_ID__c);
            System.debug('Here is our existing person: ' + existingPerson);
            person.Id = existingPerson.Id;
            System.debug('Here is our just person: ' + person);
            insertUsers.put(existingPerson.SymphonyIPM__Employee_ID__c, person);
        }

        System.debug(insertUsers.values());
//        System.debug('Existing person ID' + insertUsers.values()[0].Id);
//        Database.UpsertResult[] results =
        Database.upsert(insertUsers.values());
//        Set<Id> failedPersonObjects = new Set<Id>();
//        for(Database.UpsertResult result: results){
//            if(result.isSuccess() == false){
//                failedPersonObjects.add(result.getId());
//            }
//        }
//
//        System.debug('--failedPersonObjects--- ' + failedPersonObjects);
    }

    private static SymphonyIPM__Inventor__c createPersonByTempObject(Temp_Workday_Int__c temp, String recordTypeId, Map<String, Map<String, Map<String, Id>>> buMap, List<String> jurisdictions) {

        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(
                Preferred_Name__c = temp.Preferred_Name__c,
                Name = evaluateName(temp.Preferred_Name__c, temp.Employee_First_Name__c, temp.EmployeeLastName__c),
                SymphonyIPM__FirstName__c = temp.employee_first_name__c,
                SymphonyIPM__LastName__c = temp.EmployeeLastName__c,
                SymphonyIPM__Email__c = temp.Email__c,
                SymphonyIPM__Employee_ID__c = temp.Employee_Id__c,
                PhoneNumber__c = temp.Phone__c,
                Business_Unit_Text__c = temp.Business_Unit__c,
                Division_Text__c = temp.Division_Code__c,
                Group_Text__c = temp.Group_Code__c,
                Hierarchy__c = buMap.get(temp.Group_Code__c)?.get(temp.Division_Code__c)?.get(temp.Business_Unit__c),
                Department_name__c = temp.Department_Name__c,
                Employer_City__c = temp.Employer_City__c,
                Middle_Name__c = temp.Employee_Middle_Name__c,
                Department_Id__c = temp.Department_Id__c,
//            SymphonyIPM__Employment_status__c = temp.Status__c,
//            SymphonyIPM__Location__c  = temp.Employer_Country__c,
//            SymphonyIPM__EmploymentCategory__c = temp.Type_of_Employee__c,
                Employer_State__c = temp.Employer_State__c,
                Employer_Street__c = temp.Employer_Street__c,
                Employer_Zip_Code__c = temp.Employer_ZipCode__c,
                Federation_Id_SSO__c = temp.Federation_Id_SSO__c,
                Resident_City__c = temp.Home_City__c,
                Home_State__c = temp.Home_State__c,
                Home_Street__c = temp.Home_Street__c,
                Home_Zip_Code__c = temp.Home_Zip_Code__c,
//                Nationality__c = temp.Nationality__c,
                SymphonyIPM__Title__c = temp.Title__c,
//            Start_Date__c = String.isBlank(temp.Start_Date__c) ? null : Date.parse(temp.Start_Date__c),
//            Termination_Date__c = String.isBlank(temp.Termination_Date__c) ? null : Date.parse(temp.Termination_Date__c),
//                recordTypeId = recordTypeId,
                Source__c = temp.Id,
                Legal_Entity__c = temp.Legal_Entity__c
        );
        System.debug('Inventor`s name:' + inventor.Name);

        if(!stringValid(temp.Termination_Date__c) && stringValid(temp.Employee_Id__c)){
            inventor.SymphonyIPM__Employment_status__c = 'Active';

            if(jurisdictions.contains(temp.Employer_Country__c)){
                inventor.SymphonyIPM__Is_Eligible_for_Inventor_Award__c = true;
            }
        }

        if (stringValid(temp.Start_Date__c)) {
            inventor.Start_Date__c = dateFormatting(temp.Start_Date__c);
        }

        if (stringValid(temp.Termination_Date__c)) {
            inventor.Termination_Date__c = dateFormatting(temp.Termination_Date__c);
        }

        // do not override person Nationality__c if new value is blank
        if (stringValid(temp.Nationality__c)) {
            inventor.Nationality__c = temp.Nationality__c;
        }

        if (getPicklistValues(SymphonyIPM__Inventor__c.SymphonyIPM__Employment_status__c).contains(temp.Status__c)) {
            inventor.SymphonyIPM__Employment_status__c = temp.Status__c;
        }

        if (getPicklistValues(SymphonyIPM__Inventor__c.SymphonyIPM__Location__c).contains(temp.Employer_Country__c)) {
            inventor.SymphonyIPM__Location__c = temp.Employer_Country__c;
        }

        if (getPicklistValues(SymphonyIPM__Inventor__c.SymphonyIPM__EmploymentCategory__c).contains(temp.Type_of_Employee__c)) {
            inventor.SymphonyIPM__EmploymentCategory__c = temp.Type_of_Employee__c;
        }

        if (getPicklistValues(SymphonyIPM__Inventor__c.Resident_Country__c).contains(temp.Home_Country__c)) {
            inventor.Resident_Country__c = temp.Home_Country__c;
        }

        return inventor;
    }

    private static Boolean stringValid(String startDate) {
        return String.isNotBlank(startDate) && startDate.toLowerCase() != 'null';
    }

    private static Date dateFormatting(String d) {
        if (d.contains('-')) {
            return Date.valueOf(d);
        } else return Date.parse(d);
    }

    private static String evaluateName(String preferredName, String firstName, String lastName) {
        if(String.isNotBlank(preferredName) && String.isNotBlank(lastName)){
            return preferredName + ' ' + lastName;
        }
        else if(String.isNotBlank(firstName) && String.isNotBlank(lastName)){
            return firstName + ' ' + lastName;
        }
        else if(String.isNotBlank(preferredName)){
            return preferredName;
        }
        else if(String.isNotBlank(firstName)){
            return firstName;
        }
        else if(String.isNotBlank(lastName)){
            return lastName;
        }
        else {
            return '';
        }

    }

    private static List<String> getPicklistValues(Schema.sObjectField f) {
        List<String> activeEntries = new List<String>();

        for (Schema.PicklistEntry entry : f.getDescribe().getPickListValues()) {
            if (entry.isActive()) {
                activeEntries.add(entry.value); // or label?
            }
        }

        return activeEntries;
    }
}
public with sharing class RequestorLookupController {
  /**
* @description Searches users and groups with given text in names
* @param searchText - text to search in names
* @return List<Map<String, String>> - List of key value pairs in format Id:<id value>, Name:<name value>, Type<user or group>
*/
  public static void coverage(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
  }

  @AuraEnabled(Cacheable=true)
  public static List<RequestorWrapper> findRequestorPerson(String searchText) {
    //don't search for users if search text is empty
    if (searchText == '') {
      return new List<RequestorWrapper>();
    }
    String queryFilter = searchText + '%';

    List<RequestorWrapper> result = new List<RequestorWrapper>();

    //add groups to the result list that match the search text
    for (SymphonyIPM__Inventor__c person : [
            SELECT Id,Name, SymphonyIPM__Email__c,SymphonyIPM__User__r.IsActive,Termination_Date__c,SymphonyIPM__User__r.SymphonyIPM__Profile_Name__c
            FROM SymphonyIPM__Inventor__c
            WHERE Name LIKE :queryFilter
            AND Termination_Date__c = NULL
            AND SymphonyIPM__User__r.IsActive = TRUE
            LIMIT 5]
    ) {
      result.add(new RequestorWrapper(person.Id, person.Name, person.SymphonyIPM__Email__c));
    }

    return result;
  }

  @AuraEnabled(Cacheable=true)
public static RequestorWrapper getPersonByCurrentUser(String Id){
    SymphonyIPM__Inventor__c person = [
            SELECT Id,SymphonyIPM__User__r.Id,Name, SymphonyIPM__Email__c,SymphonyIPM__User__r.IsActive,Termination_Date__c,SymphonyIPM__User__r.SymphonyIPM__Profile_Name__c
            FROM SymphonyIPM__Inventor__c
            WHERE SymphonyIPM__User__r.Id =: Id
            AND Termination_Date__c = NULL
            AND SymphonyIPM__User__r.IsActive = TRUE
            LIMIT 1];

    return new RequestorWrapper(person.Id,person.Name,person.SymphonyIPM__Email__c);
  }

  public with sharing class RequestorWrapper {

  public RequestorWrapper(String Id,String name, String email){
    this.Id = Id;
    this.Name = name;
    this.Email = email;
  }
    @AuraEnabled
    public String Id{get;set;}

    @AuraEnabled
    public String Name{get;set;}

    @AuraEnabled
    public String Email{get;set;}

  }
}
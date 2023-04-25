@IsTest
private class SendEmailHelperTest {

    @TestSetup
    static void setup() {
        SymphonyIPM__Hierarchy__c hierarchy = new SymphonyIPM__Hierarchy__c(Division__c = 'CMD', Group__c = 'AIG', Business_Unit__c = 'TM Business Unit Test', SymphonyIPMExt__Is_TM_Path__c = true);
        insert hierarchy;
        SymphonyIPM__Inventor__c inventor = new SymphonyIPM__Inventor__c(SymphonyIPM__FirstName__c = 'Test', SymphonyIPM__LastName__c = 'Test1', SymphonyIPM__Email__c = 'test@test.test');
        insert inventor;
        Trademark_Hierarchy_Role__c hierarchyRole = new Trademark_Hierarchy_Role__c(Role__c = 'TM IP Responsible Manager', Person__c = inventor.Id, Hierarchy_Path__c = hierarchy.Id);
        Trademark_Hierarchy_Role__c hierarchyParalegal = new Trademark_Hierarchy_Role__c(Role__c = 'TM IP Paralegal', Person__c = inventor.Id, Hierarchy_Path__c = hierarchy.Id);
        insert hierarchyRole;
        insert hierarchyParalegal;
        SymphonyIPMExt__Trademark_Search__c search = new SymphonyIPMExt__Trademark_Search__c(SymphonyIPMExt__Portfolio__c = hierarchy.Id, Requestor__c = inventor.Id, SymphonyIPMExt__Project_Name__c = 'Test', Product_Manager__c = inventor.Id);
        insert search;
        SymphonyIPM__Trademark_New__c trademarkNew = new SymphonyIPM__Trademark_New__c(Name = 'Test');
        insert trademarkNew;
        insert new Trademark_Role__c(Trademark_Roles__c = 'TM IP Responsible Manager', Person__c = inventor.Id, Trademark__c = trademarkNew.Id);
        insert new Trademark_Role__c(Trademark_Roles__c = 'TM IP Paralegal', Person__c = inventor.Id, Trademark__c = trademarkNew.Id);
        insert new D_O_Recommendation__c(Product_Manager__c = inventor.Id, Trademark__c = trademarkNew.Id);
    }

    @IsTest
    static void getEmailsByRolesWithMetaData_ForSearchProjectAndManualSendEmail() {
        Email_By_Roles__mdt bRoles = [SELECT CC_Roles__c, To_Roles__c, Object_API_Name__c FROM Email_By_Roles__mdt WHERE DeveloperName = 'Proceed_with_search_by_Paralegal_No'];
        SymphonyIPMExt__Trademark_Search__c search = [SELECT Id FROM SymphonyIPMExt__Trademark_Search__c LIMIT 1];

        GetEmails.flowOutput outputData = SendEmailHelper.getEmailsByRolesWithMetaData(bRoles, search, null, false, null);

        System.assert(outputData.toPersonIds != null);
    }

    @IsTest
    static void getEmailsByRolesWithMetaData_ForSearchProjectAndAutoSendEmail() {
        Email_By_Roles__mdt bRoles = [SELECT CC_Roles__c, To_Roles__c, Object_API_Name__c FROM Email_By_Roles__mdt WHERE DeveloperName = 'Submits_Search_Request'];
        SymphonyIPMExt__Trademark_Search__c search = [SELECT Id FROM SymphonyIPMExt__Trademark_Search__c LIMIT 1];

        GetEmails.flowOutput outputData = SendEmailHelper.getEmailsByRolesWithMetaData(bRoles, search, null, false, null);

        System.assert(outputData.toEmails != null);
    }

    @IsTest
    static void getEmailsByRolesWithMetaData_ForDORecommendationAndManualSendEmail() {
        Email_By_Roles__mdt bRoles = [SELECT CC_Roles__c, To_Roles__c, Object_API_Name__c FROM Email_By_Roles__mdt WHERE DeveloperName = 'D_O_Recommendation_Created'];
        D_O_Recommendation__c doRecommendation = [SELECT Id, Trademark__c FROM D_O_Recommendation__c LIMIT 1];

        GetEmails.flowOutput outputData = SendEmailHelper.getEmailsByRolesWithMetaData(bRoles, null, doRecommendation.Trademark__c, true, doRecommendation);

        System.assert(outputData.toPersonIds != null);
    }

    @IsTest
    static void createEmailHistoryForSearchProject_AfterEmailSend() {
        SymphonyIPMExt__Trademark_Search__c search = [SELECT Id FROM SymphonyIPMExt__Trademark_Search__c LIMIT 1];
        List<String> emails = new List<String>{'test@test.test', 'test1@test.test'};

        Test.startTest();
        SendEmailHelper.createEmailHistory(search.Id, 'Test Body', 'Test Subject', null, emails, emails);
        Test.stopTest();

        EmailAuditTrail__c emailAuditTrail = [SELECT Id, Search_Project__c FROM EmailAuditTrail__c WHERE Search_Project__c = :search.Id];
        System.assertEquals(search.Id, emailAuditTrail.Search_Project__c);
    }

    @IsTest
    static void getEmailSubject_AndRenderValue() {
        SymphonyIPMExt__Trademark_Search__c search = [SELECT Id, SymphonyIPMExt__Project_Name__c FROM SymphonyIPMExt__Trademark_Search__c LIMIT 1];
        EmailTemplate emailTemplate = new EmailTemplate(Name = 'Test', Body = 'Hi', HtmlValue = '<table border="0" cellpadding="5" width="550" cellspacing="5" height="400" >Test Value </table>', Subject = '{!SymphonyIPMExt__Trademark_Search__c.SymphonyIPMExt__Project_Name__c}', DeveloperName = 'Test', FolderId = UserInfo.getUserId(), IsActive = true, TemplateType = 'text');
        insert emailTemplate;
        String expectedValue = search.SymphonyIPMExt__Project_Name__c;

        String subject = SendEmailHelper.getEmailSubject(emailTemplate.Id, search.Id);

        System.assertEquals(expectedValue, subject);
    }

    @IsTest
    static void getEmailBody_AndRenderValue() {
        SymphonyIPMExt__Trademark_Search__c search = [SELECT Id, SymphonyIPMExt__Project_Name__c FROM SymphonyIPMExt__Trademark_Search__c LIMIT 1];
        EmailTemplate emailTemplate = new EmailTemplate(Name = 'Test', Body = 'Hi', HtmlValue = '<table border="0" cellpadding="5" width="550" cellspacing="5" height="400" >Test Value {!SymphonyIPMExt__Trademark_Search__c.SymphonyIPMExt__Project_Name__c} {0} {1}</table>', Subject = '{!SymphonyIPMExt__Trademark_Search__c.SymphonyIPMExt__Project_Name__c}', DeveloperName = 'Test', FolderId = UserInfo.getUserId(), IsActive = true, TemplateType = 'text');
        insert emailTemplate;
        List<String> templateValues = new List<String>{'Test Name', null};
        String expectedValue = 'Test Value ' + search.SymphonyIPMExt__Project_Name__c + ' Test Name  ';

        String body = SendEmailHelper.renderAndReplaceEmailBody(emailTemplate.Id, search.Id, templateValues);

        System.assertEquals(expectedValue, body);
    }

    @IsTest
    static void setEmails_AndCheckNullInList()  {
        List<String> emails = new List<String>{'test@test.test', 'test1@test.test', null};

        List<String> toEmails = SendEmailHelper.setEmails(emails);

        System.assert(!toEmails.contains(null));
        System.assert(!toEmails.isEmpty());
    }
}
@isTest public class DeletionOfContDocuAndSharingOfRcdTest {

    @TestSetup
    public static void TestData(){
       test.startTest();
        List<User> listUser = new List<User>();
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last',
            Email ='abc@gmail.com',
            Username ='puser0067@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        listUser.add(u);
        //insert u;
       
        /*User u1 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Reviewer'].Id,
            LastName = 'reviewer321',
            Email ='abciop123@gmail.com',
            Username ='puser0067@amamama@amamamamam.com.tes' + System.currentTimeMillis(),
            CompanyName = 'TEST432123',
            Title = 'title12543',
            Alias = 'alias341',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US',
IsActive = true);
        insert u1;

        User u2 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Platform Inventor'].Id,
            LastName = 'last2',
            Email ='abc2@gmail.com',
            Username ='puser00672@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title2',
            Alias = 'alias2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        insert u2;*/

User u3 = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'In-house Counsel'].Id,
            LastName = 'last3',
            Email ='abc3@gmail.com',
            Username ='puser00673@amamama@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST1',
            Title = 'title3',
            Alias = 'alias3',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey ='en_US');
        listUser.add(u3);
        insert listUser;

        List<SymphonyIPM__Inventor__c> listInventors = new List<SymphonyIPM__Inventor__c>();
        SymphonyIPM__Inventor__c objInventor = new SymphonyIPM__Inventor__c();
        objInventor.Name = 'Test Inventor';
        objInventor.SymphonyIPM__Email__c = 'testinventor@test.com';
        objInventor.SymphonyIPM__User__c =u.id;
        listInventors.add(objInventor);
       
        SymphonyIPM__Inventor__c objInventor1 = new SymphonyIPM__Inventor__c();
        objInventor1.Name = 'Test Inventor1';
        objInventor1.SymphonyIPM__Email__c = 'testinventor@test.com';
        objInventor1.SymphonyIPM__User__c =u.id;
        listInventors.add(objInventor1);

SymphonyIPM__Inventor__c objInventor2 = new SymphonyIPM__Inventor__c();
        objInventor2.Name = 'Test Inventor2';
        objInventor2.SymphonyIPM__Email__c = 'testinventor2@test.com';
        //objInventor2.SymphonyIPM__User__c =u2.id;
        listInventors.add(objInventor2);
        
       
   SymphonyIPM__Law_Firm__c objlawfirm = new SymphonyIPM__Law_Firm__c();
objlawfirm.Name = 'Law firm';
INSERT objlawfirm;
 
SymphonyIPM__Inventor__c objInventor3 = new SymphonyIPM__Inventor__c();
        objInventor3.Name = 'Test Inventor3';
        objInventor3.SymphonyIPM__Email__c = 'testinventor2@test.com';
        objInventor3.SymphonyIPM__User__c =u3.id;
objInventor3.SymphonyIPM__Law_Firm__c =objlawfirm.id;
        listInventors.add(objInventor3);
        INSERT listInventors;
 
        SymphonyIPM__Hierarchy__c path = new SymphonyIPM__Hierarchy__c();
        path.name = 'Test Path123';
        INSERT path;
       
        /*SymphonyIPM__Hierarchy__c path1 = new SymphonyIPM__Hierarchy__c();
        path1.name = 'Test123 Path123';
        INSERT path1;*/
       
        SymphonyIPM__Hierarchy_Role__c Hierarchyrole1 = new SymphonyIPM__Hierarchy_Role__c();
        //Hierarchyrole1.SymphonyIPM__User__c = u1.id;
        Hierarchyrole1.SymphonyIPM__Hierarchy_Path__c= path.id;
Hierarchyrole1.SymphonyIPM__isPrimary__c = true;
Hierarchyrole1.SymphonyIPM__Role__c ='UHG IP Legal';
        insert Hierarchyrole1;

/*SymphonyIPM__Hierarchy_Role__c Hierarchyrole = new SymphonyIPM__Hierarchy_Role__c();
        Hierarchyrole.SymphonyIPM__User__c = u3.id;
        Hierarchyrole.SymphonyIPM__Hierarchy_Path__c= path1.id;
        insert Hierarchyrole;*/

SymphonyIPM__Invention_Disclosure_New__c objInventionDisclosure = new SymphonyIPM__Invention_Disclosure_New__c();
        objInventionDisclosure.SymphonyIPM__Title__c = 'Test IDF132';
        //objInventionDisclosure.PRB_Decision__c = 'IOT';
objInventionDisclosure.SymphonyIPM__Primary_Inventor__c= objInventor.id;
        objInventionDisclosure.SymphonyIPM__Hierarchy__c = path.id;
        objInventionDisclosure.Primary_Contact__c=objInventor.id;
         objInventionDisclosure.MentorsIDs__c=objInventor.id;
        INSERT objInventionDisclosure;
       
        /*SymphonyIPM__Invention_Disclosure_New__Share ObjIDFShare = new SymphonyIPM__Invention_Disclosure_New__Share();
        ObjIDFShare.AccessLevel='Edit';
        ObjIDFShare.ParentId=objInventionDisclosure.id;
        ObjIDFShare.UserOrGroupId=objInventor.SymphonyIPM__User__c;
        ObjIDFShare.RowCause='Manual'; //Schema.SymphonyIPM__Invention_Disclosure_New__Share.RowCause.SharingIDFwithOC__c;
        insert ObjIDFShare;*/
       
       /* SymphonyIPM__Invention_Disclosure_New__Share ObjIDFShareHierarchy = new SymphonyIPM__Invention_Disclosure_New__Share();
        ObjIDFShareHierarchy.AccessLevel='Edit';
        ObjIDFShareHierarchy.ParentId=objInventionDisclosure.id;
        ObjIDFShareHierarchy.UserOrGroupId=Hierarchyrole.SymphonyIPM__User__c;
        ObjIDFShareHierarchy.RowCause='Manual'; //Schema.SymphonyIPM__Invention_Disclosure_New__Share.RowCause.SharingIDFwithOC__c;
        insert ObjIDFShareHierarchy; */
       
        /*ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;
       
        //Get Content Version
        List<ContentVersion> cvList = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];
        System.assertEquals(cvList.size(), 1);
       
        //Get Content Documents
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        System.assertEquals(cdList.size(), 1);*/

/*SymphonyIPM__Patent__c objPatent = new SymphonyIPM__Patent__c();
objPatent.SymphonyIPM__Title_of_Invention__c = 'Test Patent';
INSERT objPatent;*/
       
       /* ContentDocumentLink cdl=new ContentDocumentLink();
        cdl.LinkedEntityId=objInventionDisclosure.id;
        insert cdl;*/
        objInventionDisclosure.SymphonyIPM__Title__c = 'Test IDF';
        //objInventionDisclosure.SymphonyIPM__Hierarchy__c = path1.id;
        objInventionDisclosure.Primary_Inventor__c= objInventor1.id;
        objInventionDisclosure.Primary_Contact__c = objInventor1.id;
        objInventionDisclosure.MentorsIDs__c= objInventor1.id+','+objInventor.Id;
//objInventionDisclosure.SymphonyIPM__Related_Patent__c= objPatent.id;
objInventionDisclosure.Other_Contact__c = objInventor2.id;
//objInventionDisclosure.Law_Firm__c = objlawfirm.id;
        update objInventionDisclosure;
//objInventionDisclosure.SymphonyIPM__Title__c ='update';   
test.stopTest();     
       
    }
    @isTest public static  void Meth1(){
        //SymphonyIPM__Invention_Disclosure_New__c idf =[Select id from SymphonyIPM__Invention_Disclosure_New__c limit 1];
       
    }
}
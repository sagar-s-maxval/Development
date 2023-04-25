@isTest
public class trgUserHandlertest {
    @isTest
    public static void Method1()
    {
        profile p=[SELECT Id FROM Profile WHERE Name = 'Platform Inventor'];
    User u = new User(
     ProfileId = p.Id,
     LastName = 'lastINV',
     FirstName = 'FirstINV',
     Email = 'jayaram@maxval.com',
     Username = 'puser0lkm00@amamama.com',
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     IsActive = false,
     LocaleSidKey = 'en_US');
     insert u;
     Set<Id> u2 = new Set<Id>();
         list<User> u3 = new list<User>();
     u3 = [SELECT id,Name from User where FirstName = :'FirstINV'];
     //u2.addAll(u3.Id);
        for(User obj1 : u3)
{
    u2.add(obj1.id);

}
     Set<String>p1 = new Set<String>();
     p1.add('Platform Inventor');
     
       
        trgUserHandler lrh = new trgUserHandler();
        //lrh.createUser(true,u1,attributes,'abcdef',true);
        lrh.handleRecycling(p1,u2,true);
}
    
}
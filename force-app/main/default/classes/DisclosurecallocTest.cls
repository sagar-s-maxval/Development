@istest(seealldata=true)
public class DisclosurecallocTest {
@istest
    public static void met1(){
        
        SymphonyIPM__Inventor__c invlist=[select id,SymphonyIPM__User__r.id,SymphonyIPM__User__r.email,name,recordtype.name from SymphonyIPM__Inventor__c
                                                     where recordtype.name='OC'  limit 1];
        SymphonyIPM__Invention_Disclosure_New__c inv=[select id,Outside_Counsel__c from SymphonyIPM__Invention_Disclosure_New__c  order by createddate ASC limit 1];
                      //user u=[select id from user where ];
                      inv.Outside_Counsel__c=userinfo.getUserId();
        update inv;
        SymphonyIPM__Invention_Disclosure_New__c inv1=[select id,Outside_Counsel__c from SymphonyIPM__Invention_Disclosure_New__c  where Outside_Counsel__c = null limit 1];
        SymphonyIPM__Law_Firm__c law=[select id,name from SymphonyIPM__Law_Firm__c limit 1];
        SymphonyIPM__Inventor__c invs=[select id,name from SymphonyIPM__Inventor__c limit 1];
        test.starttest();
       list<string> str= Disclosurecalloc.getlawfirm(inv.id);
         list<string> str1= Disclosurecalloc.getlawcounsel(inv.id);
        list<string> str4= Disclosurecalloc.getlawcounsel(inv1.id);
        list<string> str2= Disclosurecalloc.getousidecounsel( law.name,inv.id);
                         string se= Disclosurecalloc.updatedisclosure(invlist.name,inv.id);
        test.stopTest();
    }
}
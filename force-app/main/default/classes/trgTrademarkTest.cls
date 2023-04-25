@isTest
public class trgTrademarkTest {
    @isTest public static void testing(){
        SymphonyIPM__Trademark_New__c trdnew = new SymphonyIPM__Trademark_New__c(TM_IP_Paralegal__c='test');
        insert trdnew;
        SymphonyIPM__Trademark_New__c trdnew1 = new SymphonyIPM__Trademark_New__c(TM_IP_Paralegal__c='test');
        insert trdnew1;
        SymphonyIPM__Law_Firm__c LawFirm = new SymphonyIPM__Law_Firm__c(Name='LLB');
        trdnew.TM_IP_Paralegal__c='test2';
        update trdnew;
        SymphonyIPM__Inventor__c per = new SymphonyIPM__Inventor__c(Name='test per');
        insert per;
        SymphonyIPM__Inventor__c per2 = new SymphonyIPM__Inventor__c(Name='test per');
        insert per2;
        Trademark_Role__c trd = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='TM IP Paralegal',Person__c=per.id);
        insert trd;  
        Trademark_Role__c trdT = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='TM IP Paralegal',Person__c=per.id);
        insert trdT;  
         Trademark_Role__c trd3 = new Trademark_Role__c(Trademark__c=trdnew1.id,Trademark_Roles__c='CN TM Attorney 1',Person__c=per.id);
        insert trd3;  
        Trademark_Role__c trd4 = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='CN TM Attorney 2',Person__c=per.id);
        insert trd4;  
       Trademark_Role__c trd2 = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='Outside Counsel Firm',Person__c=per2.id,Law_Firm__c = LawFirm.id);
        insert trd2; 
        Trademark_Role__c trdT2 = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='CN TM Attorney 1',Person__c=per2.id,Law_Firm__c = LawFirm.id);
        insert trdT2; 
        Trademark_Role__c trdT3 = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='CN TM Attorney 2',Person__c=per2.id,Law_Firm__c = LawFirm.id);
        insert trdT3; 
        Trademark_Role__c trdT4 = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='TM IP Responsible Manager',Person__c=per2.id,Law_Firm__c = LawFirm.id);
        insert trdT4;
         Trademark_Role__c trdT5 = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='TM Docketer',Person__c=per2.id,Law_Firm__c = LawFirm.id);
        insert trdT5;
        Trademark_Role__c trdT6 = new Trademark_Role__c(Trademark__c=trdnew.id,Trademark_Roles__c='TM IP Associate 1',Person__c=per2.id,Law_Firm__c = LawFirm.id);
        insert trdT6;
        trdT5.Trademark_Roles__c='TM IP Associate 2';
        update trdT5;
        trd4.Trademark_Roles__c='TM Docketer';
        update trd4;
        trd.Trademark_Roles__c ='TM IP Associate 2';
        update trd;
        trd.Trademark_Roles__c ='TM IP Associate 1';
        update trd;
        trd.Trademark_Roles__c ='Agent';
        update trd;
        update trd2;
        delete trd;
        delete trd4;
       //delete trd2;
       Trademark_Role__c trd1 = new Trademark_Role__c(Trademark__c=trdnew.id,Person__c=per.id);
        insert trd1;  
        trd1.Trademark_Roles__c ='TM IP Responsible Manager';
        update trd1;
        delete trd1;
  
    }

}
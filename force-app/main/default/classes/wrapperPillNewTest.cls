@isTest
private class wrapperPillNewTest
{
    static testMethod void wrapperPillNewTest()
    {   
        Test.starttest(); 
        wrapperPillNew pill = New wrapperPillNew();
        pill.type='type';
        pill.label ='label';
        pill.name ='name';
        pill.fallbackIconName ='IconName';
        pill.variant='variant';
        pill.alternativeText='alternativeText';
        pill.EmailId='test@sfdc.com';
        pill.InventorName='Test';
        pill.IsPrimary=false;
        pill.RoleOfConception='Test';
        pill.IndexVal=1;
        pill.IsActive=true;
        pill.UserId='000';
        pill.comment='test';
        String Recid=pill.Recid ='Recid';
        system.assertEquals(Recid,'Recid');
        Test.stoptest(); 
    }
}
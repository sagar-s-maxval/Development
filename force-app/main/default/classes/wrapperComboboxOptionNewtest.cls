@isTest
private class wrapperComboboxOptionNewtest
{
    static testMethod void wrapperComboboxOptionNewtest()
    {   
        Test.starttest(); 
        wrapperComboboxOptionNew option = New wrapperComboboxOptionNew();
        
        option.label='label';
        option.value ='value';
        option.isSelected =True;
        system.assert(true);
        Test.stoptest(); 
    }
}
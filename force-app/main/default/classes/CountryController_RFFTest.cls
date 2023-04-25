@isTest
public class CountryController_RFFTest {
	static testmethod void CountryController_RFFTestmtd()
    {
        SymphonyIPM__Country__c sic = new SymphonyIPM__Country__c(name='test',SymphonyIPM__Is_Trademark_Jurisdiction__c=false,SymphonyIPM__Country_Code__c='test',SymphonyIPM__PCT_Contracting_State__c=false,SymphonyIPM__EP_Validation_State__c = true);
        insert sic;
        CountryController_RFF.searchCountries('test',new List<string>());
        CountryController_RFF.getSelectedCountries(new List<string>{sic.id});
    }
}
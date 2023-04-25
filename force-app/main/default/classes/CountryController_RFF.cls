public with sharing class CountryController_RFF
{
    @AuraEnabled
    public static List<wrapperComboboxOption_FF> searchCountries(string searchWord, List<string> countryIds) 
    {
        try
        {
            Id userId = UserInfo.getUserId();
            List<wrapperComboboxOption_FF> objOptions = new List<wrapperComboboxOption_FF>();
            searchWord = searchWord + '%';
            if(Schema.sObjectType.SymphonyIPM__Country__c.isAccessible() && SymphonyIPM__Country__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPM__Country__c> lstCountries = [SELECT Id, Name, SymphonyIPM__Country_Code__c FROM SymphonyIPM__Country__c WHERE (Name LIKE :searchWord OR SymphonyIPM__Country_Code__c LIKE :searchWord) AND Id NOT IN :countryIds ORDER BY Name];
                for(SymphonyIPM__Country__c objCountry : lstCountries )
                {
                    wrapperComboboxOption_FF objOption = new wrapperComboboxOption_FF();
                    if (objCountry.SymphonyIPM__Country_Code__c != null)
                        objOption.label = objCountry.Name  + ' (' + objCountry.SymphonyIPM__Country_Code__c + ')';
                    else
                        objOption.label = objCountry.Name;
                    objOption.value = objCountry.Id;
                    objOptions.add(objOption);
                }
            }
            return objOptions;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
    @AuraEnabled
    public static List<wrapperPill_FF> getSelectedCountries(List<string> countryIds) 
    {
        try
        {
            List<wrapperPill_FF> objPills = new List<wrapperPill_FF>();
            if(Schema.sObjectType.SymphonyIPM__Country__c.isAccessible() && SymphonyIPM__Country__c.sObjectType.getDescribe().isAccessible())
            {
                List<SymphonyIPM__Country__c> lstCountries = [SELECT  Id, Name, SymphonyIPM__Country_Code__c FROM SymphonyIPM__Country__c WHERE Id IN :countryIds ORDER BY Name];
                for(SymphonyIPM__Country__c objCountry : lstCountries)
                {
                    wrapperPill_FF objPill = new wrapperPill_FF();
                    objPill.type = 'avatar';
                    objPill.label = objCountry.Name;
                    objPill.name = objCountry.Id;
                    objPill.fallbackIconName = 'standard:address';
                    objPill.variant = 'circle';
                    if (objCountry.SymphonyIPM__Country_Code__c!= null)
                        objPill.alternativeText = objCountry.Name + ' (' + objCountry.SymphonyIPM__Country_Code__c + ')';
                    else
                        objPill.alternativeText = objCountry.Name;
                    objPills.add(objPill);
                }
            }
            return objPills;
        }
        catch(Exception exp)
        {
            throw exp;
        }
    }
}
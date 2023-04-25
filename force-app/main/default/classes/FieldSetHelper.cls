public with sharing class FieldSetHelper {
    public static FieldSet getFieldSetBySObjectAndName(String sObjectApiName, String fieldSetApiName) {
        FieldSet fSet = Schema.getGlobalDescribe().get(sObjectApiName)?.getDescribe().fieldSets.getMap().get(fieldSetApiName);

        if (fSet == null) {
            NoDataFoundException exc = new NoDataFoundException();
            exc.setMessage('No Field Set Found');
            throw exc;
        }

        if (fSet.getFields().isEmpty()) {
            NoDataFoundException exc = new NoDataFoundException();
            exc.setMessage('Field Set Have No Fields');
            throw exc;
        }

        return fSet;
    }

    public static Set<String> getApiNames(List<FieldSetMember> fieldSetMembers) {
        Set<String> names = new Set<String>();

        for (FieldSetMember member : fieldSetMembers) {
            names.add(member.getFieldPath());
        }

        return names;
    }
}
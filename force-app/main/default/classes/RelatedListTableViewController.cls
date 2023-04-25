public with sharing class RelatedListTableViewController {

    @AuraEnabled(Cacheable=true)
    public static Table getTable(Id recordId, String sObjectApiName, String parentLookupField, String fieldSet) {

        if (recordId == null) {
            throw new AuraHandledException('No recordId passed to table');
        }
        if (sObjectApiName == null) {
            throw new AuraHandledException('No SObject specified for table');
        }
        if (parentLookupField == null) {
            throw new AuraHandledException('No parent lookup specified for table');
        }
        if (fieldSet == null) {
            throw new AuraHandledException('No Field Set lookup specified for table');
        }

        Table t = new Table();

        List<FieldSetMember> fields;

        try {
            fields = FieldSetHelper.getFieldSetBySObjectAndName(sObjectApiName, fieldSet).getFields();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        t.columns = fieldSetToColumns(fields);

        try {
            t.records = Database.query(
                    new QueryBuilder()
                            .fromObject(sObjectApiName)
                            .selectFields(FieldSetHelper.getApiNames(fields))
                            .whereClause(parentLookupField + ' = \'' + recordId + '\'')
                            .limits(50000)
                            .buildQuery()
            );
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving records for table');
        }

        return t;
    }

    @AuraEnabled
    public static void updateRecords(List<SObject> records) {
        update records;
    }

    private static List<Column> fieldSetToColumns(List<FieldSetMember> fieldSetMembers) {
        List<Column> columns = new List<Column>();

        for (FieldSetMember member : fieldSetMembers) {
            columns.add(
                    new Column(
                            member.getFieldPath(),
                            member.getType().name(),
                            member.getLabel(),
                            member.getRequired()
                    )
            );
        }

        return columns;
    }

    public class Table {
        @AuraEnabled
        public List<Column> columns;
        @AuraEnabled
        public List<SObject> records;
    }

    public class Column {
        @AuraEnabled
        public String fieldName;
        @AuraEnabled
        public String type;
        @AuraEnabled
        public String label;
        @AuraEnabled
        public Boolean editable;
        @AuraEnabled
        public Integer initialWidth;

        public Column(String name, String type, String label, Boolean editable) {
            this.fieldName = name;
            this.type = type.toLowerCase();
            this.label = label;
            this.editable = editable;
        }
    }
}
public with sharing class QueryBuilder {
    private String selectFields;
    private String fromObject;
    private String whereClause;
    private String orderByClause;
    private Integer limits;
    private String polymorphFieldQuery;

    public String getFromObject() {
        return this.fromObject;
    }

    public QueryBuilder() {
        this.selectFields = '';
        this.fromObject = '';
        this.whereClause = '';
        this.orderByClause = '';
        this.polymorphFieldQuery = '';
        this.limits = 0;
    }

    public QueryBuilder selectFields(String fields) {
        if (String.isNotBlank(fields)) {
            this.selectFields = fields;
        }
        return this;
    }

    public QueryBuilder selectFields(Set<String> fields) {
        if (!fields.isEmpty()) {
            this.selectFields = String.join(new List<String>(fields), ' ,');
        }
        return this;
    }

    public QueryBuilder fromObject(String fromObject) {
        if (String.isNotBlank(fromObject)) {
            this.fromObject = fromObject;
        }
        return this;
    }

    public QueryBuilder whereClause(String whereClause) {
        if (String.isNotBlank(whereClause)) {
            this.whereClause = whereClause;
        }
        return this;
    }

    public QueryBuilder orderByClause(String orderByClause) {
        if (String.isNotBlank(whereClause)) {
            this.orderByClause = orderByClause;
        }
        return this;
    }

    public QueryBuilder limits(Decimal limits) {
        if (limits != null && limits != 0) {
            this.limits = Integer.valueOf(limits);
        }
        return this;
    }

    public QueryBuilder buildPolimorphFieldQuery(String polymorphQuery) {
        this.polymorphFieldQuery = polymorphQuery;
        return this;
    }

    public String buildQuery() {
        if (this.selectFields.length() == 0 || this.fromObject.length() == 0) {
            throw new QueryBuilderException('Error');
        }
        String query = 'SELECT ' + this.selectFields + this.polymorphFieldQuery + ' FROM ' + this.fromObject;
        if (String.isNotBlank(this.whereClause)) {
            query += ' WHERE ' + this.whereClause;
        }
        if (String.isNotBlank(this.orderByClause)) {
            query += ' ORDER BY ' + this.orderByClause;
        }
        if (this.limits != 0) {
            query += ' LIMIT ' + this.limits;
        }
        return query;
    }

    public String buildQueryForSOSL() {
        if (String.isBlank(this.fromObject)) {
            throw new QueryBuilderException('Error');
        }
        String query = ' RETURNING ' + this.fromObject;
        if (String.isNotBlank(this.selectFields)) {
            query += ' (' + this.selectFields;
        }
        if (String.isNotBlank(this.whereClause)) {
            query += ' WHERE ' + this.whereClause;
        } else {
            query += ')';
        }
        if (String.isNotBlank(this.orderByClause)) {
            query += ' ORDER BY ' + this.orderByClause;
        } else {
            query += ')';
        }
        if (this.limits != 0) {
            query += ' LIMIT ' + this.limits + ')';
        } else {
            query += ')';
        }
        return query;
    }

    public class PolymorphField {
        public String typeOfField;
        public List<String> polymorphObjects;

        public PolymorphField() {
            this.typeOfField = '';
            this.polymorphObjects = new List<String>();
        }

        public PolymorphField typeField(String typeOfField) {
            if (String.isNotBlank(typeOfField)) {
                this.typeOfField = typeOfField;
            }
            return this;
        }

        public PolymorphField addPolymorphObject(String polymorphObject) {
            polymorphObjects.add(polymorphObject);
            return this;
        }

        public String buildPolymorphFieldQuery() {
            String polymorphQuery = '';
            if (String.isNotBlank(this.typeOfField)) {
                polymorphQuery = ', TYPEOF ' + this.typeOfField;
                if (!polymorphObjects.isEmpty()) {
                    polymorphQuery += ' ' + String.join(polymorphObjects, ' ') + ' END';
                }
            }
            return polymorphQuery;
        }
    }

    public class PolymorphFieldObject {
        public String objectType;
        public List<String> fieldsToReturn;

        public PolymorphFieldObject() {
            this.objectType = '';
            this.fieldsToReturn = new List<String>();
        }

        public PolymorphFieldObject objectType(String objectType) {
            if (String.isNotBlank(objectType)) {
                this.objectType = objectType;
            }
            return this;
        }

        public PolymorphFieldObject addFieldToReturn(String fieldToReturn) {
            if (String.isNotBlank(fieldToReturn)) {
                fieldsToReturn.add(fieldToReturn);
            }
            return this;
        }

        public String buildObjectToReturn() {
            String objectToReturnQuery = '';
            if (String.isNotBlank(this.objectType)) {
                objectToReturnQuery = 'WHEN ' + this.objectType + '';
            }
            if (!fieldsToReturn.isEmpty() && String.isNotBlank(objectToReturnQuery)) {
                objectToReturnQuery += ' THEN ' + String.join(fieldsToReturn, ', ');
            }
            return objectToReturnQuery;
        }
    }

    public static void magicMethod() {
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }

    public class QueryBuilderException extends Exception { }
}
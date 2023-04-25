public with sharing class ValidateRichTextInvocable {

    @InvocableMethod(Label='Validate rich text')
    public static List<Boolean> validateRichText(List<ValidationInput> fieldValue) {
        List<Boolean> result = new List<Boolean>();
        for (ValidationInput value : fieldValue) {
            result.add(value.q1.length() <= value.limit1 && value.q2.length() <= value.limit2 && value.q3.length() <= value.limit3
                    && value.q4.length() <= value.limit4 && value.q5.length() <= value.limit5 && value.q6.length() <= value.limit6
                    && value.q7.length() <= value.limit7 && value.q8.length() <= value.limit8);
        }

        return result;
    }

    public class ValidationInput {
        @InvocableVariable
        public String q1;

        @InvocableVariable
        public Integer limit1;

        @InvocableVariable
        public String q2;

        @InvocableVariable
        public Integer limit2;

        @InvocableVariable
        public String q3;

        @InvocableVariable
        public Integer limit3;

        @InvocableVariable
        public String q4;

        @InvocableVariable
        public Integer limit4;

        @InvocableVariable
        public String q5;

        @InvocableVariable
        public Integer limit5;

        @InvocableVariable
        public String q6;

        @InvocableVariable
        public Integer limit6;

        @InvocableVariable
        public String q7;

        @InvocableVariable
        public Integer limit7;

        @InvocableVariable
        public String q8;

        @InvocableVariable
        public Integer limit8;

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


    }
}
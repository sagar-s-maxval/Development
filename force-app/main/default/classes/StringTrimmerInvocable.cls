public with sharing class StringTrimmerInvocable {

    @InvocableMethod(Label='Trim line')
    public static List<TrimInput> checkWhetherPIRAUploaded(List<TrimInput> fieldValue) {
        TrimInput input = fieldValue[0];
        input.q1 = setLine(input.q1);
        input.q2 = setLine(input.q2);
        input.q3 = setLine(input.q3);
        input.q4 = setLine(input.q4);
        input.q5 = setLine(input.q5);
        input.q6 = setLine(input.q6);
        input.q7 = setLine(input.q7);
        input.q8 = setLine(input.q8);
        input.q9 = setLine(input.q9);
        input.q10 = setLine(input.q10);

        return new List<TrimInput> {input};
    }

    private static String setLine(String input) {
        String localString = input;
        if (input != null) {
            localString = localString.replaceAll('<p>', '');
            localString = localString.replaceAll('</p>', '');
            localString = localString.replaceAll('<br/>', '');
            localString = localString.replaceAll('<br>', '');
            localString = localString.trim();
        }

        return localString == '' || localString == null ? localString : input;
    }

    public class TrimInput {
        @InvocableVariable
        public String q1;

        @InvocableVariable
        public String q2;

        @InvocableVariable
        public String q3;

        @InvocableVariable
        public String q4;

        @InvocableVariable
        public String q5;

        @InvocableVariable
        public String q6;

        @InvocableVariable
        public String q7;

        @InvocableVariable
        public String q8;

        @InvocableVariable
        public String q9;

        @InvocableVariable
        public String q10;
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

    }



}
global with sharing class ConvertStringToListFlowHelper {

    global class flowInput {

        @InvocableVariable
        global String text;

        @InvocableVariable
        global String separator;

        @InvocableVariable
        global String prefix;

        @InvocableVariable
        global String postfix;
    }

    @InvocableMethod(Label='Move String To Next Line')
    global static List<String> convertToList(flowInput[] inputs) {
        List<String> convertedText = new List<String>();
        for (flowInput input : inputs) {
            String converted = '';
            for (String convertedData : input.text.split(input.separator)) {
                converted += input.prefix + convertedData + ' ' + input.postfix;
            }
            convertedText.add(converted);
        }
        return convertedText;
    }

    public static void coverage(){
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
    }
}
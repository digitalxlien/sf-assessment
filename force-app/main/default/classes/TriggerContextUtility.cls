public with sharing class TriggerContextUtility {
    
    
    // Variables to handle trigger recursion
    private static boolean firstRun = true;

    public static boolean isFirstRun() {
        System.debug('First Run:: ' + firstRun);
        Boolean result = firstRun;
        if(result) {
            firstrun = ! firstRun;
        }

        System.debug('Result:: ' + result);

        return result;
    }



}

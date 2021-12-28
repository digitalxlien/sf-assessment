trigger CreditCard on CreditCard__c (after update) {

    Integer responseStatusCode;
    

    // Logica para registros en tiempo beforeUpdate
    if( Trigger.isUpdate && Trigger.isAfter ) {

        if( TriggerContextUtility.isFirstRun() ){
       

            Set<Id> creditCardIds = new Set<Id>();


            for(Id creditCardId : Trigger.newMap.keySet() ){
                creditCardIds.add(creditCardId);
            }


            if( ! CreditCardIds.isEmpty() && ! System.isFuture() ){

                CreditCardWebservice.validateCreditCardWithExternalService(CreditCardIds);
            }

        }
       
    }




}
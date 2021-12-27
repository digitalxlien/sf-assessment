trigger CreditCard on CreditCard__c (after update) {

    Integer responseStatusCode;
        
    // Logica para registros en tiempo beforeUpdate
    if( Trigger.isUpdate && Trigger.isAfter ) {

        List<Id> creditCardIds = new List<Id>();


        for(Id creditCardId : Trigger.newMap.keySet() ){
            creditCardIds.add(creditCardId);
        }

        


        


    }




}
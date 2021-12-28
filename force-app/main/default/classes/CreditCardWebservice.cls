public class CreditCardWebservice {
    


    @future (callout=true)
    public static void validateCreditCardWithExternalService(Set<Id> creditCardIds){

        List<CreditCard__c> creditCards = [SELECT Id, Number__c, CreatedDate, contact__r.FirstName, contact__r.LastName, contact__r.email, contact__r.ProgramType__c, ValidatedExternalSystem__c FROM CreditCard__c where Id IN : creditCardIds ];
        Map<String, CreditCard__c> creditCardsByNumber = new Map<String, CreditCard__c>();

        // Request
        List<CreditCardWrapper> creditCardsResquest = new List<CreditCardWrapper>();
        
        // Response
        List<ValidatedCreditCard> validatedCreditCards;
        

        for(creditCard__c cd : creditCards){

            creditCardsResquest.add(new creditCardWrapper(
                cd.Number__c,
                CreditCardWebservice.formatDate(cd.CreatedDate),
                cd.contact__r.FirstName + cd.contact__r.LastName,
                cd.contact__r.email, 
                cd.contact__r.ProgramType__c 
                ) 
            );

            creditCardsByNumber.put(cd.Number__c, cd);
        }

        System.debug('creditCardsByNumber -->');
        System.debug(JSON.serialize(creditCardsByNumber));


        if( ! creditCardsResquest.isEmpty() ){
            
            Http caller = new Http();
            HttpRequest req = new HttpRequest();
            Integer StatusCode;

            req.setEndpoint('https://sf-assessment.free.beeceptor.com/');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            //req.setBody( JSON.serialize(new RequestWrapper( creditCardsResquest ) ) );
            req.setBody( JSON.serialize( creditCardsResquest) );

            HttpResponse res = caller.send(req);
            
            System.debug('Request made.');

            statusCode = res.getStatusCode();
            
            if(statusCode == 201){
                
                validatedCreditCards = ( List<ValidatedCreditCard> ) JSON.deserialize( res.getBody(),  List<ValidatedCreditCard>.class );
            
                System.debug(res.getBody() + '');
                System.debug('Response --> ');
                System.debug(JSON.serialize(validatedCreditCards));
                for (ValidatedCreditCard validatedCreditCard : validatedCreditCards) {
                    creditCardsByNumber.get(validatedCreditCard.creditCardNumber ).ValidatedExternalSystem__c = validatedCreditCard.validated;
                }

                if( ! creditCardsByNumber.values().isEmpty() ){
                    update creditCardsByNumber.values();
                }

            } 

        }


    }

    public static String formatDate(Datetime dateToCovert){
        String dateFormated = '';
        if(dateToCovert != null){
            dateFormated = dateToCovert.day() + '/' + dateToCovert.month() + '/' + dateToCovert.year();
        }
        return dateFormated;
    }

    /*
    public class RequestWrapper{
        List<CreditCardWrapper> creditCardsResquest = new List<CreditCardWrapper>();
        
        public RequestWrapper(List<CreditCardWrapper> creditCardsResquest ){
            this.creditCardsResquest = creditCardsResquest;
        }
    }


    public class ResponseWrapper{
        List<ValidatedCreditCard> validatedCreditCards = new List<ValidatedCreditCard>();

        public ResponseWrapper(){ }

        public ResponseWrapper(List<ValidatedCreditCard> validatedCreditCards ){
            this.validatedCreditCards = validatedCreditCards;
        }

    }
    */

    public class CreditCardWrapper {

        String creditCardNumber;
        String creditCardCreatedDate;
        String contactName;
        String contactEmail;
        String contactProgramType;

        public CreditCardWrapper(String creditCardNumber, String creditCardCreatedDate, String contactName, String contactEmail,  String contactProgramType ){
            this.creditCardNumber = creditCardNumber;
            this.creditCardCreatedDate = creditCardCreatedDate;
            this.contactName = contactName;
            this.contactEmail = contactEmail;
            this.contactProgramType = contactProgramType;
        }

    }

    public class ValidatedCreditCard {
        String creditCardNumber;
        Boolean validated;
    }

}

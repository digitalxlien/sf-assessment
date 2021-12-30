public with sharing class TestFactory {
    


    public static List<Account> accountsFactory(Integer amount){
        
        List<Account> accounts = new List<Account>();
        
        for (Integer x = 0; x < amount; x++) {
            accounts.add(
                new Account(
                    Name = 'Test account No. ' + x, 
                    ActiveBoolean__c = true)
            );
        }

        return accounts;
    }

    
    public static List<contact> contactsFactory(List<Account> accounts, Integer contactsPerAccount){
        
        List<Contact> contacts = new List<Contact>();
        List<String> programTypes = new List<String>();
        programTypes.add('Basic');
        programTypes.add('Plus');
        programTypes.add('Premium');
        //programTypes.add('Canceled');

        Integer counter = 0;

        for (account acc : accounts) {
            for (Integer x = 0; x < contactsPerAccount; x++) {
                
                contacts.add(
                    new Contact(
                        Salutation = 'Mr.',
                        firstName = 'Contact',
                        lastName = 'Test ' + x,
                        programType__c = programTypes.get(counter),
                        AccountId = acc.id
                    )
                );


                counter++;
                if(counter==3){
                    counter = 0;
                }

            }
        }

        return contacts;
    }


    
    public static List<Opportunity> opportunitiesFactory(List<Account> accounts, Integer oppsPerAccount){
        
        List<Opportunity> opps = new List<Opportunity>();
        
        for (account acc : accounts) {
            for (Integer x = 0; x < oppsPerAccount; x++) {
                opps.add(
                    new Opportunity(
                        Name = 'Opportunity Test',
                        accountId = acc.Id,
                        Amount = 1000,
                        CloseDate = Date.today().addDays(3),
                        StageName = 'Prospecting',
                        Type = 'New Customer'
                    )
                );
            }
        }

        return opps;
    }


    public static List<CreditCard__c> creditCardsFactory(List<Contact> contacts, Integer creditCardsPerContact){

        List<CreditCard__c> creditCards = new List<CreditCard__c>();
        
        Integer counter = 0;
        String numberString = '';
        
        for (Contact contact : contacts) {

            for (Integer x = 0; x < creditCardsPerContact; x++) {
                
                // 0
                numberString = (counter + x) + '';
                System.debug('numberString: ' + numberString);
                System.debug('numberString.leftPad( 16 - numberString.length()  ,0): ' + numberString.leftPad( 16 ,'0') );

                creditCards.add(
                    new CreditCard__c(
                        Active__c = true,
                        Contact__c = contact.id,
                        Number__c =  numberString.leftPad( 16  ,'0'),
                        ValidatedExternalSystem__c = false
                    )
                );
                
                counter++;
            
            }
        } 

        return creditCards;

    }


}

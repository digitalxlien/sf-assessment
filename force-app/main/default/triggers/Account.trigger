trigger Account on Account (before insert, before update) {


    Set<Id> accountsIds = new Set<Id>();
    Set<Id> contactIds = new Set<Id>();

    List<Contact> contacts = new List<Contact>();
    List<CreditCard__c> creditCards = new List<CreditCard__c>();
    List<Opportunity> opps = new List<Opportunity>();
    List<Case> cases = new List<Case>();
    
    // Logica para registros en tiempo beforeUpdate
    if( Trigger.isUpdate && Trigger.isBefore ) {

        // Obtencion de cuentas cuyos campos hayan cambiado sus valores en el campo ActiveBoolean__c
        for( Id accountId : Trigger.oldMap.keySet() ) { 

            if ( Trigger.oldMap.get( accountId ).ActiveBoolean__c && ! Trigger.newMap.get( accountId ).ActiveBoolean__c ) {
                accountsIds.add( accountId );
            }
        }

        
        if( ! accountsIds.isEmpty() ){
        
            // Procesamiento de contactos asociados a las cuentas afectadas y creacion de casos para contactos de tipo Premium
            contacts = [SELECT Id, ProgramType__c, accountId FROM Contact WHERE accountId IN : accountsIds ];

            if( ! contacts.isEmpty() ){
                    
                for(Contact contact : contacts) {
                    
                    contactIds.add( contact.Id );
                    
                    // Creacion de cases para los contactos afectados cuando son premium
                    if( contact.programType__c.equalsIgnoreCase( 'Premium') ){
                        cases.add (
                            new Case(
                                Status = 'New',
                                ContactId = contact.id,
                                AccountId = contact.accountId,
                                Subject = 'Canceled Account',
                                Description = 'account that has been canceled with associated premium contacts',
                                Origin = 'Web'
                            )
                        );
                    }

                    contact.ProgramType__c = 'Canceled';

                }

                update contacts;

                if( ! cases.isEmpty() ){
                    insert cases;
                }

            }

        
            // Procesamiento de tarjetas de credito asociadas a los contactos afectados
            creditCards = [SELECT Id, Active__c FROM CreditCard__c Where Contact__c IN : contactIds];

            if( ! creditCards.isEmpty() ){
                for( CreditCard__c cd : creditCards ){
                    cd.Active__c = false;
                }
                update creditCards;
            }



            // Procesamiento de oportunidades asociadas a las cuentas afectadas
            opps = [SELECT id, Description, StageName FROM Opportunity WHERE AccountId in : accountsIds AND (StageName != 'Closed Won' OR StageName != 'Closed Lost') ];

            if( ! opps.isEmpty() ){
                for(Opportunity op : opps){
                    op.StageName = 'Closed Lost';
                    op.Description = 'Cerrada por Cuenta Inactiva';
                }
                update opps;
            }

        }


    }




}
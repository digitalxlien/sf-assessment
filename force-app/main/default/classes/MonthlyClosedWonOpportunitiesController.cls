public class MonthlyClosedWonOpportunitiesController {

    public string renderAsExcel {get;set;}
    public boolean renderedInExcel {get;set;}
    public List<Opportunity> opportunities {get;set;}
    
    public MonthlyClosedWonOpportunitiesController(){
        this.opportunities = [SELECT Id,
                                    Name,
                                    Account.Name,
                                    Amount,
                                    CloseDate,
                                    StageName,
                                    Type FROM Opportunity where closeDate =
                                    THIS_MONTH and StageName = 'Closed Won' ];
        this.renderedInExcel = true;
    }

    public PageReference saveAsExcel() {
        this.renderedInExcel = false;
        renderAsExcel = 'application/vnd.ms-excel#Oportunidades mensuales cerradasganadas de ' + this.getCurrentMonthName() +'.xls';
        return null;
    }

    public String getCurrentMonthName(){
        List<String> monthsList = new List<String>();
        monthsList.add('Enero');
        monthsList.add('Febrero');
        monthsList.add('Marzo');
        monthsList.add('Abril');
        monthsList.add('Mayo');
        monthsList.add('Junio');
        monthsList.add('Julio');
        monthsList.add('Agosto');
        monthsList.add('Septiembre');
        monthsList.add('Octubre');
        monthsList.add('Noviembre');
        monthsList.add('Diciembre');
        return monthsList.get( Date.today().month() - 1 );
    }
    
}

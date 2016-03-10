*** Settings ***

Documentation  Common keywords for OpenERP tests
...            versions of the application. The correct SUT specific resource
...            is imported based on ${SUT} variable. SeleniumLibrary is also
...            imported here so that no other file needs to import it.
Library     Selenium2Library
Library     String
Library     DatabaseLibrary
Variables   ${CONFIG}


*** Keywords ***
    
OnHand	   [Arguments]    ${product_id}	${warehouse_id}
	Connect 
    @{queryResults}		Query		select qty, location_id from stock_quant where product_id='${product_id}';
    #toLog          @{queryResults}
    Disconnect from Database
    Calculate	${warehouse_id}	@{queryResults}
    @{queryResults} 	Set Global Variable 	@{queryResults}
    
Forecast	   [Arguments]    ${id}	${onHand}
	Connect 
	${product_id}= 		Query		select id from product_product where product_tmpl_id='${id}';
	toLog	${product_id[0][0]}
    @{queryResults}		Query		select product_uom_qty, picking_type_id from stock_move where product_id='${product_id[0][0]}' and state= 'assigned';
    #toLog	@{queryResults}
    Disconnect from Database
    Forecast_calculate    ${onHand}	 @{queryResults}
    @{queryResults} 	Set Global Variable 	@{queryResults}
    
Calculate    [Arguments]   ${warehouse_id}	 @{queryResults}
	${result}=	Set variable	${0.00}
	: FOR    ${data}    IN  @{queryResults}
    \    Run Keyword If          '${data[1]}'=='${warehouse_id}' 	Math		${result}	${data[0]}	+
    \    toLog	${result}
    ${result}=	 	Set Global Variable 	${result}
    
Math    [Arguments]    ${data1}	${data2}	${operation}
	${result}=            Evaluate          ${data1}${operation}${data2}
	${result}=	 	Set Global Variable 	${result}
    
Forecast_calculate    [Arguments]   ${onHand}	 @{datas}
	: FOR    ${data}    IN  @{datas}
	\    Run Keyword If          '${data[1]}'=='2'	 	Math		${result}	${data[0]}	-
	\    Run Keyword If          '${data[1]}'=='1'	 	Math		${result}	${data[0]}	+
	\    toLog	${result}
	 ${result}=	 	Set Global Variable 	${result}
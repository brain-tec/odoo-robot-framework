** Settings ***

Documentation  Common keywords for OpenERP tests
...            versions of the application. The correct SUT specific resource
...            is imported based on ${SUT} variable. SeleniumLibrary is also
...            imported here so that no other file needs to import it.
Library        Selenium2Library
Variables   ${CONFIG}

*** Variables ***
# Time defined in web/static/src/js/chrome.js till 
# interface gets blocked after a RPC call
# We wait first the same time (+0.5s) and then till the interface is no longer blocked
${OPENERP_RPC_BLOCK_TIME}	3.5


# Time till the next command is executed
${SELENIUM DELAY}   0

# How long a "Wait Until ..." command should wait
${SELENIUM TIMEOUT}   20
${BROWSER}      ff
${SERVER}       localhost
${ODOO_PORT}        8069
${OPENERP URL}      http://${SERVER}:${ODOO_PORT}
${OPENERP DB}       odoo8_selenium


*** Keywords ***
Set Up
#Uncomment the next 2 lines if you need to use Marionette
    #${ff default caps}=       Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
    # ${Marionette}     Set To Dictionary     ${ff default caps}    marionette=${True}
    log to console   Marionette Off

Login    [Arguments]    ${user}    ${password}    ${db}=None
    Open Browser                        ${OPENERP URL}  browser=${BROWSER}
    Maximize Browser Window
    Go To                               ${OPENERP URL}
    Set Selenium Speed                  ${SELENIUM DELAY}
    Set Selenium Timeout                ${SELENIUM DELAY}
    Set Selenium Implicit Wait          ${SELENIUM TIMEOUT}
    Run Keyword If                      '${db}' != 'None'                   Wait Until Page Contains Element    name=db
    Run Keyword If                      '${db}' != 'None'                   Select From List By Value           name=db    ${db}
    Wait Until Page Contains Element    name=login
    Input Text                          name=login  ${user}
    Input Password                      name=password   ${password}
    Click Button                        name=submit
    Wait Until Page Contains Element    xpath=//td[contains(@class,'oe_topbar')]/ul/li/a/span
    
# v7.0
MainMenu    [Arguments]    ${menu}
	Click Link				xpath=//td[contains(@class,'oe_topbar')]/ul/li/a[@data-menu='${menu}']
	Wait Until Page Contains Element	xpath=//div[contains(@class, 'oe_secondary_menus_container')]/div[contains(@class, 'oe_secondary_menu') and not(contains(@style, 'display: none'))]	
	ElementPostCheck			xpath=//td[contains(@class,'oe_topbar')]/ul/li/a[@data-menu='${menu}']    

# v7.0
SubMenu    [Arguments]    ${menu}
     Click Link				xpath=//td[contains(@class,'oe_leftbar')]//ul/li/a[@data-menu='${menu}']
#    Click Link                          xpath=//td[contains(@class,'oe_leftbar')]//div[contains(@class,'oe_secondary_menu') and not(contains(@style, 'display: none'))]/div[contains(text(),'${section}')]/following-sibling::ul/li/a[contains(span,'${menu}')]
	ElementPostCheck		xpath=//td[contains(@class,'oe_leftbar')]//ul/li/a[@data-menu='${menu}']
   
 
# v7.0  
SubSubMenu    [Arguments]    ${menu}
    Click Link                          xpath=//td[contains(@class,'oe_leftbar')]//div[contains(@class,'oe_secondary_menu') and not(contains(@style, 'display: none'))]/ul[contains(@class,'oe_secondary_submenu')]/li/a[contains(@class,'oe_menu_opened')]/following-sibling::ul/li/a/span[contains(text(),'${menu}')]

# v7.0
Menu    [Arguments]    ${menu1}    ${section}=None    ${menu2}=None    ${menu3}=None
    MainMenu        ${menu1}
    Run Keyword If  '${section}'!='None' and '${menu2}'!='None'     SubMenu ${section}  ${menu2}
    Run Keyword If  '${menu3}'!='None'      SubSubMenu  ${menu3}

# v7.0
ChangeView    [Arguments]    ${view}
    Click Link                          xpath=//div[contains(@class,'openerp')][last()]//ul[contains(@class,'oe_view_manager_switch')]//a[contains(@data-view-type,'${view}')]
    Wait Until Page Contains Element    xpath=//div[contains(@class,'openerp')][last()]//div[contains(@class,'oe_view_manager_view_${view}') and not(contains(@style, 'display: none'))]
   
# main window
# view-manager-main-content

# Checks that are done always before a element is executed
ElementPreCheck    [Arguments]    ${element}
	Execute Javascript      console.log("${element}");
#	Execute Javascript	var path="${element}".replace('xpath=','');var id=document.evaluate("("+path+")/ancestor::div[contains(@class,'oe_notebook_page')]/@id",document,null,XPathResult.STRING_TYPE,null).stringValue; $("a[href='#"+id+"']").click(); console.log("Clicked at a[href='#"+id+"']"); return true;

        Execute Javascript      var path="${element}".replace('xpath=','');var id=document.evaluate("("+path+")/ancestor::div[contains(@class,'oe_notebook_page')]/@id",document,null,XPathResult.STRING_TYPE,null).stringValue; if(id != ''){ window.location = "#"+id; $("a[href='#"+id+"']").click(); console.log("Clicked at #" + id); } return true;

	# Element may be in a tab. So click the parent tab. If there is no parent tab, forget about the result 
#	Run Keyword And Ignore Error   Execute Javascript    console.log("mypath: " + bot.locators.xpath.single("${element}"+"//ancestor::div[contains(@class,'oe_notebook_page')]/@id")); return true;


ElementPostCheck    [Arguments]    ${element}
   Wait Until Page Contains Element	xpath=//div[contains(@class,'openerp_webclient_container') and not(contains(@class, 'oe_wait'))]
   # Check that page is not blocked by RPC Call
#   Sleep        ${OPENERP_RPC_BLOCK_TIME}
#   Wait Until Keyword Succeeds    3 min   1 sec    Xpath Should Match X Times      //div[contains(@class,'blockPage')]     0


WriteInField                [Arguments]     ${model}    ${fieldname}    ${value}
    ElementPreCheck         xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']
    Input Text              xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']    ${value}

# v7.0
Button                      [Arguments]     ${button_name}
    Click Button            xpath=//div[contains(@class,'openerp')][last()]//*[not(contains(@style,'display:none'))]//button[@data-bt-testing-name='${button_name}']  
#    Click Button            xpath=//td[@class='oe_application']//div[contains(@class,'oe_view_manager_buttons')]//div[contains(@class,'_buttons') and not(contains(@style,'display: none'))]//button[@data-bt-testing-name='${button_name}')]
     Wait For Condition     return true;    20.0

Many2OneSelect    [Arguments]    ${model}    ${field}    ${value}
     ElementPreCheck	    xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
     Input Text		    xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
#     Wait Until Page Contains Element    xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
     Click Link             xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
     Textfield Should Contain    xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}

Date    [Arguments]    ${model}    ${field}    ${value}
     ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
     Input Text             xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}

Char    [Arguments]    ${model}    ${field}    ${value}
     ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
     Execute Javascript     $("div.openerp:last input[data-bt-testing-model_name='${model}'][data-bt-testing-name='${field}']").val(''); return true;
     Input Text             xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}

Float    [Arguments]    ${model}    ${field}    ${value}
     ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']

     Input Text             xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}

Text    [Arguments]    ${model}    ${field}    ${value}
     ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
     Input Text             xpath=//div[contains(@class,'openerp')][last()]//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}

Checkbox    [Arguments]    ${model}    ${field}
     ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@type='checkbox' and @data-bt-testing-name='${field}']
     Checkbox Should Not Be Selected	xpath=//div[contains(@class,'openerp')][last()]//input[@type='checkbox' and @data-bt-testing-name='${field}']
     Click Element          xpath=//div[contains(@class,'openerp')][last()]//input[@type='checkbox' and @data-bt-testing-name='${field}']

NotebookPage    [Arguments]    ${model}=None
    Wait For Condition      return true;

NewOne2Many    [Arguments]    ${model}    ${field}
     ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//div[contains(@class,'oe_form_field_one2many')]/div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//tr/td[contains(@class,'oe_form_field_one2many_list_row_add')]/a
     Click Link             xpath=//div[contains(@class,'openerp')][last()]//div[contains(@class,'oe_form_field_one2many')]/div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//tr/td[contains(@class,'oe_form_field_one2many_list_row_add')]/a


MainWindowButton            [Arguments]     ${button_text}
    Click Button            xpath=//td[@class='oe_application']//div[contains(@class,'oe_view_manager_current')]//button[contains(text(), '${button_text}')]

MainWindowNormalField       [Arguments]     ${field}    ${value}
    Input Text              xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']  ${value}

MainWindowSearchTextField   [Arguments]     ${field}    ${value}
    Input Text              xpath=//div[@id='oe_app']//div[contains(@id, '_search')]//input[@name='${field}']   ${value}

MainWindowSearchNow
    
MainWindowMany2One          [Arguments]     ${field}    ${value}
    Click Element           xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']  don't wait
    Input Text              xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']      ${value}
    Click Element           xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']/following-sibling::span[contains(@class, 'oe-m2o-drop-down-button')]/img don't wait
    Click Link              xpath=//ul[contains(@class, 'ui-autocomplete') and not(contains(@style, 'display: none'))]//a[self::*/text()='${value}']    don't wait
    

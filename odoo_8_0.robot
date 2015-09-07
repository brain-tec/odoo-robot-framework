** Settings ***

Documentation  Common keywords for OpenERP tests
...            versions of the application. The correct SUT specific resource
...            is imported based on ${SUT} variable. SeleniumLibrary is also
...            imported here so that no other file needs to import it.
Library     Selenium2Library
Library     String
Variables   config_80.py


*** Keywords ***
# checked: 8.0 ok
Login    [Arguments]    ${user}=${ODOO_USER}    ${password}=${ODOO_PASSWORD}    ${db}=${ODOO_DB}
    Open Browser                        ${ODOO URL}  browser=${BROWSER}
    Maximize Browser Window
    Go To                               ${ODOO URL}
    Set Selenium Speed                  ${SELENIUM_DELAY}
    Set Selenium Timeout                ${SELENIUM_TIMEOUT}
    Set Selenium Implicit Wait          ${SELENIUM_TIMEOUT}
#    Run Keyword If                      '${db}' != 'None'                   Wait Until Page Contains Element    xpath=//select[@id='db']
#    Run Keyword If                      '${db}' != 'None'                   Select From List By Value           xpath=//select[@id='db']    ${db}
    Wait Until Page Contains Element    name=login
    Input Text                          name=login  ${user}
    Input Password                      name=password   ${password}
    Click Button                        xpath=//div[contains(@class,'oe_login_buttons')]/button[@type='submit']
    Wait Until Page Contains Element    xpath=//div[@id='oe_main_menu_placeholder']/ul/li/a/span
    
# checked: 8.0 ok
MainMenu    [Arguments]    ${menu}
	Click Link				xpath=//div[@id='oe_main_menu_placeholder']/ul/li/a[@data-menu='${menu}']
	Wait Until Page Contains Element	xpath=//div[contains(@class, 'oe_secondary_menus_container')]/div[contains(@class, 'oe_secondary_menu') and not(contains(@style, 'display: none'))]	
	ElementPostCheck

# checked: 8.0 ok
SubMenu    [Arguments]    ${menu}
    Click Link				xpath=//td[contains(@class,'oe_leftbar')]//ul/li/a[@data-menu='${menu}']
    Wait Until Page Contains Element	xpath=//div[contains(@class,'oe_view_manager_body')]

# checked: 8.0 ok
ChangeView    [Arguments]    ${view}
   Click Link                          xpath=//div[contains(@class,'openerp')][last()]//ul[contains(@class,'oe_view_manager_switch')]//a[contains(@data-view-type,'${view}')]
   Wait Until Page Contains Element    xpath=//div[contains(@class,'openerp')][last()]//div[contains(@class,'oe_view_manager_view_${view}') and not(contains(@style, 'display: none'))]
   ElementPostCheck

# main window
# view-manager-main-content

# Checks that are done always before a element is executed
ElementPreCheck    [Arguments]    ${element}
	Execute Javascript      console.log("${element}");
	# Element may be in a tab. So click the parent tab. If there is no parent tab, forget about the result
    Execute Javascript      var path="${element}".replace('xpath=','');var id=document.evaluate("("+path+")/ancestor::div[contains(@class,'oe_notebook_page')]/@id",document,null,XPathResult.STRING_TYPE,null).stringValue; if(id != ''){ window.location = "#"+id; $("a[href='#"+id+"']").click(); console.log("Clicked at #" + id); } return true;


ElementPostCheck
   # Check that page is not blocked by RPC Call
   Wait Until Page Contains Element    xpath=//body[not(contains(@class, 'oe_wait'))]
#   Wait Until Page Contains Element	xpath=//div[contains(@class,'openerp_webclient_container') and not(contains(@class, 'oe_wait'))]


WriteInField                [Arguments]     ${model}    ${fieldname}    ${value}
    ElementPreCheck         xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']
    Input Text              xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']    ${value}

# checked: 8.0 ok
Button                      [Arguments]     ${model}    ${button_name}
     Click Button           xpath=//div[contains(@class,'openerp')][last()]//*[not(contains(@style,'display:none'))]//button[@data-bt-testing-name='${button_name}']
     Wait For Condition     return true;    20.0
     ElementPostCheck

# checked: 8.0 ok
Many2OneSelect    [Arguments]    ${model}    ${field}    ${value}
    ElementPreCheck	    xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
    Input Text		    xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
    Click Link             xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
    Textfield Should Contain    xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
    ElementPostCheck

Date    [Arguments]    ${model}    ${field}    ${value}
    ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
    Input Text             xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
    ElementPostCheck

Char    [Arguments]    ${model}    ${field}    ${value}
    ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
    Execute Javascript     $("div.openerp:last input[data-bt-testing-model_name='${model}'][data-bt-testing-name='${field}']").val(''); return true;
    Input Text             xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
    ElementPostCheck

Float    [Arguments]    ${model}    ${field}    ${value}
    ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
    Input Text             xpath=//div[contains(@class,'openerp')][last()]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
    ElementPostCheck

Text    [Arguments]    ${model}    ${field}    ${value}
    ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
    Input Text             xpath=//div[contains(@class,'openerp')][last()]//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
    ElementPostCheck

Select-Option    [Arguments]    ${model}    ${field}    ${value}    
    ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//select[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
    Select From List By Label	xpath=//div[contains(@class,'openerp')][last()]//select[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
    ElementPostCheck

Checkbox    [Arguments]    ${model}    ${field}
    ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//input[@type='checkbox' and @data-bt-testing-name='${field}']
    Checkbox Should Not Be Selected	xpath=//div[contains(@class,'openerp')][last()]//input[@type='checkbox' and @data-bt-testing-name='${field}']
    Click Element          xpath=//div[contains(@class,'openerp')][last()]//input[@type='checkbox' and @data-bt-testing-name='${field}']
    ElementPostCheck

NotebookPage    [Arguments]    ${model}=None
    Wait For Condition      return true;

# checked: 8.0 ok
NewOne2Many    [Arguments]    ${model}    ${field}
    ElementPreCheck        xpath=//div[contains(@class,'openerp')][last()]//div[contains(@class,'oe_form_field_one2many')]/div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//tr/td[contains(@class,'oe_form_field_one2many_list_row_add')]/a
    Click Link             xpath=//div[contains(@class,'openerp')][last()]//div[contains(@class,'oe_form_field_one2many')]/div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//tr/td[contains(@class,'oe_form_field_one2many_list_row_add')]/a
    ElementPostCheck

One2ManySelectRecord  [Arguments]    ${model}    ${field}    ${submodel}    @{fields}
    ElementPreCheck    xpath=//div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']

    # Initialize variable
    ${pre_check_xpath}=    Set Variable
    ${post_check_xpath}=    Set Variable
    ${pre_click_xpath}=    Set Variable
    ${post_click_xpath}=    Set Variable
    ${pre_check_xpath}=    Catenate    (//div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//table[contains(@class,'oe_list_content')]//tr[descendant::td[
    ${post_check_xpath}=    Catenate    ]])[1]
    ${pre_click_xpath}=    Catenate    (//div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//table[contains(@class,'oe_list_content')]//tr[
    ${post_click_xpath}=    Catenate    ]/td)[1]
    ${xpath}=    Set Variable

    # Got throught all field=value and to select the correct record
    : FOR    ${field}    IN  @{fields}
    # Split the string in fieldname=fieldvalue
    \    ${fieldname}    ${fieldvalue}=    Split String    ${field}    separator==    max_split=1
    \    ${fieldxpath}=    Catenate    @data-bt-testing-model_name='${submodel}' and @data-field='${fieldname}'

         # We first check if this field is in the view and visible
         # otherwise a single field can break the whole command

    \    ${checkxpath}=     Catenate    ${pre_check_xpath} ${fieldxpath} ${post_check_xpath}
    \    Log To Console    ${checkxpath}
    \    ${status}    ${value}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=${checkxpath}

         # In case the field is not there, log a error
    \    Run Keyword Unless     '${status}' == 'PASS'    Log    Field ${fieldname} not in the view or unvisible
         # In case the field is there, add the path to the xpath
    \    ${xpath}=    Set Variable If    '${status}' == 'PASS'    ${xpath} and descendant::td[${fieldxpath} and string()='${fieldvalue}']    ${xpath}

    # remove first " and " again (5 characters)
    ${xpath}=   Get Substring    ${xpath}    5
    ${xpath}=    Catenate    ${pre_click_xpath}    ${xpath}    ${post_click_xpath}
    Click Element    xpath=${xpath}
    ElementPostCheck


SelectListView  [Arguments]    ${model}    @{fields}
    # Initialize variable
    ${xpath}=    Set Variable

    # Got throught all field=value and to select the correct record
    : FOR    ${field}    IN  @{fields}
    # Split the string in fieldname=fieldvalue
    \    ${fieldname}    ${fieldvalue}=    Split String    ${field}    separator==    max_split=1
    \    ${fieldxpath}=    Catenate    @data-bt-testing-model_name='${model}' and @data-field='${fieldname}'

         # We first check if this field is in the view and visible
         # otherwise a single field can break the whole command

    \    ${checkxpath}=     Catenate    (//table[contains(@class,'oe_list_content')]//tr[descendant::td[${fieldxpath}]])[1]
    \    ${status}    ${value}=    Run Keyword And Ignore Error    Page Should Contain Element    xpath=${checkxpath}

         # In case the field is not there, log a error
    \    Run Keyword Unless     '${status}' == 'PASS'    Log    Field ${fieldname} not in the view or unvisible
         # In case the field is there, add the path to the xpath
    \    ${xpath}=    Set Variable If    '${status}' == 'PASS'    ${xpath} and descendant::td[${fieldxpath} and string()='${fieldvalue}']    ${xpath}

    # remove first " and " again (5 characters) 
    ${xpath}=   Get Substring    ${xpath}    5
    ${xpath}=    Catenate    (//table[contains(@class,'oe_list_content')]//tr[${xpath}]/td)[1]
    Click Element    xpath=${xpath}
    ElementPostCheck

SidebarAction  [Arguments]    ${type}    ${id}
    ClickElement   xpath=//div[contains(@class,'oe_view_manager_sidebar')]/div[not(contains(@style,'display: none'))]//div[contains(@class,'oe_sidebar')]//div[contains(@class,'oe_form_dropdown_section') and descendant::a[@data-bt-type='${type}' and @data-bt-id='${id}']]/button[contains(@class,'oe_dropdown_toggle')]
    ClickLink   xpath=//div[contains(@class,'oe_view_manager_sidebar')]/div[not(contains(@style,'display: none'))]//div[contains(@class,'oe_sidebar')]//a[@data-bt-type='${type}' and @data-bt-id='${id}']
    ElementPostCheck

MainWindowButton            [Arguments]     ${button_text}
    Click Button            xpath=//td[@class='oe_application']//div[contains(@class,'oe_view_manager_current')]//button[contains(text(), '${button_text}')]
    ElementPostCheck

MainWindowInput             [Arguments]   ${value}   ${description}
    Input Text	xpath=//div[@class='oe_form_nosheet']/table/tbody/tr[2]/td[2]/span/input      ${value}
    Input Text	xpath=//div[2]/table/tbody/tr/td[2]/div/div/div/div/div/div[3]/div/div[4]/div/div/table/tbody/tr[3]/td[2]/div/textarea       ${description}
    ElementPostCheck

MainWindowNormalField       [Arguments]     ${field}    ${value}
    Input Text              xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']  ${value}
    ElementPostCheck

MainWindowSearchTextField   [Arguments]     ${field}    ${value}
    Input Text              xpath=//div[@id='oe_app']//div[contains(@id, '_search')]//input[@name='${field}']   ${value}
    ElementPostCheck

MainWindowSearchNow
    
MainWindowMany2One          [Arguments]     ${field}    ${value}
    Click Element           xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}'] don't wait
    Input Text              xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']      ${value}
    Click Element           xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']/following-sibling::span[contains(@class, 'oe_m2o_drop_down_button')]/img don't wait
    Click Link              xpath=//ul[contains(@class, 'ui-autocomplete') and not(contains(@style, 'display: none'))]//a[self::*/text()='${value}']    don't wait
    ElementPostCheck
    

** Settings ***

Documentation  Common keywords for OpenERP tests
...	versions of the application. The correct SUT specific resource
...	is imported based on ${SUT} variable. SeleniumLibrary is also
...	imported here so that no other file needs to import it.
Library  	String
Library     connection_erp.py
Library     Collections
#Library     XvfbRobot



*** Keywords ***
Set Up
    Set Global Variable     ${ODOO_URL_DB}     http://${SERVER}:${ODOO_PORT}

    #ff default caps shoul be always presented
    ${ff default caps}=         Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
    #marionette optional, just if we need it
    #Set To Dictionary     ${ff default caps}    marionette=${True}


    #Virtual display if we want the test to run in background
    #Start Virtual Display   1920    1080

sidebaraction     [Arguments]	${action}
    sleep   1s
    Click Element   //div[@class='o_cp_left']/div[2]/div/div[2]/a
    sleep   1s
	Click Element   //div[@class='o_cp_left']/div[2]/div/div[2]/ul//a[normalize-space(.)='${action}']
# checked: 9.0 ok
Login	[Arguments]	${user}=${USER}	${password}=${PASSWORD}	${db}=${ODOO_DB}
    Set Global Variable     ${ODOO_URL_DB}     http://${SERVER}:${ODOO_PORT}
	Open Browser	${ODOO_URL_DB}  browser=${BROWSER}
	Maximize Browser Window
	Go To                           ${ODOO_URL_DB}/web/database/selector
	Set Selenium Speed	            ${SELENIUM_DELAY}
	Set Selenium Timeout	        ${SELENIUM_TIMEOUT}
	Set Selenium Implicit Wait	    ${SELENIUM_TIMEOUT}
	Click Element	xpath=//div[1]/div//a[@href="/web?db=${ODOO_DB}"]
	#Run Keyword and Ignore error    Click element   //a[@href="/web/login"]
	Wait Until Element is Visible	name=login
	Input Text	name=login  ${user}
	Input Password	name=password	${password}
	Click Button	xpath=//div[contains(@class,'oe_login_buttons')]/button[@type='submit']
	Wait Until Page Contains Element	xpath=//div[contains(@class, 'o_application_switcher')]	timeout=30 sec

# checked: 9.0 ok
DatabaseConnect    [Arguments]    ${odoo_db}=${ODOO_DB}    ${odoo_db_user}=${ODOO_DB_USER}    ${odoo_db_password}=${ODOO_DB_PASSWORD}    ${odoo_db_server}=${SERVER}    ${odoo_db_port}=${ODOO_DB_PORT}
		Connect To Database Using Custom Params	psycopg2        database='${odoo_db}',user='${odoo_db_user}',password='${odoo_db_password}',host='${odoo_db_server}',port=${odoo_db_port}

# checked: 9.0 ok
DatabaseDisconnect
		Disconnect from Database

# ok: 90EE
BackToMainMenu
    Wait Until Page Contains Element    xpath=//a[contains(@class, 'o_menu_toggle')]
	Click Link	xpath=//a[contains(@class, 'o_menu_toggle')]
	Wait Until Page Contains Element	xpath=//body[contains(@class, 'o_web_client')]
	ElementPostCheck

# ok: 110EE
MainMenu	[Arguments]	${menu}
	Click Link	xpath=//a[@data-menu='${menu}']
	Wait Until Page Contains Element	xpath=//body[contains(@class, 'o_web_client')]
	ElementPostCheck

# ok: 110EE
SubMenu	[Arguments]	${menu}
	Click Link	xpath=//a[@data-bt-testing-sub-menu_id='${menu}']
	ElementPostCheck

# ok: 110EE
SubSubMenu	[Arguments]	${menu}
    Wait Until Element is visible    xpath=//a[@data-menu='${menu}']
	Click Element	xpath=//a[@data-menu='${menu}']
	ElementPostCheck

SubMenuXMLid    [Arguments]		${Name}
	${MODULE}=              Fetch From Left            ${Name}              .
    ${NAME}=                Fetch From Right           ${Name}              .
    ${SubMenuID}=		    get_menu_res_id	${ODOO_URL_DB}	${ODOO_DB}	${USER}	${PASSWORD}	${MODULE}	${NAME}
    Run Keyword If          ${SubMenuID}               SubMenu         ${SubMenuID}
    Run Keyword Unless      ${SubMenuID}        Fail    ERROR: Module or Name not correct
   
MainMenuXMLid    [Arguments]    ${Name}
	${MODULE}=              Fetch From Left            ${Name}              .
    ${NAME}=                Fetch From Right           ${Name}              .
    ${MainMenuID}=		    get_menu_res_id	${ODOO_URL_DB}	${ODOO_DB}	${USER}	${PASSWORD}	${MODULE}	${NAME}
    Run Keyword If          ${MainMenuID}               MainMenu         ${MainMenuID}
    Run Keyword Unless      ${MainMenuID}        Fail    ERROR: Module or Name not correct
    
SubSubMenuXMLid    [Arguments]    ${Name}
    ${MODULE}=              Fetch From Left            ${Name}              .
    ${NAME}=                Fetch From Right           ${Name}              .
    ${SubSubMenuID}=		get_menu_res_id	${ODOO_URL_DB}	${ODOO_DB}	${USER}	${PASSWORD}	${MODULE}	${NAME}
    Run Keyword If          ${SubSubMenuID}            SubSubMenu         ${SubSubMenuID}
    Run Keyword Unless      ${SubSubMenuID}        Fail    ERROR: Module or Name not correct


# checked: 9.0 ok
ChangeView	[Arguments]	${view}
   Click Button	xpath=//div[contains(@class,'o_cp_switch_buttons')]/button[@data-view-type='${view}']
   Wait Until Page Contains Element	xpath=//*[contains(@class,'o_${view}_view') and not(contains(@style, 'display: none'))]
   ElementPostCheck

# main window
# view-manager-main-content

# Checks that are done always before a element is executed
SelectNotebook	[Arguments]	${element}
	Execute Javascript	console.log("${element}");
	# Element may be in a tab. So click the parent tab. If there is no parent tab, forget about the result
	${modal}=	IsModal
	${element}=	Set Variable If	'${modal}' == 'PASS'	(//div[contains(@class,'modal-content')][last()])${element}	${element}
	Execute Javascript	var path="${element}".replace('xpath=','');var id=document.evaluate("("+path+")/ancestor::div[@role='tabpanel']/@id",document,null,XPathResult.STRING_TYPE,null).stringValue; if(id != ''){ $("a[href='#"+id+"']").click(); console.log("Clicked at #" + id); } return true;

# ok: 110EE
IsModal
	# Check if modal is open
	Set Selenium Implicit Wait	1s	
	${modal}	${message}=		Run Keyword And Ignore Error	Element Should Be Visible	xpath=//div[contains(@class,'modal')]
	#Page should Contain Element	xpath=//div[contains(@class,'modal')]
	Set Selenium Implicit Wait	${SELENIUM_TIMEOUT}
	[return]	${modal}

# ok: 110EE
Modal	[Arguments]	${command}	${xpath}	${value}=
	${modal}=	IsModal
	${xpath}=	Set Variable If	'${modal}' == 'PASS'	(//div[contains(@class,'modal-lg')]/div[contains(@class,'modal-content')])[last()]${xpath}	${xpath}
	Log	${xpath}
	Run Keyword If	'''${value}'''	${command}	xpath=${xpath}	${value}
	Run Keyword Unless	'''${value}'''	${command}	xpath=${xpath}

# ok: 100EE
ElementPostCheck
   # Check that page is not blocked by RPC Call
   Wait Until Page Contains Element	xpath=//body[not(contains(@class, 'o_loading'))]	timeout=2min

WriteInField	[Arguments]	${model}	${fieldname}	${value}	${submodel}=
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']
	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']	${value}

Radio	[Arguments]	${model}	${field}	${value}
	Click Element	 xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}' and @value='${value}']

# ok: 9.0EE ok (Mainpage)
Button
	[Arguments]	${model}=	${button_name}=	${class}=
	Wait Until Page Contains Element	xpath=//div[contains(@class,'o_cp_pager')]
	Run Keyword Unless	'${model}' == ''	Modal	Focus	xpath=//button[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${button_name}' and not(contains(@class,'o_form_invisible'))]
	Run Keyword Unless	'${model}' == ''	Modal	Click Button	xpath=//button[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${button_name}' and not(contains(@class,'o_form_invisible'))]
	Run Keyword If	'${model}' == ''	Modal	Focus	xpath=//button[@class='${class}']
	Run Keyword If	'${model}' == ''	Modal	Click Button	xpath=//button[@class='${class}']
	ElementPostCheck

ButtonXMLid    [Arguments]		${IR_MODEL_DATA_MODEL}    ${Model}    ${Name}
	${MODULE}=              Fetch From Left            ${Name}              .
    ${NAME}=                Fetch From Right           ${Name}              .
    ${ButtonID}=		    get_button_res_id	${ODOO_URL_DB}	${ODOO_DB}	${USER}	${PASSWORD}  ${IR_MODEL_DATA_MODEL}  ${MODULE}	${NAME}
    Run Keyword If          ${ButtonID}               Button         model=${Model}  button_name=${ButtonID}

ButtonWizard
	[Arguments]	${model}=	${button_name}=	    ${class}=
	Wait Until Page Contains Element	xpath=//div[contains(@class,'o_cp_pager')]
	Click Button	xpath=//button[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${button_name}']
	ElementPostCheck

# ok: 90EE ok (Mainpage)
Many2OneSelect	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	value=${value}
	Click Link	xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
	ElementPostCheck
	
Many2OneSelectWizard	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Input Text	xpath=//div[contains(@div,modal)]//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	Click Link	xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
	ElementPostCheck

# ok: 90EE ok (Mainpage)
X2Many-Many2OneSelect	[Arguments]	${model}	${field}	${value}
	Modal	Input Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']	value=${value}
	Modal	Click Link	xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
	ElementPostCheck


# The blue arrow on the right side of a many2one
Many2One-External	[Arguments]	${model}	${field}
	Modal	Click Button	xpath=//div[contains(@class,'o_form_field_many2one') and .//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']]//button[contains(@class,'o_external_button')]

# ok: 11.0EE
Date	[Arguments]	${model}	${field}	${value}
	${xpath}=	set variable	//div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//input[@class='o_datepicker_input o_input']
	SelectNotebook	xpath=${xpath}
	Click Element	${xpath}
	sleep	1s
	Modal	Input Text	xpath=${xpath}	value=${value}
	Modal	Press Key	${xpath}	\\13
	ElementPostCheck

X2Many-Date	[Arguments]	${model}	${field}	${value}
	Modal	Input Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

# ok: 9.0EE
Char	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Clear Element Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	value=${value}
	ElementPostCheck
	
# ok: 9.0EE
CharWizard	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Clear Element Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

X2Many-Char	[Arguments]	${model}	${field}	${value}
    #Click Element    //td[@data-field="${field}" and @data-bt-testing-model_name="${model}"]
   # Modal   Click Element	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']
#	Modal	Clear Element Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']
    Input Text	xpath=//input[ancestor::div[contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

Float	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	  value=${value}
	ElementPostCheck

X2Many-Float	[Arguments]	${model}	${field}	${value}
	Modal	Clear Element Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']	value=${value}
	ElementPostCheck

FloatWizard	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

Text	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	value=${value}
	ElementPostCheck
	
TextWizard	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Input Text	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

X2Many-Text	[Arguments]	${model}	${field}	${value}
    Modal   Click Element xpath=//textarea[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
    Modal	Clear Element Text	xpath=//textarea[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//textarea[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']	value=${value}
	ElementPostCheck

Select-Option	[Arguments]	${model}	${field}	${value}	
	SelectNotebook	xpath=//select[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	#Modal	Select From List By Value	xpath=//select[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	value=${value}
	#SelectNotebook	xpath=//select[@id='${model}' and @name='${field}']
	Select From List By Value   	xpath=//select[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']    ${value}
	ElementPostCheck

X2Many-Selection	[Arguments]	${model}	${field}	${value}
    Modal   Click Element   xpath=//select[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']
    Modal   Select From List By Value   xpath=//select[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-submodel_name='${model}']] and @data-bt-testing-name='${field}']  value=${value}
    ElementPostCheck

Checkbox-Select	[Arguments]	${model}	${field}
	SelectNotebook	xpath=//input[@type='checkbox' and @data-bt-testing-name='${field}']
	Click Element	xpath=//input[@type='checkbox' and @data-bt-testing-name='${field}']
	ElementPostCheck

X2Many-Checkbox	[Arguments]	${model}	${field}
	Click Element	xpath=//input[@type='checkbox' and ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
	ElementPostCheck

NotebookPage	[Arguments]	${string}
	Click Element	xpath=//div[@class='o_notebook']//li/a[@data-bt-testing-original-string='${string}']

# checked: 8.0 ok
NewOne2Many	[Arguments]	${model}	${field}
	SelectNotebook	xpath=//div[contains(@class,'o_form_field') and contains(@class, 'o_view_manager_content') and descendant::div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']]//td[contains(@class,'o_form_field_x2many_list_row_add')]/a
	Click element	xpath=(//div[contains(@class,'o_form_field') and contains(@class, 'o_view_manager_content') and descendant::div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']]//td[contains(@class,'o_form_field_x2many_list_row_add')]/a)[last()]
	ElementPostCheck

One2ManySelectRecord	[Arguments]	${model}	${field}	${submodel}	@{fields}
	SelectNotebook	xpath=//div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']

	# Initialize variable
	${pre_check_xpath}=	Set Variable
	${post_check_xpath}=	Set Variable
	${pre_click_xpath}=	Set Variable
	${post_click_xpath}=	Set Variable
	${pre_check_xpath}=	Catenate	(//div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//table[contains(@class,'oe_list_content')]//tr[descendant::td[
	${post_check_xpath}=	Catenate	]])[1]
	${pre_click_xpath}=	Catenate	(//div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']//table[contains(@class,'oe_list_content')]//tr[
	${post_click_xpath}=	Catenate	]/td)[1]
	${xpath}=	Set Variable

	# Got throught all field=value and to select the correct record
	: FOR	${field}	IN  @{fields}
	# Split the string in fieldname=fieldvalue
	\	${fieldname}	${fieldvalue}=	Split String	${field}	separator==	max_split=1
	\	${fieldxpath}=	Catenate	@data-bt-testing-model_name='${submodel}' and @data-field='${fieldname}'

	# We first check if this field is in the view and visible
	# otherwise a single field can break the whole command

	\	${checkxpath}=	Catenate	${pre_check_xpath} ${fieldxpath} ${post_check_xpath}
	\	Log To Console	${checkxpath}
	\	${status}	${value}=	Run Keyword And Ignore Error	Page Should Contain Element	xpath=${checkxpath}

	# In case the field is not there, log a error
	\	Run Keyword Unless	'${status}' == 'PASS'	Log	Field ${fieldname} not in the view or unvisible
	# In case the field is there, add the path to the xpath
	\	${xpath}=	Set Variable If	'${status}' == 'PASS'	${xpath} and descendant::td[${fieldxpath} and normalize-space(string())=normalize-space('${fieldvalue}')]	${xpath}

	# remove first " and " again (5 characters)
	${xpath}=   Get Substring	${xpath}	5
	${xpath}=	Catenate	${pre_click_xpath}	${xpath}	${post_click_xpath}
	Click Element	xpath=${xpath}
	ElementPostCheck


SelectListView  [Arguments]	${model}	@{fields}
	# Initialize variable
	${xpath}=	Set Variable

	# Got throught all field=value and to select the correct record
	: FOR	${field}	IN  @{fields}
	# Split the string in fieldname=fieldvalue
	\	${fieldname}	${fieldvalue}=	Split String	${field}	separator==	max_split=1
	\	${fieldxpath}=	Catenate	@data-bt-testing-model_name='${model}' and @data-field='${fieldname}'

	# We first check if this field is in the view and visible
	# otherwise a single field can break the whole command

	\	${checkxpath}=	Catenate	(//table[contains(@class,'o_list_view')]//tr[descendant::td[${fieldxpath}]])[1]
	\	${status}	${value}=	Run Keyword And Ignore Error	Page Should Contain Element	xpath=${checkxpath}

	# In case the field is not there, log a error
	\	Run Keyword Unless	'${status}' == 'PASS'	Log	Field ${fieldname} not in the view or unvisible
	# In case the field is there, add the path to the xpath
	\	${xpath}=	Set Variable If	'${status}' == 'PASS'	${xpath} and descendant::td[${fieldxpath} and normalize-space(string())=normalize-space('${fieldvalue}')]	${xpath}

	# remove first " and " again (5 characters)
	${xpath}=   Get Substring	${xpath}	5
	${xpath}=	Catenate	(//table[contains(@class,'o_list_view')]//tr[${xpath}]/td[not(contains(@class,'o_list_record_selector'))])[1]
	Click Element	xpath=${xpath}
	ElementPostCheck

SidebarActionOld  [Arguments]	${type}	${id}
	# open the menu
	ClickElement   xpath=//div[contains(@class,'o_cp_sidebar')]//div[contains(@class,'o_dropdown') and descendant::a[@data-bt-type='${type}' and @data-bt-id='${id}']]/button[contains(@class,'oe_dropdown_toggle')]
	# click on the menuentry
	ClickLink   xpath=//div[contains(@class,'oe_view_manager_sidebar')]/div[not(contains(@style,'display: none'))]//div[contains(@class,'oe_sidebar')]//a[@data-bt-type='${type}' and @data-bt-id='${id}']
	ElementPostCheck

old_SidebarAction  [Arguments]	${type}	${index}
	# open the menu
	Click Element	xpath=//div[contains(@class,'o_cp_sidebar')]/div/div[@class='o_dropdown' and @data-bt-type='${type}']
	# click on the menuentry
	Click Element	xpath=//div[contains(@class,'o_cp_sidebar')]/div/div[contains(@class,'o_dropdown') and @data-bt-type='${type}']/ul/li/a[@data-section='${type}' and @data-index='${index}']


MainWindowButton	[Arguments]	${button_text}
	Click Button	xpath=//td[@class='oe_application']//div[contains(@class,'oe_view_manager_current')]//button[contains(text(), '${button_text}')]
	ElementPostCheck

MainWindowNormalField	[Arguments]	${field}	${value}
	Input Text	xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']  ${value}
	ElementPostCheck

MainWindowSearchTextField   [Arguments]	${field}	${value}
	Input Text	xpath=//div[@id='oe_app']//div[contains(@id, '_search')]//input[@name='${field}']   ${value}
	ElementPostCheck

MainWindowSearchNow
	
MainWindowMany2One	[Arguments]	${field}	${value}
	Click Element	xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']  don't wait
	Input Text	xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']	${value}
	Click Element	xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']/following-sibling::span[contains(@class, 'oe-m2o-drop-down-button')]/img don't wait
	Click Link	xpath=//ul[contains(@class, 'ui-autocomplete') and not(contains(@style, 'display: none'))]//a[self::*/text()='${value}']	don't wait
	ElementPostCheck
	

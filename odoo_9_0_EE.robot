** Settings ***

Documentation  Common keywords for OpenERP tests
...	versions of the application. The correct SUT specific resource
...	is imported based on ${SUT} variable. SeleniumLibrary is also
...	imported here so that no other file needs to import it.
Library	Selenium2Library
Library	String
Variables   config_80.py


*** Keywords ***
# checked: 9.0 ok
Login	[Arguments]	${user}=${ODOO_USER}	${password}=${ODOO_PASSWORD}	${db}=${ODOO_DB}
	Open Browser	${ODOO URL}  browser=${BROWSER}
	Maximize Browser Window
	Go To                           ${ODOO URL}
	Set Selenium Speed	            ${SELENIUM_DELAY}
	Set Selenium Timeout	        ${SELENIUM_TIMEOUT}
	Set Selenium Implicit Wait	    ${SELENIUM_TIMEOUT}
	Click Element	xpath=//div[1]/div//a[@href="/web?db=${ODOO_DB}"]
	Wait Until Page Contains Element	name=login
	Input Text	name=login  ${user}
	Input Password	name=password	${password}
	Click Button	xpath=//div[contains(@class,'oe_login_buttons')]/button[@type='submit']
	Wait Until Page Contains Element	xpath=//nav[contains(@class, 'navbar')]	timeout=30 sec

# ok: 90EE
BackToMainMenu
	Click Link	xpath=//a[contains(@class, 'o_menu_toggle')]
	Wait Until Page Contains Element	xpath=//body[contains(@class, 'o_web_client')]
	ElementPostCheck

# ok: 90EE
MainMenu	[Arguments]	${menu}
	Click Link	xpath=//a[@data-menu='${menu}']
	Wait Until Page Contains Element	xpath=//body[contains(@class, 'o_web_client')]
	ElementPostCheck

# ok: 90EE
SubMenu	[Arguments]	${menu}
	Click Link	xpath=//a[@data-bt-testing-sub-menu_id='${menu}']
	ElementPostCheck

# ok: 90EE
SubSubMenu	[Arguments]	${menu}
	Click Link	xpath=//a[@data-menu='${menu}']
	ElementPostCheck


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

# ok: 90EE
IsModal
	# Check if modal is open
	Set Selenium Implicit Wait	2s	
	${modal}	${value}=		Run Keyword And Ignore Error	Element Should Be Visible	xpath=//div[contains(@class,'modal')]
	#Page should Contain Element	xpath=//div[contains(@class,'modal')]
	Set Selenium Implicit Wait	${SELENIUM_TIMEOUT}
	[return]	${modal}

# ok: 90EE
Modal	[Arguments]	${command}	${xpath}	${value}=
	${modal}=	IsModal
	${xpath}=	Set Variable If	'${modal}' == 'PASS'	(//div[contains(@class,'modal-content')])[last()]${xpath}	${xpath}
	Log	${xpath}
	Run Keyword If	'''${value}'''	${command}	xpath=${xpath}	${value}
	Run Keyword Unless	'''${value}'''	${command}	xpath=${xpath}

# ok: 90EE
ElementPostCheck
   # Check that page is not blocked by RPC Call
   Wait Until Page Contains Element	xpath=//body[not(contains(@class, 'oe_wait'))]	timeout=2min


WriteInField	[Arguments]	${model}	${fieldname}	${value}	${submodel}=
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']
	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']|textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${fieldname}']	${value}


# ok: 9.0EE ok (Mainpage)
Button
	[Arguments]	${model}=	${button_name}=	${class}=
	Wait Until Page Contains Element	xpath=//div[contains(@class,'o_cp_pager')]
	Run Keyword Unless	'${model}' == ''	Modal	Click Button	xpath=//button[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${button_name}']
	Run Keyword If	'${model}' == ''	Modal	Click Button	xpath=//button[@class='${class}']
	ElementPostCheck

ButtonWizard
	[Arguments]	${model}=	${button_name}=	${class}=
	Wait Until Page Contains Element	xpath=//div[contains(@class,'o_cp_pager')]
	Click Button	xpath=//button[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${button_name}']
	ElementPostCheck

# ok: 90EE ok (Mainpage)
Many2OneSelect	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	value=${value}
	Modal	Click Link	xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
	ElementPostCheck
	
Many2OneSelectWizard	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	Click Link	xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
	ElementPostCheck

# ok: 90EE ok (Mainpage)
X2Many-Many2OneSelect	[Arguments]	${model}	${field}	${value}
	Modal	Input Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']	value=${value}
	Modal	Click Link	xpath=//ul[contains(@class,'ui-autocomplete') and not(contains(@style,'display: none'))]/li[1]/a
	ElementPostCheck

# The blue arrow on the right side of a many2one
Many2One-External	[Arguments]	${model}	${field}
	Modal	Click Button	xpath=//div[contains(@class,'o_form_field_many2one') and .//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']]//button[contains(@class,'o_external_button')]

Date	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
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
	Modal	Clear Element Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']	value=${value}
	ElementPostCheck

Float	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

X2Many-Float	[Arguments]	${model}	${field}	${value}
	Modal	Clear Element Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//input[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

FloatWizard	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Input Text	xpath=//input[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

Text	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck
	
TextWizard	[Arguments]	${model}	${field}	${value}
	SelectNotebook	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	Input Text	xpath=//textarea[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	ElementPostCheck

X2Many-Text	[Arguments]	${model}	${field}	${value}
	Modal	Clear Element Text	xpath=//textarea[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
	Modal	Input Text	xpath=//textarea[ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']	value=${value}
	ElementPostCheck

Select-Option	[Arguments]	${model}	${field}	${value}	
	#SelectNotebook	xpath=//select[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']
	#Modal	Select From List By Label	xpath=//select[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']	${value}
	SelectNotebook	xpath=//select[@id='${model}' and @name='${field}']
	Select From List By Value   	xpath=//select[@id='${model}' and @name='${field}']    ${value}
	ElementPostCheck

Checkbox	[Arguments]	${model}	${field}
	SelectNotebook	xpath=//input[@type='checkbox' and @data-bt-testing-name='${field}']
	#Checkbox Should Not Be Selected	xpath=//input[@type='checkbox' and @data-bt-testing-name='${field}']
	Click Element	xpath=//input[@type='checkbox' and @data-bt-testing-name='${field}']
	ElementPostCheck

X2Many-Checkbox	[Arguments]	${model}	${field}
	Checkbox Should Not Be Selected	xpath=//input[@type='checkbox' and ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
	Click Element	xpath=//input[@type='checkbox' and ancestor::div[contains(@class, 'o_view_manager_content') and contains(@class, 'o_form_field') and descendant::div[@data-bt-testing-model_name='${model}']] and @data-bt-testing-name='${field}']
	ElementPostCheck

NotebookPage	[Arguments]	${string}
	Click Element	xpath=//div[@class='o_notebook']//li/a[@data-bt-testing-original-string='${string}']

# checked: 8.0 ok
NewOne2Many	[Arguments]	${model}	${field}
	SelectNotebook	xpath=//div[contains(@class,'o_form_field') and contains(@class, 'o_view_manager_content') and descendant::div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']]//td[contains(@class,'o_form_field_x2many_list_row_add')]/a
	Click Link	xpath=//div[contains(@class,'o_form_field') and contains(@class, 'o_view_manager_content') and descendant::div[@data-bt-testing-model_name='${model}' and @data-bt-testing-name='${field}']]//td[contains(@class,'o_form_field_x2many_list_row_add')]/a
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

SidebarAction  [Arguments]	${type}	${id}
	# open the menu
	ClickElement   xpath=//div[contains(@class,'o_cp_sidebar')]//div[contains(@class,'o_dropdown') and descendant::a[@data-bt-type='${type}' and @data-bt-id='${id}']]/button[contains(@class,'oe_dropdown_toggle')]
	# click on the menuentry
	ClickLink   xpath=//div[contains(@class,'oe_view_manager_sidebar')]/div[not(contains(@style,'display: none'))]//div[contains(@class,'oe_sidebar')]//a[@data-bt-type='${type}' and @data-bt-id='${id}']
	ElementPostCheck

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
	

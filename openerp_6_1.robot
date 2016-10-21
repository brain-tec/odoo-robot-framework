*** Settings ***

Documentation  Common keywords for OpenERP tests
...            versions of the application. The correct SUT specific resource
...            is imported based on ${SUT} variable. SeleniumLibrary is also
...            imported here so that no other file needs to import it.
Library        SeleniumLibrary

*** Variables ***

${SELENIUM DELAY}	0.5
${BROWSER}			ff
${SERVER}			localhost
${ODOO_PORT}				8069
${OPENERP URL}		http://${SERVER}:${ODOO_PORT}/web/webclient/home
${OPENERP DB}		DEMO
${OPENERP USERNAME}	admin
${OPENERP PASSWORD}	admin


*** Keywords ***
Set Up
#Uncomment the next 2 lines if you need to use Marionette
    #${ff default caps}=       Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
    # ${Marionette}     Set To Dictionary     ${ff default caps}    marionette=${True}
    log to console   Marionette Off

Login
#	Start Selenium Server
    Open Browser  			${OPENERP URL}  ${BROWSER}
#    Maximize Browser Window
    Set Selenium Speed  	${SELENIUM DELAY}
    Select From List		db			${OPENERP DB}
	Input Text 				login		${OPENERP USERNAME}
	Input Password			password	${OPENERP PASSWORD}
	Click Button			submit		don't wait
	Wait Until Page Contains Element	xpath=//h1[@class='header_title']
	Element Should Contain	xpath=//h1[@class='header_title']	${OPENERP DB}

	
MainMenu	[Arguments]	${menu}
	Click Link							xpath=//div[@id='oe_menu']//a[descendant-or-self::*/text()[contains(., '${menu}')]]		dont't wait
	Wait Until Page Contains Element	xpath=//td[@id='oe_secondary_menu']
	
SubMenu	[Arguments]	${menu}
	Page Should Contain Element			xpath=//td[@id='oe_secondary_menu']/div[contains(@class, 'oe_secondary_menu') and not(contains(@style, 'display: none'))]/a[contains(@class, 'oe_secondary_menu_item') and descendant-or-self::*/text()[contains(., '${menu}') and not(contains(@class, 'opened']]	
	Run Keyword If Test Passed			Click Link							xpath=//td[@id='oe_secondary_menu']/div[contains(@class, 'oe_secondary_menu') and not(contains(@style, 'display: none'))]/a[contains(@class, 'oe_secondary_menu_item') and descendant-or-self::*/text()[contains(., '${menu}')]]	don't wait
#	Click Link							xpath=//td[@id='oe_secondary_menu']//a[contains(@class, 'oe_secondary_menu_item') and descendant-or-self::*/text()[contains(., '${menu}')]]		don't wait
	
SubSubMenu	[Arguments]	${menu}
	Click Link							xpath=//td[@id='oe_secondary_menu']/div[contains(@class, 'oe_secondary_menu') and not(contains(@style, 'display: none'))]/div[not(contains(@style, 'display: none'))]/a[contains(@class, 'oe_secondary_submenu_item') and descendant-or-self::*/text()[contains(., '${menu}')]]		don't wait
#	Click Link							xpath=//td[@id='oe_secondary_menu']//div[not contains(@style, 'visibility: none')]//a[contains(@class, 'oe_secondary_submenu_item') and descendant-or-self::*/text()[contains(., '${menu}')]]		don't wait
# ok
	
SubSubSubMenu	[Arguments]	${menu}
	Click Link							xpath=//td[@id='oe_secondary_menu']/div[contains(@class, 'oe_secondary_menu') and not(contains(@style, 'display: none'))]/div[not(contains(@style, 'display: none'))]/div[not(contains(@style, 'display: none'))]/a[contains(@class, 'oe_secondary_submenu_item') and descendant-or-self::*/text()[contains(., '${menu}')]]	don't wait
#	Click Link							xpath=//td[@id='oe_secondary_menu']//a[contains(@class, 'oe_secondary_submenu_item') oe_secondary_menu_item submenu opened    //td[@id='oe_secondary_submenu']//a[contains(@class, 'oe_secondary_submenu_item') and descendant-or-self::*/text()[contains(., '${menu}')]]		don't wait

SubSubSubSubMenu	[Arguments]	${menu}
	Click Link							xpath=//td[@id='oe_secondary_menu']/div[contains(@class, 'oe_secondary_menu') and not(contains(@style, 'display: none'))]/div[not(contains(@style, 'display: none'))]/div[not(contains(@style, 'display: none'))]/div[not(contains(@style, 'display: none'))]/a[contains(@class, 'oe_secondary_submenu_item') and descendant-or-self::*/text()[contains(., '${menu}')]]		don't wait

Menu				[Arguments]	${menu1}	${menu2}=None	${menu3}=None	${menu4}=None	${menu5}=None
	MainMenu		${menu1}
	Run Keyword If	'${menu2}'!='None'		SubMenu	${menu2}
	Run Keyword If	'${menu3}'!='None'		SubSubMenu	${menu3}
	Run Keyword If	'${menu4}'!='None'		SubSubSubMenu	${menu4}
	Run Keyword If	'${menu5}'!='None'		SubSubSubSubMenu	${menu5}
	
	
# oberstes Fenster
# ui-dialog ui-widget ui-widget-content ui-corner-all ui-draggable ui-resizable
# role = dialog


# main window
# view-manager-main-content

MainWindowSearchTextField	[Arguments]		${field}	${value}
	Input Text				xpath=//div[@id='oe_app']//div[contains(@id, '_search')]//input[@name='${field}']	${value}

MainWindowSearchNow
	Click Button			xpath=//div[@id='oe_app']//div[contains(@class, 'oe_search-view-buttons')]//button[descendant-or-self::*/text()[contains(., 'Search')]]		don't wait
	
MainWindowListViewCreate	
	Click Button			xpath=//div[@id='oe_app']//td[contains(@class, 'oe-actions')]//button[contains(@class, 'oe-list-add')]	don't wait
	
MainWindowNormalField		[Arguments]		${field}	${value}
	Input Text				xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']	${value}
	
MainWindowMany2One			[Arguments]		${field}	${value}
	Click Element			xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']	don't wait
	Input Text				xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']		${value}
	Click Element			xpath=//td[contains(@class, 'view-manager-main-content')]//input[@name='${field}']/following-sibling::span[contains(@class, 'oe-m2o-drop-down-button')]/img	don't wait
	Click Link				xpath=//ul[contains(@class, 'ui-autocomplete') and not(contains(@style, 'display: none'))]//a[self::*/text()='${value}']	don't wait
	
	
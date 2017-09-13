*** Settings ***

Documentation   Basic test for odoo v9. Every Selenium update should pass it
Resource       odoo_10_0.robot
Library        Selenium2Library
Library        String
Variables      config.py
Library        connection_erp.py


*** Test Cases ***
Create Variables
    Set Global Variable     ${ODOO_URL_DB}     http://${SERVER}:${ODOO_PORT}
    ${ff default caps}=         Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
    Set To Dictionary     ${ff default caps}    marionette=${True}
    ${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin    90
	log to console	 ${module}
	${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin	189
	log to console	 ${module}
Drop DB
	${drop}=	Drop Db     ${ODOO_URL_DB}	  admin	  ${ODOO_DB}
	log to console	${drop}
Create db
	#url, postgres_superuser_pw, new_DB name, boolean demo_data_loaded, new_db_pw
	${created}=	    Create New Db	${ODOO_URL_DB}	admin	${ODOO_DB}	True	admin   en_US
	log to console	${created}
	Run Keyword Unless	${created}	Fail
Install sales
	#url, DB_name, db_pw, module_name
	${module_installed}=	Install Module	${ODOO_URL_DB}	${ODOO_DB}	admin	sale
	log to console	${module_installed}
	Run Keyword Unless	${module_installed}	Fail
Install web Selenium
	#url, DB_name, db_pw, module_name
	${module_installed}=	Install Module	${ODOO_URL_DB}	${ODOO_DB}	admin	web_selenium
	log to console	${module_installed}
	Run Keyword Unless	${module_installed}	Fail
Valid Login
	Login     user=admin    password=admin
	sleep   1s
Create new User
    MainMenuXMLid    sales_team.menu_base_partner
    SubMenuXMLid     sales_team.menu_sales
    SubSubMenuXMLid    sales_team.menu_partner_form
    sleep   3s
	Button	class=btn btn-primary btn-sm o-kanban-button-new
	Char	res.partner	name	New customer
	Many2OneSelect    res.partner	parent_id	Agrolait
Partner Address
	Button	model=res.partner	button_name=open_parent
	Char	res.partner	street	69 street
	Char	res.partner	city	London
	Many2OneSelect	res.partner	country_id	United Kingdom
Contact phone
    Button	model=res.partner	button_name=oe_form_button_save
    Button	class=close
	Char	res.partner	phone	4568275555
	Char	res.partner	mobile	5555346783
Text partner
	Text	res.partner	comment	internal note
Other data
	Many2OneSelect    res.partner	user_id	Administrator
	Checkbox-Select	res.partner	supplier
save Partner
	Button	model=res.partner	button_name=oe_form_button_save
Test SelectListView
    BackToMainMenu
	MainMenuXMLid    sales_team.menu_base_partner
	SubMenuXMLid     sales_team.menu_sales
	SubSubMenuXMLid    sale.menu_sale_quotations
	SelectListView	sale.order		name=SO004
	Button	model=sale.order	button_name=oe_form_button_edit
	Button	model=sale.order	button_name=oe_form_button_save
Create Quotation
    SubMenuXMLid   sales_team.menu_sales
    SubSubMenuXMLid    sale.menu_sale_order
	Button	model=sale.order	button_name=oe_list_add
	Many2OneSelect    sale.order	partner_id	Agrolait
	Date	sale.order	validity_date	 12/21/2017
	NewOne2Many    sale.order	order_line
	X2Many-Many2OneSelect	sale.order.line	  product_id	ipad mini
second order line
	NewOne2Many    sale.order	order_line
	X2Many-Many2OneSelect	sale.order.line	  product_id    iMac
Third Order Line
	NewOne2Many    sale.order	order_line
	X2Many-Many2OneSelect	sale.order.line	  product_id    iPod
	NotebookPage    Other Information
	Char	sale.order	client_order_ref	Hello Test
Save Quotation
	Button	model=sale.order	button_name=oe_form_button_save
and cancel
	Button	model=sale.order	button_name=action_cancel
Quotation
	Button	model=sale.order	button_name=action_draft
Confirm SO
	Button	model=sale.order	button_name=action_confirm
Create Invoice
	Button	model=sale.order	button_name=oe_form_button_edit
	click element  //a[@data-bt-testing-original-string="Order Lines"]
	click element  //table[@class="o_list_view table table-condensed table-striped"]/tbody/tr[1]/td[@data-field="qty_delivered" and @data-bt-testing-model_name="sale.order.line"]
	X2Many-Char	    sale.order.line	    qty_delivered	1.000
	click element  //table[@class="o_list_view table table-condensed table-striped"]/tbody/tr[2]/td[@data-field="qty_delivered" and @data-bt-testing-model_name="sale.order.line"]
	sleep   1s
	X2Many-Char	    sale.order.line	    qty_delivered	1.000
	click element  //table[@class="o_list_view table table-condensed table-striped"]/tbody/tr[3]/td[@data-field="qty_delivered" and @data-bt-testing-model_name="sale.order.line"]
	sleep   1s
	X2Many-Char	    sale.order.line	    qty_delivered	1.000
	Button	model=sale.order	button_name=259
	Radio	sale.advance.payment.inv	advance_payment_method	all
	Button	model=sale.advance.payment.inv	button_name=create_invoices
close
    close browser

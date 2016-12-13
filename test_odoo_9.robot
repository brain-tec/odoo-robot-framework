*** Settings ***

Documentation   Basic test for odoo v9. Every Selenium update should pass it
Resource       odoo_9_0_EE.robot
Library        Selenium2Library
Library        String
Variables      config_90.py
Library        connection_erp.py


*** Test Cases ***
Create Variables
    Set Global Variable     ${ODOO_URL_DB}     http://${SERVER}:${ODOO_PORT}
    ${ff default caps}=         Evaluate    sys.modules['selenium.webdriver'].common.desired_capabilities.DesiredCapabilities.FIREFOX    sys,selenium.webdriver
    Set To Dictionary     ${ff default caps}    marionette=${True}
    ${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin    67
	log to console	 ${module}
	${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin	186
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
Test SelectListView
	MainMenuXMLid    base.menu_base_partner
	sleep   2s
	SubMenuXMLid    base.menu_sales
	SubSubMenuXMLid    sale.menu_sale_quotations
	SelectListView	sale.order		name=SO004
	Button	model=sale.order	button_name=oe_form_button_edit
	Button	model=sale.order	button_name=oe_form_button_save
Create Quotation
    SubMenuXMLid   base.menu_sales
    SubSubMenuXMLid    sale.menu_sale_quotations
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
	Button	model=sale.order	button_name=246
	Radio	sale.advance.payment.inv	advance_payment_method	all
	Button	model=sale.advance.payment.inv	button_name=create_invoices
	Button	model=account.invoice	button_name=invoice_open
	Button	model=account.invoice	button_name=invoice_pay_customer
	Select-Option	account.voucher	journal_id	17
	Button	model=account.voucher	button_name=button_proforma_voucher
close
    close browser

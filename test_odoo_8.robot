*** Settings ***

Documentation   Basic test for odoo v8. Every Selenium update should pass it
Resource       odoo_8_0.robot
Library        Selenium2Library
Library        String
Variables      config_80.py
Library        connection_erp.py


*** Test Cases ***
Create Variables
    Set Global Variable     ${ODOO_URL_DB}     http://${SERVER}:${ODOO_PORT}
    ${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin    260
	log to console	 ${module}
	${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin	68
	log to console	 ${module}
Drop DB
	${drop}=	Drop Db     ${ODOO_URL_DB}	  admin	  ${ODOO_DB}
	log to console	${drop}
Create db
	#url, postgres_superuser_pw, new_DB name, boolean demo_data_loaded, new_db_pw
	${created}=	    Create New Db	${ODOO_URL_DB}	admin	${ODOO_DB}	True	admin   en_EN
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
Test SelectListView
	MainMenuXMLid    base.menu_base_partner
	SubMenuXMLid    sale.menu_sale_quotations
	SelectListView	sale.order		name=SO006
	Button	model=sale.order	button_name=oe_form_button_edit
	Button	model=sale.order	button_name=oe_form_button_save
Create Quotation
    MainMenuXMLid    base.menu_base_partner
	SubMenuXMLid    sale.menu_sale_quotations
	Button	model=sale.order	button_name=oe_list_add
	Many2OneSelect    sale.order	partner_id	Agrolait
	Date	sale.order	date_order	12/21/2017 10:35:00
	Char	sale.order	client_order_ref	Hello Test
	NewOne2Many    sale.order	order_line
	Many2OneSelect    sale.order.line	product_id	mac
	NewOne2Many    sale.order	order_line
	Many2OneSelect    sale.order.line	product_id	[A1090] iMac
	NotebookPage    Other Information
Save and cancel Quotation
	Button	model=sale.order	button_name=oe_form_button_save
	Button	model=sale.order	button_name=cancel
Confirm SO
	Button	model=sale.order	button_name=copy_quotation
	Button	model=sale.order	button_name=action_button_confirm
Create Invoice
	Button	model=sale.order	button_name=356
	Select-Option	sale.advance.payment.inv	advance_payment_method	"all"
	Button	model=sale.advance.payment.inv	button_name=create_invoices
	Button	model=account.invoice	button_name=invoice_open
	Button	model=account.invoice	button_name=invoice_pay_customer
	Select-Option	account.voucher	journal_id	17
	Button	model=account.voucher	button_name=button_proforma_voucher
close
    close browser

*** Settings ***

Documentation   Basic test for odoo v8. Every Selenium update should pass it
Resource       odoo_8_0.robot
Library        ExtendedSelenium2Library
Library        String
Variables      config.py
Library        connection_erp.py


*** Test Cases ***
Create Variables
    Set Global Variable     ${ODOO_URL_DB}     http://${SERVER}:${ODOO_PORT}
    ${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin    260
	log to console	 ${module}
	${module}=	get_module_name	${ODOO_URL_DB}	${ODOO_DB}		admin	admin	74
	log to console	 ${module}
Drop DB
	${drop}=	Drop Db     ${ODOO_URL_DB}	  admin	  ${ODOO_DB}
	log to console	${drop}
Create db
	#url, postgres_superuser_pw, new_DB name, boolean demo_data_loaded, new_db_pw
	${created}=	    Create New Db	${ODOO_URL_DB}	admin	${ODOO_DB}	${True}	admin   en_US
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
Create new User
    MainMenuXMLid    base.menu_base_partner
    SubMenuXMLid    base.menu_partner_form
    sleep   2s
	Button	class=oe_kanban_button_new oe_highlight
	Char	res.partner	name	New customer
	Many2OneSelect    res.partner	parent_id	Agrolait
	Checkbox-Select	res.partner	use_parent_address
	Checkbox-Select	res.partner	use_parent_address
	Char	res.partner	street	69 street
	Char	res.partner	city	London
	Many2OneSelect    res.partner	state_id	California
	Many2OneSelect    res.partner	country_id	United Kingdom
	Char	res.partner	phone	4568275555
	Char	res.partner	mobile	5555346783
	Text	res.partner	comment	internal note
	#NotebookPage    Sales & Purchases
	Many2OneSelect    res.partner	user_id	Administrator
	Date	res.partner	date	09.09.1909
	Checkbox-Select	res.partner	supplier
	Button	model=res.partner	button_name=oe_form_button_save
Test SelectListView
	MainMenuXMLid    base.menu_base_partner
	SubMenuXMLid    sale.menu_sale_quotations
	SelectListView	sale.order		name=SO006
	Button	model=sale.order	button_name=oe_form_button_edit
	Button	model=sale.order	button_name=oe_form_button_save
Create Quotation
    MainMenuXMLid    base.menu_base_partner
	SubMenuXMLid    sale.menu_sale_quotations
	sleep   2s
	Button	model=sale.order	button_name=oe_list_add
	Many2OneSelect    sale.order	partner_id	Agrolait
	Date	sale.order	date_order	12/21/2017 10:35:00
	Char	sale.order	client_order_ref	Hello Test
Order line
	NewOne2Many    sale.order	order_line
	sleep   1s
	X2Many-Many2OneSelect    sale.order.line	product_id  iPod
Second Order Line
	NewOne2Many    sale.order	order_line
	X2Many-Many2OneSelect    sale.order.line	product_id	iMac
	NotebookPage    Other Information
Save and cancel Quotation
	Button	model=sale.order	button_name=oe_form_button_save
	Button	model=sale.order	button_name=cancel
Quotation
    MainMenuXMLid    base.menu_base_partner
	SubMenuXMLid    sale.menu_sale_quotations
	sleep   2s
	Button	model=sale.order	button_name=oe_list_add
	Many2OneSelect    sale.order	partner_id	Agrolait
	Date	sale.order	date_order	12/21/2017 10:35:00
	Char	sale.order	client_order_ref	Hello Test
	NewOne2Many    sale.order	order_line
	sleep   1s
	X2Many-Many2OneSelect    sale.order.line	product_id  iPod
	NewOne2Many    sale.order	order_line
	X2Many-Many2OneSelect    sale.order.line	product_id	iMac
	NotebookPage    Other Information
    Button	model=sale.order	button_name=oe_form_button_save
Confirm SO
	Button	model=sale.order	button_name=action_button_confirm
Create Invoice
	Button	class=oe_button oe_form_button oe_highlight
	#Select-Option	sale.advance.payment.inv	advance_payment_method	"all"
	Button	model=sale.advance.payment.inv	button_name=create_invoices
	Button	model=account.invoice	button_name=invoice_open
	Button	model=account.invoice	button_name=invoice_pay_customer
	Select-Option	account.voucher	journal_id	Cash Journal - (test) (EUR)
	Button	model=account.voucher	button_name=button_proforma_voucher

close
    close browser

*** Settings ***

Documentation  Test of all elements in OpenERP
Resource       odoo_9_0_EE.robot
Library        Selenium2Library
Variables      config.py

Suite Setup      Run Keywords	Set Up

*** Test Cases ***
Valid Login
	Login		admin	admin	demo

Main Menu
    MainMenuXMLid    base.menu_base_partner
    Capture Page Screenshot

Sub menu
	SubMenuXMLid    base.menu_sales
	Capture Page Screenshot

Sub Sub Menu
	SubSubMenuXMLid    sale.menu_sale_order
	Capture Page Screenshot

ChangeView
	ChangeView	graph
	Capture Page Screenshot
	ChangeView      list
    Capture Page Screenshot

Create
	Button		sale.order  oe_list_add
    Capture Page Screenshot
	Many2OneSelect	sale.order	partner_id	Agrolait, Thomas Passot
	Date		sale.order	validity_date	07/30/2013
	Char		sale.order	client_order_ref	Hallo Welt

AddOne2Many
	NewOne2Many     sale.order    order_line
    Capture Page Screenshot

CreateOrderLine
	X2Many-Many2OneSelect	sale.order.line    product_id    Flugticket
	X2Many-Char    sale.order.line    product_uom_qty    15
    X2Many-Char	sale.order.line    price_unit    213
    Button         sale.order    oe_form_button_save
    Capture Page Screenshot


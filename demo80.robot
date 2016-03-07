*** Settings ***

Documentation  Test of all elements in OpenERP
Library        DatabaseLibrary
Resource       odoo_8_0.robot

*** Test Cases ***
# make some checks in DB
Check in DB
        DatabaseConnect
        @{queryResults}         Query           select * from res_partner
        Log Many                @{queryResults}
        Check if exists in database             select * from res_partner WHERE name='Agrolait'
        DatabaseDisconnect

Valid Login
	Login		admin	admin	odoo8_selenium

Main Menu
	MainMenu	68
	Capture Page Screenshot
	
SubMenu
	SubMenu		287
	Capture Page Screenshot

ChangeView
	ChangeView	graph
	Capture Page Screenshot
	ChangeView      list
    Capture Page Screenshot

Create
	Button		oe_form_button_create
    Capture Page Screenshot
	Many2OneSelect	sale.order	partner_id	Agrolait, Thomas Passot
	Date		sale.order	date_order	07/30/2013
	Char		sale.order	client_order_ref	Hallo Welt

AddOne2Many
	NewOne2Many     sale.order    order_line
    Capture Page Screenshot

CreateOrderLine
	Many2OneSelect	sale.order.line    product_id    Flugticket
	Char    sale.order.line    product_uom_qty    15
    Char	sale.order.line    price_unit    213
	Button		oe_form_button_save_and_close
    Button          oe_form_button_save
    Capture Page Screenshot

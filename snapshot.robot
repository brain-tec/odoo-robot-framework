*** Settings ***

Documentation  Test to compare screenshot with Percy from Dominik (not working yet)
Resource       odoo_9_0_EE.robot
Library        Selenium2Library
Library        percy_library.py
Variables      config.py

Suite Setup      Run Keywords	Set Up

*** Test Cases ***
percy
    ${percy}=       setup_percy
    set global variable     ${percy}
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
	run_percy       ${percy}    screenshot1


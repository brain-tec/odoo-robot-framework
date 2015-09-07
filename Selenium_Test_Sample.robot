*** Settings ***

Documentation  Test of all elements in OpenERP
Library        DatabaseLibrary
Resource       odoo_8_0.robot
Variables      config_80.py

*** Test Cases ***
Valid Login

	Login

This is my test

	MainMenu	378
	SubMenu		380

Entering Courses: form and list

 	ChangeView 	form
	ChangeView 	list
	ChangeView 	form

Creating a new course

	Button	openacademy.course	oe_form_button_create

Filling up the form prior to store

	MainWindowInput	Course_Selenium1	Text with description
	Many2OneSelect	openacademy.course	responsible	Administrator

Saving now

	Button	openacademy.course	oe_form_button_save	

Returning to list view

 	ChangeView 	list



Entering Sessions: form, list, calendar and gantt

	SubMenu	381
 	ChangeView	form
	ChangeView	list
	ChangeView	calendar
        ChangeView	gantt
        ChangeView	form

Creating a new session

	Button	openacademy.session	oe_form_button_create

Filling up the form prior to store

	WriteInField	openacademy.session	name	Session_Selenium1
	WriteInField	openacademy.session	description	Hi, I'm here to describe the Selenium1 session

Saving now

	Button	openacademy.session	oe_form_button_save

Returning to list view

 	ChangeView 	list

*** Settings ***

Documentation  Common keywords for OpenERP tests
Resource       odoo_8_0.robot
Resource       odoo_EBev.robot
Library     Selenium2Library
Library     String
Variables   ${CONFIG}
Library     connection_erp.py

*** Test Cases ***
Create db
	#url, postgres_superuser_pw, new_DB name, boolean demo_data_loaded, new_db_pw
	${created}=	Create New Db	http://localhost:8069	admin	test_create_db	True	admin
	log to console	${created}
	Run Keyword Unless	${created}	Fail
Install module
	#url, DB_name, db_pw, module_name
	${module_installed}=	Install Module	http://localhost:8069	test_create_db	admin	l10n_ch
	log to console	${module_installed}
	Run Keyword Unless	${module_installed}	Fail
Valid Login
	Login     user=admin    password=admin
	sleep	10s
	#Close Browser
uninstall
	${module_uninstalled}=	Uninstall Module	http://localhost:8069	test_create_db	admin	l10n_ch
	log to console	${module_uninstalled}
	Run Keyword Unless	${module_uninstalled}	Fail

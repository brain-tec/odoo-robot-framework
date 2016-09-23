*** Settings ***

Documentation  Common keywords for OpenERP tests
Resource       odoo_9_0_EE.robot
Library     Selenium2Library
Library     String
Variables      config_80.py
Library      connection_erp.py

*** Test Cases ***
Drop DB
	${drop}=	Drop Db	http://localhost:8069	admin	${ODOO_DB}
	log to console	${drop}
Create db
	sleep	10s
	#url, postgres_superuser_pw, new_DB name, boolean demo_data_loaded, new_db_pw
	${created}=	Create New Db	http://localhost:8069	admin	${ODOO_DB}	True	admin   de_DE
	log to console	${created}
	Run Keyword Unless	${created}	Fail
Install module
	#url, DB_name, db_pw, module_name
	${module_installed}=	Install Module	http://localhost:8069	${ODOO_DB}	admin	l10n_ch
	log to console	${module_installed}
	Run Keyword Unless	${module_installed}	Fail
Valid Login
	Login     user=admin    password=admin
	sleep	10s
	#Close Browser
*uninstall*
	${module_uninstalled}=	Uninstall Module	http://localhost:8069	${ODOO_DB}	admin	l10n_ch
	log to console	${module_uninstalled}
	Run Keyword Unless	${module_uninstalled}	Fail
Install second module
	#url, DB_name, db_pw, module_name
	${module_installed}=	Install Module	http://localhost:8069	${ODOO_DB}	admin	crm
	log to console	${module_installed}
	Run Keyword Unless	${module_installed}	Fail
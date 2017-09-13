*** Settings ***

Documentation  Common keywords for OpenERP tests
Resource       odoo_10_0.robot
Library     Selenium2Library
Library     String
Variables      config.py
Library      connection_erp.py

*** Test Cases ***
Create Variables
    Set Global Variable     ${ODOO_URL_DB}     http://${SERVER}:${ODOO_PORT}
Drop DB
	${drop}=	Drop Db	${ODOO_URL_DB}	admin	${ODOO_DB}
	log to console	${drop}
Create db
	sleep	10s
	#url, postgres_superuser_pw, new_DB name, boolean demo_data_loaded, new_db_pw
	${created}=	Create New Db	${ODOO_URL_DB}	admin	${ODOO_DB}	True	admin   en_EN
	log to console	${created}
	Run Keyword Unless	${created}	Fail
Install module
	#url, DB_name, db_pw, module_name
	${module_installed}=	Install Module	${ODOO_URL_DB}	${ODOO_DB}	admin	crm
	log to console	${module_installed}
	Run Keyword Unless	${module_installed}	Fail
Valid Login
	Login     user=admin    password=admin
	sleep	10s
	#Close Browser
uninstall
	${module_uninstalled}=	Uninstall Module	${ODOO_URL_DB}	${ODOO_DB}	admin	l10n_ch
	log to console	${module_uninstalled}
	Run Keyword Unless	${module_uninstalled}	Fail
Install second module
	#url, DB_name, db_pw, module_name
	${module_installed}=	Install Module	${ODOO_URL_DB}	${ODOO_DB}	admin	crm
	log to console	${module_installed}
	Run Keyword Unless	${module_installed}	Fail
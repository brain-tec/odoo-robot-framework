# -*- coding: utf-8 -*-
##############################################################################
#
#    Copyright (c) 2016 brain-tec AG (http://www.braintec-group.com)
#    All Right Reserved
#
#    See LICENSE file for full licensing details.
##############################################################################
import logging
logger = logging.getLogger(__name__)

try:
    import erppeek
except:
    print "Please install sudo pip install -U erppeek"

def create_new_db(URL, password, name, demo = False, user_password='admin'):
    if (demo == "True" or demo == "u'True" or demo):
        demo = True
    else:
        demo=False
    connection = erppeek.Client(URL)
    db = connection.create_database (password, name, demo ,lang='en_US',user_password=user_password)
    if db==1:
        return True
    return False

def drop_db(URL, password, name):
    connection = erppeek.Client(URL)
    echo="fail"
    try:
        connection.db.drop(password, name)
    except:
        return echo

def install_module(URL, DBname, password, module):
    connection = erppeek.Client(URL, db=DBname, user="admin", password=password, transport=None, verbose=False)
    install = connection.install(module)
    modules_installed = connection.modules(installed=True)
    if module in modules_installed.get('installed', []):
        return True
    return False

def uninstall_module(URL, DBname, password, module):
    connection = erppeek.Client(URL, db=DBname, user="admin", password=password, transport=None, verbose=False)
    uninstall = connection.uninstall(module)
    modules_installed = connection.modules(installed=True)
    if module not in modules_installed.get('installed', []):
        return True
    return False

def get_res_id(URL, DBname, login, password, model, module, name):
    
    connection = erppeek.Client(URL, DBname, login, password, transport=None, verbose=False)
    ir_model_data = connection.model("ir.model.data")
    ir_model_obj = ir_model_data.search([('model','=',model),('module','=',module), ('name','=', name)])
    if not ir_model_obj:
        return False
    
    if not isinstance(ir_model_obj, list):
        ir_model_obj = [ir_model_obj]     
    ir_model_obj = ir_model_data.read(ir_model_obj[0], ["res_id"])
    return ir_model_obj['res_id']

def get_stock(URL, DBname, login, password, model, product_id):
    connection = erppeek.Client(URL, DBname, login, password, transport=None, verbose=False)
    stock = connection.model(model)
    stock_obj = stock.search([('product_id','=', int(product_id))])
    if not stock_obj:
        return [0.0]
    
    if not isinstance(stock_obj, list):
        stock_obj = [stock_obj]     
    #TODO    look for and return qty and location_id for the element on the list
    returnValue = []
    for element in stock_obj:
        stock_aux = stock.read(element, ["qty", "location_id"])
        returnValue.append([stock_aux["qty"], stock_aux['location_id'][0]])
    return returnValue

def get_stock_move(URL, DBname, login, password, model, product_id, variable_name, variable):
    
    connection = erppeek.Client(URL, DBname, login, password, transport=None, verbose=False)
    stock_move = connection.model("stock.move")
    stock_move_obj = stock_move.search([('product_id','=', product_id),(variable_name,'=',variable)])
    if not stock_move_obj:
        return [0.0]
    
    if not isinstance(stock_move_obj, list):
        stock_move_obj = [stock_move_obj]     
    returnValue=[]
    for element in stock_move_obj:
        stock_aux = stock_move.read(element, ["product_uom_qty", "picking_type_id"])
        returnValue.append([stock_aux["product_uom_qty"], stock_aux['picking_type_id']])
    return returnValue

def get_id(URL, DBname, login, password, model, product_tmpl_id):
    
    connection = erppeek.Client(URL, DBname, login, password, transport=None, verbose=False)
    product_product = connection.model(model)
    product_product_obj = product_product.search([("product_tmpl_id","=", int(product_tmpl_id))])
    if not product_product_obj:
        return False
    if not isinstance(product_product_obj, list):
        product_product_obj = [product_product_obj]
    product_product_id = product_product.read(product_product_obj[0], ["id"])
    return product_product_id['id']

def get_menu_res_id(URL, DBname, login, password, module, name):
    return get_res_id(URL, DBname, login, password, model= 'ir.ui.menu', module=module, name=name)
'''
def create_db():
    return create_new_db("http://localhost:8069","admin","test_create_db",False,"admin")
def install():
    install_module("http://localhost:8069", "test_create_db", "admin", "l10n_ch")
'''

   # get_menu_res_id('http://localhost:8069', 'test_create_db', 'admin', 'admin', 'base', 'menu_administration')
    
    
    
    
    
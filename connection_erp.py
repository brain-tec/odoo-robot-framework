# -*- coding: utf-8 -*-
##############################################################################
#
#    Copyright (c) 2016 brain-tec AG (http://www.braintec-group.com)
#    All Right Reserved
#
#    See LICENSE file for full licensing details.
##############################################################################
import logging
import string
logger = logging.getLogger(__name__)
__version__ = '1.6.3'

try:
    import erppeek
except:
    logger.warning("Please install sudo pip install -U erppeek")

#Decorator to convert the arguments from Robot Framework into UTF-8, as far as they are often Unicode
def to_utf8(f):
    def converter(*args, **kwargs):
        arguments = map(lambda x: x.encode('utf-8'), args)
        return f(*arguments, **kwargs)
    return converter

#Depending on the date format, it returns the Day
def return_day (date):
    date_str=str (date)
    if date_str.find('.')>=0:
        #logger.error("{0}".format("."))
        days = date_str.split('.')
        day = days[0]
    else:
        #logger.error("{0}".format("/"))
        days = date_str.split('/')
        day = days[1]
    return int(day)


@to_utf8
def create_new_db(server, password, name, demo = False, user_password='admin', lang='de_DE'):
    connection = erppeek.Client(server)
    if demo == "True" or demo == "u'True" or demo==True:
        demo = True
    else:
        demo = False

    db = connection.create_database (password, name, demo, lang, user_password=user_password)
    if db == 1:
        return True
    return False

@to_utf8
def drop_db(server, password, name):
    connection = erppeek.Client(server)
    echo = "fail"
    try:
        connection.db.drop(password, name)
    except:
        return echo

@to_utf8
def install_module(server, db, password, module):
    connection = erppeek.Client(server, db=db, user="admin",
                                password=password, transport=None,
                                verbose=False)
    connection.install(module)
    modules_installed = connection.modules(installed=True)
    if module in modules_installed.get('installed', []):
        return True
    return False

@to_utf8
def upgrade_module(server, db, password, module):
    connection = erppeek.Client(server, db=db, user="admin",
                                password=password, transport=None,
                                verbose=False)
    connection.upgrade(module)
    return True

@to_utf8
def module_is_installed(server, db, password, module):
    connection = erppeek.Client(server, db=db, user="admin",
                                password=password, transport=None,
                                verbose=False)
    modules_installed = connection.modules(installed=True)
    return module in modules_installed.get('installed', [])


@to_utf8
def uninstall_module(server, db, password, module):
    connection = erppeek.Client(server, db=db, user="admin",
                                password=password, transport=None,
                                verbose=False)
    connection.uninstall(module)
    modules_installed = connection.modules(installed=True)
    if module not in modules_installed.get('installed', []):
        return True
    return False

@to_utf8
def get_res_id(server, db, user, password, model, module, name):
    connection = erppeek.Client(server, db,
                                user, password, transport=None, verbose=False)
    ir_model_data = connection.model("ir.model.data")
    ir_model_obj = ir_model_data.search([('model', '=', model),
                                         ('module', '=', module),
                                         ('name', '=', name)])
    if not ir_model_obj:
        return False
    if not isinstance(ir_model_obj, list):
        ir_model_obj = [ir_model_obj]
    ir_model_obj = ir_model_data.read(ir_model_obj[0], ["res_id"])
    return ir_model_obj['res_id']

@to_utf8
def get_module_name(server, db, user, password, res_id):
    connection = erppeek.Client(server, db,
                                user, password,
                                transport=None, verbose=False)
    ir_model_data = connection.model("ir.model.data")
    ir_model_obj = ir_model_data.search([('model', '=', 'ir.ui.menu'),
                                         ('res_id', '=', res_id)])
    if not ir_model_obj:
        return False
    ir_model_obj_name = ir_model_data.read(ir_model_obj[0], ["name"])
    ir_model_obj_module = ir_model_data.read(ir_model_obj[0], ["module"])
    return ir_model_obj_module['module'], ir_model_obj_name['name']

@to_utf8
def get_stock(server, db, user, password, model, product_id):
    connection = erppeek.Client(server, db,
                                user, password, transport=None, verbose=False)
    stock = connection.model(model)
    stock_obj = stock.search([('product_id', '=', int(product_id))])
    if not stock_obj:
        return [0.0]

    if not isinstance(stock_obj, list):
        stock_obj = [stock_obj]
#  TODO    look for and return qty and location_id for the element on the list
    returnValue = []
    for element in stock_obj:
        stock_aux = stock.read(element, ["qty", "location_id"])
        returnValue.append([stock_aux["qty"], stock_aux['location_id'][0]])
    return returnValue

@to_utf8
def get_stock_move(server, db,
                   user, password,
                   model, product_id, variable_name, variable):
    connection = erppeek.Client(server, db,
                                user, password,
                                transport=None, verbose=False)
    stock_move = connection.model("stock.move")
    stock_move_obj = stock_move.search([('product_id', '=', product_id),
                                        (variable_name, '=', variable)])
    if not stock_move_obj:
        return [0.0]
    if not isinstance(stock_move_obj, list):
        stock_move_obj = [stock_move_obj]
    returnValue = []
    for element in stock_move_obj:
        stock_aux = stock_move.read(element, ["product_uom_qty",
                                              "picking_type_id"])
        returnValue.append([stock_aux["product_uom_qty"],
                            stock_aux['picking_type_id']])
    return returnValue

@to_utf8
def browse(server, db, user, password, name, model, desired):
    connection = erppeek.Client(server, db,
                                user, password,
                                transport=None, verbose=False)
    Element = connection.model(model)
    Element_name = Element.search([('name', '=', name)])
    if not Element_name:
        Element_name = Element.search([('name_template', '=', name)])
    if not Element_name:
        return False
    if not isinstance(Element_name, list):
        Element_name = [Element_name]
    Element_data = Element.read(Element_name[0], [desired])
    return Element_data[desired]

@to_utf8
def get_id(server, db, user, password, model, product_tmpl_id):
    connection = erppeek.Client(server, db,
                                user, password,
                                transport=None, verbose=False)
    product_product = connection.model(model)
    product_product_obj = product_product.search([("product_tmpl_id",
                                                   "=",
                                                   int(product_tmpl_id))])
    if not product_product_obj:
        return False
    if not isinstance(product_product_obj, list):
        product_product_obj = [product_product_obj]
    product_product_id = product_product.read(product_product_obj[0], ["id"])
    return product_product_id['id']

@to_utf8
def get_menu_res_id(server, db, user, password, module, name):
    return get_res_id(server, db,
		      user, password,
		      model= 'ir.ui.menu', module=module, name=name)

@to_utf8
def get_button_res_id(server, db, user, password, model, module, name):
    return get_res_id(server, db, 
		      user, password,
		      model=model, module=module, name=name)
'''
def create_db():
    return create_new_db("http://localhost:8069",
                        "admin","test_create_db",False,"admin")
def install():
    install_module("http://localhost:8069",
                   "test_create_db", "admin", "l10n_ch")
'''


#    get_menu_res_id('http://localhost:8069',
# 'test_create_db', 'admin', 'admin', 'base', 'menu_administration')

import sys
if __name__ == "__main__":
    print "Try connection"
    connection = erppeek.Client(server="http://localhost:12004", db="34529-399-861d2c-all",
                                user="admin", password="admin", verbose=True
                                )
    print "Get model"
    Element = connection.model('res.users')
    Element_name = Element.search([('id', '=', 1)])
    print "Found"


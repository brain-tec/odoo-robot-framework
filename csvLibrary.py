# -*- coding: utf-8 -*-
##############################################################################
#
#    Copyright (c) 2016 brain-tec AG (http://www.braintec-group.com)
#    All Right Reserved
#
#    See LICENSE file for full licensing details.
##############################################################################
import csv


class csvLibrary(object):

    def read_csv_file(self, filename):
        '''
        This keyword takes one argument, which is a path to a .csv file. It
        returns a list of the first data row.
        We always consider the row 0 with labels.
        '''
        data = []
        with open(filename, 'rb') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                data.append(row)
        if len(data) <= 1:
            return []
        return data[1:][0]

    def read_csv_dict(self, filename):
        '''
        This keyword takes one argument, which is a path to a .csv file. It
        returns a list of the first data row.
        We always consider the row 0 with labels.
        '''
        data = []
        with open(filename, 'rb') as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                data.append(row)
        return data

''' def utf_8_encoder(self, unicode_csv_data):
        for line in unicode_csv_data:
            yield line.encode('utf-8')'''


def test():
    t = csvLibrary()
    print "Reading CSV ..."
    print t.read_csv_file('test_els_005_read_csv.csv')

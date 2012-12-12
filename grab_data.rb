#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# http://www.servicesalapersonne.gouv.fr/repertoire-national-des-organismes-%281701%29.cml?
# Les services à la famille pour Jobenfance
require 'yaml'
require 'rubygems'
require 'mechanize'
require 'hpricot'
require 'rexml/document'
require 'iconv'
require 'logger'
require 'fileutils'
require 'axlsx'
require './my_grabber.rb'

@@logger = Logger.new('out.log')

grabber = Grabber.new(false)
data    = grabber.grab

# puts grabber.selService1_h[data[0]['srvc_code']]
# puts data[100]

prospects = Array.new
i = 0
puts "NOM;ADDRESSE;TEL;MAIL;CONTACT;FAX;URL;SRVC_NAME;SRVC_CODE;DEP"
Find.find('data').each do |f| 
  if f =~ /.data$/
    (srvc_code, dep) = f.split('/')[1..-2]
    # puts '======= ' + f + ' ======='
    prosp = Propect.new(f)
    prosp.srvc_code = srvc_code
    prosp.srvc_name = '"' + grabber.selService1_h[srvc_code.to_i] + '"'
    prosp.dep       = dep
    # prospects << prosp
    puts prosp.to_csv
    # break if i > 10
    # i += 1
  end
end
# xlsfilename = 'data.xls'
# xls_builder = XlsBuilder.new(xlsfilename)
# xls_builder.build(prospects)






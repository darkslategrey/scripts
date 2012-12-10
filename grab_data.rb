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
require 'my_grabber.rb'

@@logger = Logger.new(STDOUT)

grabber = Grabber.new(false)
data    = grabber.grab

# pp data


# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


selService1_h = { 18 => "Assistance aux personnes âgées",
  24 => "Garde-malade, sauf soins",
  25 => "Aide mobilité et transport de personnes",
  26 => "Conduite du véhicule personnel",
  29 => "Accompagnement hors domicile PA et/ou PH",
  22 => "Assistance aux personnes handicapées",
  23 => "Interprète en langue des signes",
  32 => "Soins et promenades d'animaux de compagnie",
  33 => "Soins esthétiques",
  39 => "Soins esthétiques",
  12 => "Garde d'enfant -3 ans à domicile",
  6  => "Garde d'enfant +3 ans à domicile",
  27 => "Accompagnement/déplacement enfants -3 ans",
  28 => "Accomp./déplacement enfants +3 ans",
  19 => "Soutien scolaire à domicile",
  20 => "Cours particuliers à domicile",
  31 => "Assistance informatique à domicile",
  35 => "Assistance administrative à domicile" }

selService1_h.each_pair do |k, v|
  Service.create(code: k, libelle: v)
end

File.open('new_data.csv', 'r').each do |l|
  params = l.gsub(/"/, '').split(';')
  Prospect.create(addr: params[1], contact: params[4],  departement: params[9],  
                  fax: params[5], mail: params[3], name: params[0], srvc_code: params[7],
                  srvc_name: params[8], tel: params[2])
end



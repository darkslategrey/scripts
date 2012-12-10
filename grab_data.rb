#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# http://www.servicesalapersonne.gouv.fr/repertoire-national-des-organismes-%281701%29.cml?
# Les services à la famille pour Jobenfance
require 'rubygems'
require 'mechanize'
require 'hpricot'
require 'rexml/document'
require 'iconv'
require 'logger'




class Recherche
  attr_accessor :query, :result, :selService1, :selService2, :txtLieux


  def initialize(selService1, txtLieux)
    self.result      = Array.new    
    self.selService1 = selService1
    self.txtLieux    = txtLieux
    @@agent = Mechanize.new
  end

  def launch
    page = @@agent.post('https://nova.servicesalapersonne.gouv.fr/extranet/rechercheV2/resultats.php', 
                      { 'btRechercher' =>  1,
                        'selService1' => self.selService1,
                        'selService2' => '',
                        'txtLieu' => self.txtLieux,
                        'txtNom' => '',
                        'rbCAE' => 0,
                        'rbCesu' => 0,
                        'btRechercher' => '1' 
                      })
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    valid_string = ic.iconv(page.body.to_s)
    puts valid_string

    doc = Hpricot(valid_string)
    (doc/'//td[@class="lienOrganisme"]').each do |lo|
      puts lo
    end

  end

  def to_s
    "query: #{self.query}" + "\nresult: #{self.result}"
  end
  
end
  



class Grabber

  attr_accessor :recherches

  def initialize
    self.recherches = Array.new
    @@logger = Logger.new(STDOUT)
  end


  def grab
    selService1_h  = { 18 => "Assistance aux personnes âgées",
      24 => "Garde-malade, sauf soins",
      25 => "Aide mobilité et transport de personnes",
      26 => "Conduite du véhicule personnel",
      29 => "Accompagnement hors domicile PA et/ou PH",
      22 => "Assistance aux personnes handicapées",
      23 => "Interprète en langue des signes",
      32 => "Soins et promenades d'animaux de compagnie",
      33 => "Soins esthétiques",
      39 => "Soins esthétiques" }
    selService2_h = { 12 => "Garde d'enfant -3 ans à domicile",
      6 => "Garde d'enfant +3 ans à domicile",
      27 => "Accompagnement/déplacement enfants -3 ans",
      28 => "Accomp./déplacement enfants +3 ans",
      19 => "Soutien scolaire à domicile",
      20 => "Cours particuliers à domicile",
      31 => "Assistance informatique à domicile",
      35 => "Assistance administrative à domicile" }

    selService1_h.each_pair { |k,v| 
      @@logger.info("Launch search for <#{v}>")
      recherche = Recherche.new(k, 75018)
      recherche.launch
      break
    }
  end


end

se_url = 'https://nova.servicesalapersonne.gouv.fr/extranet/rechercheV2/resultats.php'



grabber = Grabber.new
grabber.grab


# agent = Mechanize.new

# selService1 = 1
# selService2 = 2
# txtLieux    = 75018



# page = agent.post('https://nova.servicesalapersonne.gouv.fr/extranet/rechercheV2/resultats.php', 
#                    { 'btRechercher' =>  1,
#                      'selService1' => 18,
#                      'selService2' => 24,
#                      'txtLieu' => '75018',
#                      'txtNom' => '',
#                      'rbCAE' => 0,
#                      'rbCesu' => 0,
#                      'btRechercher' => '1' 
#                    })

# # puts page.body

# ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
# valid_string = ic.iconv(page.body.to_s)

# page = REXML::Document.new(valid_string.gsub(/&/, '&amp;'))
# puts REXML::XPath.match(page, '//aquarium')
# REXML::XPath.match(page, '//td[@class="lienOrganisme"]/a').each { |org| 
#   puts "##########"
#   detail = agent.get('https://nova.servicesalapersonne.gouv.fr/extranet/rechercheV2/' + org.attribute('href').to_s)
#   valid_string = ic.iconv(detail.body.to_s)
#   doc = Hpricot(valid_string)
#   libelle     = '==='+doc.search('//div[@id="centreTitreHautGauche"]/text()').to_s.strip+'===='
#   address = (doc/"#contactColonne1").inner_html.strip
#   puts '===='+doc.search('//div[@id="contactColonne2"]/text()').to_s.strip+'===='
#   puts '===='+doc.search('//div[@id="contactColonne2"]/span/span/text()').to_s.strip+'===='
#   break
# }


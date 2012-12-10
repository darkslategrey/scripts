# -*- coding: utf-8 -*-


  class Grabber

    attr_accessor :recherches, :data_file, :dev

    def initialize(dev=false)
      self.recherches = Array.new
      self.data_file = 'data.yaml'
      self.dev = dev
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
        39 => "Soins esthétiques",
        12 => "Garde d'enfant -3 ans à domicile",
        6  => "Garde d'enfant +3 ans à domicile",
        27 => "Accompagnement/déplacement enfants -3 ans",
        28 => "Accomp./déplacement enfants +3 ans",
        19 => "Soutien scolaire à domicile",
        20 => "Cours particuliers à domicile",
        31 => "Assistance informatique à domicile",
        35 => "Assistance administrative à domicile" }

      if(File.file? data_file) 
        @@logger.info("Load data from #{data_file}")
        data = YAML::load(File.open(data_file, 'rb').read)
      else
        data = Array.new
        
        lieu = 1000
        limit = 99000
        lieu = 75000 if self.dev
        limit = 75000 if self.dev

        while lieu <= limit
          selService1_h.each_pair { |k,v| 
            @@logger.info("Launch search for <#{v}> in <#{lieu}>")
            seek = Recherche.new(k, v, lieu, './page.html', self.dev)
            main_data = { 
              'srvc_code' => k,
              'srvc_name' => v, 
              'lieu'      => lieu,
              'details' => seek.launch
            }
            data << main_data
            break if self.dev
          }
          lieu += 1000
        end
        serialized_data = YAML::dump(data)
        File.open(data_file, 'w').write(serialized_data)
      end
      data
    end
  end


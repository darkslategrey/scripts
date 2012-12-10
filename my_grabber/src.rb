
  class SrcBase
    attr_accessor :valid_string, :urls, :base_url



    def initialize(srvc_code, srvc_name, txtLieux)
      self.urls = Array.new
      self.valid_string = Array.new
      self.base_url     = 'https://nova.servicesalapersonne.gouv.fr/extranet/rechercheV2'
      @@agent           = Mechanize.new
      @@srvc_code       = srvc_code
      @@srvc_name       = srvc_name
      @@txtLieux        = txtLieux
    end

    def set_links
      self.valid_string.each do |vs| 
        doc = Hpricot(vs)
        (doc/'//td[@class="lienOrganisme"]/a').each do |lo|
          self.urls << self.base_url + '/' + lo.attributes['href']
        end
      end
    end

    def conv(string)
      Iconv.new('UTF-8//IGNORE', 'UTF-8').iconv(string)    
    end
    
    def get_details
      set_links
      details = Array.new
      i = 1
      self.urls.each do |url|
        @@logger.info("Url <#{url}")
        result = Result.new(conv(@@agent.get(url).body.to_s.strip), url.strip, '',
                            @@srvc_code, @@txtLieux, i)
        i += 1
        details << result
      end
      details
    end

  end


  class SrcPage < SrcBase

    def initialize(filename, srv_code, srv_name, txtLieux) 
      super(srv_code, srv_name, txtLieux)
      @@logger.info("SrcPage init")

      file = File.open(filename, "rb")
      self.valid_string = conv(file.read)
    end

  end

  class SrcNet < SrcBase

    def initialize(srv_code, srv_name, txtLieux)
      super(srv_code, srv_name, txtLieux)
      @@logger.info("SrcNet init")
      @@srvc_code  = srv_code
      @@srvc_name  = srv_name
      @@txtLieux  = txtLieux
      get_page
    end

    def get_page
      lieu = @@txtLieux < 10000 ? '0'+@@txtLieux.to_s : @@txtLieux.to_s
      @@logger.info("Get page for #{@@srvc_code} lieu #{lieu}")
      page = @@agent.post(self.base_url + '/resultats.php', 
                          { 'btRechercher' =>  1,
                            'selService1' => @@srvc_code,
                            'selService2' => '',
                            'txtLieu' => lieu,
                            'txtNom' => '',
                            'rbCAE' => 0,
                            'rbCesu' => 0,
                            'btRechercher' => '1' 
                          })
      self.valid_string << conv(page.body.to_s)
      temp_cookie = @@agent.cookie_jar
      doc = Hpricot(conv(page.body.to_s))
      liens_page = (doc/'//a[@class="lienPage"]')
      @@logger.info "taille lien #{liens_page.size}"
      if(liens_page.size > 0)
        pages_nbr = liens_page.size
        current_page = 2
        while current_page <= pages_nbr
          @@logger.info("getting page #{current_page}")
          @@agent = Mechanize.new
          @@agent.cookie_jar = temp_cookie
          page = @@agent.get(self.base_url + '/resultats.php?page=' + current_page.to_s)
          self.valid_string << conv(page.body.to_s)
          current_page += 1
        end
      end
    end

  end


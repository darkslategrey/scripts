#!/usr/bin/env ruby

require 'hpricot'
require 'find'
require 'htmlentities'

class Propect
  attr_accessor :tel, :entity_name, :mail, :contact, :fax, :url, :extractor, :addr,
  :srvc_code, :srvc_name, :dep
  
  def initialize(filename)
    self.extractor = Extractor.new(filename)
    self.tel = extractor.extract_tel
    self.entity_name = extractor.extract_name
    self.mail = extractor.extract_mail
    self.contact = extractor.extract_contact
    self.fax = extractor.extract_fax
    self.url = extractor.extract_url
    self.addr = extractor.extract_addr
  end

  def to_s
    "entity_name\t<#{self.entity_name}>\n" +
      "addr\t<#{self.addr}>\n" +
      "tel\t<#{self.tel}>\n" +
      "mail\t<#{self.mail}>\n" +
      "contact\t<#{self.contact}>\n" +
      "fax\t<#{self.fax}>\n" +
      "url\t<#{self.url}>\n" +
      "srvc_code\t<#{self.srvc_code}>\n" +
      "srvc_name\t<#{self.srvc_name}>\n" +
      "dep\t<#{self.dep}>\n"

  end

  def to_csv
    "#{self.entity_name};#{self.addr};#{self.tel};#{self.mail};#{self.contact};#{self.fax};#{self.url};" +
      "#{self.srvc_name};#{self.srvc_code};#{self.dep}"
  end

end


class Extractor
  
  def initialize(filename)
    @doc = Hpricot(File.open(filename, 'rb').read)
    @ent_decoder = HTMLEntities.new
  end

  def extract_name
    entity_name = ''
    (@doc/'//div[@id="centreTitreHautGauche"]').each do |e|
      entity_name = e.innerText.strip
    end
    '"' + @ent_decoder.decode(entity_name) + '"'
  end

  def extract_addr
    addr = ''
    (@doc/'//div[@id="contact"]').each do |e|
      addr = e.get_element_by_id('contactColonne1').inner_html.strip
    end
    '"' + @ent_decoder.decode(addr.gsub(/<br \/>/, "\n").gsub(/<.*$/m, '').strip) + '"'
  end

  def extract_tel
    tel = ''
    (@doc/'//div[@id="contact"]').each do |e|
      (e.get_element_by_id('contactColonne1')/'//span[@class="txtRose12Gras"]').each do |cc|
        tel = cc.innerText.strip
      end
    end
    '"' + tel + '"'
  end

  def extract_mail
    mail = ''
    (@doc/'//div[@id="contact"]').each do |e|
      (e.get_element_by_id('contactColonne2')/'//span[@class="txtRose12"]/a').each do |cc|
        mail = cc.get_attribute('href').sub(/^mailto:/, '')
      end
    end
    '"' + mail + '"'

  end

  def extract_contact
    contact = ''
    (@doc/'//div[@id="contact"]').each do |e|
      (e.get_element_by_id('contactColonne2')/'//span[@class="txtRose12"]/a').each do |cc|
        contact = cc.innerText
      end
    end
    '"' + @ent_decoder.decode(contact) + '"'
  end

  def extract_fax
    fax = ''
    (@doc/'//div[@id="contact"]').each do |e|
      (e.get_element_by_id('contactColonne2')/'//img[@src="img/icone_fax.jpg"]').each do |cc|
        fax = cc.next_sibling.innerText.strip
      end
    end
    '"' + fax + '"'
  end

  def extract_url
    url = ''
    (@doc/'//div[@id="plusDInfoColonne1"]//img[@src="img/icone_url.jpg"]').each do |e|
      url = e.next_sibling.attributes['href']
    end
    '"' + url + '"'
  end

end



# puts "url <#{url}>\nentity <#{entity_name}>\ntel <#{tel}>\nmail <#{mail}>\nnom_contact <#{nom_contact}>\nfax <#{fax}>"







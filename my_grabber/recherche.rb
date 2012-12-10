
require 'my_grabber/src.rb'

class Recherche
  attr_accessor :query, :results, :src

  def initialize(srv_code, srv_name, txtLieux, filename='', dev=false)
    if filename.length > 0 and File.file?(filename)
      self.src = SrcPage.new(filename, srv_code, srv_name, txtLieux)
    else
      self.src = SrcNet.new(srv_code, srv_name, txtLieux)
    end
  end

  def launch
    src.get_details
  end

  def to_s
    "query: #{self.query}" + "\nresult: #{self.results}"
  end
  
end



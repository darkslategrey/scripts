  class Result
    attr_accessor :content, :url, :name

    def initialize(content, url, name, code, lieux, n)
      self.to_file(code, lieux, n, content)
      self.content = "#{code.to_s}/#{lieux.to_s}/file_#{n}.data"
      self.url     = url
      self.name    = name 
    end

    def to_file(code, lieux, n, content)
      FileUtils.mkdir_p "data/#{code.to_s}/#{lieux.to_s}"
      File.open("data/#{code.to_s}/#{lieux.to_s}/file_#{n}.data", "w").write(content)
    end

    def to_s 
      # "content: \n\t\t#{self.content}\n" + 
      "url:\t@@@@@#{self.url}@@@@@\n" + 
        "name:\t@@@@@#{self.name}@@@@@\n"
    end
  end



class Source 

    def initialize(id, url, title)
		  @id = id
        @url = url
        @title = title
    end

    def getUrl
        return @url
    end

    def getId
		return @id
    end
    
    def getTitle
		return @title
    end
end


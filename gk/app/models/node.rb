class Node 

   def initialize(id, title, content, image_url, post_date)
        @id = id
        @title = title
	@content = content
	@image_url = image_url
	@post_date = post_date
	@sources = Array.new
   end
   
   def getTitle
        return @title
   end
   
   def getImage_Url
        return @image_url
   end

   def getId
        return @id
   end

   def getContent
        return @content
   end

   def getSources
        return @sources
   end

   def getPostDate
        return @post_date
   end

   def addSource(id, source, title)
        @sources.push(Source.new(id, source, title))
   end
end


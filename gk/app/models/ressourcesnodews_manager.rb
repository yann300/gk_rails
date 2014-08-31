
require "rubygems"
require "json"
require "httpclient"

class RessourcesnodewsManager 

   def initialize()       
   end
	
   def getRessourceNodesFrom(sources) 
	connection = self.getSQLConnection()
	hash = Hash.new
		logger = Logger.new(STDOUT)
			logger.info 'test'
		logger.info sources	
	sources.each do |source|
		results = connection.connection.execute("select T2.id, T2.title, T2.content, T2.image_url, T1.id, T1.source, T1.title, DATE(T2.post_date) from (select * FROM focus_has_sources WHERE source='" + source + "') T1 JOIN Focus T2 ON T2.id=T1.id_focus ")
				
		hash = self.computeResults(results, hash)
	end	
		
	return Nodes.new(hash.values)
  end

  def addRessource(content, sources) 
	connection = self.getSQLConnection()
      	results = connection.connection.execute("INSERT INTO Focus (content) VALUES(" + content + ")");
	sources.each do |source|
		connection.execute("INSERT INTO focus_has_sources (id_focus, source) VALUES(" + row[0] + ", " + source + ")");
  	end
  end

  def getLastCreatedRessourceNode(length) 
	connection = self.getSQLConnection()
	logger = Logger.new(STDOUT)
	
	#results = connection.connection.execute("select * from focus_has_sources WHERE id_focus=(select id, content FROM Focus LIMIT " + length.to_s + ")")
	results = connection.connection.execute("select T1.id, T1.title, T1.content,T1.image_url, T2.id, T2.source, T2.title, DATE(T1.post_date) from (select * FROM Focus ORDER BY post_date DESC LIMIT " + length.to_s + ") T1 JOIN focus_has_sources T2 ON T1.id=T2.id_focus ")
	hash = Hash.new
	hash = self.computeResults(results, hash)
	return Nodes.new(hash.values)
  end

  def computeResults(results, hash)
	logger = Logger.new(STDOUT)
	results.each do |row|	
			
		if hash.has_key?(row[0])			
			hash[row[0]].addSource(row[4], row[5], row[6])
		else
			new_node = Node.new(row[0], row[1], row[2], row[3], row[7])
			new_node.addSource(row[4], row[5], row[6])
			hash[row[0]] = new_node
		end
  	end
	return hash
  end

  def getSQLConnection()
	return ActiveRecord::Base.establish_connection(
	:adapter => "mysql2",
	:host => "localhost",
	:database => "global_k",
	:username => "root",
	:password => "azerty"
	)
  end
end



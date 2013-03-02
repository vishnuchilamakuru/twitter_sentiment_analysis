require 'open-uri'

module ReviewHelper
  class TwitterApi
    attr_accessor :query
    
    def initialize(query)
      @query = query
    end     
    
    def get_json_response    
      results = []
      base_url = "http://search.twitter.com/search.json"
      url = "#{base_url}?q=#{@query}"
      results_count = 0

      while (results_count <= 15)
        response = open(url).read
        json_response = JSON.parse(response)

        if json_response["results"].length == 0
          break
        end
        tweets = json_response["results"]
        results_count += tweets.length  
        tweets.each do |tweet|
          #if tweet["text"].force_encoding("UTF-8").ascii_only?
            results << tweet["text"]
          #end
        end

        url = "#{base_url}#{json_response["next_page"]}" 
         
      end
      #puts results.to_json 
      results
    end  

    def get_tweets
      #tweets = []
      #tweets << "greekuveerudu trailers are awesome"
      #tweets << "dandupalyam movie is worst"   
      #tweets 
      get_json_response
    end
 
  end
end

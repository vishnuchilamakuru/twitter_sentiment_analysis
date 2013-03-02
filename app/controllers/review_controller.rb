class ReviewController < ApplicationController
  def index
    if params["query"] != nil
      redirect_to :action => "output",:query => params["query"]
    end
  end

  def output
    #puts params[:query]
    t = ReviewHelper::TwitterApi.new(params[:query])
    tweets = t.get_tweets
    @positive_responses = {}
    @negative_responses = {}
    @neutral_responses = {}

    tweets.each do |tweet|
      #puts Sentimentalizer.analyze(tweet)
      begin
        sentiment_analysis_response = JSON.parse(Sentimentalizer.analyze(tweet))
        #sentiment_analysis_response = {"sentiment" => ":)", "text" => "ok"}
        #puts tweet
        #puts sentiment_analysis_response
        sentiment = sentiment_analysis_response["sentiment"]
        if sentiment.eql?(":(") 
         color_code = "#FFAA70"
         @negative_responses[sentiment_analysis_response["text"]] = color_code
        elsif sentiment.eql?(":)") 
         color_code = "#00FFFF"
         @positive_responses[sentiment_analysis_response["text"]] = color_code
        else 
         color_code = "#FFFFCC"
         @neutral_responses[sentiment_analysis_response["text"]] = color_code
        end
      rescue NoMethodError => e
        puts "Error for tweet #{tweet}"
      end  

      #@responses[sentiment_analysis_response["text"]] = color_code 
    end
    
    @total_responses_length = @positive_responses.length + @negative_responses.length + @neutral_responses.length 
 
  end
end

class UserController < ApplicationController
  def index
    if !session[:user_id].nil?
      @user = User.find(session[:user_id])
    else
      redirect_to '/login'
    end
  end

  def show
    @user = User.find(params[:id])

    wordFound = false
    while (!wordFound)
      preWord = Word.offset(rand(Word.count)).first
      if preWord.difficulty == session[:difficulty]
        @word = preWord
        wordFound = true
      end
    end
    # @word = Word.offset(rand(Word.count)).first
    sting_hash = HTTP.get("http://www.dictionaryapi.com/api/v1/references/collegiate/xml/#{@word.word}?key=489d1a74-a245-4ac9-b764-e21dc6aa513c").to_s
    @word_hash = Hash.from_xml(sting_hash.gsub("\n", ""))
    if @word_hash["entry_list"]["suggestion"] != nil

    elsif @word_hash["entry_list"]["entry"].class != Array && @word_hash["entry_list"]["entry"]["fl"] == "prefix"

    else 
      word = @word_hash["entry_list"]["entry"]
      
      if word.class == Hash
        @definition = word["def"]["dt"]
        if @definition.nil?
          @definiton = "No defintion found"
        end
        wave_file = word["sound"]["wav"]
      elsif word.class == Array

        (0...10).each do |i|
          break if word[i]["sound"].nil?

          wave_file = word[i]["sound"]["wav"]
          @definition = word[i]["def"]["dt"]
          break if wave_file.present?
        end
      end 

      if wave_file.class == String
        @word_audio_url = "http://media.merriam-webster.com/soundc11/#{wave_file[0]}/#{wave_file}"
      else 
          @word_audio_url = "http://media.merriam-webster.com/soundc11/#{wave_file[0][0]}/#{wave_file[0]}"
      end
    end
  end

  def share_score
    @user = User.find(params[:id])
    @authorization = Authorization.find_by(:user_id => params[:id])

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["twitter_app_id"] 
      config.consumer_secret     = ENV["twitter_app_secret"]
      config.access_token        = @authorization[:token]
      config.access_token_secret = @authorization[:secret]
    end
  end 

  def thanks_page
    @user = User.find(params[:id])
  end 

  def update
    if request.xhr?
      user = User.find(params[:id])
      if user.total_score.nil?
        user.total_score = params[:score]
      else
        user.total_score = user.total_score += params[:score].to_i
      end
      if user.words_guessed.nil?
        user.words_guessed = params[:wordCount]
      else
        user.words_guessed = user.words_guessed + params[:wordCount].to_i
      end
      if user.score.nil?
        user.score = params[:averageScore]
      elsif params[:averageScore].to_i >= user.score.to_i 
        user.score = params[:averageScore].to_i
      end
      user.save
    end
    # redirect_to "/user/#{params[:id]}"
    render :json => "awesome!"
  end


  private

  def user_params
    params.require(:user).permit(:name)
  end

end

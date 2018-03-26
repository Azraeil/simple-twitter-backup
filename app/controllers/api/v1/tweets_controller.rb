class Api::V1::TweetsController < ApiController
  def index
    @tweets = Tweet.all
    render json: {
      # 用 data: 排版 JSON 輸出格式
      # 用 map 重新映射一個新的陣列，只留 API 想給 client 的資料
      data: @tweets.map do |tweet|
        {
          id: tweet.id,
          date: tweet.created_at.strftime("%Y-%m-%d"),
          description: tweet.description
        }
      end
    }
  end


  def show
    # 用 find_by 在找不到 tweet 時，回傳 nil
    @tweet = Tweet.find_by(id: params[:id])
    if !@tweet
      render json: {
        message: "Can't find the tweet!",
        status: 400
      }
    else
      render json: {
        id: @tweet.id,
        date: @tweet.created_at.strftime("%Y-%m-%d"),
        description: @tweet.description
      }
    end
  end
end

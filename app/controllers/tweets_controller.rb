class TweetsController < ApplicationController
  before_action :set_tweet, only: [:like, :unlike]

  def index
    # 基於測試規格，必須給定變數名稱，請用此變數中存放關注人數 Top 10 的使用者資料
    @users = User.all.order(followers_count: :desc).limit(2)

    # Tweets：排序依日期，最新的在前
    @tweets = Tweet.all.order(created_at: :desc).limit(10)

    @tweet = Tweet.new
  end

  # 當卷軸到底時觸發 load
  def load
    if params[:current_tweet_id]
      @tweets = Tweet.where( "id < ?", params[:current_tweet_id]).order("id DESC").limit(10)

      render :json => {
        # 用 map method 改寫每一筆 @tweet 資料爲 json 格式
        data: @tweets.map do |tweet|
          # 根據目前使用者是否對該推文有 like 關係
          if current_user.is_liked?(tweet)
            like_url = unlike_tweet_url(tweet.id)
            like_status = true
          else
            like_url = like_tweet_url(tweet.id)
            like_status = false
          end
        {
          :id => tweet.id,
          :description => tweet.description,
          :createDate => tweet.created_at.strftime("%Y-%m-%d"),
          :createTime => tweet.created_at.strftime("%H:%M"),
          :userName => current_user.name,
          :userAvatar => current_user.avatar,
          :userUrl => tweets_user_url(current_user),
          :replyUrl => tweet_replies_url(tweet.id),
          :replyCount => tweet.replies_count,
          :likeUrl => like_url,
          :likeCount => tweet.likes_count,
          :likeStatus => like_status
        }
        end
      }
    end
  end

  # 在首頁新增推文
  def create
    @tweet = Tweet.new(tweet_params)

    # 取得 FK: user_id 的值
    @tweet.user_id = current_user.id

    if @tweet.save
      flash[:notice] = "Tweet was created successfully."
      # redirect_to tweets_path

      # 回傳 JSON 資料給 jQuery ajax
      render :json => {
        :id => @tweet.id,
        :description => @tweet.description,
        :createDate => @tweet.created_at.strftime("%Y-%m-%d"),
        :createTime => @tweet.created_at.strftime("%H:%M"),
        :userName => current_user.name,
        :userAvatar => current_user.avatar,
        :userUrl => tweets_user_url(current_user),
        :replyUrl => tweet_replies_url(@tweet.id),
        :likeUrl => like_tweet_url(@tweet.id)
      }

    else
      flash[:alert] = "Tweet was failed to create."
      redirect_to tweets_path
    end
  end

  # 建立推文喜好記錄 tweets#like
  def like
    # set_tweet

    @like = Like.create!(user_id: current_user.id, tweet_id: @tweet.id)

    redirect_back(fallback_location: tweets_path)
  end

  # 刪除推文喜好記錄 tweets#unlike
  def unlike
    # set_tweet

    like = Like.where(user_id: current_user.id, tweet_id: @tweet.id)

    like.destroy_all
    redirect_back(fallback_location: tweets_path)
  end

  private
  def tweet_params
    params.require(:tweet).permit(:description)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

end

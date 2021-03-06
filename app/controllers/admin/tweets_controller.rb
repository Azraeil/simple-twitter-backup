class Admin::TweetsController < Admin::BaseController
  def index
    @tweets = Tweet.all.order(created_at: :desc)
  end

  def destroy
    @tweet = Tweet.find(params[:id])

    if @tweet.destroy
      flash[:notice] = "Tweet was successfully destroyed."
    else
      flash[:warning] = "Tweet was failed to destroy."
    end

    # redirect_back(fallback_location: admin_root_path)
    # 將指定刪除的 tweet id 用 JSON 格式回傳給前端
    render :json => { :id => @tweet.id }
  end
end

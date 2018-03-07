class Like < ApplicationRecord
  # 喜好記錄屬於使用者
  belongs_to :user, counter_cache

  # 喜好記錄屬於推文
  belongs_to :tweet
end

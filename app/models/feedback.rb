class Feedback < ActiveRecord::Base

      belongs_to :bid
      belongs_to :user

end

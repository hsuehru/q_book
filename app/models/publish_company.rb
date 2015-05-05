class PublishCompany < ActiveRecord::Base
  has_many :author_require_join_publishes
end

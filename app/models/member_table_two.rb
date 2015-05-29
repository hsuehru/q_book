class MemberTableTwo < ActiveRecord::Base
  self.table_name = "member_table_2s"
  has_secure_password
  before_save { self.email = email.downcase }
  before_save { self.web_session_id ||= Digest::SHA1.hexdigest(
    SecureRandom.urlsafe_base64.to_s ) }
  before_save { self.phone_session_id ||= Digest::SHA1.hexdigest(
    SecureRandom.urlsafe_base64.to_s ) }
  validates :email, :presence => true, :length => { :maximum => 100 }
  validates :email, :format => { :with => /\A[^@]+@[^@]+\z/ }
  validates :email, :uniqueness => { :case_sensitive => false }
end

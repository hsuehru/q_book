class Administrator < ActiveRecord::Base
  belongs_to :administrator_type
  has_secure_password
  before_save { self.email = email.downcase }
  before_save { self.web_session_id ||= Digest::SHA1.hexdigest( SecureRandom.urlsafe_base64.to_s ) }
  validates :email, :presence => true, :length => { :maximum => 100 }
  validates :email, :format => { :with => /\A[^@]+@[^@]+\z/ }
  validates :email, :uniqueness => { :case_sensitive => false }

end

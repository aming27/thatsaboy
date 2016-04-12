require "#{Rails.root}/app/controllers/core/interpolations"
# Photo class
# Fields:
#  [Integer]        id
#  [String]         file_file_name
#  [String]         file_content_type
#  [Integer]        file_file_size
#  [DateTime]       file_updated_at
#  [DateTime]       deleted_at
#  [DateTime]       created_at
#  [DateTime]       updated_at
#  [User::User]     user
#  [Object]         file
class Uploaded::Photo < ActiveRecord::Base
  include Core::Deletable
  extend Core::Deletable::ClassMethods

  belongs_to :user, inverse_of: :photos, class_name: 'User::User'

  has_attached_file :file,
                    url: '/images/:hash/:id/image.:extension',
                    path: ENV['UPLOAD_FOLDER'] + '/images/:hash/:id/image.:extension',
                    hash_secret: 'asd1we1478yasdhbjhqbekhjqb',
                    use_timestamp: false

  validates_attachment_presence :file
  validates_attachment_content_type :file, content_type: %r{\Aimage/.*\Z}

  # Generates a photo
  # @param [User::User] user
  # @param [Object] file
  def initialize(user, file)
    super()
    self.user = user
    self.file = file
  end

  # Finds actual photos owned by user
  # @param [User::User] user
  # @return [Uploaded::Photo]
  def self.find_actual_by_user(user)
    where(user: user, deleted_at: nil)
  end
end

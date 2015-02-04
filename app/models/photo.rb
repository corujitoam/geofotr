# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  caption            :string
#  visibility         :string           default("public")
#  latitude           :decimal(10, 6)
#  longitude          :decimal(10, 6)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#
class Photo < ActiveRecord::Base
  validates :visibility, inclusion: { in: %w/public followers private/ }

  belongs_to :user

  def Photo.public_photos
    Photo.where(visibility: "public")
  end

  #photo uploads using paperclip
  has_attached_file :photo, :styles => {
        :big => "600x600>",
        :small => "50x50#"
      }
  validates_attachment_content_type(
    :photo,
    :content_type => /\Aimage\/.*\Z/
  )

  before_post_process :extract_exif

  def extract_exif
    imgfile = EXIFR::JPEG.new(photo.queued_for_write[:original].path)
    return unless imgfile

    self.latitude      = imgfile.gps_latitude.to_f
    self.longitude     = imgfile.gps_longitude.to_f
    #store other attributes later, perhaps?
  end
end

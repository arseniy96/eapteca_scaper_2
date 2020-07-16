class Drug < ApplicationRecord
  mount_uploader :description_file, FileUploader
  mount_uploader :image_file, FileUploader
end

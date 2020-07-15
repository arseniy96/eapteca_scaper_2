class Drug < ApplicationRecord
  mount_uploader :description_file, FileUploader
end

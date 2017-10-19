class Image::ProfileImage < Image::Base
	mount_uploader :image, ProfileImageUploader
end

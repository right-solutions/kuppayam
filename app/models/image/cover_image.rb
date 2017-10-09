class Image::CoverImage < Image::Base
	mount_uploader :image, CoverImageUploader
end

class Image::LogoImage < Image::Base
	mount_uploader :image, LogoImageUploader
end

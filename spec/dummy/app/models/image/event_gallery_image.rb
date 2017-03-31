class Image::EventGalleryImage < Image::Base

	INSTRUCTIONS = [
		"the filename should be in .jpg / .jpeg or .png format",
		"the image dimensions are smaller than 750 pixels by 368 pixels, (Portrait Format). (most cameras and camera phones will produce images bigger than this)",
		"the file size is less than 20 Kb,  or bigger than 5 Mb"
	]

	mount_uploader :image, EventGalleryImageUploader

end
class Image::EventCoverImage < Image::Base

	INSTRUCTIONS = [
		"the filename should be in .jpg / .jpeg or .png format",
		"the image dimensions are smaller than <strong>750 x 368 Pixels</strong>, (Portrait Format). (most cameras and camera phones will produce images bigger than this)",
		"the file size is less than 20 Kb,  or bigger than <strong>5 Mb</strong>"
	]

	mount_uploader :image, EventCoverImageUploader


end

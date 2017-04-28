class Document::EventBrochure < Document::Base

	INSTRUCTIONS = [
		"the filename should be in .PDF format",
		"if you have images of the brochure, create a PDF with the imags and upload it here.",
		"the file size should not exceed <strong>5 MB</strong>"
	]

	mount_uploader :document, DocumentUploader

end

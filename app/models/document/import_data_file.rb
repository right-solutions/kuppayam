class Document::ImportDataFile < Document::Base

	# Constants
  UPLOAD_LIMIT = 12582912 # this is in bytes which is equivalent to 12 megabytes

	INSTRUCTIONS = [
		"the filename should be in in CSV/XLS/XLSX format",
		"the column structure should be exactly the same as mentioned. To make sure that you are following the structure, download the sample data and inspect it.",
		"the file size should not exceed <strong>10 Mb</strong>. In case if your file is big, split them into multiple files."
	]

	mount_uploader :document, DocumentUploader

end

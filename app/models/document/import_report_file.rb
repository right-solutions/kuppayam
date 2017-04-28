class Document::ImportReportFile < Document::Base

	# Constants
  UPLOAD_LIMIT = 12582912 # this is in bytes which is equivalent to 12 megabytes

	mount_uploader :document, DocumentUploader

end

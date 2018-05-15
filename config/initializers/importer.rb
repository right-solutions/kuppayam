# require 'axlsx'
require 'colorized_string'
# require 'roo'
require 'benchmark'
require 'iconv'

module Kuppayam
	
	module Importer

		class ErrorHash

			attr_accessor :warnings,
		                :errors

		  def initialize
		  	@warnings = []
		    @errors = []
		  end

		  def warnings?
		  	@warnings.any?
		  end

		  def errors?
		  	@errors.any?
		  end

		  def print_dot
		  	if self.warnings?
	        print ".".yellow
	      elsif self.errors?
	        print ".".red
	      else
	        print ".".green
	      end
		  end

		  def print_all
		  	self.warnings.each do |item|
	        puts "Summary: #{item[:summary]}".yellow
	        puts "Details: #{item[:details]}".yellow if item[:details]
	        puts "Stack Trace: #{item[:stack_trace]}".yellow if item[:stack_trace]
	        puts ""
		  	end
		  	self.errors.each do |item|
	        puts "Summary: #{item[:summary]}".red
	        puts "Details: #{item[:details]}".red if item[:details]
	        puts "Stack Trace: #{item[:stack_trace]}".red if item[:stack_trace]
	        puts ""
		  	end
		  end
		end

		class DataError
			attr_accessor :errors, :columns

			def initialize
				@errors = {}
				@columns = []
			end

			def add_column_error(name, value, errors, row_number)
				if @errors[row_number].blank?
					@errors[row_number] = {
						name => { value: value, errors: errors }
					}
				else
					@errors[row_number][name] = { value: value, errors: errors }
				end
			end

			def generate_error_file

		  	axlsx_package = Axlsx::Package.new
				wb = axlsx_package.workbook

				normal_cell = s.add_style :bg_color => "FFFFFF", :fg_color => "4B4B4B", :sz => 14, :alignment => { :horizontal=> :center }
				error_cell = s.add_style :bg_color => "FFE2E2", :fg_color => "4B4B4B", :sz => 14, :alignment => { :horizontal=> :center }

				wb.add_worksheet(:name => "Errors") do |sheet|
			    
			    sheet.add_row self.columns

			    self.errors.each do |row_number, values|
			    	row_data = self.columns.map{|col| values[col][:value] }
						sheet.add_row row_data
			    end

			  end
		  	axlsx_package.serialize("tmp/example.xlsx")
		  end
		end

		def clean_string(str, label=nil)
			begin
				cleaned_str = str.gsub(/\r/, "").gsub(/\n/, "").squeeze(" ")
				cleaned_str = Iconv.conv('UTF-8', 'ISO-8859-1//TRANSLIT//IGNORE', cleaned_str)
			rescue Exception => e
				puts "Error while cleaning #{label ? label : 'string'} '#{str}' - #{e.message}".red
			end
		end

	  # Import Data from Various Files
	  # -------------------------------

		def check_file_type_and_import(path, single_transaction=true, verbose=true)
	  	if File.exists?(path)
	    	if File.extname(path) == ".csv"
	      	puts "CSV file found at '#{path.to_s}'.".green if verbose
	      	self.import_from_csv(path.to_s, single_transaction, verbose)
	      elsif File.extname(path) == ".xlsx"
	      	puts "XSLX file found at '#{path.to_s}'.".green if verbose
	      	self.import_from_xslx(path.to_s, single_transaction, verbose)
	      else
	      	puts "Unsupported File encountered'#{path.to_s}'.".red if verbose
	      	return
	      end
	    else
	      puts "Import File not found at '#{path.to_s}'.".red if verbose
	    end
	  end

		def import_from_sql(sql_path, verbose=true)

			errors = []

			print_memory_usage do
			  print_time_spent do
			    sum = 0

			    CSV.foreach(csv_path, headers: true, header_converters: :symbol) do |row|
			    	error_object = save_row_data(row)
			      errors << error_object if error_object
			      error_object.print_dot if error_object && verbose
			      sum += 1
			    end

			    puts "Sum: #{sum}"
			  end
			end

			if verbose
	      puts ""
	      errors.each do |error_object|
	        error_object.print_all if error_object
	      end
	    end
	  end

		def import_from_csv(csv_path, single_transaction=true, verbose=true)
			errors = []
	    sum = 0

	    # , encoding: 'windows-1251:utf-8', :row_sep => :auto
	    if single_transaction
		    ActiveRecord::Base.transaction do 
			    CSV.foreach(csv_path, headers: true, header_converters: :symbol, skip_blanks: true) do |row|
			    	error_object = save_row_data(row)
			      errors << error_object if error_object
			      error_object.print_dot if error_object && verbose
			      sum += 1
			    end
		    end
		  else
		  	CSV.foreach(csv_path, headers: true, header_converters: :symbol, skip_blanks: true) do |row|
		    	error_object = save_row_data(row)
		      errors << error_object if error_object
		      error_object.print_dot if error_object && verbose
		      sum += 1
		    end
	    end
	    puts "\tScanned #{sum} rows".yellow

			if verbose
	      puts ""
	      errors.each do |error_object|
	        error_object.print_all if error_object
	      end
	    end
	  end

	  def import_from_xslx(xlsx_path, single_transaction = true, verbose=true)
	  	xlsx = Roo::Spreadsheet.open(xlsx_path, extension: :xlsx)
    	sheet = xlsx.sheet(0)
			headers = sheet.row(1)

			errors = []
			if single_transaction
		    ActiveRecord::Base.transaction do 
					2.upto(xlsx.last_row) do |line|
						row_hash = ActiveSupport::HashWithIndifferentAccess[headers.zip(xlsx.row(line))]
						obj, error_object = save_row_data(row_hash)
			      errors << error_object if error_object
			      error_object.print_dot if error_object && verbose
					end
				end
			else
				2.upto(xlsx.last_row) do |line|
					row_hash = ActiveSupport::HashWithIndifferentAccess[headers.zip(xlsx.row(line))]
					obj, error_object = save_row_data(row_hash)
		      errors << error_object if error_object
		      error_object.print_dot if error_object && verbose
				end
			end
			
			if verbose
	      puts ""
	      errors.each do |error_object|
	        error_object.print_all if error_object
	      end
	    end
	  end

	  def walk_and_import(start, single_transaction=true, verbose=true)
	  	puts "Importing Files from the Folder '#{start.to_s}'".yellow if verbose
	  	items = Dir.foreach(start).sort_by {|x| x }
		  items.each do |x|
		  	next if x.starts_with?("master")
		  	next unless x.ends_with?(".csv")
		    path = File.join(start, x)
		    if x == "." or x == ".."
		      next
		    elsif File.directory?(path)
		    	self.walk_and_import(path, single_transaction, verbose)
		    else
		      self.check_file_type_and_import(path, single_transaction, verbose)
		    end
		  end
		end

	  def import_data_recursively(path, single_transaction=true, verbose=true)
	  	print_memory_usage do
			  print_time_spent do
			  	if Dir.exists?(path)
			  		self.walk_and_import(path, single_transaction, verbose)
			  	else
			      puts "Import Folder not found: '#{path.to_s}'.".red if verbose
			    end
			  end
			end
	  end

	  # Import Images
	  # -------------

	  def import_image(image_path, object_class_name, finder_method, image_class_name, verbose=true)

	  	filename = File.basename(image_path, File.extname(image_path))

	  	imageable_object = object_class_name.constantize.where("#{finder_method} = ?", filename).first
	  	image_object = image_class_name.constantize.new
	  	image_object.imageable = imageable_object
	  	image_object.image = File.open(image_path)

	  	if image_object.valid?
	  		image_object.save
	  	else
	  		puts ""
	  		puts "Error while saving #{filename} - #{image_path}".red
	  		puts ""
	  	end
	  end

	  def walk_and_import_images(start, object_class_name, finder_method, image_class_name, verbose=true)
	  	puts "Importing Images from the Folder '#{start.to_s}'".yellow if verbose
	  	items = Dir.foreach(start).sort_by {|x| x }
		  items.each do |x|
		  	path = File.join(start, x)
		    if x == "." or x == ".."
		      next
		    elsif File.directory?(path)
		    	self.walk_and_import_images(path, object_class_name, finder_method, image_class_name, verbose)
		    else
		    	next unless [".png", ".jpg", "jpeg"].include?(File.extname(x.downcase))
		      self.import_image(path, object_class_name, finder_method, image_class_name, verbose)
		    end
		  end
		end

	  def import_image_recursively(path, object_class_name, finder_method, image_class_name, verbose=true)
	  	print_memory_usage do
			  print_time_spent do
			  	if Dir.exists?(path)
			  		self.walk_and_import_images(path, object_class_name, finder_method, image_class_name, verbose)
			  	else
			      puts "Import Folder not found: '#{path.to_s}'.".red if verbose
			    end
			  end
			end
	  end

	  def import_data_file(path, single_transaction=true, verbose=true)
	  	print_memory_usage do
			  print_time_spent do
			  	check_file_type_and_import(path, single_transaction, verbose)
			  end
			end
	  end

	  def print_memory_usage
		  memory_before = `ps -o rss= -p #{Process.pid}`.to_i
		  yield
		  memory_after = `ps -o rss= -p #{Process.pid}`.to_i

		  puts "Memory: #{((memory_after - memory_before) / 1024.0).round(2)} MB"
		end

		def print_time_spent
		  time = Benchmark.realtime do
		    yield
		  end

		  puts "Time: #{time.round(2)}"
		end

		def csv_foreach_backup_code
			#   batch_size = 1000

			  #   File.open(csv_path) do |file|
					#   file.lazy.drop(header_lines).each_slice(batch_size) do |lines|
					#     puts lines
					#   end
					# end

			  #   File.open(csv_path) do |file|
			  	#   headers = file.first
					#   file.lazy.each_slice(batch_size) do |lines|
					#     csv_rows = CSV.parse(lines.join, write_headers: true, headers: headers)
					#     csv_rows.each do |row|
				 #    		error_object = save_row_data(row)
					#       errors << error_object if error_object
					#       error_object.print_dot if error_object
					#       sum += 1
					#     end
					#   end
					# end

					# rows = CSV.new(File.open(csv_path,'r'), headers: true, header_converters: :symbol).lazy.select do |row|
					# end

					# rows.each do |row|

					# 	error_object = save_row_data(row)
			  #     errors << error_object if error_object
			  #     error_object.print_dot if error_object
			  #     sum += 1
			  #   end
		end

	end

end
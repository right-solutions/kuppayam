# require 'axlsx'
require 'colorized_string'

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

		  	# binding.pry

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

		def import_from_csv(csv_path, verbose=true)
    	
    	csv_table = CSV.table(csv_path, {headers: true, converters: nil, header_converters: :symbol})
	    headers = csv_table.headers

	    errors = []

	    csv_table.each do |row|
	      error_object = save_row_data(row)
	      errors << error_object if error_object
	      error_object.print_dot if error_object
	    end

	    if verbose
	      puts ""
	      errors.each do |error_object|
	        error_object.print_all if error_object
	      end
	    end
	  end

	  def import_data(engine, path, dummy=true, verbose=true)
	  	if dummy
		  	# Check for the file in the application path
        # If not found, check it in engine path
        csv_file_path = Rails.root.join('db', 'import_data', 'dummy', "#{self.table_name}.csv")
        unless File.exists?(csv_file_path)
          csv_file_path = engine.root.join('db', 'import_data', 'dummy', "#{self.table_name}.csv")
        end

        if File.exists?(csv_file_path)
          self.import_from_csv(csv_file_path.to_s, verbose)
        else
          puts "CSV file not found at '#{csv_file_path.to_s}'.".red if verbose
        end
	    else
	    	if path
	        # If path is given, check if the file exists
	        if File.exists?(path)
	          import_from_csv(path, verbose)
	        else
	          puts "CSV file not found at '#{path}'. Please give absolute path.".red if verbose
	        end
	      else
	        csv_file_path = Rails.root.join('db', 'import_data', "#{self.table_name}.csv")
	        unless File.exists?(csv_file_path)
	          csv_file_path = engine.root.join('db', 'import_data', "#{self.table_name}.csv")
	        end

	        if File.exists?(csv_file_path)
	          self.import_from_csv(csv_file_path.to_s, verbose)
	        else
	          puts "CSV file not found at '#{csv_file_path.to_s}'.".red if verbose
	        end
	      end
	    end
	  end
	end
end
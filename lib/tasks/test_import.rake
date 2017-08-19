require 'csv'
require 'open-uri'
require 'time'

namespace 'import' do
  namespace 'test' do
    namespace 'csv' do
    
      # Import from a small CSV file (single)
      desc "Importing a single CSV file (less than 5000 rows)"
      task 'single_file' => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        path = Kuppayam::Engine.root.join('db', 'test_data', "single_file", "master.csv")
        Region.destroy_all
        Region.import_data_file(path, true, verbose)
        puts "Importing Completed".green if verbose
      end

      # Import from a bunch of split CSV files of same format (typically large CSV gets split into rows of 5000 or 10000)
      desc "Importing a bunch of split CSV file"
      task 'split_files' => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        path = Kuppayam::Engine.root.join('db', 'test_data', "split_files")
        Region.destroy_all
        Region.import_data_recursively(path, true, verbose)
        puts "Importing Completed".green if verbose
      end

    end
    
    namespace 'xlsx' do
    end
    
    namespace 'sql' do
    end
  end
end
    
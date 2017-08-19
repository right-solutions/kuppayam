require 'csv'
require 'open-uri'
require 'time'

namespace 'import' do
  namespace 'template' do

    desc "Import all data in sequence"
    task 'all' => :environment do

      import_list = ["countries", "cities"]
      
      import_list.each do |item|
        print "Importing #{item.titleize} \t".yellow
        begin
          Rake::Task["usman:import:#{item}"].invoke
        rescue ArgumentError => e
            puts "Loading #{item} - Failed - #{e.message}".red
        rescue Exception => e
          puts "Importing #{item.titleize} - Failed - #{e.message}".red
          puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        end
      end
      puts " "
    end

    # Import from xlsx
    ["ClassName"].each do |cls_name|
      name = cls_name.underscore.pluralize
      desc "Import #{cls_name.pluralize}"
      task name => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        path = Kuppayam::Engine.root.join('db', 'master_data', "#{cls_name.constantize.table_name}.xlsx")
        cls_name.constantize.import_data(path, verbose)
      end
    end

    # Import from CSV
    ["ClassName"].each do |cls_name|
      name = cls_name.underscore.pluralize
      desc "Import #{cls_name.pluralize}"
      task name => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)
        path = Kuppayam::Engine.root.join('db', 'master_data', "#{cls_name.constantize.table_name}.csv")
        cls_name.constantize.import_data(path, verbose)
      end
    end

    # Import from SQL file
    ["Country", "City"].each do |cls_name|
      name = cls_name.underscore.pluralize
      desc "Import #{cls_name.pluralize}"
      task name => :environment do
        path = Kuppayam::Engine.root.join('db', 'master_data', "#{cls_name.constantize.table_name}.sql")
        begin
          system "bundle exec rails db < #{path.to_s}"
          puts "Imported #{cls_name.pluralize} SQL file successfully".green
          puts "Saved #{cls_name.constantize.count} rows".green
        rescue ArgumentError => e
          puts "Loading #{item} - Failed - #{e.message}".red
        rescue Exception => e
          puts "Importing #{item.titleize} - Failed - #{e.message}".red
          puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
        end
      end
    end

  end
end
    
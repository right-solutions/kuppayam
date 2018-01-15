require 'csv'
require 'open-uri'
require 'time'

namespace 'import' do
  namespace 'data' do

    # # Import Cover Images
    # ["Category", "ClassifiedAttribute"].each do |imageable_cls_name|
    #   name = imageable_cls_name.underscore.pluralize
    #   desc "Import Cover Image for #{name}"
    #   task name => :environment do
    #     verbose = true
    #     verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)

    #     path = Rails.root.join('db', 'images', "cover_images", name)
    #     imageable_cls_name.constantize.import_cover_image_recursively(path, true, verbose)
    #     puts "Importing Completed".green if verbose
    #   end
    # end

    desc "Import all images"
    task 'images' => :environment do
      verbose = true
      verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)

      path = Rails.root.join('db', 'images', "#{cls_name.constantize.table_name}")
      cls_name.constantize.destroy_all if destroy_all
      cls_name.constantize.import_images_recursively(path, true, verbose)
      puts "Importing Completed".green if verbose
    end

    namespace 'dummy' do
      desc "Import all dummy images"
      task 'images' => :environment do
        verbose = true
        verbose = false if ["false", "f","0","no","n"].include?(ENV["verbose"].to_s.downcase.strip)

        path = Rails.root.join('db', 'images', "#{cls_name.constantize.table_name}")
        cls_name.constantize.destroy_all if destroy_all
        cls_name.constantize.import_images_recursively(path, true, verbose)
        puts "Importing Completed".green if verbose
      end
    end
  end
end
    
require 'rails/generators'
require 'rails/generators/migration'

class Kuppayam::ResourceGenerator < Rails::Generators::Base
  
  include Rails::Generators::Migration
  
  def self.next_migration_number(path)
    @migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i.to_s
  end
  
  source_root File.expand_path('../templates', __FILE__)
  
  desc "Generates a migration, model and it specs"
  
  argument :resource_name, :type=>:string
  argument :fields, :type=>:hash, :banner =>"Resource Fields."
  
  class_option :debug, :type => :boolean, :default => false, :desc => "This will print the arguments for debugging"
  
  def debug_args
    print_args if options.debug?
  end

  def generate_migrations
    migration_dir = "db/migrate"
    migration_file_name = "create_#{instances_name}.rb"
    destination = self.class.migration_exists?(migration_dir, migration_file_name)
    if destination
      say_status("skipped", "Migration #{migration_file_name}.rb already exists")
    else
      migration_template "db/migrate/create_resources.rb", "db/migrate/create_#{instances_name}.rb"
    end
  end
  
  def generate_model
    template "models/resource.rb", "app/models/#{model_path}.rb"
  end

  def generate_factory
    template "spec/factories/resource.rb", "spec/factories/#{model_path}.rb"
  end

  def generate_model_spec
    template "spec/models/resource_spec.rb", "spec/models/#{model_path}_spec.rb"
  end
  
  def generate_controllers
    template "controllers/resource_controller.rb", "app/controllers/#{controller_path}_controller.rb"
  end

  def generate_controller_spec
    template "spec/controllers/resource_controller_spec.rb", "spec/controllers/#{controller_path}_controller_spec.rb"
  end
  
  def generate_views
    template "views/_form.html.erb", "app/views/#{controller_path}/_form.html.erb"
    template "views/_index.html.erb", "app/views/#{controller_path}/_index.html.erb"
    template "views/_row.html.erb", "app/views/#{controller_path}/_row.html.erb"
    template "views/_show.html.erb", "app/views/#{controller_path}/_show.html.erb"
    template "views/index.html.erb", "app/views/#{controller_path}/index.html.erb"
  end

  private
  
  def print_args
    puts ":fields: #{fields}"
    puts ":form_link_param: #{form_link_param}"
    puts "name_phrases: #{name_phrases}"
    puts "controller_path: #{controller_path}"
    puts "controller_class: #{controller_class}"
    puts "model_path: #{model_path}"
    puts "model_class: #{model_class}"
    puts "instance_name: #{instance_name}"
    puts "instances_name: #{instances_name}"
    puts "table_name: #{table_name}"
    
    puts "index path: #{resource_link}"
    puts "show path: #{resource_link('show')}"
    puts "new path: #{resource_link('new')}"
    puts "edit path: #{resource_link('edit')}"
    puts "create path: #{resource_link('create')}"
    puts "update path: #{resource_link('update')}"
    puts "destroy path: #{resource_link('destroy')}"
    
    puts "index url: #{resource_link('index','url')}"
    puts "show url: #{resource_link('show','url')}"
    puts "new url: #{resource_link('new','url')}"
    puts "edit url: #{resource_link('edit','url')}"
    puts "create url: #{resource_link('create','url')}"
    puts "update url: #{resource_link('update','url')}"
    puts "destroy url: #{resource_link('destroy','url')}"
  end
  
  def name_phrases
    if resource_name.include?('::')
      resource_name.split("::")
    elsif resource_name.include?('/')
      resource_name.split("/")
    else
      [resource_name]
    end
  end
  
  def controller_path
    words = name_phrases
    resource = words.pop
    if words.any?
      words.collect(&:downcase).join("/") + "/#{resource.pluralize}"
    else
      "#{resource.pluralize}"
    end
  end
  
  def controller_class
    words = name_phrases
    resource = words.pop
    if words.any?
      words.collect(&:camelize).join("::") + "::#{resource.camelize.pluralize}Controller"
    else
      "#{resource.camelize.pluralize}Controller"
    end
  end
  
  def model_path
    name_phrases.last.downcase
  end
  
  def model_class
    name_phrases.last.camelize
  end
  
  def instance_name
    name_phrases.last.underscore
  end
  
  def instances_name
    instance_name.pluralize
  end
  
  def instance_title
    instance_name.titleize
  end
  
  def instances_title
    instances_name.titleize
  end
  
  def table_name
    instances_name
  end
  
  def resource_link(actn='index', ltype='path')
    map = {
      'index' => '',
      'show' => '',
      'edit' => 'edit_',
      'new' => 'new_',
      'update' => '',
      'create' => '',
      'destroy' => '',
    }
    words = name_phrases
    resource = words.pop
    if actn == "index"
      map[actn] + (words.any? ? words.join("_") + "_" : "") + resource.pluralize + "_" + ltype
    else
      map[actn] + (words.any? ? words.join("_") + "_" : "") + resource + "_" + ltype
    end
  end 
  
  def form_for_object
    if name_phrases.size > 1
      words = name_phrases.dup
      resource = words.pop
      "[" + words.map{|x| ":#{x}"}.join(", ") + ", @#{resource}]"
    else
      "@#{instance_name}"
    end
    
  end 
  
  def form_link_param
    words = name_phrases
    resource = words.pop
    if words.any?
      # to print like this [:admin, :user, :location, @chakka]
      # in form.html.erb
      "[" + (words.map{|x| ":" + x.downcase} << "@" + resource.downcase).join(", ") + "]"
    else
      "@#{resource.downcase}"
    end
  end
  
  ## List of all the string fields 
  def string_fields
    main_field = main_string_field
    fields.map{|name, type| name if name != main_field && type == "string" }.uniq.compact
  end
  
  ## List of all the string fields including main field
  def string_fields_including_main_field
    main_field = main_string_field
    fields.map{|name, type| name if type == "string" }.uniq.compact
  end
  
  ## The main string field like 'name'
  def main_string_field
    fields.map{|name, type| name if name.include?("name") && type == "string"}.uniq.compact || fields.keys.any? ? fields.keys.first : "id"
  end
  
  def guess_input_type(name, type)
    case type
    when "string"
      if name.include?("url")
        return "url"
      elsif name.include?("email")
        return "email"
      elsif name.include?("phone") || name.include?("mobile") || name.include?("landline") || name.include?("contact number") 
        return "tel"
      elsif name.include?("time")
        return "time"
      elsif name.include?("date")
        return "date"
      elsif name.include?("password")
        return "password"
      else
        "text"
      end
    when "text"
      "textarea"
    when "integer"
      "number"
    when "references"
      "type"
    when "date"
      "date"
    when "datetime"
      "datetime-local"
    when "timestamp", "time"
      "time"
    when "boolean"
      "checkbox"
    else
      "text"
    end
  end
  
  ## Text Fields like description or summary
  def text_fields
    fields.map{|name, type| name if type == "text"}.uniq.compact
  end

end
module Kuppayam
  module ActionView
    # This module creates Bootstrap wrappers around basic View Tags
    module FormHelper
      # Example 1
      #
      #   theme_form_group("Student Name") do
      #     text_field_tag(:student, :name)
      #   end
      #
      # is equivalent to:
      #
      # <div class="form-group ">
      #   <label for="inp_name" class="col-md-4 control-label kuppayam-label">Student Name
      #     <span class="text-color-red ml-10 mr-5 pull-right">*</span>
      #   </label>
      #   <div class="col-md-8">
      #     <%= text_field_tag(:student, :name) %>
      #   </div>
      # </div>
      #
      # ---------------------------
      #
      # Example 2
      #
      #   theme_form_group("Please select a Movie", required: false) do
      #     collection_select(@movie_ticket, :movie_id, movies_list, :id, name, {:prompt=>true}, {:class => 'form-control'})
      #   end
      #
      # is equivalent to:
      #
      # <div class="form-group ">
      #   <label for="inp_movie_id" class="col-md-4 control-label kuppayam-label">
      #     Please select a Movie
      #   </label>
      #   <div class="col-md-8">
      #     <%= collection_select(@movie_ticket, :movie_id, movies_list, :id, name, {:prompt=>true}, {:class => 'form-control'}) %>
      #   </div>
      # </div>

      # Example 3
      # if you want to change the label div column width which is by default set to "col-md-4"
      # and field div column width which is by default set to "col-md-8" by passing label_col_class and field_col_class
      #
      #   theme_form_group("Please select a Movie", label_col_class: "col-md-6", field_col_class: "col-md-6") do
      #     ....
      #   end
      #

      # Example 4
      # If you want to add error_class to form-group div tag you can pass it through options
      #
      #   theme_form_group("Please select a Movie", error_class: "error-class") do
      #     ....
      #   end
      #

      def theme_form_group(label, **options)
        options.reverse_merge!(
          error_class: "",
          param_name: label.gsub(" ", "_").underscore,
          required: true,
          form_style: "left-right"
        )

        if options[:form_style] == "left-right"
          options.reverse_merge!(
            error_class: "",
            param_name: label.gsub(" ", "_").underscore,
            required: true,
            form_group_div_class: "form-group",
            label_col_class: "col-md-4",
            field_col_class: "col-md-8"
          )
        elsif options[:form_style] == "top-down" || options[:form_style] == "top-bottom"
          options.reverse_merge!(
            error_class: "",
            param_name: label.gsub(" ", "_").underscore,
            required: true,
            form_group_div_class: "form-group",
            label_col_class: "col-md-12 text-align-left pb-2",
            field_col_class: "col-md-12"
          )
        elsif options[:form_style] == "materialize"
          options.reverse_merge!(
            error_class: " filled",
            param_name: label.gsub(" ", "_").underscore,
            required: true,
            form_group_div_class: "form-group filled mt-15",
            label_col_class: "",
            field_col_class: "pt-10"
          )
        end

        content_tag(:div, class: "#{options[:form_group_div_class]} #{options[:error_class]}") do
          content_tag(:label, class: "#{options[:label_col_class]} control-label kuppayam-label") do
            star_content = options[:required] ? "*" : raw("&nbsp;&nbsp;")
            raw(label + content_tag(:span, star_content, class: "text-color-red ml-10 mr-5"))
          end +
          content_tag(:div, class: options[:field_col_class]) do
            if block_given?
              yield
            else
              "No Block Passed"
            end
          end
        end
      end

      # Creates the form group with label, and text field
      # Supports the following input type: "text", "email", "search", "password", "date", "time", "tel", "url", "month"
      # Example
      #    theme_form_field(@project, :name)
      #
      # <div class="form-group ">
      #    <label class="col-md-4 control-label kuppayam-label" for="inp_name">
      #      Name
      #      <span class="text-color-red ml-10 mr-5 pull-right">*</span>
      #    </label>
      #    <div class="col-md-8">
      #     <input class="text input form-control" id="inp_name" name="link_type[name]" placeholder="" type="text">
      #    </div>
      # </div>

      def theme_form_field(object, field_name, **options)

        options.symbolize_keys!
        options.reverse_merge!(
          object_name: object.class.name.underscore,
          label: field_name.to_s.gsub("_", " ").titleize,
          required: true,
          error_class: "has-error",
          html_options: { readonly: false },
          form_style: "left-right"
        )
        options.reverse_merge!(
          param_name: "#{options[:object_name]}[#{field_name}]"
        )

        if object.errors[field_name.to_s].any?
          error_class =  options[:error_class]
          error_message = content_tag(:span, object.errors[field_name].first, class: "help-block")
        else
          error_class = ""
          error_message = ""
        end

        theme_form_group(options[:label], required: options[:required], error_class: error_class, form_style: options[:form_style]) do
          options[:html_options].reverse_merge!(
            type: "text",
            id: "inp_#{options[:label].to_s.gsub(" ", "_").downcase}",
            class: "text input form-control",
            place_holder: ""
          )
          case options[:html_options][:type].to_sym
          when :text, :email, :search, :password, :time, :tel, :url, :month, :number
            text_field_tag(options[:param_name], object.send(field_name.to_s), **options[:html_options])
          when :decimal
            precision = options[:html_options][:precision] || 2
            text_field_tag(options[:param_name], number_with_precision(object.send(field_name), precision: precision), **options[:html_options])
          when :date
            begin
              date_value = object.send(field_name.to_s).strftime("%Y-%m-%d")
            rescue
              date_value = Date.today.strftime("%Y-%m-%d")
            end
            options[:html_options].reverse_merge!(value: date_value)
            text_field_tag(options[:param_name], object.send(field_name.to_s), **options[:html_options])
          when :textarea
            options[:html_options].reverse_merge!(style: "height: 100px;")
            text_area_tag(options[:param_name], object.send(field_name.to_s), **options[:html_options])
          when :file
            file_field_tag(options[:param_name], **options[:html_options])
          when :checkbox
            options[:html_options][:class] = "iswitch iswitch-secondary checkbox mt-10"
            current_value = object.send(field_name.to_s)
            options[:html_options][:checked] = current_value
            check_box_tag(options[:param_name], "1", current_value, **options[:html_options])
          else
            text_field_tag(options[:param_name], object.send(field_name.to_s), **options[:html_options])
          end + error_message
        end
      end

      # Example
      #   assoc_collection = Customer.select("id, name").order("name ASC").all
      #   options = {assoc_object: customer, assoc_display_method: :name, assoc_collection: Customer.select("id, name").order("name ASC").all, label: "Customer", required: true}
      #   theme_form_assoc_group(project, :customer_id, **options)
      # is equivalent to:
      # ---------------------------
      # <% Choose Customer - Drop Down  %>
      # <div class="form-group ">
      #   <label for="inp_name" class="col-md-4 control-label kuppayam-label">
      #     Customer
      #     <span class="text-color-red ml-10 mr-5 pull-right">*</span>
      #   </label>
      #   <div class="col-md-8">
      #     <% if editable && @customer %>
      #       <%= @customer.name %>
      #       <%= hidden_field_tag "project[customer_id]", @customer.id %>
      #     <% else %>
      #       <%= collection_select(:project, :customer_id, Customer.select("id, name").order("name ASC").all, :id, :name, {:prompt=>true}, {:class => 'form-control'}) %>
      #     <% end %>
      #   </div>
      # </div>
      def theme_form_assoc_group(object, foreign_key, **options)
        options.symbolize_keys!
        assoc_method_name = foreign_key.to_s.chomp("_id")
        options.reverse_merge!(
          assoc_object: object.respond_to?(assoc_method_name) ? object.send(assoc_method_name) : nil,
          assoc_display_method: :name,
          assoc_collection: [],
          param_name: object.class.name.underscore,
          object_name: object.class.name.underscore,
          required: true,
          label: foreign_key.to_s.titleize,
          include_blank: "Please Select",
          editable: true,
          error_class: "has-error",
          form_style: "left-right"
        )

        # Populating Errors
        errors = object.errors[foreign_key.to_s]
        # if foreign_key is an id, check errors for the association
        # errors = project.errors[:customer_id] + project.errors[:customer]
        if object.errors[foreign_key.to_s.gsub("_id", "")]
          errors += object.errors[foreign_key.to_s.gsub("_id", "")]
        end

        error_class = errors.any? ? options[:error_class] : ""
        if errors.any?
          error_class =  options[:error_class]
          error_message = content_tag(:span, errors.first, class: "help-block")
        else
          error_class = ""
          error_message = ""
        end

        selected_id = object.send(foreign_key)
        
        theme_form_group(options[:label], required: options[:required], error_class: error_class, form_style: options[:form_style]) do
          if !options[:editable] && options[:assoc_object]
            raw(options[:assoc_object].send(options[:assoc_display_method]) + hidden_field_tag("#{options[:param_name]}[#{foreign_key}]", options[:assoc_object].id))
          else
            collection_select(options[:object_name], foreign_key, options[:assoc_collection], :id, options[:assoc_display_method], {include_blank: options[:include_blank], selected: selected_id}, {:class => 'form-control'})
          end + error_message
        end
      end

      # Example
      #   roles = ConfigCenter::Roles::LIST
      #   options_list = Array[*roles.collect {|v,i| [v,v] }].sort
      #   theme_form_select_group(f, @proposal, :plan, options_list, label: "Choose Plan", param_name: "proposal[:plan]", prompt: true)
      # is equivalent to:
      # ---------------------------
      # <div class="form-group ">
      #   <label for="inp_name" class="col-md-4 control-label kuppayam-label">Choose Plan
      #     <span class="text-color-red ml-10 mr-5 pull-right">*</span>
      #   </label>
      #   <div class="col-md-8">
      #     <% options_list = ConfigCenter::Roles::LIST %>
      #     <%= f.select("proposal[:plan]", options_for_select(options_list, :selected => f.object.name), {:prompt=>true}, {:class => 'form-control'}) %>
      #   </div>
      # </div>
      def theme_form_select_group(object, field_name, options_list, **options)
        options.reverse_merge!(
          label: field_name.to_s.titleize,
          param_name: field_name,
          prompt: "Select",
          error_class: "has-error",
          select_class: "form-control",
          required: false,
          form_style: "left-right"
        )
        
        error_class = object.errors[field_name.to_s].any? ? options[:error_class] : ""
        if object.errors[field_name.to_s].any?
          error_class =  options[:error_class]
          error_message = content_tag(:span, object.errors[field_name].first, class: "help-block")
        else
          error_class = ""
          error_message = ""
        end

        selected = options[:selected] if options[:selected]
        begin
          selected = object.send(field_name) if selected.blank?
          selected = options_list.first.last if selected.blank?
        rescue
          selected = nil
        end
        theme_form_group(options[:label], required: options[:required], error_class: error_class, form_style: options[:form_style]) do
          select_tag(options[:param_name], options_for_select(options_list, :selected => selected), {:prompt=>options[:prompt], :class => options[:select_class]}) + error_message
        end
      end

      # Creates a submit button with basic styles
      # Example
      #   submit_tag button_text, "data-reset-text"=>button_text, "data-loading-text"=>"Saving ...", :class=>"btn btn-primary ml-10"
      # is equivalent to:
      # ---------------------------
      # submit_tag button_text, "data-reset-text"=>button_text, "data-loading-text"=>"Saving ...", :class=>"btn btn-primary ml-10"
      def theme_form_button(object, button_text="", saving_message="Saving ...", classes="btn btn-primary ml-10")
        button_text = "#{object.new_record? ? "Create" : "Update"}" if button_text.blank?
        submit_tag(button_text, "data-reset-text"=>button_text, "data-loading-text"=>saving_message, :class=>classes)
      end

      # Displays Full errors with basic alert styles
      # Example
      #   theme_form_errors(@user)
      def theme_form_errors(object, **options)
        options.reverse_merge!(
          row_class: "row mb-10",
          col_class: "col-md-12",
          alert_class: "alert alert-danger",
          ul_class: "",
          li_class: ""
        )
        if object.errors.any?
          content_tag(:div, class: options[:row_class]) do 
            content_tag(:div, class: options[:col_class]) do 
              content_tag(:div, class: options[:alert_class]) do 
                content_tag(:ul, class: options[:ul_class]) do 
                  li_array = []
                  object.errors.each do |attr, msg|
                    next unless object.errors[attr].last == msg
                    li_array << content_tag(:li, class: options[:li_class]) do 
                      "#{attr.to_s.titleize} #{msg}"
                    end
                  end
                  raw(li_array.join(" "))
                end
              end
            end
          end
        end
      end

    end
  end
end
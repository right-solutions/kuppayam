module KuppayamHelper
  
  # fa_icon('plus')
  # <i class='fa fa-plus'></i>
  # theme_fa_icon('plus', 'lg')
  # <i class='fa fa-plus fa-lg'></i>
  def fa_icon(icon_text, size="")
    size_class = %w{lg 2x 3x 4x 5x}.include?(size.strip) ? " fa-#{size.strip}" : ""
    "<i class='fa fa-#{icon_text}#{size_class}'></i>"
  end

  # Example
  #   paginate_kuppayam(@projects, false)
  #
  # is equivalent to:
  # ---------------------------
  # <div class="cl"></div>
  # <% if @projects.any? %>
  #    <%= content_tag :div, :class=>"pull-right" do %>
  #      <%= paginate @projects, :remote => true %>
  #    <% end %>
  # <% end %>
  # <div class="cl"></div>
  # ---------------------------
  def paginate_kuppayam(collection, remote=true)
    return "" if collection.empty?
    clear_tag(10) +
    content_tag(:div, :class=>"pull-right") do
      paginate(collection, :remote => remote)
    end +
    clear_tag(10)
  end

  # theme_search_form is a helper to create a form to filter the results by entering a search query
  def search_form_kuppayam(cls, url, **options)
    options.reverse_merge!(
      method: :get, 
      remote: true, 
      text: "", 
      param_name: "q",
      placeholder: "Search ...", 
      button_text: "Search!", 
      form_html: {
          :class=>"pull-right", 
          :style=>"margin-bottom:0px;width:100%;"},
      div_html: {:class=>"input-group"},
      button_class: "btn btn-primary",
      text_class: "btn-text hidden-sm hidden-xs"
    )

    form_for cls.new, 
            :url => url,
            :method => options[:method], 
            :remote=>options[:remote],
            :html=>options[:form_html] do |f|

      content_tag :div, options[:div_html] do
        text_field_tag(options[:param_name], options[:text], :class => 'form-control', :placeholder => options[:placeholder]) +
        content_tag(:span, class: "input-group-btn") do
          button_tag(type: 'submit', class: options[:button_class]) do
            raw(fa_icon('search') +
              content_tag(:span, class: options[:text_class]) do
                " " + options[:button_text]
              end)
          end
        end
      end

    end
  end
  
end

module BreadcrumbsHelper
  
  def breadcrumbs_configuration
    {}
  end

  def default_breadcrumbs_configuration
    {
      heading: "Heading",
      description: "Description for the Page",
      links: [{name: "Home", link: "#", icon: 'fa-home'}, 
                {name: "Current Page", link: "#", icon: 'fa-calendar', active: true}]
    }
  end

  def configure_breadcrumbs
    @breadcrumbs = breadcrumbs_configuration
    @breadcrumbs.reverse_merge!(default_breadcrumbs_configuration)
  end

  # Initialize @links in your controller action
  def breadcrumb
    if @breadcrumbs && @breadcrumbs.has_key?(:links) && @breadcrumbs[:links].any?
      content_tag(:div, class: "breadcrumb-env") do
        content_tag(:ol, class: "breadcrumb bc-1") do
          li_array = []
          @breadcrumbs[:links].each do |item|
            li_class = item[:active] == true ? "active" : ""
            li_array << content_tag(:li, class: li_class) do
              i_tag = item.has_key?(:icon) ? "<i class='#{item[:icon]}'></i>" : ""
              if item[:active]
                raw("#{i_tag}<strong>#{item[:name]}</strong>")
              else
                link_to(raw("#{i_tag} #{item[:name]}"), item[:link] )
              end
            end
          end
          raw(li_array.join(" "))
        end
      end
    end
  end
  
end

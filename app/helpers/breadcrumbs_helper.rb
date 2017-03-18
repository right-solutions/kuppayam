module BreadcrumbsHelper
  
  # Initialize @links in your controller action
  def breadcrumb
    @links = [
      {name: "Home", link: root_path, icon: 'fa-home'}, 
      {name: "Current Page", link: root_path, active: true}] if @links.nil?
    content_tag(:div, class: "breadcrumb-env") do
      content_tag(:ol, class: "breadcrumb bc-1") do
        li_array = []
        @links.each do |item|
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

FactoryBot.define do
  
  factory :unpublished_<%= instance_name %>, class: <%= model_class %> do
    
    <%- fields.each do |name, type| -%>
    <%= name -%> "Some Text"
    <%- end -%>

  end

  factory :published_<%= instance_name %>, parent: :unpublished_<%= instance_name %> do
    after :build do |e|
      e.publish
    end
  end

  factory :removed_<%= instance_name %>, parent: :unpublished_<%= instance_name %> do
    after :build do |e|
      e.remove
    end
  end

  factory :archived_<%= instance_name %>, parent: :unpublished_<%= instance_name %> do
    after :build do |e|
      e.archive
    end
  end

  factory :featured_<%= instance_name %>, parent: :published_<%= instance_name %> do
    after :build do |e|
      e.mark_as_featured
    end
  end

  factory :non_featured_<%= instance_name %>, parent: :published_<%= instance_name %> do
    after :build do |e|
      e.remove_from_featured
    end
  end

  
end
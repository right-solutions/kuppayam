class Create<%= model_class.pluralize %> < ActiveRecord::Migration[5.0]
  def self.up
    create_table :<%= table_name %> do |t|
    <%- fields.each do |name, type| -%>
      t.<%= type %> :<%= name %>
    <%- end -%>
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
Fabricator(:product_with_versions, class_name: 'Product') do
  after_create do |product|
    product.versions << [
      Fabricate(:product_version_live), 
      Fabricate(:product_version_development)
    ]
  end
end

Fabricator(:product_version_live, class_name: 'ProductVersion') do
  product_name 'Test product'
  version_description 'live'
  live_date DateTime.now
end

Fabricator(:product_version_development, class_name: 'ProductVersion') do
  product_name 'Test product'
  version_description 'development'
end

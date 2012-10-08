class Import
 
  def self.create_url(model, url)
    if url != nil
      unless model.urls.where(:text => url).exists?
	model.urls.create!(
	  :text => url,
	  :_type => 'UrlPersonal'
	)
      end
    end
  end
  
  def self.create_location(model, location)
    unless location.blank?
      unless model.addresses.where(:full_address => location).exists?
        model.addresses.create!(
	  :full_address => location,
	  :_type => 'AddressPersonal'
        )
      end
    end
  end
  
  def self.create_facebook_educations(model, educations)
    if educations
      educations.each do |edu|
	if edu["school"]["name"]
	  title = edu["school"]["name"]
	else
	  title = nil
	end
	if edu["year"]
	  year = edu["year"]["name"]
	else
	  year = nil
	end
	if edu["type"]
	  if edu["type"] == "High School"
	    type = "EducationSchool"
	  elsif edu["type"] == "College"
	  type = "EducationCollege"
	  end
	else
	  type = "Education"
	end
	unless model.educations.where(:title => title).exists?
	  model.educations.create!(
	    :title => title,
	    :year => year,
	    :_type => type
	  )
	end
      end
    end
  end
  
  def self.create_facebook_positions(model, positions)
    if positions
      i = 1
      positions.each do |pos|
	if pos["employer"]["name"]
	  company = pos["employer"]["name"]
	else
	  company = nil
	end
	if pos["position"]
	  title = pos["position"]["name"]
	else
	  title = nil
	end
	if i == 1
	  current = true
	else
	  current = false
	end
	unless model.positions.where(:title => title, :company => company).exists?
	  model.positions.create!(
	    :title => title,
	    :company => company,
	    :current => current
	  )
	end
	i = i + 1
      end
    end
  end
  
  def self.create_linkedin_positions(model, positions)  
    if positions.total > 0
      @positions = positions.all
      @positions.each do |pos|
	if pos.is_current
	  current = pos.is_current
	else
	  current = nil
	end
	if pos.title
	  title = pos.title
	else
	  title = nil
	end
	if pos.company.name
	  company = pos.company.name
	else
	  company = nil
	end
	unless model.positions.where(:title => title, :company => company).exists?
	  model.positions.create!(
	    :title => title,
	    :company => company,
	    :current => current
	  )
	end
      end
    end  
  end  
  
end
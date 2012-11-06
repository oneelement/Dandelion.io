class ImportsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  
  def import_mobile
    puts "hello"
    input = ActiveSupport::JSON.decode(request.body)
    
    #input = JSON.parse params[:output]
    
    if input
      input.each do |contact|
        name = contact['name']
        phoneid = contact['phoneid']
        phonerawid = contact['phonerawid']
        emails = contact['emails']
        puts name
        if Contact.where(:name => name, :user_id => current_user.id).exists?
          @contact = Contact.where(:name => name, :user_id => current_user.id).first          
          if @contact.phoneid.blank? or @contact.phonerawid.blank?
            @contact.phoneid = phoneid
            @contact.phonerawid = phonerawid
            @contact.save
            check_contact_attributes(@contact, contact)
          else
            if @contact.phoneid == phoneid and @contact.phonerawid == phonerawid
              check_contact_attributes(@contact, contact)
            end
          end
        else
          @contact = Contact.new(
            :name => name,
            :phoneid => phoneid,
            :phonerawid => phonerawid,
            :user_id => current_user.id
          )
          @contact.save
          check_contact_attributes(@contact, contact)
        end
      end
    end  
    
    respond_to do |format|
      format.json { render :json => input }
    end
  end
  
  def check_contact_attributes(saved_contact, contact)
    emails = contact['emails']
    unless emails.nil?
      emails.each do |email|
        unless saved_contact.emails.where(:text => email['text']).exists?
          saved_contact.emails.create!(
            :text => email['text'],
            :_type => 'EmailPersonal'
          )
        end
      end
    end
   
    urls = contact['urls']
    unless urls.nil?
      urls.each do |url|
        unless saved_contact.urls.where(:text => url['text']).exists?		
    saved_contact.urls.create!(
      :text => url['text'],
      :_type => 'UrlPersonal'
    )
        end
      end
    end     
    
    notes = contact['notes']
    unless notes.nil?
      notes.each do |note|
        unless saved_contact.notes.where(:text => note['text']).exists?		
    saved_contact.notes.create!(
      :text => note['text']
    )
        end
      end
    end
    
    mobiles = contact['mobiles']
    unless mobiles.nil?
      mobiles.each do |mobile|
        unless saved_contact.phones.where(:number => mobile['number']).exists?		
    saved_contact.phones.create!(
      :number => mobile['number'],
      :_type => 'MobilePersonal'
    )
        end
      end
    end
    
    phones = contact['phones']
    unless phones.nil?
      phones.each do |phone|
        unless saved_contact.phones.where(:number => phone['number']).exists?	
    if phone['_type'] == 'Mobile'
      type = 'MobilePersonal'
    elsif phone['_type'] == 'Work'
      type = 'PhoneBusiness'
    else
      type = 'PhonePersonal'
    end
    saved_contact.phones.create!(
      :number => phone['number'],
      :_type => type
    )
        end
      end
    end
    
    addresses = contact['addresses']
    unless addresses.nil?
      addresses.each do |address|
        unless saved_contact.addresses.where(:full_address => address['full_address']).exists?	
    if address['_type'] == 'Work'
      type = 'AddressBusiness'
    else
      type = 'AddressPersonal'
    end
    saved_contact.addresses.create!(
      :full_address => address['full_address'],
      :_type => type
    )
        end
      end
    end
    
  end
  
  def import_google
    @user = User.find(current_user.id)
    
    #using the google client to access calendars
    provider = @user.authentications.where(:provider => 'google_oauth2').first       
    
    ## This is how to use the discoveries, do NOT delete
    ##@client = Google::APIClient.new
    ##@client.authorization.access_token = provider.token
    ##service = @client.discovered_api('calendar', 'v3')  
    #method_names = @client.discovered_api('plus').to_h.keys
    ##method_names = @client.discovered_api('calendar', 'v3').to_h.keys
    ##result = @client.execute(
    ##  :api_method => service.calendar_list.list,
    ##  :parameters => {},
    ##  :headers => {'Content-Type' => 'application/json'})

    ##test = result.data
    
    #new = GData::Client::Contacts.new
    
    if provider
      #getting a new token
      @newclient = Google::APIClient.new
      @newclient.authorization.client_id = '815307397724.apps.googleusercontent.com'
      @newclient.authorization.client_secret = 'MNhKJWej9dJaXv1AKhI9CD7E'
      @newclient.authorization.scope = 'https://www.google.com/m8/feeds/'
      @newclient.authorization.redirect_uri = 'http://localhost:3000/auth/google_oauth2/callback'
      @newclient.authorization.access_token = provider.token
      @newclient.authorization.refresh_token = provider.refresh_token
      newkey = @newclient.authorization.fetch_access_token!
    
      new_token = newkey["access_token"]
    
      #manual Api call to contacts using new token
      url = 'https://www.google.com/m8/feeds/contacts/default/full/'
      auth = 'OAuth ' + new_token
      #auth = 'OAuth ya29.AHES6ZTcxPBLMj6eczmP4s5b8JmLd08-ADUZM-drP4jWDA'
    
      response = HTTParty.get(url, :headers => {'Authorization' => auth, 'Content-Type' => 'application/json', 'Host' => 'www.google.com', 'Gdata-version' => '3.0', 'Content-length' => '0'})
      xml  = Crack::XML.parse(response.body)
      result = xml.to_json
      #result = response.to_json
      
      @import_count = 0
    
      contacts = xml["feed"]["entry"]
      
      contacts.each do |contact|
	google_id = contact["gd:etag"]
	if GoogleContact.where(:google_id => google_id, :user_id => current_user.id).exists?
	else
	  if contact["gd:name"]
	    if contact["gd:name"]["gd:familyName"]
	      name = contact["gd:name"]["gd:givenName"] + " " + contact["gd:name"]["gd:familyName"]
	    else
	      name = contact["gd:name"]["gd:fullName"]
	    end
	  else
	    if contact["gd:email"]
	      #name = contact["gd:email"]["address"]
	      emails = contact["gd:email"]
	      if emails.kind_of?(Array) == true
		emails.each do |email|
		  if email['primary'] == 'true'
		    name = email['address']
		  end
		end		
	      else
		name = emails['address']
	      end
	    end    
	  end	  
	  if name
	    friend = GoogleContact.new(
	      :name => name, 
	      :user_id => current_user.id,
	      :google_id => google_id
	    )
            friend.save
	    if Contact.where(:name => name, :user_id => current_user.id).exists?
	      @contact_dual = Contact.where(:name => name, :user_id => current_user.id).first
	      if @contact_dual.google_id == nil
		@contact_dual.google_id = google_id
		@contact_dual.save
	      end
	      friend.contact_id = @contact_dual._id
              friend.save
	    else
	      @contact_dual = Contact.new(
                :name => name, 
                :user_id => current_user.id, 
                :google_id => google_id
              )
              @contact_dual.save
	      @import_count = @import_count + 1
	      friend.contact_id = @contact_dual._id
              friend.save
	    end
	    
	    if contact["gd:email"]
	      emails = contact["gd:email"]
	      if emails.kind_of?(Array) == true
		emails.each do |email|
		  unless @contact_dual.emails.where(:text => email['address']).exists?	
		    @contact_dual.emails.create!(
		      :text => email['address'],
		      :_type => 'EmailPersonal'
		    )
		  end
		end		
	      else
		unless @contact_dual.emails.where(:text => emails['address']).exists?	
		  @contact_dual.emails.create!(
		    :text => emails['address'],
		    :_type => 'EmailPersonal'
		  )
		end
	      end
	    end 
	    
	    if contact["gd:phoneNumber"]
	      phones = contact["gd:phoneNumber"]
	      if phones.kind_of?(Array) == true
		phones.each do |phone|
		  unless @contact_dual.phones.where(:number => phone).exists?	
		    @contact_dual.phones.create!(
		      :number => phone,
		      :_type => 'PhonePersonal'
		    )
		  end
		end		
	      else
		unless @contact_dual.phones.where(:text => phones).exists?	
		  @contact_dual.phones.create!(
		    :number => phones,
		    :_type => 'PhonePersonal'
		  )
		end
	      end
	    end 
	    
	    if contact["gContact:website"]
	      urls = contact["gContact:website"]
	      if urls.kind_of?(Array) == true
		urls.each do |url|
		  unless @contact_dual.urls.where(:text => url['href']).exists?	
		    @contact_dual.urls.create!(
		      :text => url['href'],
		      :_type => 'UrlPersonal'
		    )
		  end
		end		
	      else
		unless @contact_dual.urls.where(:text => urls['href']).exists?	
		  @contact_dual.urls.create!(
		    :text => urls['href'],
		    :_type => 'UrlPersonal'
		  )
		end
	      end
	    end 
	    
	    if contact["gd:structuredPostalAddress"]
	      addresses = contact["gd:structuredPostalAddress"]
	      if addresses.kind_of?(Array) == true
		addresses.each do |address|
		  unless @contact_dual.addresses.where(:full_address => address['gd:formattedAddress']).exists?	
		    @contact_dual.addresses.create!(
		      :full_address => address['gd:formattedAddress'],
		      :_type => 'AddressPersonal'
		    )
		  end
		end		
	      else
		unless @contact_dual.addresses.where(:full_address => addresses['gd:formattedAddress']).exists?	
		  @contact_dual.addresses.create!(
		    :full_address => addresses['gd:formattedAddress'],
		    :_type => 'AddressPersonal'
		  )
		end
	      end
	    end 
	    
	    
	    
	  end	  
	end
      end
    end
    @google_contacts = GoogleContact.where(:user_id => current_user.id).asc(:name)
    #would be nice if this was kept to just the exists clause, OC, check contact.rb clear_delete method
    @google_contacts = @google_contacts.any_of({ :contact_id.exists => false }, { :contact_id => "" }) 
    
    ##TODO
    #return enriched count or merged count
    #check for changes to existing contact info and enhance existing contacts, separate sync button I think

    respond_to do |format|
      format.json { render :json => contacts }
    end
  end
  
  def import_facebook
    id = current_user.id    
    @import_count = ImportFacebook.import(id)    

    respond_to do |format|
      format.json { render :json => @import_count }
    end

  end
  
  def import_twitter
    id = current_user.id    
    @import_count = ImportTwitter.import(id) 
    
    respond_to do |format|
      format.json { render :json => @import_count }
    end
  end
  
  def import_linkedin
    id = current_user.id
    @import_count = ImportLinkedin.import(id)

    respond_to do |format|
      format.json { render :json => @import_count }
    end
  end
  
  def create
    if params[:faces]
      faces = params[:faces]
      id = current_user.id
      faces.each do |face|
        name = face[1]['name']
        check = face[1]['check']
	face_id = face[1]['face_id']
	avatar = 'https://graph.facebook.com/' + face_id + '/picture?size=square'
        if check  
          contact = Contact.new(:name => name, :user_id => id, :facebook_id => face_id, :avatar => avatar)
          contact.save
	  friend = FacebookFriend.where(:facebook_id => face_id, :user_id => id).first
	  friend.contact_id = contact._id
	  friend.save
        end   
	#contact = Contact.new(:name => name, :user_id => id)
	#contact.save
	#print face[0]["name"]
	#print "testing"
	#print face('name')
      end
    end
    
    if params[:connections]
      connections = params[:connections]
      id = current_user.id
      @user = User.find(id)
      connections.each do |connection|
	check = connection[1]['check']
	name = connection[1]['name']
	connection_id = connection[1]['connection_id']	
	if check
	  person = @user.linkedin.profile(:id => connection_id, :fields => [:picture_url, :public_profile_url])
	  if person.picture_url != nil
	    picture = person.picture_url
	  else
	    picture = ""
	  end
	  contact = Contact.new(:name => name, :user_id => id, :linkedin_id => person.public_profile_url, :avatar => picture)
          contact.save
	  connection = LinkedinConnection.where(:linkedin_id => connection_id, :user_id => id).first
	  connection.contact_id = contact._id
	  connection.save
	end
      end
    end
    redirect_to(user_path(:id => current_user.id))
    #redirect_to current_user
  end
  
end

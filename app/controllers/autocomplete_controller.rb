class AutocompleteController < ApplicationController
  def wonderbar
    # the autocomplete library needs a result in the form of
    # [{"label":"foo","value":"foo"},{"label":"bar","value":"bar"}]
    # or
    # [{"value":"foo"},{"value":"bar"}] if label and value are the same
    #
    # in this case we grab all movies that begin with the typed term and
    # rename the name attribute to value for convenience
    #users = User.excludes(:id => current_user.id)
    #users = users.where(:full_name => /#{params[:term]}/i).asc(:name).limit(8)
    groups = Group.where(:user_id => current_user.id)
    groups = groups.where(:name => /#{params[:term]}/i).asc(:name).limit(8)
    #tasks = Task.where(:user_id => current_user.id)
    #tasks = tasks.where(:title => /#{params[:term]}/i).asc(:name).limit(8)
    contacts = Contact.where(:user_id => current_user.id)
    contacts = contacts.where(:name => /#{params[:term]}/i).asc(:name).limit(8)
    list = contacts.map {|u| Hash[ id: u.id, label: u.name, name: u.name, avatar: u.avatar, category: "Contact", icon: "dicon-user"]} + groups.map {|u| Hash[ id: u.id, label: u.name, name: u.name, avatar: u.avatar, category: "Group", icon: "dicon-circles"]} 
    #render json: list
    render :json => list.to_json
  end
  
  def contacts
    contacts = Contact.where(:user_id => current_user.id)
    contacts = contacts.where(:name => /#{params[:term]}/i).asc(:name).limit(8)
    list = contacts.map {|u| Hash[ id: u.id, label: u.name, name: u.name, avatar: u.avatar, category: "Contact", icon: "dicon-user"]}
    render :json => list.to_json
  end
  
  def hashtags
    hashtags = Hashtag.where(:user_id => current_user.id)
    hashtags = hashtags.where(:text => /#{params[:term]}/i).asc(:name).limit(8)
    list = hashtags.map {|u| Hash[ id: u.id, label: u.text, name: u.text, category: "Hashtag", icon: "icon-avatar"]}
    render :json => list.to_json
  end
end

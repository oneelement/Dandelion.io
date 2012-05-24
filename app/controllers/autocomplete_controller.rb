class AutocompleteController < ApplicationController
  def wonderbar
    # the autocomplete library needs a result in the form of
    # [{"label":"foo","value":"foo"},{"label":"bar","value":"bar"}]
    # or
    # [{"value":"foo"},{"value":"bar"}] if label and value are the same
    #
    # in this case we grab all movies that begin with the typed term and
    # rename the name attribute to value for convenience
    groups = Group.where(:user_id => current_user.id)
    groups = groups.where(:name => /#{params[:term]}/i)
    tasks = Task.where(:user_id => current_user.id)
    tasks = tasks.where(:title => /#{params[:term]}/i)
    contacts = Contact.where(:user_id => current_user.id)
    contacts = contacts.where(:name => /#{params[:term]}/i)
    list = contacts.map {|u| Hash[ id: u.id, label: u.name, name: u.name, category: "Contact", icon: "icon-avatar"]} + tasks.map {|u| Hash[ id: u.id, label: u.title, name: u.title, category: "Task", icon: "icon-group"]} + groups.map {|u| Hash[ id: u.id, label: u.name, name: u.name, category: "Group", icon: "icon-group"]}
    #render json: list
    render :json => list.to_json
  end
  
  def contacts
    contacts = Contact.where(:user_id => current_user.id)
    contacts = contacts.where(:name => /#{params[:term]}/i)
    list = contacts.map {|u| Hash[ id: u.id, label: u.name, name: u.name, category: "Contact", icon: "icon-avatar"]}
    render :json => list.to_json
  end
end

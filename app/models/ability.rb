class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new => :new
    alias_action :show => :show
    if user.user_type.name == "Organisation" #is_admin?
      if user.is_admin?
	can :manage, User, :organisation_id => user.organisation_id
	can :manage, Entity #, :id => user.entity_id	
      else
	can :update, User, :id => user.id
	can :read, User, :organisation_id => user.organisation_id
	cannot :manage, Entity
      end
      cannot :manage, Organisation
    elsif user.user_type.name == "Entity"
      if user.is_admin?
	can :manage, User, :entity_id => user.entity_id
	can :update, Entity, :id => user.entity_id	
      else
	can :update, User, :id => user.id
	can :read, User, :entity_id => user.entity_id
	cannot :manage, Entity
      end
      cannot :new, User
      cannot :manage, Organisation
    elsif user.user_type.name == "Superuser"
      can :manage, User #, :organisation_id => user.organisation_id
      can :manage, Entity #, :id => user.entity_id
      can :manage, Organisation
    elsif user.user_type.name == "Consumer"
      #can :update, User, :id => user.id
      can :manage, User, :id => user.id
      can :manage, Contact, :user_id => user.id
      #can :read, User, :id => user.id
      cannot :manage, Entity
      cannot :manage, Organisation
      #cannot :manage, :all
    else
      cannot :manage, :all
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end

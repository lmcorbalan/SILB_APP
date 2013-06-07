class AdminAbility
  include CanCan::Ability

  def initialize(user)
    @user = user || User.new
    @user.roles.each { |role| send(role) }

  end

  def products_admin
    # can :manage, Products
  end

  def content_admin
    # manager
    # can :manage, Content
  end

  def users_admin
    # manager
    can :manage, User
  end

  def reports_admin
    # manager
    # can :manage, Report
  end

  def upkeeps_admin
    # manager
    can :manage, [City, Region, ShippingMethod, ShippingCost]
  end
end
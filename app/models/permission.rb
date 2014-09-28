class Permission
  
  def initialize(user)
    # Visitante
    allow :products, [:index, :show, :view]
    allow :sessions, [:create, :destroy]
    allow :auth, [:failure]
    allow :users, [:show]
    allow :votes, [:index]
    allow :comments, [:index]

    # Miembro
    if user
      allow :products, [:new, :create]
      allow :votes, [:vote]
      
      allow :products, [:destroy] do |product|
        product.user_id == user.id
      end
      
      allow :users, [:edit, :update] do |u|
        u.id == user.id
      end

      allow :comments, [:create] do |comment|
        user.reputation >= Const::REPUTATION_COMMENT || comment.product.user == user
      end
      
    end
    
    # Administrador
    if user && user.admin
      allow_all
    end
  end
  
  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
    
  end
  
  def allow_all
    @allow_all = true
  end
  
  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end

  def allow_param(resources, attributes)
    @allowed_params ||= {}
    Array(resources).each do |resource|
      @allowed_params[resource] ||= []
      @allowed_params[resource] += Array(attributes)
    end
  end

  def allow_param?(resource, attribute)
    if @allow_all
      true
    elsif @allowed_params && @allowed_params[resource]
      @allowed_params[resource].include? attribute
    end
  end

  def permit_params!(params)
    if @allow_all
      params.permit!
    elsif @allowed_params
      @allowed_params.each do |resource, attributes|
        if params[resource].respond_to? :permit
          params[resource] = params[resource].permit(*attributes)
        end
      end
    end
  end
end
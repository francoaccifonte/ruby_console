load 'user.rb'

class AuthenticationManager
  attr_reader :current_user

  VALID_ROLES = {
    'super' => :super,
    'regular' => :regular,
    'read_only' => :read_only
  }

  def initialize
    @current_user = initialize_root_user
    @users = [@current_user]
  end

  def create_user(name:, password:, role:)
    return puts 'UserError: You dont have enough permissions to create a user' unless @current_user.super_user?

    role = parse_role(role)
    # Add here other validations: password, username, etc
    return puts 'UserError: invalid role' if role == :invalid_role
    return puts "UserError: user named #{name} already exists" if find_user(name)

    @users << User.new(name: name, password: password, role: role, creator: @current_user)
  end

  def parse_role(role)
    VALID_ROLES[role.split('=')[1]] || :invalid_role
  end

  def find_user(name)
    @users.detect { |u| u.name == name }
  end

  def update_password(current_password:, new_password:)
    @current_user.update_password(current_password: current_password, new_password: new_password)
  end

  def destroy_user(name:)
    return puts 'UserError: You dont have enough permissions to destroy a user' unless @current_user.super_user?

    @users -= find_user(name)
  end

  def login(user_name:, password:)
    target_user = find_user(user_name)
    return puts "UserError: No user named #{name} was found" unless target_user

    login_result = target_user.login(password)
    return @current_user = target_user if login_result

    puts 'UserError: Invalid password'
  end

  def whoami
    puts "Current user: #{@current_user.name}"
  end

  def can_create_file?
    !@current_user.read_only?
  end

  def can_create_folder?
    !@current_user.read_only?
  end

  def can_delete_file?
    !@current_user.read_only?
  end

  private

  def initialize_root_user
    User.new(name: 'root', password: root_password, role: :super)
  end

  def root_password
    # safely get password from secrets file
    '123'
  end
end

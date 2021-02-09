require 'byebug'
class User
  attr_reader :name, :role

  def initialize(name:, password:, role:, creator: nil)
    @name = name
    @role = role
    @password = password
    @creator = creator
  end

  def login(password)
    password == @password
  end

  def super_user?
    role == :super
  end

  def read_only?
    role == :read_only
  end

  def regular?
    role == :regular
  end

  def create_user(name:, password:, role: '-role=read_only')
    return puts 'You do not have permisson to create another user' unless super_user?
    return puts "User #{name} already exists" if User.find_user(name: name)

    User.new(name: name, password: password, role: role, creator: self)
  end

  def update_password(password:, new_password:)
    return puts 'UserError: Invalid password' unless password == @password

    @password = new_password
  end
end

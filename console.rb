require 'byebug'
require 'yaml'
require 'json'
load 'file_for_console.rb'
load 'folder_for_console.rb'
load 'authentication_manager.rb'
load 'base_console.rb'

class Console < BaseConsole
  def accepted_commands
    base_commands = super
    %w[create_file show metadata create_folder cd destroy ls whereami
       create_user update_password destroy_user login whoami] + base_commands
  end

  def create_file(*args)
    return puts 'UserError: you dont have enough permissions to create a file' unless auth_manager.can_create_file?
    return puts 'ComandError: file name required.' if args.empty?

    name = args.first
    data = args[1..-1].join(' ')
    working_directory.create_file(name: name, data: data, user_name: auth_manager.current_user.name)
  end

  def show(*args)
    return puts 'CommandError: file name required' if args.empty?

    working_directory.print_file_data(args.first, type: :data)
  end

  def metadata(*args)
    return puts 'CommandError: file name required' if args.empty?

    working_directory.print_file_data(args.first, type: :metadata)
  end

  def create_folder(*args)
    return puts 'UserError: you dont have enough permissions to create a folder' unless auth_manager.can_create_folder?
    return puts 'CommandError: folder name required' if args.empty?

    working_directory.create_folder(folder_name: args.first)
  end

  def cd(*args)
    return @working_directory = working_directory.up if args.first == '..'

    folder_name = args.first
    @working_directory = working_directory.cd(folder_name)
  end

  def whereami
    puts working_directory.path
  end

  def ls
    working_directory.list_content
  end

  def destroy(*args)
    return puts 'UserError: you dont have enough permissions to delete files' unless auth_manager.can_delete_file?
    return puts 'CommandError: folder or file name required' if args.empty?

    working_directory.destroy(args.first)
  end

  def create_user(*args)
    return puts 'CommandError: user name required' if args.empty?
    return puts 'CommandError: user password required' if args.length == 1
    return puts 'CommandError: user role required' if args.length == 2
    return puts 'CommandError: invalid flag' unless args[2].match(/-role=.*/)

    auth_manager.create_user(name: args[0], password: args[1], role: args[2])
  end

  def update_password(*args)
    return puts 'CommandError: current password required' if args.empty?
    return puts 'CommandError: new password required' if args.size == 1

    auth_manager.update_password(current_password: args.first, new_password: ags.second)
  end

  def destroy_user(*args)
    return puts 'CommandError: user name required' if args.empty?

    auth_manager.destroy_user(args[0])
  end

  def login(*args)
    return puts 'CommandError: User name required' if args.empty?
    return puts 'CommandError: Password required' if args.size == 1

    auth_manager.login(user_name: args[0], password: args[1])
  end

  def whoami
    auth_manager.whoami
  end
end

def save_session(console, file_name)
  session = YAML.dump(console)
  File.write(file_name, session)
end

def load_session(file_name)
  YAML.load(File.read(file_name))
end

if caller.size.zero? # Program starts here
  console = if ARGV[0] == '-persisted'
              load_session(ARGV[1])
            else
              Console.new
            end
  console.listen
  save_session(console, ARGV[1]) if ARGV[0] == '-persisted'
end

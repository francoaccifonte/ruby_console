require 'byebug'
require 'yaml'
load 'file_for_console.rb'
load 'folder_for_console.rb'

class Console
  attr_accessor :current_user, :exit_signal_received,
                :working_directory
  ACCEPTED_COMMANDS = %w[exit create_file show metadata create_folder cd destroy ls whereami].freeze

  def initialize
    @current_user = 1
    @exit_signal_received = false
    @working_directory = FolderForConsole.new
  end

  def listen
    @exit_signal_received = false
    until exit_signal_received
      action = gets
      send(*parse_action(action))
    end
    self
  end

  private

  def parse_action(action)
    command_and_arguments = action.strip.split(' ')
    command_name = command_and_arguments.first
    arguments = command_and_arguments[1..-1]
    return [command_name.to_sym, *arguments] if ACCEPTED_COMMANDS.include?(command_name)

    [:invalid_command, action]
  end

  def create_file(*args)
    return puts 'ComandError creating file: File name required.' if args.empty?

    name = args.first
    data = args[1..-1].join(' ')
    working_directory.create_file(name: name, data: data)
  end

  def show(*args)
    return puts 'CommandError: file name missing' if args.empty?

    working_directory.print_file_data(args.first)
  end

  def create_folder(*args)
    return puts 'CommandError: folder name missing' if args.empty?

    working_directory.create_folder(args.first)
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

  def exit
    @exit_signal_received = true
  end

  def invalid_command(command)
    puts "Invalid command received: #{command}"
  end
end

def save_session(console)
  session = YAML.dump(console)
  puts session
  file_name = 'session.yaml'
  File.write(file_name, session)
end

def load_session
  YAML.load(File.read('session.yaml'))
end

# console = Console.new
console = load_session
console.listen
save_session(console)

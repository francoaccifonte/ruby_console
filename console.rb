require 'byebug'
require 'yaml'
load 'file.rb'
load 'folder.rb'

class Console
  attr_accessor :current_user, :exit_signal_received,
                :working_directory
  ACCEPTED_COMMANDS = %w[exit create_file show metadata create_folder cd destroy ls].freeze
  SESSION_FILE = 'session.yaml'.freeze

  def initialize
    @current_user = 1
    @exit_signal_received = false
    @working_directory = Folder.new('/')
  end

  def listen
    until exit_signal_received
      begin
        action = gets
        send(*parse_action(action))
      rescue MissingArguments => e
        puts e.message
      end
    end
    persist_console
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
    raise MissingArguments, 'Error creating file: File name required.' if args.empty?

    name = args.first
    data = args[1..-1].join(' ')
    working_directory.create_file(name: name, data: data)
  end

  def exit
    @exit_signal_received = true
  end

  def invalid_command(command)
    puts "Invalid command received: #{command}"
  end

  def persist_console # Validate if the object is changing while its being persisted
    session = YAML.dump(self)
    puts session
    # File.open(SESSION_FILE, 'w') do |f|
    #   f.write(session)
    # end
  end
end

class MissingArguments < StandardError
  attr_reader :message
  def initialize(message)
    @message = message
  end
end

Console.new.listen

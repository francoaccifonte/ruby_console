class BaseConsole
  attr_accessor :current_user, :exit_signal_received,
                :working_directory, :auth_manager

  def initialize
    @working_directory = FolderForConsole.new
    @auth_manager = AuthenticationManager.new
  end

  def listen
    @exit_signal_received = false
    until exit_signal_received
      action = STDIN.gets
      send(*parse_action(action))
    end
    self
  end

  private

  def accepted_commands
    %w[exit]
  end

  def parse_action(action)
    command_and_arguments = action.strip.split(' ')
    command_name = command_and_arguments.first
    arguments = command_and_arguments[1..-1]
    return [command_name.to_sym, *arguments] if accepted_commands.include?(command_name)

    [:invalid_command, action]
  end

  def exit
    @exit_signal_received = true
  end

  def invalid_command(command)
    puts "Invalid command received: #{command}"
  end
end

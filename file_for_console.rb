require 'byebug'

class FileForConsole
  attr_accessor :data, :metadata, :path, :name
  REQUIRED_PARAMS = %i[data metadata path].freeze

  def initialize(params)
    @metadata = params[:metadata]
    @data = params[:data]
    @path = params[:path]
    @name = @path.split('/').last
  end

  def print_data
    puts @data
  end

  def print_metadata
    puts @metadata
  end

  def print
    puts(
      "file: \n#{path}\n\n"\
      "data: \n#{data}\n\n" \
      "metadata: \n\n#{metadata}"
    )
  end
end
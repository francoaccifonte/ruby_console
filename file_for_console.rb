require 'byebug'

class FileForConsole
  attr_accessor :data, :metadata, :path, :name
  REQUIRED_PARAMS = %i[data metadata path].freeze

  def initialize(params)
    @metadata = { created_at: Time.now }
    @data = params[:data]
    @path = params[:path]
    @name = @path.split('/').last
  end

  def print_data
    @metadata[:read_at] = Time.now
    puts @data
  end

  def print_metadata
    puts JSON.pretty_generate(@metadata)
  end

  def print
    puts(
      "file: \n#{path}\n\n"\
      "data: \n#{data}\n\n" \
      "metadata: \n\n#{metadata}"
    )
  end
end

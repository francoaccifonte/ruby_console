require 'byebug'

class File
  attr_accessor :data, :metadata, :path
  REQUIRED_PARAMS = %i[data metadata path].freeze

  def initialize(params)
    @metadata = params[:metadata]
    @data = params[:data]
    @path = params[:path]
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

  def name
    path.split('/').last
  end
end

# class FileInitializationError < StandardError; end

if caller.size.zero?
  File.new(
    data: 'a',
    metadata: 'b',
    path: 'c'
  ).print
end

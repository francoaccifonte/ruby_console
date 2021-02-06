class Folder
  attr_reader :path
  attr_accessor :files, :folders
  def initialize(path)
    @path = path
    @files = []
    @folders = []
  end

  def create_file(name: file_name, data: nil)
    @files << File.new(path: path + name, data: data)
  end

  def create_folder(folder_name)
    @folders << Folder.new(@path + '/' + folder_name)
  end

  def list_content
    file_names = files.pluck(:name)
    folder_names = folders.pluck(:name)
    puts(
      'Files: \n' + files.join(', ') + '\n' \
      'Folders: \n' + folders.join(', ') + '\n' \
    )
  end
end

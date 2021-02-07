class FolderForConsole
  attr_reader :path, :parent_folder, :name
  attr_accessor :files, :folders
  def initialize(name: nil, parent_folder: nil)
    if parent_folder.nil? && name.nil?
      @path = '/'
      @parent_folder = self
    else
      @path = parent_folder.path + name + '/'
      @parent_folder = parent_folder
      @name = name
    end
    @files = []
    @folders = []
  end

  def create_file(name: file_name, data: nil)
    @files << FileForConsole.new(path: path + name, data: data)
  end

  def create_folder(folder_name)
    @folders << FolderForConsole.new(name: folder_name, parent_folder: self)
  end

  def list_content
    file_names = files.map(&:name)
    folder_names = folders.map(&:name)
    puts(
      "Files: \n\t" + file_names.join("\n\t") + "\n" \
      "Folders: \n\t" + folder_names.join("\n\t") + "\n" \
    )
  end

  def up
    parent_folder
  end

  def cd(folder_name)
    return find_child_folder(folder_name) if folder_names.include?(folder_name)

    puts "Folder #{name} does not include folder #{folder_name}"
    self
  end

  def print_file_data(file_name)
    find_child_file(file_name).print_data
  end

  private

  def folder_names
    folders.map(&:name)
  end

  def find_child_folder(folder_name)
    folders.detect { |f| f.name == folder_name }
  end

  def find_child_file(file_name)
    files.detect { |f| f.name == file_name }
  end
end

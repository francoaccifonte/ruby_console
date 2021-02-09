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

  def create_file(name: file_name, data: nil, user_name:)
    return puts "Error: File #{name} already exists" unless find_child_file(name).nil?

    @files << FileForConsole.new(path: path + name, data: data, user_name: user_name)
  end

  def create_folder(folder_name:)
    return puts "Error: Folder #{name} already exists" unless find_child_folder(folder_name).nil?

    @folders << FolderForConsole.new(name: folder_name, parent_folder: self)
  end

  def list_content
    file_names = files.map(&:name)
    folder_names = folders.map(&:name)
    puts(
      "Files: \n\t" + file_names.join("\n\t") +
      "\nFolders: \n\t" + folder_names.join("\n\t")
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

  def print_file_data(file_name, type:)
    target_file = find_child_file(file_name)
    return "File #{file_name} does not exist" if target_file.nil?
    return target_file.print_data if type == :data

    target_file.print_metadata if type == :metadata
  end

  def destroy(file_or_folder)
    folder = find_child_folder(file_or_folder)
    return @folders -= [folder] unless folder.nil?

    file = find_child_file(file_or_folder)
    return @files -= [file] unless file.nil?

    puts "Error: no file or folder named #{file_or_folder} found"
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

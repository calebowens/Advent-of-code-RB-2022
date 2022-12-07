class Seven < Day
  class Folder
    attr_reader :parent, :size, :sub_folders

    def initialize(parent)
      @parent = parent
      @size = 0
      @sub_folders = []
    end

    def navigate(folder_name)
      folder = Folder.new(self)

      @sub_folders.push folder

      folder
    end

    def add_file(size)
      @size += size

      @parent.add_file(size) if @parent
    end
  end

  def initialize
    instructions = File.readlines('seven.txt', chomp: true)

    current_folder = Folder.new(nil)
    @root = current_folder

    instructions.shift # cd / is meaningless

    while instructions.size != 0
      if instructions.first.start_with? '$ cd'
        folder = instructions.first[5..]

        if folder == '..'
          current_folder = current_folder.parent
        else
          current_folder = current_folder.navigate(folder)
        end

        instructions.shift
      elsif instructions.first.start_with? '$ ls'
        instructions.shift

        while instructions.first && !instructions.first.start_with?('$')
          unless instructions.first.start_with? 'dir'
            current_folder.add_file(instructions.first.split(' ').first.to_i)
          end

          instructions.shift
        end
      end
    end
  end

  def part_a(folder = @root)
    out = folder.sub_folders.sum(0) { part_a(_1) }
    out += folder.size if folder.size < 100000
    out
  end

  def part_b
    sizes = directory_sizes

    required_space = @root.size - 40000000

    sizes.select { _1 > required_space }.sort.first
  end

  def directory_sizes(folder = @root)
    out = folder.sub_folders.sum([]) { directory_sizes(_1) }
    out.push folder.size
    out
  end
end

# makemakefileincludeme
# akemakefileincludemem
# kemakefileincludemema
# emakefileincludememak
# makefileincludememake
# akefileincludememakem
# kefileincludememakema
# efileincludememakemak
# fileincludememakemake
# ileincludememakemakef
# leincludememakemakefi
# eincludememakemakefil
# includememakemakefile
# ncludememakemakefilei
# cludememakemakefilein
# ludememakemakefileinc
# udememakemakefileincl
# dememakemakefileinclu
# ememakemakefileinclud
# memakemakefileinclude
# emakemakefileincludem
# makemakefileincludeme

require 'set'
require 'enumerator'
require 'kconv'

module Enumerable
  def dfs(visited = Set.new, &blk)
    return if visited.include?(self)
    
    blk.call self
    visited << self
    
    each {|x| x.dfs(visited, &blk) }
  end
end

class Makemakefileincludeme
  attr_reader :objs, :includes, :source_header_dependencies, :object_source_dependencies, :header_header_dependencies
  
  def self.makemakefileincludeme(dir, out)
    new(dir).write(out)
  end
  
  def initialize(dir)
    @dir = dir
  end
  
  def write(f=$stdout)
    calculate unless @calculated
    
    f.puts objs
    f.puts
    f.puts header_header_dependencies
    f.puts
    f.puts source_header_dependencies
    f.puts
    f.puts object_source_dependencies
    
    self
  end
  
  def calculate
    sources = Sources.new(@dir)
    
    includes = sources.header_dirs
    
    hhdeps = {}
    shdeps = {}
    osdeps = {}
    
    main = sources.find_source(File.join(@dir, 'main'))
    all = main.all_related_sources
    
    all.each do |source|
      if source.header?
        h = source
        hhdeps[h.path] = h.depending_headers
      else
        c = source
        osdeps[obj_path(c)] = [c]
        shdeps[c] = c.depending_headers
      end
    end
    
    objs = osdeps.keys
    
    @objs = file_list('OBJS', objs)
    @header_header_dependencies = dep_list(hhdeps)
    @source_header_dependencies = dep_list(shdeps)
    @object_source_dependencies = dep_list(osdeps, compile_command)
    
    @calculated = true
    
    self
  end
  
  private
  def obj_path(c)
    "$(OBJDIR)/#{c.name.gsub(c.ext, '.$(O)')}"
  end
  
  def file_list(name, list, separator=" \\\n  ")
    (["#{name} ="] + list.sort).join(separator)
  end
  
  def dep_list(hash, command=nil)
    command &&= "\n\t#{command}\n"
    
    hash.
      reject {|k,v| v.empty? }.
      map {|c,h| "#{c}: #{h.map {|x| x.to_s }.sort.join(' ')}#{command}" }.
      sort.
      join("\n")
  end
  
  def compile_command
    "$(CC) $(CFLAGS) -I#{@dir} $(CC_OBJ_OUT_FLAG)$@ -c $?"
  end

  class Sources
    include Enumerable
    
    def initialize(dir)
      @dir = dir
      files = Dir[File.join(dir, '**/*.{c,h,cc,cpp,hpp}')]
      @sources = files.map {|f| Source.new(self, f) }
      @index_cache = {}
    end
    
    def header_dirs
      @header_dirs ||= make_header_dirs
    end
    
    def [](name)
      @index_cache[name] ||= find_file(name)
    end
    
    def each(&blk)
      @sources.each(&blk)
    end
    
    def find_source(name)
      sources = %w/c cc cpp/.map {|ext| self["#{name}.#{ext}"] }.compact
      
      if sources.length > 1
        raise FileNameConflictError, %_multiple file exists for module "#{name}": "#{sources.join '" and "'}"_
      end
      
      sources[0]
    end
    
    private
    def make_header_dirs
      @sources.map {|s| s.dir if s.header? }.compact.sort.uniq
    end
    
    def find_file(str)
      @sources.find {|s| s.path == str || s.path == File.join(@dir, str) }
    end
  end

  class Source
    attr_reader :path
    
    include Enumerable
    
    def initialize(sources, path)
      @sources = sources
      @path = path
    end
    
    alias to_s path
    
    def name
      File.basename(path)
    end
    
    def ext
      File.extname(path)
    end
    
    def dir
      File.dirname(path)
    end
    
    def header?
      ext == '.h' || ext == '.hpp'
    end
    
    def each(&blk)
      depending_headers.each(&blk)
      depending_sources.each(&blk)
    end
    
    def all_related_sources
      enum_for(:dfs).to_set
    end
    
    def depending_headers
      @depending_headers ||= make_depending_headers
    end
    
    def depending_sources
      @depending_sources ||= make_depending_sources
    end
    
    private
    def make_depending_headers
      headers = IO.read(path).toutf8.scan(/^#\s*include\s*["<]([^">]*)[">]$/i)
      headers.map {|header_name| @sources[header_name[0]] }.compact
    end
    
    def make_depending_sources
      depending_headers.map {|h| @sources.find_source(h.path.gsub(h.ext, '')) }.compact
    end
  end

  class FileNameConflictError < StandardError
  end
end

if __FILE__ == $0
  dir = 'src'

  begin
    if ARGV.include?('-n')
       Makemakefileincludeme.makemakefileincludeme(dir, STDOUT)
    else
      open('makefileincludeme', 'w') {|f| Makemakefileincludeme.makemakefileincludeme(dir, f) }
    end
  rescue Makemakefileincludeme::FileNameConflictError => e
    abort e
  end
end

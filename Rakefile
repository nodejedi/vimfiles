require 'fileutils'
include FileUtils

task :default => [:coffeetags, :tmp_dirs, :update, :link, :drjs]

desc %(Bring bundles up to date)
task :update do
  sh "git submodule sync >/dev/null"
  sh "git submodule update --init"
  sh "pwd"
  sh "cp -r bundle/ctrlp.vim/autoload/* autoload/"
  sh "cp -r bundle/ctrlp.vim/plugin/* plugin/"
end

desc %(Update each submodule from its upstream)
task :submodule_pull do
  system %[git submodule foreach '
        git pull --quiet --ff-only --no-rebase origin master &&
        git log --no-merges --pretty=format:"%s %Cgreen(%ar)%Creset" --date=relative master@{1}..
        echo
      ']
end

desc %(Make ~/.vimrc and ~/.gvimrc symlinks)
task :link do
  %w[vimrc gvimrc screenrc gemrc ackrc inputrc].each do |script|
    dotfile = File.join(ENV['HOME'], ".#{script}")
    if File.exist? dotfile
      warn "~/.#{script} already exists"
    else
      ln_s File.join('.vim', script), dotfile
    end
  end
end

task :tmp_dirs do
  mkdir_p "_backup"
  mkdir_p "_temp"
end

desc %(Install CoffeeTags)
task :coffeetags do
  sh "gem install CoffeeTags"
end

desc %(Install doctorjs http://drjs.org)
task :drjs do
  Dir.chdir "bundle/doctorjs" do
    sh "pwd"
    sh "git submodule init"
    sh "git submodule update"
    sh "make install"
  end
end
#desc %(Compile Command-T plugin)
#task :command_t => :macvim_check do
#  vim = which('mvim') || which('vim') or abort "vim not found on your system"
#  ruby = read_ruby_version(vim)
#
#  Dir.chdir "bundle/command-t/ruby/command-t" do
#    if ruby
#      puts "Compiling Command-T plugin..."
#      sh(*Array(ruby).concat(%w[extconf.rb]))
#      sh "make clean && make"
#    else
#      warn color('Warning:', 31) + " Can't compile Command-T, no ruby support in #{vim}"
#      sh "make clean"
#    end
#  end
#end

task :macvim_check do
  if mvim = which('mvim') and '/usr/bin/vim' == which('vim')
    warn color('Warning:', 31) + " You have MacVim installed, but `vim` still opens system Vim."
    warn "To use MacVim version when you invoke `vim`:  " + color("$ ln -s mvim #{File.dirname(mvim)}/vim", 37)
  end
end

def color msg, code
  if $stderr.tty? then "\e[1;#{code}m#{msg}\e[m"
  else msg
  end
end

# Read which ruby version is vim compiled against
def read_ruby_version vim
  script = %{require "rbconfig"; print File.join(RbConfig::CONFIG["bindir"], RbConfig::CONFIG["ruby_install_name"])}
  version = `#{vim} --nofork --cmd 'ruby #{script}' --cmd 'q' 2>&1 >/dev/null | grep -v 'Vim: Warning'`.strip
  version unless version.empty? or version.include?("command is not available")
end

# Cross-platform way of finding an executable in the $PATH.
#
#   which('ruby') #=> /usr/bin/ruby
def which cmd
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = "#{path}/#{cmd}#{ext}"
      return exe if File.executable? exe
    }
  end
  return nil
end

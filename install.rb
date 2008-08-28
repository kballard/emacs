# this is not the ruby you're looking for
require 'fileutils'

Joiner = lambda do |base|
  lambda do |*others|
    File.join(base, *others)
  end
end

CurDir = File.dirname( __FILE__ )
Home = Joiner[ File.expand_path( '~' ) ]
Cwd  = Joiner[ CurDir ]

Link = lambda do |target, new|
  if File.exists? Home[ new ] then
    puts("~/#{new} exists.")
  else
    FileUtils.ln_s Cwd[ target ], Home[ new ]
  end
end

Link[ 'emacs.el', '.emacs' ]
Link[ 'emacs.d',  '.emacs.d' ]

Write = lambda do |target, body|
  File.open( Cwd[ target ], "w" ) { |f| f.write body }
end

Exists = lambda do |target|
  File.exists? Cwd[ target ]
end

unless Exists[ "emacs.d/local.el" ]
  Write[ "emacs.d/local.el", '(load "defunkt")' ]
end

Git = lambda do |command|
  `git --git-dir=#{CurDir}/.git #{command}`
end

Git[ 'submodule init' ]
Git[ 'submodule update' ]

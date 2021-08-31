" personal compiler file for my vimtastic script

let current_compiler = "vimtastic"

CompilerSet makeprg=clear;vimtastic\ %:p:S
CompilerSet errorformat=%E%f:%l:\ %m,%-Z%p^,%-C%.%#,%-G%.%#
"CompilerSet errorformat=%f:%l:\ %m,%-G%.%#


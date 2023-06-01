

syn match hash '#\?' contained nextgroup=hashtagtail
syn match hashtagtail '[^\r\n]\+' contained
syn match hashtagargs '([^()]\+)' contained nextgroup=hash
syn match hashtagopen '#[a-zA-Z0-9]\+' nextgroup=hash,hashtagargs
syn match hashtagclose '#/[a-zA-Z0-9]\+#'
syn match hashtaginline '#[a-zA-Z0-9]\+/[^/]*/'

syn match hashcomment '#[*] [^#\r\n]\+'
syn region hashmulticomment start="#[*]#" end="#/[*]#"

hi def link hash Statement
hi def link hashtagtail Type
hi def link hashtagargs Constant
hi def link hashtagopen Statement
hi def link hashtagclose Statement
hi def link hashtaginline Statement

hi def link hashcomment Constant
hi def link hashmulticomment Constant



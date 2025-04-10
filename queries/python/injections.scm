;; Highlight literal strings marked with a function call nvim_highlight_as().
;; Example:
;;    nvim_highlight_as("xml", """<?xml version="1.0"><doc/>")
(
  (call
    function: (identifier) @marker (#eq? @marker "nvim_highlight_as")
    arguments: (argument_list
      (string (string_start) (string_content) @injection.language (string_end))
      (string (string_start) (string_content) @injection.content (string_end))
    )
  )
)

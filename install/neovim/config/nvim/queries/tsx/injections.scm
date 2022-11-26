; Emotion keyframes https://emotion.sh/docs/keyframes <css>
(call_expression
  function: (identifier) @_name (#eq? @_name "keyframes")
  arguments: (template_string) @css
  ; NOTE: do not include the backticks of the template literal
  (#offset! @css 0 1 0 -1))

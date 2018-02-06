  command: 'date "+%H:%M %a %b %d"'

  refreshFrequency: 5000

  render: (output) ->
    "<div>#{output}</div>"

  style: """
    color: white
    font-family: 'Inconsolata LGC'
    font-size: 14px
    background: rgba(black, 0.5)
    padding: 5px 10px
    left: 20px
    bottom: 20px
  """

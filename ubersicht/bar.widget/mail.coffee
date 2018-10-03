  command: './scripts/get_unread_mail'

  refreshFrequency: 10000

  render: (output) ->
    """
    <div><i class="fa fa-envelope" aria-hidden="true"></i> #{output}</div>
    """

  style: """
    font-family: 'Source Code Pro Light'
    color: white
    font-size: 13px
    right: 175px
    bottom: 6px;

    .fa
      display: inline-block
      font: normal normal normal 14px/1 FontAwesome
      font-size: inherit
      text-rendering: auto
      position: relative
      -webkit-font-smoothing: antialiased
      -moz-osx-font-smoothing: grayscale

    .fa-envelope:before
      content: "\\f0e0"
  """

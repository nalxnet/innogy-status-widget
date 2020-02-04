class Dashing.InnogyCp extends Dashing.Widget

  onData: (data) ->
    cp_state = @get('cp_state')

    colorclass = switch
      when cp_state == "AVAILABLE" then 'green'
      when cp_state == "OCCUPIED" then 'yellow'
      when cp_state == "OUT_OF_SERVICE" then 'red'
      else 'gray' # UNKNOWN

    node = $(@node)
    node.removeClass "red yellow green gray"
    node.addClass colorclass

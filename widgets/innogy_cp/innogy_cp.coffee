class Dashing.InnogyCp extends Dashing.Widget

  onData: (data) ->
    cp1_state = @get('cp1_state')
    cp2_state = @get('cp2_state')

    colorclass = switch
      when cp1_state == "AVAILABLE" && cp2_state == "AVAILABLE" then 'green'
      when cp1_state == "OUT_OF_SERVICE" || cp2_state == "OUT_OF_SERVICE" then 'red'
      when cp1_state == "OCCUPIED" || cp2_state == "OCCUPIED" then 'yellow'
      else 'gray'

    node = $(@node)
    node.removeClass "red yellow green gray"
    node.addClass colorclass

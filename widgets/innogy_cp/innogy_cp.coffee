class Dashing.InnogyCp extends Dashing.Widget

  onData: (data) ->
    charger_state = @get('charger_state')

    colorclass = switch
      when charger_state == "AVAILABLE" then 'green'
      when charger_state == "PART_AVAILABLE" || charger_state == "OCCUPIED" then 'yellow'
      when charger_state == "OUT_OF_SERVICE" then 'red'
      else 'gray'

    node = $(@node)
    node.removeClass "red yellow green gray"
    node.addClass colorclass

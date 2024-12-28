# frozen_string_literal: true
require 'app/level_loader'

def tick args
  $Game = Gameplay.new args
  $Game.args = args
  $Game.tick
end

class Gameplay
  attr_gtk

  def initialize args


    args.state.stage = 1
    args.state.level = 1
    args.state.next_level = 1
    args.state.bricks = load_current_level args

  end

  
def tick

    render args



end



def render(args)
  render_background args
  render_center_line args
  render_bricks args

end

begin
  def render_background(args)
    args.outputs.background_color = {r: 0, g: 0, b: 0}
  end

  def render_center_line(args)
    args.outputs.primitives << {primitive_marker: :line, x: 640, y: 0, x2: 640, y2: 720, r: 255, g: 255, b: 255, a: 255, blendmode_enum: 1 }
  end


  def render_bricks(args)
    putz args.state.bricks
    args.outputs.sprites << args.state.bricks
  end

end


end
#end

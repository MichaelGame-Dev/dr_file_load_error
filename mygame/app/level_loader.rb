def check_next_level(args)
  return unless args.state.bricks.count { |b| !b.unbreakable } == 0

  next_level = args.gtk.stat_file "data/level_#{args.state.stage}_#{args.state.next_level}.rblvl"
  return unless next_level

  args.state.level += 1
  load_current_level args
end

def load_current_level(args)
  # args.state.bricks = []
  contents = File.read("data/level_#{args.state.stage}_#{args.state.level}.rblvl")

  args.state.next_level += 1 if args.state.level == args.state.next_level
  return unless contents || !context.strip.empty?

  args.state.bricks = contents.lines.map do |line|
    l = line.strip
    next if l.empty?

    x, y, w, h, color, health, path, moving, *optional_data = l.split ','
    # { x: x.to_f, y: y.to_f, w: w.to_f, h: h.to_f, color: color.to_sym, health: health.to_i, path: path,
    #   anchor_x: 0.5, anchor_y: 0.5 }
    brick = {
      x: x.to_f,
      y: y.to_f,
      w: w.to_f,
      h: h.to_f,
      color: color.to_sym,
      health: health.to_i,
      path: path,
      anchor_x: 0.5,
      anchor_y: 0.5
    }
    brick.moving = moving.to_sym if moving
    optional_data.each do |prop|
      key, value = prop.split(':') # Assume optional data is in "key:value" format
      brick[key.to_sym] = case value
                          when 'true' then true
                          when 'false' then false
                          # when /\A\d+\z/ then value.to_i
                          # when /\A\d+\.\d+\z/ then value.to_f
                          else value.to_sym
                          end
    end
    # putz brick
    brick
  end.compact.uniq
end

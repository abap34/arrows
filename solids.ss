import "./style" as { SolidStyle }
import "./options" as { BlockStyle, ChevronStyle, TaperStyle, SwooshStyle, BentBlockStyle }
import "./geometry" as g

fn draw(geometry: Path, width: Number, height: Number, style: SolidStyle) -> PathShape
  let dimensions = g::size(width, height, style.direction)
  return path_shape(geometry,
    dimensions.width,
    dimensions.height,
    vector_style(style.fill ?? solid_fill(style.color), style.stroke))
end

fn/! block(width: Number = 180, height: Number = 70, style: SolidStyle = SolidStyle {}, shape: BlockStyle = BlockStyle {}) -> PathShape
  let f = g::Frame { direction = style.direction }
  let head = g::clamp(shape.head, 0.05, 0.9)
  let half_shaft = g::clamp(shape.shaft, 0.04, 1) * 0.5
  return draw(path(
    g::move(f, 0, 0.5 - half_shaft),
    g::line(f, 1 - head, 0.5 - half_shaft),
    g::line(f, 1 - head, 0),
    g::line(f, 1, 0.5),
    g::line(f, 1 - head, 1),
    g::line(f, 1 - head, 0.5 + half_shaft),
    g::line(f, 0, 0.5 + half_shaft),
    close_path()
  ), width, height, style)
end

fn/! double_block(width: Number = 180, height: Number = 70, style: SolidStyle = SolidStyle {}, shape: BlockStyle = BlockStyle { head = 0.26 }) -> PathShape
  let f = g::Frame { direction = style.direction }
  let head = g::clamp(shape.head, 0.05, 0.45)
  let half_shaft = g::clamp(shape.shaft, 0.04, 1) * 0.5
  return draw(path(
    g::move(f, 0, 0.5),
    g::line(f, head, 0),
    g::line(f, head, 0.5 - half_shaft),
    g::line(f, 1 - head, 0.5 - half_shaft),
    g::line(f, 1 - head, 0),
    g::line(f, 1, 0.5),
    g::line(f, 1 - head, 1),
    g::line(f, 1 - head, 0.5 + half_shaft),
    g::line(f, head, 0.5 + half_shaft),
    g::line(f, head, 1),
    close_path()
  ), width, height, style)
end

fn/! chevron(width: Number = 180, height: Number = 70, style: SolidStyle = SolidStyle {}, shape: ChevronStyle = ChevronStyle {}) -> PathShape
  let f = g::Frame { direction = style.direction }
  let point = g::clamp(shape.point, 0.05, 0.9)
  let notch = g::clamp(shape.notch, 0, 0.9)
  return draw(path(
    g::move(f, 0, 0),
    g::line(f, 1 - point, 0),
    g::line(f, 1, 0.5),
    g::line(f, 1 - point, 1),
    g::line(f, 0, 1),
    g::line(f, notch, 0.5),
    close_path()
  ), width, height, style)
end

fn/! taper(width: Number = 180, height: Number = 70, style: SolidStyle = SolidStyle {}, shape: TaperStyle = TaperStyle {}) -> PathShape
  let f = g::Frame { direction = style.direction }
  let head = g::clamp(shape.head, 0.05, 0.9)
  let half_shaft = g::clamp(shape.shaft, 0.04, 1) * 0.5
  let half_tail = g::clamp(shape.tail, 0, half_shaft * 2) * 0.5
  return draw(path(
    g::move(f, 0, 0.5 - half_tail),
    g::line(f, 1 - head, 0.5 - half_shaft),
    g::line(f, 1 - head, 0),
    g::line(f, 1, 0.5),
    g::line(f, 1 - head, 1),
    g::line(f, 1 - head, 0.5 + half_shaft),
    g::line(f, 0, 0.5 + half_tail),
    close_path()
  ), width, height, style)
end

fn/! swoosh(width: Number = 180, height: Number = 70, style: SolidStyle = SolidStyle {}, shape: SwooshStyle = SwooshStyle {}) -> PathShape
  let f = g::Frame { direction = style.direction }
  let head = g::clamp(shape.head, 0.05, 0.65)
  let half_shaft = g::clamp(shape.shaft, 0.04, 0.65) * 0.5
  let bend = g::clamp(shape.bend, 0, 1)
  let tail = 0.4 + bend * 0.6
  let upper = 0.4 - half_shaft
  let lower = 0.4 + half_shaft
  return draw(path(
    g::move(f, 0, tail),
    g::quadratic(f, (1 - head) * 0.3, max(0, upper - bend * 0.15), 1 - head, upper),
    g::line(f, 1 - head, 0.05),
    g::line(f, 1, 0.4),
    g::line(f, 1 - head, 0.75),
    g::line(f, 1 - head, lower),
    g::quadratic(f, (1 - head) * 0.35, max(0, lower - bend * 0.15), 0, tail),
    close_path()
  ), width, height, style)
end

fn/! bent_block(width: Number = 180, height: Number = 70, style: SolidStyle = SolidStyle {}, shape: BentBlockStyle = BentBlockStyle {}) -> PathShape
  let f = g::Frame { direction = style.direction }
  let head = g::clamp(shape.head, 0.05, 0.6)
  let turn = g::clamp(shape.turn, 0.2, 0.45)
  let shaft = g::clamp(shape.shaft, 0.04, min(turn * 1.8, (1 - head) * 0.9))
  let tail = g::clamp(shape.tail, turn + shaft * 0.5 + 0.05, 1)
  return draw(path(
    g::move(f, 0, tail),
    g::line(f, 0, turn - shaft * 0.5),
    g::line(f, 1 - head, turn - shaft * 0.5),
    g::line(f, 1 - head, 0),
    g::line(f, 1, turn),
    g::line(f, 1 - head, turn * 2),
    g::line(f, 1 - head, turn + shaft * 0.5),
    g::line(f, shaft, turn + shaft * 0.5),
    g::line(f, shaft, tail),
    close_path()
  ), width, height, style)
end

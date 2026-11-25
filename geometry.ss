import "./style" as { Direction }

type Point { x: Number y: Number }
type Size { width: Number height: Number }

type Frame {
  inset_x: Number = 0
  inset_y: Number = 0
  span_x: Number = 1
  span_y: Number = 1
  direction: Direction = Direction {}
}

fn size(width: Number, height: Number, direction: Direction) -> Size
  if direction.vertical
    return Size { width = height height = width }
  end
  return Size { width = width height = height }
end

fn rotate(x: Number, y: Number, vertical: Bool) -> Point
  if vertical
    return Point { x = 1 - y y = x }
  end
  return Point { x = x y = y }
end

fn point(f: Frame, x: Number, y: Number) -> Point
  let mapped_x = f.inset_x + x * f.span_x
  let mapped_y = f.inset_y + y * f.span_y
  if f.direction.reverse
    return rotate(1 - mapped_x, 1 - mapped_y, f.direction.vertical)
  end
  return rotate(mapped_x, mapped_y, f.direction.vertical)
end

fn move(f: Frame, x: Number, y: Number) -> PathCommand
  let p = point(f, x, y)
  return move_to(p.x, p.y)
end

fn line(f: Frame, x: Number, y: Number) -> PathCommand
  let p = point(f, x, y)
  return line_to(p.x, p.y)
end

fn quadratic(f: Frame, cx: Number, cy: Number, x: Number, y: Number) -> PathCommand
  let c = point(f, cx, cy)
  let p = point(f, x, y)
  return quadratic_to(c.x, c.y, p.x, p.y)
end

fn cubic(f: Frame, ax: Number, ay: Number, bx: Number, by: Number, x: Number, y: Number) -> PathCommand
  let a = point(f, ax, ay)
  let b = point(f, bx, by)
  let p = point(f, x, y)
  return cubic_to(a.x, a.y, b.x, b.y, p.x, p.y)
end

fn clamp(value: Number, low: Number, high: Number) -> Number
  return min(max(value, low), high)
end

fn frame(width: Number, height: Number, padding: Number, direction: Direction) -> Frame
  let inset = min(padding, min(width, height) * 0.22)
  return Frame {
    inset_x = inset / width
    inset_y = inset / height
    span_x = 1 - 2 * inset / width
    span_y = 1 - 2 * inset / height
    direction = direction
  }
end

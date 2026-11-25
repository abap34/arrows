import "./style" as { StrokeStyle }
import "./options" as { CurveStyle, ElbowStyle, BendStyle, ArcStyle, UTurnStyle, LoopStyle, WaveStyle, ZigZagStyle, StepStyle }
import "./geometry" as g
import "./markers" as markers

fn draw(geometry: Path, width: Number, height: Number, style: StrokeStyle) -> PathShape
  let size = min(style.head_size, min(width, height) * 0.6)
  let dimensions = g::size(width, height, style.direction)
  return path_shape(
    geometry,
    dimensions.width,
    dimensions.height,
    vector_style(no_fill(), vector_stroke(style.color, style.width, style.cap, style.join, style.dash, style.dash_offset)),
    markers::marker(style, size, style.ends.start),
    markers::marker(style, size, style.ends.finish)
  )
end

fn frame(width: Number, height: Number, style: StrokeStyle) -> g::Frame
  let padding = max(style.head_size * 0.5 + style.width, style.width)
  return g::frame(width, height, padding, style.direction)
end

fn/! straight(length: Number = 180, style: StrokeStyle = StrokeStyle {}) -> PathShape
  let width = length
  let height = max(style.head_size, style.width) + style.width * 2 + 4
  let f = frame(width, height, style)
  let geometry = path(
    g::move(f, 0, 0.5),
    g::line(f, 1, 0.5)
  )
  return draw(geometry, width, height, style)
end

fn/! curve(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: CurveStyle = CurveStyle {}) -> PathShape
  let f = frame(width, height, style)
  let b = g::clamp(shape.bend, -0.9, 0.9)
  let peak = g::clamp(shape.peak, 0.1, 0.9)
  let base = 0.5 + b * 0.5
  let geometry = path(
    g::move(f, 0, base),
    g::quadratic(f, peak, 0.5 - 1.5 * b, 1, base)
  )
  return draw(geometry, width, height, style)
end

fn/! elbow(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: ElbowStyle = ElbowStyle {}) -> PathShape
  let f = frame(width, height, style)
  let turn = g::clamp(shape.turn, 0.1, 1)
  let radius = g::clamp(shape.roundness, 0, min(turn, 0.8))
  let geometry = path(
    g::move(f, 0, 0),
    g::line(f, turn - radius, 0),
    g::quadratic(f, turn, 0, turn, radius),
    g::line(f, turn, 1)
  )
  return draw(geometry, width, height, style)
end

fn/! bend(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: BendStyle = BendStyle {}) -> PathShape
  let f = frame(width, height, style)
  let balance = g::clamp(shape.balance, 0.1, 0.9)
  let tension = g::clamp(shape.tension, 0, 1)
  let a = g::clamp(balance + tension * 0.25, 0, 1)
  let b = g::clamp(balance - tension * 0.25, 0, 1)
  let geometry = path(
    g::move(f, 0, 1),
    g::cubic(f, a, 1, b, 0, 1, 0)
  )
  return draw(geometry, width, height, style)
end

fn/! arc(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: ArcStyle = ArcStyle {}) -> PathShape
  let f = frame(width, height, style)
  let gap = g::clamp(shape.gap, 0.05, 0.95)
  let geometry = path(
    g::move(f, 1, 0.5 + gap * 0.5),
    g::cubic(f, 1, 1, 0.75, 1, 0.5, 1),
    g::cubic(f, 0.22, 1, 0, 0.78, 0, 0.5),
    g::cubic(f, 0, 0.22, 0.22, 0, 0.5, 0),
    g::cubic(f, 0.75, 0, 1, 0, 1, 0.5 - gap * 0.5)
  )
  return draw(geometry, width, height, style)
end

fn/! u_turn(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: UTurnStyle = UTurnStyle {}) -> PathShape
  let f = frame(width, height, style)
  let depth = g::clamp(shape.depth, 0.1, 1)
  let spread = g::clamp(shape.spread, 0.1, 1)
  let left = (1 - spread) * 0.5
  let right = 1 - left
  let geometry = path(
    g::move(f, left, 1),
    g::line(f, left, depth),
    g::cubic(f, left, -depth / 3, right, -depth / 3, right, depth),
    g::line(f, right, 1)
  )
  return draw(geometry, width, height, style)
end

fn/! loop(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: LoopStyle = LoopStyle {}) -> PathShape
  let f = frame(width, height, style)
  let size = g::clamp(shape.size, 0.1, 0.8)
  let center = g::clamp(shape.position, size * 0.5 + 0.05, 0.95 - size * 0.5)
  let left = center - size * 0.5
  let right = center + size * 0.5
  let exit_y = g::clamp(shape.exit, 0.05, 0.95)
  let geometry = path(
    g::move(f, 0, 0.85),
    g::cubic(f, left, 0.85, right, 1.05, right, 0.4),
    g::cubic(f, right, -0.13, left, -0.13, left, 0.4),
    g::cubic(f, left, 0.9, 0.85, exit_y, 1, exit_y)
  )
  return draw(geometry, width, height, style)
end

fn/! wave(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: WaveStyle = WaveStyle {}) -> PathShape
  let f = frame(width, height, style)
  let a = g::clamp(shape.amplitude, 0, 0.65)
  let b = g::clamp(shape.balance, 0.2, 0.8)
  let geometry = path(
    g::move(f, 0, 0.5),
    g::cubic(f, b * 0.3, 0.5 - a, b * 0.7, 0.5 - a, b, 0.5),
    g::cubic(f, b + (1 - b) * 0.3, 0.5 + a, b + (1 - b) * 0.7, 0.5 + a, 1, 0.5)
  )
  return draw(geometry, width, height, style)
end

fn/! zigzag(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: ZigZagStyle = ZigZagStyle {}) -> PathShape
  let f = frame(width, height, style)
  let a = g::clamp(shape.amplitude, 0, 0.5)
  let skew = g::clamp(shape.skew, -1, 1) * 0.08
  let geometry = path(
    g::move(f, 0, 0.5),
    g::line(f, 0.2 + skew, 0.5 - a),
    g::line(f, 0.4 - skew, 0.5 + a),
    g::line(f, 0.6 + skew, 0.5 - a),
    g::line(f, 0.8 - skew, 0.5 + a),
    g::line(f, 1, 0.5)
  )
  return draw(geometry, width, height, style)
end

fn/! step(width: Number = 180, height: Number = 90, style: StrokeStyle = StrokeStyle {}, shape: StepStyle = StepStyle {}) -> PathShape
  let f = frame(width, height, style)
  let first = g::clamp(shape.first, 0.05, 0.85)
  let second = g::clamp(shape.second, first + 0.05, 0.95)
  let level = g::clamp(shape.level, 0.05, 0.95)
  let geometry = path(
    g::move(f, 0, 1),
    g::line(f, first, 1),
    g::line(f, first, level),
    g::line(f, second, level),
    g::line(f, second, 0),
    g::line(f, 1, 0)
  )
  return draw(geometry, width, height, style)
end

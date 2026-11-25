import "./style" as { StrokeStyle }

;; Every line cap fits inside a circle of diameter sqrt(2) times the line width.
const max_cap_width_ratio: Number = 1.4142135623730951

fn marker(style: StrokeStyle, size: Number, enabled: Bool) -> MarkerStyle?
  if !enabled
    return none
  end
  let result = MarkerStyle {
    path = style.head.geometry
    width = size * max(0.1, style.head.aspect)
    height = size
    fill = solid_fill(style.color)
    stroke = vector_stroke(style.color, style.width * max_cap_width_ratio, LineCap.round, LineJoin.round)
  }
  if style.head.outline
    return result with { fill = no_fill() }
  end
  return result
end

type Direction {
  vertical: Bool = false
  reverse: Bool = false
}

const right: Direction = Direction {}
const down: Direction = Direction { vertical = true }
const left: Direction = Direction { reverse = true }
const up: Direction = Direction { vertical = true reverse = true }

type Head {
  geometry: Path? = path(move_to(1, 0.5), line_to(0, 0), line_to(0, 1), close_path())
  outline: Bool = false
  aspect: Number = 1
}

const triangle: Head = Head {}
const open: Head = Head { geometry = path(move_to(0, 0), line_to(1, 0.5), line_to(0, 1)) outline = true }
const stealth: Head = Head { geometry = path(move_to(1, 0.5), line_to(0, 0), line_to(0.25, 0.5), line_to(0, 1), close_path()) }
const diamond: Head = Head { geometry = path(move_to(1, 0.5), line_to(0.5, 0), line_to(0, 0.5), line_to(0.5, 1), close_path()) }
const dot: Head = Head { geometry = path(move_to(1, 0.5), arc_to(0.5, 0.5, 0, false, true, 0, 0.5), arc_to(0.5, 0.5, 0, false, true, 1, 0.5), close_path()) }
const no_head: Head = Head { geometry = none }

type Ends {
  start: Bool = false
  finish: Bool = true
}

const tip: Ends = Ends {}
const both: Ends = Ends { start = true }
const tail: Ends = Ends { start = true finish = false }
const neither: Ends = Ends { finish = false }

type StrokeStyle {
  color: Color = c"#2563eb"
  width: Number = 3
  head_size: Number = 16
  head: Head = Head {}
  ends: Ends = Ends {}
  dash: String = ""
  dash_offset: Number = 0
  cap: LineCap = LineCap.round
  join: LineJoin = LineJoin.round
  direction: Direction = Direction {}
}

type SolidStyle {
  fill: FillStyle? = none
  stroke: VectorStrokeStyle = no_stroke()
  color: Color = c"#2563eb"
  direction: Direction = Direction {}
}

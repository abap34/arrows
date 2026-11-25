import "./style" as {
  StrokeStyle, SolidStyle, Direction, Head,
  Ends, right, down, left,
  up, triangle, open, stealth,
  diamond, dot, no_head, tip,
  both, tail, neither
}

import "./strokes" as {
  straight, straight!, curve, curve!,
  elbow, elbow!, bend, bend!,
  arc, arc!, u_turn, u_turn!,
  loop, loop!, wave, wave!,
  zigzag, zigzag!, step, step!
}

import "./solids" as {
  block, block!, double_block, double_block!,
  chevron, chevron!, taper, taper!,
  swoosh, swoosh!, bent_block, bent_block!
}

import "./options" as {
  CurveStyle, ElbowStyle, BendStyle, ArcStyle,
  UTurnStyle, LoopStyle, WaveStyle, ZigZagStyle,
  StepStyle, BlockStyle, ChevronStyle, TaperStyle,
  SwooshStyle, BentBlockStyle
}

input ← •FLines "two.txt"

rock_bonus ← 1
paper_bonus ← 2
scisors_bonus ← 3
win ← 6
draw ← 3

combs ← ⟨
  "A X"
  "A Y"
  "A Z"
  "B X"
  "B Y"
  "B Z"
  "C X"
  "C Y"
  "C Z"
⟩
a ← ⟨
  rock_bonus + draw
  paper_bonus + win
  scisors_bonus
  rock_bonus
  paper_bonus + draw
  scisors_bonus + win
  rock_bonus + win
  paper_bonus
  scisors_bonus + draw
⟩

b ← ⟨
  scisors_bonus
  rock_bonus + draw
  paper_bonus + win
  rock_bonus
  paper_bonus + draw
  scisors_bonus + win
  paper_bonus
  scisors_bonus + draw
  rock_bonus + win
⟩

•Out +´ (combs ⊐ input) ⊏ a
•Out +´ (combs ⊐ input) ⊏ b

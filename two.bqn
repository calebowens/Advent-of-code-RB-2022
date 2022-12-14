input ← •FLines "two.txt"

rock_bonus ← 1
paper_bonus ← 2
scisors_bonus ← 3
win ← 6
draw ← 3

a ← ⟨
  ⟨"A X", rock_bonus + draw⟩
  ⟨"A Y", paper_bonus + win⟩
  ⟨"A Z", scisors_bonus⟩
  ⟨"B X", rock_bonus⟩
  ⟨"B Y", paper_bonus + draw⟩
  ⟨"B Z", scisors_bonus + win⟩
  ⟨"C X", rock_bonus + win⟩
  ⟨"C Y", paper_bonus⟩
  ⟨"C Z", scisors_bonus + draw⟩
⟩

b ← ⟨
  ⟨"A X", scisors_bonus⟩
  ⟨"A Y", rock_bonus + draw⟩
  ⟨"A Z", paper_bonus + win⟩
  ⟨"B X", rock_bonus⟩
  ⟨"B Y", paper_bonus + draw⟩
  ⟨"B Z", scisors_bonus + win⟩
  ⟨"C X", paper_bonus⟩
  ⟨"C Y", scisors_bonus + draw⟩
  ⟨"C Z", rock_bonus + win⟩
⟩

•Out +´ ((0⊸⊑¨ a)⊸⊐ input) ⊏ (1⊸⊑¨ a)

•Out +´ ((0⊸⊑¨ b)⊸⊐ input) ⊏ (1⊸⊑¨ b)

# Drum and Bass Track in Sonic Pi
# Set the BPM to a typical drum and bass tempo
use_bpm 174

# Global mixer settings
set_mixer_control! amp: 0.8

# Drum patterns
live_loop :drums do
  sample :loop_amen, beat_stretch: 4, rate: 1.0, amp: 0.7
  sleep 4
end

# Add some extra percussion
live_loop :percussion, sync: :drums do
  sample :drum_cymbal_closed, amp: 0.5, rate: 1.3 if spread(7, 8).look
  sample :drum_tom_hi_hard, amp: 0.4 if spread(3, 16).rotate(3).look
  sleep 0.25
end

# Deep bassline
live_loop :bass, sync: :drums do
  use_synth :fm
  n = (ring :e1, :e1, :g1, :a1).tick
  
  play n, attack: 0.03, sustain: 0.1, release: 0.3, amp: 0.8, 
       cutoff: rrand(60, 90), res: 0.5
  
  sleep 0.5
end

# Sub bass for added depth
live_loop :sub_bass, sync: :drums do
  use_synth :sine
  use_synth_defaults attack: 0.1, release: 0.2, amp: 0.6
  
  pattern = (ring 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0)
  
  if pattern.tick == 1
    n = (ring :e1, :a0, :g1).choose
    play n, sustain: 0.2
  end
  
  sleep 0.25
end

# Atmospheric pad
live_loop :atmosphere, sync: :drums do
  use_synth :prophet
  use_synth_defaults cutoff: 90, amp: 0.3, attack: 2, release: 2
  
  notes = (chord :e3, :minor7, num_octaves: 2)
  play notes.choose, sustain: 4
  
  sleep 8
end

# Occasional samples for variation
live_loop :samples, sync: :drums do
  sample :ambi_glass_hum, rate: 0.5, amp: 0.2 if one_in(8)
  sample :ambi_drone, rate: 0.25, amp: 0.1 if one_in(16)
  
  sleep 4
end

# Occasional glitchy elements
live_loop :glitch, sync: :drums do
  if one_in(4)
    sample [:glitch_bass_g, :glitch_perc1, :glitch_robot1].choose, 
           rate: (ring 1, 1, 0.5, 1.5).tick, amp: 0.4
  end
  
  sleep 2
end

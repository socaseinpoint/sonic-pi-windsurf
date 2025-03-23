# CRYSTAL CASTLES "KEPT" INSPIRED TRACK (COMPACT VERSION)
# ================================================

use_bpm 120  # Dreamy pace like "Kept"

# Track structure and scales
set :phase, 0  # 0=intro, 1=verse, 2=chorus, 3=breakdown
melody_notes = (ring :e4, :b4, :g4, :fs4, :e4, :b3)  # E minor scale for melancholy
baseline_notes = (ring :e2, :b2, :g2, :fs2)  # Simple bass pattern

# Master clock for song structure
live_loop :clock do
  curr_bar = tick
  set :phase, 0 if curr_bar == 0  # Intro
  set :phase, 1 if curr_bar == 6  # Verse
  set :phase, 2 if curr_bar == 14  # Chorus
  set :phase, 3 if curr_bar == 22  # Breakdown
  set :phase, 1 if curr_bar == 26  # Back to verse
  puts "Bar: #{curr_bar}, Phase: #{get(:phase)}"
  sleep 4
end

# Combined melodic elements (lead + bass)
live_loop :melodics, sync: :clock do
  phase = get(:phase)
  
  # Dreamy lead melody
  with_fx :reverb, mix: 0.8, room: 0.9 do
    with_fx :bitcrusher, bits: (phase < 2 ? 12 : 10), sample_rate: (phase < 2 ? 16000 : 12000) do
      with_synth :dsaw do
        case phase
        when 0  # Intro - sparse notes
          play melody_notes.look, release: 1.5, amp: 0.3, cutoff: 85
          sleep [1, 2].choose
        when 1  # Verse - regular pattern
          play melody_notes.tick, release: 0.8, amp: 0.4, cutoff: 90
          sleep 0.5
        when 2  # Chorus - fuller sound
          play melody_notes.tick, release: 1.0, amp: 0.5, cutoff: 95
          # Occasional harmony
          play melody_notes.look + 7, release: 0.8, amp: 0.3 if one_in(3)
          sleep 0.5
        when 3  # Breakdown - ethereal
          play melody_notes.choose, release: 2.5, amp: 0.25, cutoff: 80
          sleep [1, 1.5].choose
        end
      end
    end
  end
  
  # Bass elements - only play on certain beats to save code space
  if look % 4 == 0
    with_fx :lpf, cutoff: 60 + (phase * 10) do
      with_synth :fm do
        play baseline_notes.tick, release: (phase < 2 ? 1 : 0.8), 
             amp: 0.3 + (phase * 0.05), depth: 1 + (phase * 0.3)
      end
    end
  end
end

# Combined rhythm elements
live_loop :rhythm, sync: :clock do
  phase = get(:phase)
  
  case phase
  when 0  # Intro - minimal beats
    sample :bd_haus, amp: 0.4, rate: 0.8 if one_in(4)
    sleep 1
  when 1, 2  # Verse and chorus
    16.times do |i|
      # Kick drum - "Kept" has a steady, muted kick
      with_fx :lpf, cutoff: (phase == 1 ? 80 : 90) do
        sample :bd_haus, amp: 0.7, rate: 0.8 if i % 4 == 0
      end
      
      # Hi-hats - subtle, consistent
      if phase == 2 || one_in(2)
        sample :drum_cymbal_closed, amp: 0.2, rate: 1.1 if i % 2 == 0
      end
      
      # Snare - muted, distant on 2 and 4
      if (i == 4 || i == 12)
        with_fx :bitcrusher, bits: 8, sample_rate: 8000 do
          with_fx :reverb, mix: 0.6 do
            sample :sn_dolf, amp: 0.4, rate: 0.9
          end
        end
      end
      
      sleep 0.25
    end
  when 3  # Breakdown - sparse percussion
    sample :bd_haus, amp: 0.3, rate: 0.7, cutoff: 70 if one_in(8)
    sleep 0.5
  end
end

# Combined atmospheric elements (pads + vocals)
live_loop :atmosphere, sync: :clock do
  phase = get(:phase)
  
  # Ethereal pads
  with_fx :reverb, mix: 0.9, room: 0.95 do
    with_fx :echo, phase: 0.5, decay: 6, mix: 0.4 do
      with_synth :hollow do
        play chord(:e3, :minor), release: (phase == 3 ? 8 : 4), 
             amp: 0.25 + (phase * 0.03), attack: (phase == 0 ? 2 : 1)
      end
    end
  end
  
  # Alice Glass-style ethereal vocals
  if one_in(phase == 2 ? 2 : 4)  # More frequent in chorus
    with_fx :reverb, mix: 0.85, room: 0.9 do
      with_fx :echo, phase: 0.5, decay: 4, mix: 0.6 do
        # "Kept" has dreamy, floating vocals
        sample :ambi_choir, rate: [0.4, 0.5, 0.6, 0.7].choose, 
               amp: 0.2 + (phase * 0.05)
        
        # Bell sounds in chorus
        if phase == 2 && one_in(3)
          with_synth :pretty_bell do
            play (ring :e5, :b4, :g4, :fs4).choose, release: 2, amp: 0.2
          end
        end
      end
    end
  end
  
  sleep 4
end

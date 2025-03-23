# DARK EMOTIONAL WITCH HOUSE TRACK (SALEM-STYLE)
# ============================================

# Slower tempo for witch house feel
use_bpm 70

# Track structure
set :phase, 0  # 0=intro, 1=verse, 2=drop, 3=breakdown

# Dark witch house scales and notes
melody_notes = (ring :e3, :b3, :e4, :fs4, :g4, :b3, :e4)  # Minor scale with dissonance
chords = (ring
  chord(:e3, :minor),       # Em
  chord(:c3, :minor),       # Cm
  chord(:g3, :minor),       # Gm
  chord(:b2, :diminished7)  # Bdim7 - dark and tense
)
bass_notes = (ring :e1, :c1, :g1, :b1)

# Master clock for structure
live_loop :clock do
  curr_bar = tick
  set :phase, 0 if curr_bar == 0   # Intro
  set :phase, 1 if curr_bar == 8    # Verse
  set :phase, 2 if curr_bar == 16   # Drop
  set :phase, 3 if curr_bar == 32   # Breakdown
  set :phase, 1 if curr_bar == 40   # Back to verse
  set :phase, 2 if curr_bar == 48   # Final drop
  puts "Bar: #{curr_bar}, Phase: #{get(:phase)}"
  sleep 4
end

# Dark witch house bass
live_loop :witch_bass, sync: :clock do
  phase = get(:phase)
  idx = tick % 4  # Cycle through bass notes
  
  # Deeper, more present bass in later phases
  amp_val = 0.5 + (phase * 0.1)
  cutoff_val = 70 + (phase * 5)
  
  with_fx :reverb, mix: 0.3, room: 0.7 do
    with_fx :distortion, distort: 0.1 do
      with_synth :fm do
        # Pitched-down, distorted bass typical of witch house
        play bass_notes[idx], release: 4, amp: amp_val, depth: 2, divisor: 0.5, cutoff: cutoff_val
      end
    end
  end
  
  # Add sub bass for extra darkness
  with_fx :lpf, cutoff: 60 do
    with_synth :sine do
      play bass_notes[idx] - 12, release: 4, amp: amp_val * 0.8
    end
  end
  
  sleep 4
end

# Chopped and screwed vocal samples (Salem style)
live_loop :witch_vocals, sync: :clock do
  phase = get(:phase)
  
  case phase
  when 0  # Intro - sparse, distant vocals
    if one_in(3)
      with_fx :reverb, mix: 0.8, room: 0.9 do
        with_fx :echo, phase: 0.75, decay: 8, mix: 0.6 do
          with_fx :pitch_shift, pitch: -4 do  # Pitched down for witch house feel
            sample :ambi_choir, rate: 0.5, amp: 0.4
            sleep 4
          end
        end
      end
    else
      sleep 4
    end
    
  when 1  # Verse - more regular vocal chops
    if one_in(2)
      with_fx :reverb, mix: 0.7, room: 0.8 do
        with_fx :echo, phase: 0.5, decay: 4, mix: 0.5 do
          with_fx :pitch_shift, pitch: -3 do
            # Chopped vocal samples
            sample :ambi_choir, rate: [0.5, 0.6, 0.7].choose, amp: 0.5, start: rrand(0, 0.7), finish: rrand(0.2, 0.9)
            sleep 2
          end
        end
      end
    else
      sleep 2
    end
    
  when 2  # Drop - intense vocal manipulation
    with_fx :reverb, mix: 0.6, room: 0.7 do
      with_fx :echo, phase: 0.25, decay: 2, mix: 0.4 do
        with_fx :pitch_shift, pitch: -5 do
          # Heavily processed vocals
          sample :ambi_choir, rate: [0.4, 0.5, 0.6].choose, amp: 0.6, start: rrand(0, 0.5), finish: rrand(0.1, 0.6)
          
          # Add glitchy effects
          if one_in(3)
            with_fx :bitcrusher, bits: 4, sample_rate: 4000 do
              sample :ambi_choir, rate: [0.3, 0.4].choose, amp: 0.4
            end
          end
          
          sleep 1
        end
      end
    end
    
  when 3  # Breakdown - ethereal, distant vocals
    if one_in(2)
      with_fx :reverb, mix: 0.9, room: 0.95 do
        with_fx :echo, phase: 1, decay: 8, mix: 0.7 do
          with_fx :pitch_shift, pitch: -6 do
            # Ghostly vocals
            sample :ambi_choir, rate: 0.3, amp: 0.5, attack: 0.5, sustain: 0.5
            sleep 4
          end
        end
      end
    else
      sleep 4
    end
  end
end

# Witch house synth melody
live_loop :witch_synth, sync: :clock do
  phase = get(:phase)
  
  case phase
  when 0  # Intro - minimal synth
    if one_in(4)
      with_fx :reverb, mix: 0.7, room: 0.8 do
        with_fx :echo, phase: 0.5, decay: 4, mix: 0.5 do
          with_synth :dark_ambience do
            play melody_notes.choose, release: 3, amp: 0.4, attack: 0.5
            sleep 2
          end
        end
      end
    else
      sleep 2
    end
    
  when 1  # Verse - dark synth pattern
    with_fx :reverb, mix: 0.6, room: 0.7 do
      with_fx :distortion, distort: 0.05 do
        with_synth :prophet do  # Good for dark pads
          play melody_notes.tick, release: 1, amp: 0.5, cutoff: 80
          sleep 1
        end
      end
    end
    
  when 2  # Drop - more intense synth
    with_fx :reverb, mix: 0.5, room: 0.6 do
      with_fx :distortion, distort: 0.1 do
        with_synth :prophet do
          play melody_notes.tick, release: 0.8, amp: 0.6, cutoff: 90
          
          # Add occasional harmony for intensity
          if one_in(3)
            play melody_notes.look + 7, release: 0.8, amp: 0.4  # Add a fifth
          end
          
          sleep 0.5
        end
      end
    end
    
  when 3  # Breakdown - sparse, atmospheric
    if one_in(3)
      with_fx :reverb, mix: 0.8, room: 0.9 do
        with_fx :echo, phase: 0.75, decay: 6, mix: 0.6 do
          with_synth :dark_ambience do
            play melody_notes.choose, release: 4, amp: 0.5, attack: 1
            sleep [2, 4].choose
          end
        end
      end
    else
      sleep 2
    end
  end
end

# Witch house pads and atmosphere
live_loop :witch_pads, sync: :clock do
  phase = get(:phase)
  idx = tick % 4  # Cycle through chord progression
  
  # Different pad sounds for each phase
  case phase
  when 0  # Intro - subtle dark pads
    with_fx :reverb, mix: 0.8, room: 0.9 do
      with_fx :lpf, cutoff: 80 do
        with_synth :hollow do
          play chords[idx], release: 8, amp: 0.4, attack: 2
        end
      end
    end
    
  when 1  # Verse - slightly more present
    with_fx :reverb, mix: 0.7, room: 0.8 do
      with_fx :lpf, cutoff: 90 do
        with_synth :hollow do
          play chords[idx], release: 4, amp: 0.5, attack: 1
        end
      end
    end
    
  when 2  # Drop - darker, more intense
    with_fx :reverb, mix: 0.6, room: 0.7 do
      with_fx :distortion, distort: 0.05 do
        with_synth :hollow do
          play chords[idx], release: 4, amp: 0.6, attack: 0.5
        end
      end
    end
    
  when 3  # Breakdown - ethereal, distant
    with_fx :reverb, mix: 0.9, room: 0.95 do
      with_fx :echo, phase: 0.5, decay: 8, mix: 0.5 do
        with_synth :hollow do
          play chords[idx], release: 8, amp: 0.5, attack: 2
        end
      end
    end
  end
  
  # Add occasional noise sweeps
  if one_in(8)
    with_fx :reverb, mix: 0.7 do
      with_fx :hpf, cutoff: 90 do
        with_synth :noise do
          play :e5, release: 4, cutoff_slide: 4, cutoff: 60, amp: 0.2
        end
      end
    end
  end
  
  sleep 4
end

# Witch house beats - slow, trap-influenced
live_loop :witch_beats, sync: :clock do
  phase = get(:phase)
  
  case phase
  when 0  # Intro - minimal beats
    sample :bd_haus, amp: 0.6, rate: 0.7 if spread(1, 4).tick
    sleep 0.5
    
  when 1, 2  # Verse and drop - witch house beat pattern
    # Typical witch house beat pattern with trap hi-hats
    8.times do |i|
      # Kick drum pattern
      sample :bd_haus, amp: 0.8, rate: 0.7 if i == 0 || i == 4 || i == 6
      
      # Snare/clap on 2 and 4 (witch house style)
      if i == 2 || i == 6
        with_fx :reverb, mix: 0.4 do
          with_fx :distortion, distort: 0.1 do
            sample :sn_dolf, amp: 0.6, rate: 0.8
          end
        end
      end
      
      # Trap-style hi-hats with rolls
      if phase == 2 && (i % 2 == 1)  # More hi-hats in drop
        # Hi-hat rolls
        h_rate = 1.1
        h_amp = 0.3
        
        if i == 3 || i == 7  # Rolls at the end of phrases
          3.times do
            sample :drum_cymbal_closed, amp: h_amp, rate: h_rate
            sleep 0.125
          end
        else
          sample :drum_cymbal_closed, amp: h_amp, rate: h_rate
          sleep 0.5
        end
      else
        # Regular hi-hats
        sample :drum_cymbal_closed, amp: 0.3, rate: 1.1 if i % 2 == 0
        sleep 0.5
      end
    end
    
  when 3  # Breakdown - sparse percussion
    if one_in(4)
      with_fx :reverb, mix: 0.8, room: 0.9 do
        with_fx :echo, phase: 0.75, decay: 4, mix: 0.5 do
          sample :bd_haus, amp: 0.5, rate: 0.6
        end
      end
    end
    sleep 1
  end
end

# Witch house effects and occult atmosphere
live_loop :witch_fx, sync: :clock do
  phase = get(:phase)
  
  # Occult atmosphere and dark ambience
  case phase
  when 0, 3  # Intro and breakdown - more atmospheric
    if one_in(4)
      with_fx :reverb, mix: 0.9, room: 0.95 do
        with_fx :echo, phase: 0.75, decay: 8, mix: 0.7 do
          # Dark ambient sounds
          sample :ambi_dark_woosh, rate: 0.5, amp: 0.4
        end
      end
    end
    
    if one_in(6)
      with_fx :reverb, mix: 0.8 do
        with_fx :pitch_shift, pitch: -2 do
          # Ghostly sounds
          sample :ambi_haunted_hum, rate: 0.5, amp: 0.3
        end
      end
    end
    
  when 1, 2  # Verse and drop - glitchy effects
    if one_in(8)
      with_fx :bitcrusher, bits: 8, sample_rate: 8000 do
        with_fx :echo, phase: 0.25, decay: 4, mix: 0.5 do
          # Glitchy effects
          sample :elec_blip, rate: [0.5, 0.7, 1.5].choose, amp: 0.3
        end
      end
    end
    
    # More intense in drop
    if phase == 2 && one_in(6)
      with_fx :reverb, mix: 0.7 do
        with_fx :distortion, distort: 0.2 do
          # Industrial noise
          sample :elec_cymbal, rate: 0.4, amp: 0.4
        end
      end
    end
  end
  
  sleep 2
end

# Occasional triangle wave synth (witch house staple)
live_loop :witch_triangle, sync: :clock do
  phase = get(:phase)
  
  # Only play during verse and drop
  if (phase == 1 || phase == 2) && one_in(3)
    with_fx :reverb, mix: 0.6, room: 0.7 do
      with_fx :echo, phase: 0.5, decay: 2, mix: 0.4 do
        with_synth :dsaw do  # Triangle-like sound
          play melody_notes.choose, release: 1, amp: 0.4, cutoff: 80
        end
      end
    end
  end
  
  sleep 2
end
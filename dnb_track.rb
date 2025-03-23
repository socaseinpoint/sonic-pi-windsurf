# EPIC DUNGEON SYNTH TRACK WITH FAMILIAR MOTIF
# ==========================================

# Slower, atmospheric tempo for dungeon synth
use_bpm 90

# Track structure and scales
set :phase, 0  # 0=intro, 1=main theme, 2=intense section, 3=mysterious section

# Familiar Zelda-inspired dungeon motif in D minor
zelda_motif = (ring :d4, :d4, :d5, :a4, :gs4, :g4, :f4, :g4, :e4, :d4)

# Dungeon synth chord progression
chords = (ring
  chord(:d3, :minor),      # Dm
  chord(:a2, :minor),      # Am
  chord(:f3, :major),      # F
  chord(:g3, :minor)       # Gm
)

# Bass notes that complement the chord progression
bass_notes = (ring :d2, :a1, :f2, :g2)

# Master clock for song structure
live_loop :clock do
  curr_bar = tick
  set :phase, 0 if curr_bar == 0   # Intro
  set :phase, 1 if curr_bar == 4    # Main theme
  set :phase, 2 if curr_bar == 12   # Intense section
  set :phase, 3 if curr_bar == 20   # Mysterious section
  set :phase, 1 if curr_bar == 28   # Back to main theme
  puts "Bar: #{curr_bar}, Phase: #{get(:phase)}"
  sleep 4
end

# Main melody - Zelda-inspired dungeon theme
live_loop :dungeon_melody, sync: :clock do
  phase = get(:phase)
  
  case phase
  when 0  # Intro - hints of the melody
    with_fx :reverb, mix: 0.8, room: 0.9 do
      with_fx :echo, phase: 0.5, decay: 4, mix: 0.4 do
        with_synth :pretty_bell do  # Bell-like quality for intro
          if one_in(3)
            play zelda_motif.choose, release: 2, amp: 0.4
          end
          sleep 1
        end
      end
    end
    
  when 1  # Main theme - play the familiar motif
    with_fx :reverb, mix: 0.7, room: 0.8 do
      with_fx :distortion, distort: 0.1 do  # Slight grit for dungeon feel
        with_synth :blade do  # Classic dungeon synth sound
          play zelda_motif.tick, release: 0.8, amp: 0.6, cutoff: 90
          sleep [0.5, 0.5, 1].choose  # Rhythmic variation
        end
      end
    end
    
  when 2  # Intense section - faster, more urgent
    with_fx :reverb, mix: 0.6, room: 0.7 do
      with_fx :distortion, distort: 0.2 do
        with_synth :blade do
          play zelda_motif.tick, release: 0.5, amp: 0.7, cutoff: 100
          sleep 0.25  # Faster pace
          
          # Occasional harmony for intensity
          if one_in(3)
            play zelda_motif.look + 5, release: 0.5, amp: 0.5  # Add a fourth
          end
          sleep 0.25
        end
      end
    end
    
  when 3  # Mysterious section - sparse, echoed
    with_fx :reverb, mix: 0.9, room: 0.95 do
      with_fx :echo, phase: 0.75, decay: 6, mix: 0.7 do
        with_synth :hollow do  # Ethereal sound
          play zelda_motif.choose, release: 3, amp: 0.5, cutoff: 80
          sleep [1, 1.5, 2].choose  # Unpredictable timing
        end
      end
    end
  end
end

# Dungeon synth chords and atmosphere
live_loop :dungeon_chords, sync: :clock do
  phase = get(:phase)
  idx = tick % 4  # Cycle through chord progression
  
  # Chord progression with different synths per phase
  with_fx :reverb, mix: 0.8, room: 0.9 do
    with_fx :echo, phase: 0.75, decay: 4, mix: 0.3 do
      case phase
      when 0  # Intro - subtle pad chords
        with_synth :hollow do
          play chords[idx], release: 4, amp: 0.4, attack: 1
        end
      when 1  # Main theme - harpsichord-like chords
        with_synth :pluck do  # Medieval feel
          play chords[idx], release: 3, amp: 0.5, attack: 0.1
        end
      when 2  # Intense section - organ-like chords
        with_synth :blade do
          play chords[idx], release: 2, amp: 0.6, attack: 0.2
        end
      when 3  # Mysterious section - ethereal chords
        with_synth :dark_ambience do
          play chords[idx], release: 6, amp: 0.5, attack: 2
        end
      end
    end
  end
  
  # Bass line that follows the chord progression
  with_fx :lpf, cutoff: 60 do
    with_synth :fm do
      play bass_notes[idx], release: 3.5, amp: 0.7, depth: 2
    end
  end
  
  sleep 4  # One chord per bar
end

# Dungeon atmosphere and sound effects
live_loop :dungeon_atmosphere, sync: :clock do
  phase = get(:phase)
  
  # Atmospheric elements
  with_fx :reverb, mix: 0.9, room: 0.95 do
    with_fx :echo, phase: 0.5, decay: 6, mix: 0.4 do
      # Dungeon wind sounds
      if one_in(4)
        with_synth :noise do
          play :e2, release: 4, cutoff: 70, amp: 0.2
          sleep 4
        end
      end
      
      # Distant dungeon sounds
      if one_in(6)
        sample :ambi_haunted_hum, rate: 0.5, amp: 0.3
      end
      
      # Water drips in dungeon
      if one_in(8) && (phase > 0)
        sample :elec_blip, rate: 0.7, amp: 0.2
      end
      
      # Occasional dungeon door creaks during mysterious section
      if phase == 3 && one_in(5)
        sample :ambi_drone, rate: 0.4, amp: 0.3
      end
    end
  end
  
  sleep 2
end

# Percussion - dungeon footsteps and ambient sounds
live_loop :dungeon_percussion, sync: :clock do
  phase = get(:phase)
  
  case phase
  when 0  # Intro - minimal percussion
    if one_in(6)
      sample :bd_boom, amp: 0.3, rate: 0.6  # Distant boom
    end
    sleep 2
    
  when 1, 2  # Main theme and intense section
    # Dungeon footsteps
    if spread(3, 8).tick
      sample :bd_tek, amp: 0.4, rate: 0.7
    end
    
    # Chains and metal sounds (more in intense section)
    if phase == 2 && one_in(4)
      sample :elec_mid_snare, amp: 0.3, rate: 0.6
    end
    
    # Occasional dungeon door
    if one_in(16)
      sample :bd_boom, amp: 0.5, rate: 0.5
    end
    
    sleep 0.5
    
  when 3  # Mysterious section - sparse, unpredictable percussion
    if one_in(8)
      sample :elec_twip, amp: 0.3, rate: 0.8  # Strange dungeon sound
    end
    
    if one_in(12)
      sample :bd_boom, amp: 0.4, rate: 0.4  # Deep dungeon boom
    end
    
    sleep 1
  end
end

# Familiar 8-bit melody that occasionally plays (Easter egg)
live_loop :familiar_motif, sync: :clock do
  phase = get(:phase)
  
  # Only play during main theme and intense sections
  if (phase == 1 || phase == 2) && one_in(4)
    with_fx :reverb, mix: 0.7 do
      with_fx :bitcrusher, bits: 8, sample_rate: 8000 do  # 8-bit sound
        with_synth :chiplead do  # NES/SNES style sound
          # Familiar "item found" melody
          play_pattern_timed [:b4, :fs4, :d5], [0.1, 0.1, 0.3], amp: 0.4
        end
      end
    end
  end
  
  sleep 4
end

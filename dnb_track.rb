# COMPACT MINIMAL TECHNO (RUFUS DU SOL INSPIRED)
# ==========================================

# Set BPM and define track structure
use_bpm 122
set :section, 0  # 0=intro, 1=build, 2=drop, 3=breakdown
set :prog, 0     # For build progression

# Define chord progression (Rufus Du Sol style emotional progression)
set :chords, (ring
  chord(:c2, :minor),
  chord(:g2, :minor),
  chord(:as2, :major),
  chord(:f2, :major)
)

# Track structure automation
live_loop :clock do
  curr_bar = tick
  # Track section changes
  set :section, 0 if curr_bar == 0
  set :section, 1 if curr_bar == 8 # Build starts earlier in compact version
  set :section, 2 if curr_bar == 16
  set :section, 3 if curr_bar == 24
  set :section, 2 if curr_bar == 28 # Back to drop sooner
  
  puts "Bar: #{curr_bar}, Section: #{get(:section)}"
  sleep 4
end

# Combined rhythmic elements (kick + percussion)
live_loop :rhythm, sync: :clock do
  section = get(:section)
  
  # Pattern depends on section
  case section
  when 0 # Intro
    # Minimal kick and hats
    16.times do |i|
      sample :bd_tek, rate: 0.8, amp: 0.8 if i % 4 == 0
      sample :drum_cymbal_closed, rate: 0.8, amp: 0.2 if i % 2 == 0
      sample :drum_cymbal_pedal, rate: 0.9, amp: 0.2 if i % 8 == 7
      sleep 0.25
    end
  when 1 # Build
    # Calculate build intensity
    set :prog, get(:prog) + 1
    prog = get(:prog)
    build_factor = prog / 16.0
    
    16.times do |i|
      # Intensifying kick
      sample :bd_tek, rate: 0.8, amp: 0.8 + (build_factor * 0.4) if i % 4 == 0
      
      # Intensifying percussion
      sample :drum_cymbal_closed, rate: 0.8 + (build_factor * 0.4), 
             amp: 0.2 + (build_factor * 0.5) if i % 2 == 0
      sample :drum_cymbal_pedal, rate: 0.9, amp: 0.2 + (build_factor * 0.4) if i % 8 == 7
      
      # Add snare build in second half
      if prog > 8 && i % 4 == 2
        sample :sn_dolf, rate: 1.2, amp: 0.1 + ((prog - 8) * 0.05)
      end
      
      sleep 0.25
    end
  when 2 # Drop
    16.times do |i|
      # Full rhythm section
      sample :bd_tek, rate: 0.9, amp: 1.2 if i % 4 == 0
      sample :sn_dolf, rate: 1.1, amp: 0.5 if i % 8 == 4
      
      # Rich hat pattern
      sample :drum_cymbal_closed, rate: 1.1, amp: 0.7 if i % 2 == 0
      sample :drum_cymbal_closed, rate: 1.2, amp: 0.5 if i % 2 == 1 && i % 4 != 3
      sample :drum_cymbal_open, rate: 0.9, amp: 0.4 if i % 8 == 7
      
      # Random organic elements
      sample :perc_snap, rate: choose([0.8, 1.2]), amp: 0.4 if one_in(16)
      
      sleep 0.25
    end
  when 3 # Breakdown
    16.times do |i|
      # Sparse elements
      sample :bd_tek, rate: 0.8, amp: 0.7 if i % 8 == 0
      sample :drum_cymbal_closed, rate: 0.8, amp: 0.3 if i % 4 == 0
      sleep 0.25
    end
  end
end

# Combined melodic and bass elements
live_loop :melodics, sync: :clock do
  section = get(:section)
  
  # Get current chord
  current_chord = get(:chords)[tick % 4]
  root_note = current_chord[0]
  
  case section
  when 0 # Intro
    # Simple bass and pads
    with_fx :reverb, mix: 0.7, room: 0.8 do
      with_synth :fm do
        play root_note, release: 0.7, amp: 0.6, depth: 2
      end
      # Ambient pad
      with_synth :hollow do
        play current_chord, release: 4, amp: 0.4, attack: 0.5
      end
    end
    sleep 4
  when 1 # Build
    # Progressive build intensity
    build_factor = get(:prog) / 16.0
    
    with_fx :reverb, mix: 0.7, room: 0.8 do
      # Bass grows in intensity
      with_synth :fm do
        play root_note, release: 1, amp: 0.6 + (build_factor * 0.4), depth: 2 + build_factor
      end
      
      # Pads swell with filter
      with_fx :lpf, cutoff: 60 + (build_factor * 40) do
        with_synth :hollow do
          play current_chord, release: 4, amp: 0.3 + (build_factor * 0.3), attack: 0.3
        end
      end
      
      # Arpeggios intensify
      if one_in(2) || get(:prog) > 8
        with_fx :echo, phase: 0.75, decay: 4, mix: 0.4 do
          with_synth :sine do
            play current_chord.choose + 12, release: 0.75, 
                 amp: 0.2 + (build_factor * 0.4)
          end
        end
      end
      
      # Add riser in second half of build
      if get(:prog) > 8
        late_build = (get(:prog) - 8) / 8.0
        with_synth :noise do
          play :c1, release: 4, amp: 0.1 + (late_build * 0.3), 
               cutoff: 60 + (late_build * 60)
        end
      end
    end
    sleep 4
  when 2 # Drop
    # Impact sound for first bar of drop
    sample :elec_boom, rate: 0.7, amp: 0.8 if look % 4 == 0
    
    with_fx :reverb, mix: 0.6, room: 0.7 do
      # Bass with movement
      with_fx :slicer, phase: 0.5, wave: 0, amp_min: 0.7 do
        with_synth :fm do
          play root_note, release: 3.5, amp: 0.9, depth: 3
        end
      end
      
      # Main melody - simplified rhythmic pattern
      with_fx :echo, phase: 0.5, decay: 4, mix: 0.3 do
        with_synth :saw do
          # Main chord
          play current_chord, release: 0.25, cutoff: 90, amp: 0.5
          sleep 1
          # Upper register notes
          play current_chord.choose + 12, release: 1, cutoff: 90, amp: 0.4
          sleep 1
          play current_chord.map{|n| n + 12}, release: 0.5, cutoff: 100, amp: 0.3
          sleep 2
        end
      end
      
      # Pads with rhythm
      with_fx :lpf, cutoff: 100 do
        with_synth :hollow do
          play current_chord, release: 4, amp: 0.4, attack: 0.1
        end
      end
    end
    sleep 4
  when 3 # Breakdown
    # Atmospheric elements
    with_fx :reverb, mix: 0.9, room: 0.9 do
      # Sustained bass
      with_synth :fm do
        play root_note, release: 3.5, amp: 0.5, depth: 1.5
      end
      
      # Ambient pad
      with_synth :dark_ambience do
        play current_chord, release: 4, amp: 0.4
      end
      
      # Occasional atmospheric sample
      if one_in(2)
        with_fx :echo, phase: 0.75, decay: 4, mix: 0.5 do
          sample :ambi_choir, rate: 0.5, amp: 0.3
        end
      end
    end
    sleep 4
  end
end

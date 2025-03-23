# NEUROFUNK TRACK
# ==============

# Faster BPM for neurofunk
use_bpm 174

# Define a scale for the track - F minor is common in neurofunk
set :root_note, :f1
set :scale_type, :minor

# Dark atmospheric pad - more minimal for neurofunk
live_loop :neuro_pad do
  # Only play pad occasionally - neurofunk is more sparse with pads
  if one_in(2)
    with_fx :reverb, room: 0.9, mix: 0.6 do
      with_fx :bitcrusher, bits: 8, sample_rate: 8000 do
        with_synth :dark_ambience do
          # Darker notes for neurofunk vibe
          note = (ring get[:root_note], get[:root_note] + 5, get[:root_note] + 7).tick
          play note, release: 8, amp: 0.3, cutoff: 80
        end
      end
    end
  end
  sleep 8
end

# Neurofunk drum pattern - precise and aggressive
live_loop :neuro_drums, sync: :neuro_pad do
  # Neurofunk typically uses precise, programmed drums rather than breaks
  pattern = tick % 4
  
  # Layered kick and snare pattern
  16.times do |i|
    # Kick on 1 and sometimes other beats
    if i % 4 == 0 || (i % 8 == 6 && one_in(2))
      # Layered kick - a neurofunk technique
      sample :bd_tek, amp: 1.2, rate: 0.9
      sample :bd_haus, amp: 0.8, rate: 0.8 # Sub layer
    end
    
    # Snare on 2 and 4
    if i % 4 == 2
      # Layered snare - another neurofunk technique
      sample :sn_dolf, amp: 1.0, rate: 1.1
      sample :elec_hi_snare, amp: 0.5, rate: 1.2 # Top layer
    end
    
    # Ghost snare hits - common in neurofunk
    if i % 8 == 7 && one_in(2)
      sample :sn_dolf, amp: 0.4, rate: 1.2
    end
    
    # Hi-hats - 16th note pattern
    if i % 2 == 0
      sample :drum_cymbal_closed, amp: rrand(0.2, 0.4), rate: 1.3
    elsif i % 4 == 3
      sample :drum_cymbal_closed, amp: 0.3, rate: 1.5
    end
    
    # Add glitchy percussion - characteristic of neurofunk
    if one_in(8)
      sample :elec_blip, amp: 0.4, rate: rrand(0.8, 1.5)
    end
    
    sleep 0.25
  end
end

# SIGNATURE NEUROFUNK REESE BASS
# This is the defining element of neurofunk
live_loop :neuro_bass, sync: :neuro_pad do
  # Neurofunk pattern
  pattern = tick % 4
  
  # Different bass pattern for variation
  case pattern
  when 0
    # Classic neurofunk pattern - 16th notes with rests
    16.times do |i|
      if [0, 2, 3, 6, 8, 10, 11, 14].include?(i)
        neuro_stab(get[:root_note], 0.25)
      end
      sleep 0.25
    end
  when 1
    # Longer notes with modulation
    4.times do
      neuro_stab(get[:root_note], 0.75)
      sleep 1
    end
  when 2
    # Rhythmic pattern
    8.times do |i|
      if i % 2 == 0
        neuro_stab(get[:root_note] + (i % 4), 0.4)
      end
      sleep 0.5
    end
  when 3
    # Famous "Noisia-style" pitch bend pattern
    4.times do
      # Start with root note
      note = get[:root_note]
      # Create pitch bend effect
      with_fx :distortion, distort: 0.4 do
        with_fx :nrlpf, cutoff: 80, cutoff_slide: 1 do |f|
          s = play note, note_slide: 0.15, release: 0.9, 
                  cutoff: 70, cutoff_slide: 0.5, 
                  res: 0.8, amp: 0.8
          # Pitch bend down - signature neurofunk move
          control s, note: note - 2
          control f, cutoff: 120
          sleep 0.75
          control f, cutoff: 60
          sleep 0.25
        end
      end
    end
  end
end

# Define a neurofunk bass stab function
define :neuro_stab do |note, duration|
  # Layer multiple synths - key to neurofunk bass design
  with_fx :distortion, distort: 0.3 do
    with_fx :nrlpf, cutoff: 90, cutoff_slide: duration do |f|
      # Layer 1: Main growl
      with_synth :tb303 do
        s = play note, release: duration, cutoff: 70, 
                cutoff_slide: duration/2, res: 0.85, 
                wave: 1, amp: 0.7
        control s, cutoff: 120
        control f, cutoff: 70
      end
      
      # Layer 2: Sub bass
      with_synth :sine do
        play note - 12, release: duration, amp: 0.8
      end
      
      # Layer 3: Noise element
      with_synth :noise do
        play note, release: duration/4, amp: 0.2, cutoff: 100
      end
    end
  end
end

# Add glitch effects - essential for neurofunk
live_loop :glitch_fx, sync: :neuro_pad do
  # Only play sometimes
  if one_in(3)
    with_fx :bitcrusher, bits: rrand_i(4, 8), sample_rate: rrand(4000, 8000) do
      with_fx :echo, phase: 0.25, decay: 2, mix: 0.4 do
        # Choose a glitch sound
        sample choose([
          :elec_blip,
          :elec_twip,
          :elec_blup,
          :elec_ping
        ]), rate: rrand(0.5, 1.5), amp: 0.4
      end
    end
  end
  sleep 0.25
end

# Add risers and falls - common in neurofunk for transitions
live_loop :risers, sync: :neuro_pad do
  # Only play occasionally for transitions
  if one_in(8)
    with_fx :reverb, room: 0.8, mix: 0.5 do
      with_synth :saw do
        # Rising pitch effect
        play get[:root_note] + 24, release: 8, note_slide: 8, 
             cutoff: 60, cutoff_slide: 8, amp: 0.3
        control note: get[:root_note] + 36, cutoff: 120
      end
    end
  end
  sleep 8
end

# Add occasional robotic vocal samples - common in neurofunk
live_loop :robot_vox, sync: :neuro_pad do
  # Only play occasionally
  if one_in(4)
    with_fx :ring_mod, freq: 50 do
      with_fx :echo, phase: 0.25, decay: 2, mix: 0.4 do
        # Use elec sounds as robotic voice substitutes
        s = sample choose([:elec_hollow_kick, :elec_ping]), 
                   rate: choose([0.5, 0.75]), amp: 0.4
      end
    end
  end
  sleep 4
end

# Add occasional stabs - for tension and release
live_loop :stabs, sync: :neuro_pad do
  # Only play sometimes
  if one_in(3)
    with_fx :reverb, room: 0.6, mix: 0.3 do
      with_synth :blade do
        # Play a chord stab
        play chord(get[:root_note] + 12, :minor), release: 0.3, amp: 0.4
      end
    end
  end
  sleep 2
end

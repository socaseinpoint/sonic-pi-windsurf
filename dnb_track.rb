# DEEP JUNGLE TRACK
# ===============

# Slower BPM for deeper jungle feel
use_bpm 165

# Create a thread for the ambient pad (your original code)
live_loop :ambient_pad do
  with_synth :dsaw do
    # Deeper phase for the slicer
    with_fx(:slicer, phase: [0.5, 0.25].choose, amp_min: 0.6) do
      with_fx(:reverb, room: 0.8, mix: 0.5) do
        # Deeper notes for jungle vibe
        start_note = chord([:b0, :e1, :g1].choose, :minor).choose
        final_note = chord([:b0, :e1, :g1].choose, :minor).choose
        
        p = play start_note, release: 12, note_slide: 6, cutoff: 80, cutoff_slide: 6, 
                detune: rrand(0, 0.3), pan: rrand(-0.7, 0), pan_slide: rrand(4, 8), amp: 0.5
        control p, note: final_note, cutoff: rrand(60, 90), pan: rrand(0, 0.7)
      end
    end
  end
  sleep 12
end

# Add jungle-style chopped breaks
live_loop :jungle_breaks, sync: :ambient_pad do
  # Use a different pattern every 4 bars for variation
  pattern = tick % 8
  
  # Jungle-style break manipulation
  case pattern
  when 0, 4
    # Standard break
    sample :loop_amen, beat_stretch: 4, amp: 0.8
    sleep 4
  when 1, 5
    # Chopped break - first half at normal speed, second half pitched down
    sample :loop_amen, beat_stretch: 4, amp: 0.8, start: 0, finish: 0.5
    sleep 2
    sample :loop_amen, beat_stretch: 8, amp: 0.8, start: 0.5, finish: 0.75, rate: 0.5
    sleep 2
  when 2, 6
    # Stuttered break
    4.times do
      sample :loop_amen, beat_stretch: 4, amp: 0.8, start: 0, finish: 0.25
      sleep 1
    end
  when 3, 7
    # Pitched down break with reverse
    sample :loop_amen, beat_stretch: 8, amp: 0.8, rate: 0.5
    sleep 2
    sample :loop_amen, beat_stretch: 8, amp: 0.7, rate: -0.5, start: 0.25, finish: 0.5
    sleep 2
  end
end

# Add a deep sub bass - essential for jungle
live_loop :sub_bass, sync: :ambient_pad do
  use_synth :sine
  use_synth_defaults release: 0.8, amp: 1.2, cutoff: 80
  
  # Deep sub notes in B minor
  notes = (ring :b0, :b0, :e1, :b0, 
               :g0, :a0, :b0, :fs0)
  
  8.times do
    note = notes.tick
    
    # Add some subtle movement to the sub
    play note, release: rrand(0.7, 1.2)
    
    sleep 0.5
  end
end

# Add a reese bass - characteristic of jungle
live_loop :reese_bass, sync: :ambient_pad do
  use_synth :tb303
  
  # Only play the reese sometimes for variation
  if one_in(3)
    with_fx :distortion, distort: 0.3 do
      with_fx :lpf, cutoff: 70, cutoff_slide: 2 do |f|
        notes = (ring :b1, :b1, :e1, :g1)
        note = notes.tick
        
        s = play note, release: 4, cutoff: 60, res: 0.5, wave: 1, amp: 0.5
        control f, cutoff: 100
      end
    end
    sleep 4
  else
    sleep 4
  end
end

# Add some percussion
live_loop :percussion, sync: :ambient_pad do
  # Hi-hats and percussion
  16.times do |i|
    # Jungle-style percussion pattern
    if i % 16 == 0
      # Occasional 808 kick
      sample :bd_808, amp: 1.2, rate: 0.8
    end
    
    if (i % 4 == 0) || (i % 8 == 6)
      # Closed hi-hat pattern
      sample :drum_cymbal_closed, amp: rrand(0.3, 0.5), rate: rrand(0.9, 1.1)
    end
    
    # Occasional snare
    if i % 8 == 4
      sample :sn_dolf, amp: 0.7, rate: 0.8
    end
    
    # Random percussion hits
    if one_in(12)
      sample :perc_bell, amp: 0.4, rate: rrand(0.8, 1.5)
    end
    
    sleep 0.25
  end
end

# Add jungle-style atmospheric effects
live_loop :jungle_atmos, sync: :ambient_pad do
  # Jungle often uses vocal samples and atmospheric sounds
  if one_in(2)
    # Choose a random atmospheric effect
    effect = choose([
      :ambi_choir,       # Ethereal choir
      :ambi_dark_woosh,  # Dark woosh
      :ambi_haunted_hum, # Spooky hum
      :ambi_lunar_land   # Spacey atmosphere
    ])
    
    # Apply effects to create jungle atmosphere
    with_fx :echo, phase: 0.75, decay: 4, mix: 0.4 do
      with_fx :reverb, room: 0.9, mix: 0.5 do
        sample effect, rate: choose([0.5, 0.25, 0.75]), amp: 0.4
      end
    end
  end
  
  # Occasional ragga vocal stab - classic jungle element
  if one_in(4)
    sample :loop_safari, start: 0.1, finish: 0.2, rate: choose([0.8, 1.0, 1.2]), amp: 0.7
  end
  
  sleep 8
end

# Add occasional dub sirens - classic jungle element
live_loop :dub_siren, sync: :ambient_pad do
  # Only play occasionally
  if one_in(4)
    with_fx :ring_mod, freq: rrand(30, 60) do
      with_synth :sine do
        play scale(:e3, :minor_pentatonic).choose, release: 0.3, amp: 0.3
        sleep 0.125
        play scale(:e4, :minor_pentatonic).choose, release: 0.2, amp: 0.2
      end
    end
  end
  
  sleep 0.25
end

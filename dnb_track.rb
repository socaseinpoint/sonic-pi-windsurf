# DRUM AND BASS WITH AMBIENT PAD
# ===========================

# Set the BPM for drum and bass
use_bpm 174

# Create a thread for the ambient pad (your original code)
live_loop :ambient_pad do
  with_synth :dsaw do
    with_fx(:slicer, phase: [0.25,0.125].choose) do
      with_fx(:reverb, room: 0.5, mix: 0.3) do
        start_note = chord([:b1, :b2, :e1, :e2, :b3, :e3].choose, :minor).choose
        final_note = chord([:b1, :b2, :e1, :e2, :b3, :e3].choose, :minor).choose
        
        p = play start_note, release: 8, note_slide: 4, cutoff: 30, cutoff_slide: 4, 
                detune: rrand(0, 0.2), pan: rrand(-1, 0), pan_slide: rrand(4, 8), amp: 0.6
        control p, note: final_note, cutoff: rrand(80, 120), pan: rrand(0, 1)
      end
    end
  end
  sleep 8
end

# Add drums - classic Amen break
live_loop :drums, sync: :ambient_pad do
  # Use a different pattern every 4 bars for variation
  pattern = tick % 4
  
  if pattern == 3
    # Every 4th pattern, use a different break for variation
    sample :loop_breakbeat, beat_stretch: 4, amp: 0.7
  else
    # Use the Amen break with slight variations
    sample :loop_amen, beat_stretch: 4, amp: 0.7, 
           rate: (pattern == 2 ? 0.95 : 1.0) # Slightly slower on 3rd pattern
  end
  
  sleep 4
end

# Add a rolling bassline
live_loop :bass, sync: :ambient_pad do
  use_synth :fm
  use_synth_defaults release: 0.2, amp: 0.8
  
  # Create a bassline that follows the chord progression
  # Using B minor since that's what the pad is using
  notes = (ring :b1, :b1, :fs1, :g1, 
               :b1, :a1, :g1, :fs1)
  
  16.times do
    # Add some variation with octaves
    note = notes.tick
    
    # Occasionally add some pitch bend for interest
    if one_in(8)
      play note, note_slide: 0.1
      control note, note: note + 0.5
    else
      play note
    end
    
    sleep 0.25
  end
end

# Add some percussion
live_loop :percussion, sync: :ambient_pad do
  # Hi-hats
  16.times do |i|
    # Closed hi-hat pattern with some variation
    if (i % 4 == 0) || (i % 4 == 2) || (one_in(4) && i % 2 == 1)
      sample :drum_cymbal_closed, amp: rrand(0.4, 0.7), rate: rrand(0.9, 1.1)
    end
    
    # Occasional open hi-hat
    sample :drum_cymbal_open, amp: 0.4, rate: 1.1 if i % 8 == 7
    
    sleep 0.25
  end
end

# Add occasional atmospheric effects
live_loop :effects, sync: :ambient_pad do
  # Only play effects sometimes
  if one_in(3)
    # Choose a random effect
    effect = choose([:ambi_glass_hum, :ambi_dark_woosh, :ambi_choir])
    sample effect, rate: choose([0.5, 0.75, 1.0]), amp: 0.3
  end
  
  sleep 8
end

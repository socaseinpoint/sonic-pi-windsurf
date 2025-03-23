# CRYSTAL CASTLES INSPIRED TRACK
# ===========================

# Set faster BPM for aggressive electronic pace
use_bpm 140

# Track structure
set :phase, 0  # 0=intro, 1=beat, 2=glitch chorus, 3=breakdown

# Define notes - Crystal Castles often uses minor scales with dissonance
melody_notes = (ring :e4, :g4, :b4, :c5, :b4, :g4)  # minor scale fragments
baseline_notes = (ring :e2, :e2, :g2, :a2)  # simple pattern
glitch_notes = (ring :e5, :fs5, :g5, :b5, :c6)  # higher register for glitches

# Global FX to add lofi character
with_fx :ixi_techno, phase: 8, phase_offset: 0.5, cutoff_min: 70, cutoff_max: 110, res: 0.5, mix: 0.2 do

  # Master clock
  live_loop :clock do
    curr_bar = tick
    
    # Track structure automation
    set :phase, 0 if curr_bar == 0  # Intro
    set :phase, 1 if curr_bar == 4  # Beat kicks in
    set :phase, 2 if curr_bar == 12  # Glitch chorus
    set :phase, 3 if curr_bar == 20  # Breakdown
    set :phase, 1 if curr_bar == 24  # Back to beat
    set :phase, 2 if curr_bar == 32  # Glitch chorus reprise
    
    puts "Bar: #{curr_bar}, Phase: #{get(:phase)}"
    sleep 4
  end

  # 8-bit style main melody (Crystal Castles signature sound)
  live_loop :chiptune_lead, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro - sparse notes
      with_fx :reverb, mix: 0.7, room: 0.8 do
        with_fx :bitcrusher, bits: 8, sample_rate: 11000 do
          with_synth :dsaw do
            play melody_notes.look, release: 0.3, amp: 0.4, cutoff: 95
            sleep [0.5, 0.5, 0.25, 0.25, 0.5].choose
          end
        end
      end
    when 1  # Main beat
      with_fx :bitcrusher, bits: 8, sample_rate: 12000 do
        with_synth :dsaw do
          play melody_notes.tick, release: 0.2, amp: 0.6, cutoff: 100
          sleep 0.25
        end
      end
    when 2  # Glitch chorus - more intense
      if one_in(3)  # Random glitching effect
        with_fx :krush, gain: 15, cutoff: 130, res: 0.95 do
          with_synth :dsaw do
            3.times do
              play glitch_notes.choose, release: 0.1, amp: 0.6, pan: rrand(-0.7, 0.7)
              sleep 0.125
            end
            sleep 0.125
          end
        end
      else
        with_fx :bitcrusher, bits: 4, sample_rate: 8000 do
          with_synth :dsaw do
            play melody_notes.reverse.tick, release: 0.2, amp: 0.7, cutoff: 110
            sleep 0.25
          end
        end
      end
    when 3  # Breakdown - sparse elements
      if one_in(3)
        with_fx :echo, phase: 0.25, decay: 4 do
          with_fx :distortion, distort: 0.5 do
            with_synth :dsaw do
              play melody_notes.choose, release: 0.5, amp: 0.3
              sleep [0.5, 0.75, 1].choose
            end
          end
        end
      else
        sleep 0.5
      end
    end
  end

  # Distorted beats (Crystal Castles style)
  live_loop :distorted_beats, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro - minimal
      sample :bd_haus, amp: 0.6, rate: 0.9 if spread(3, 8).tick
      sleep 0.5
    when 1, 2  # Main beat and glitch chorus
      # Kick drum pattern
      if phase == 1
        # Regular beat
        sample :bd_haus, amp: 0.9, rate: 0.9 if (spread(4, 16).tick)
      else
        # Glitchier beat
        sample :bd_haus, amp: 1.0, rate: [0.8, 0.9, 1.0].choose if (spread(5, 16).tick)
      end
      
      # Distorted hits
      with_fx :distortion, distort: 0.7 do
        sample :elec_blip, amp: 0.4, rate: 2 if spread(2, 16).look
        sample :elec_blip, amp: 0.3, rate: 1.5 if spread(3, 8).look
      end
      
      # Crystal Castles signature noisy snare
      if phase == 2 && one_in(4)  # Extra glitchy during chorus
        with_fx :krush, gain: 15, mix: 0.7 do
          sample :sn_dolf, amp: 0.6, rate: [0.8, 1.2].choose
        end
      elsif spread(2, 8).look
        with_fx :bitcrusher, bits: 4, sample_rate: 4000 do
          sample :sn_dolf, amp: 0.5, rate: 0.9
        end
      end
      
      sleep 0.25
    when 3  # Breakdown
      # Sparse drums
      if one_in(4)
        with_fx :echo, phase: 0.25, decay: 2 do
          with_fx :distortion, distort: 0.8 do
            sample :bd_haus, amp: 0.6, rate: 0.8
          end
        end
      end
      sleep 0.5
    end
  end

  # Glitchy arpeggios (Crystal Castles often uses these)
  live_loop :glitch_arps, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro
      sleep 4  # Silent during intro
    when 1  # Main beat
      # Simple arpeggio
      with_fx :slicer, phase: 0.25, wave: 0 do
        with_fx :bitcrusher, bits: 10, sample_rate: 10000 do
          with_synth :tb303 do
            play baseline_notes.tick, release: 0.1, cutoff: rrand(80, 100), res: 0.9, amp: 0.5
            sleep 0.25
          end
        end
      end
    when 2  # Glitch chorus - chaotic arpeggios
      # Crystal Castles style controlled chaos
      with_fx :krush, gain: 15, res: 0.8, cutoff: 90 do
        with_fx :bitcrusher, bits: 8, sample_rate: 4000 do
          with_synth :tb303 do
            play baseline_notes.shuffle.tick, release: 0.15, cutoff: rrand(70, 120), 
                 res: 0.95, amp: 0.7, wave: [0, 1].choose
            sleep [0.125, 0.25].choose  # Irregular timing
          end
        end
      end
    when 3  # Breakdown
      # Occasional low notes
      if one_in(4)
        with_fx :reverb, room: 0.9 do
          with_fx :distortion, distort: 0.2 do
            with_synth :tb303 do
              play baseline_notes.choose - 12, release: 2, cutoff: 60, res: 0.5, amp: 0.4
              sleep 0.5
            end
          end
        end
      else
        sleep 0.5
      end
    end
  end

  # Noise and atmospheric elements (typical in Crystal Castles tracks)
  live_loop :noise_textures, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro
      # Ambient noise
      with_fx :reverb, mix: 0.9, room: 0.9 do
        with_fx :echo, phase: 0.25, decay: 4 do
          with_synth :noise do
            play :e2, release: 4, cutoff: rrand(60, 90), amp: 0.3
            sleep 4
          end
        end
      end
    when 1  # Main beat - less noise
      if one_in(3)
        with_fx :hpf, cutoff: 90 do
          with_synth :noise do
            play :e3, release: 0.5, cutoff: 110, amp: 0.2
            sleep 0.5
          end
        end
      else
        sleep 0.5
      end
    when 2  # Glitch chorus - heavy noise elements
      # Crystal Castles uses aggressive noise bursts
      if one_in(3)
        with_fx :krush, gain: 15, cutoff: rand(130) do
          with_fx :distortion, distort: 0.8 do
            with_synth :noise do
              play :e3, release: 0.2, cutoff: rrand(80, 120), amp: 0.4
              sleep 0.25
            end
          end
        end
      else
        sleep 0.25
      end
    when 3  # Breakdown - atmospheric noise
      with_fx :reverb, mix: 0.95, room: 0.9 do
        with_fx :echo, phase: 0.25, decay: 8 do
          with_synth :noise do
            play :e2, release: 2, cutoff: 70, amp: 0.2
            sleep 1
          end
        end
      end
    end
  end

  # Crystal Castles-style vocal chops/samples (simulated)
  live_loop :vocal_chops, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0, 3  # Intro and breakdown - silent
      sleep 4
    when 1  # Main beat - occasional vocal chop
      if one_in(4)
        with_fx :echo, phase: 0.25, decay: 2 do
          with_fx :reverb, mix: 0.7 do
            # Since we don't have actual vocal samples, simulate with these:
            sample [:elec_hollow_kick, :elec_twip, :ambi_choir].choose, rate: [0.5, 0.8, 1.2, 1.5].choose, 
                   amp: 0.4, onset: rand
          end
        end
      end
      sleep 1
    when 2  # Glitch chorus - more vocal elements
      if one_in(3)
        with_fx :krush, gain: 10, res: 0.8, cutoff: 100 do
          with_fx :bitcrusher, bits: 6, sample_rate: 8000 do
            # Crystal Castles often uses heavily processed vocals
            sample [:elec_bell, :elec_twip, :ambi_choir].choose, rate: [0.5, 0.8, 1.2, -0.8].choose, 
                   amp: 0.5, attack: 0.01, sustain: 0.1, release: 0.1
          end
        end
      end
      sleep 0.5
    end
  end
end

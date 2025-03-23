# CRYSTAL CASTLES "KEPT" INSPIRED TRACK
# =================================

# Set slower BPM for dreamy, melancholic pace (like "Kept")
use_bpm 120

# Track structure
set :phase, 0  # 0=intro, 1=verse, 2=chorus, 3=breakdown

# Define notes - "Kept" uses melancholic minor scales with haunting intervals
melody_notes = (ring :e4, :b4, :g4, :fs4, :e4, :b3)  # melancholic e minor
baseline_notes = (ring :e2, :b2, :g2, :fs2)  # simple pattern
vocal_notes = (ring :e5, :b4, :g4, :fs4, :e4)  # for ethereal vocal-like sounds

# Global FX to add dreamy character ("Kept" has a hazy, dreamy quality)
with_fx :reverb, room: 0.9, mix: 0.4 do
with_fx :echo, phase: 0.25, decay: 4, mix: 0.3 do

  # Master clock
  live_loop :clock do
    curr_bar = tick
    
    # Track structure automation ("Kept" has a gradual build structure)
    set :phase, 0 if curr_bar == 0  # Intro
    set :phase, 1 if curr_bar == 8  # Verse (longer intro like "Kept")
    set :phase, 2 if curr_bar == 16  # Chorus
    set :phase, 3 if curr_bar == 24  # Breakdown
    set :phase, 1 if curr_bar == 32  # Back to verse
    set :phase, 2 if curr_bar == 40  # Final chorus
    
    puts "Bar: #{curr_bar}, Phase: #{get(:phase)}"
    sleep 4
  end

  # Dreamy melody ("Kept" has a melancholic, ethereal lead melody)
  live_loop :dreamy_lead, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro - sparse, haunting notes
      with_fx :reverb, mix: 0.8, room: 0.9 do
        with_fx :bitcrusher, bits: 10, sample_rate: 16000 do  # Less crushed than typical CC
          with_synth :dsaw do
            play melody_notes.look, release: 1.5, amp: 0.3, cutoff: 85
            sleep [1, 2].choose  # Slower, more sparse like "Kept"
          end
        end
      end
    when 1  # Verse - main melody like "Kept"
      with_fx :reverb, mix: 0.7, room: 0.8 do
        with_fx :bitcrusher, bits: 12, sample_rate: 16000 do  # Cleaner sound
          with_synth :dsaw do
            play melody_notes.tick, release: 0.8, amp: 0.4, cutoff: 90
            sleep 0.5  # More regular pattern like "Kept"
          end
        end
      end
    when 2  # Chorus - fuller sound but still dreamy
      with_fx :reverb, mix: 0.8, room: 0.9 do
        with_fx :bitcrusher, bits: 10, sample_rate: 12000 do
          with_synth :dsaw do
            play melody_notes.tick, release: 1.0, amp: 0.5, cutoff: 95
            sleep 0.5
            
            # Occasional harmony notes ("Kept" has layered synths)
            if one_in(3)
              play melody_notes.look + 7, release: 0.8, amp: 0.3  # Add a fifth
            end
            sleep 0.5
          end
        end
      end
    when 3  # Breakdown - sparse, ethereal elements
      with_fx :reverb, mix: 0.9, room: 0.95 do
        with_fx :echo, phase: 0.5, decay: 6, mix: 0.7 do
          with_synth :dsaw do
            play melody_notes.choose, release: 2.5, amp: 0.25, cutoff: 80
            sleep [1, 1.5, 2].choose  # Slow, floating notes
          end
        end
      end
    end
  end

  # Dreamy beats ("Kept" has a consistent, muted beat pattern)
  live_loop :kept_beats, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro - minimal, distant beats
      if one_in(4)  # Very sparse
        with_fx :lpf, cutoff: 70 do  # Muted, distant feeling
          sample :bd_haus, amp: 0.4, rate: 0.8
        end
      end
      sleep 1
    when 1, 2  # Verse and chorus - consistent beat like "Kept"
      # "Kept" has a steady, muted kick pattern
      with_fx :lpf, cutoff: (phase == 1 ? 80 : 90) do  # Slightly brighter in chorus
        sample :bd_haus, amp: 0.7, rate: 0.8 if (spread(4, 16).tick)  # Steady quarter notes
      end
      
      # Hi-hats - "Kept" has subtle, consistent hi-hats
      if phase == 2 || one_in(2)  # More hi-hats in chorus
        with_fx :hpf, cutoff: 110 do
          with_fx :bitcrusher, bits: 12, sample_rate: 10000 do  # Subtle lo-fi quality
            sample :drum_cymbal_closed, amp: 0.2, rate: 1.1 if spread(8, 16).look
          end
        end
      end
      
      # Snare - "Kept" has a muted, distant snare on 2 and 4
      if spread(2, 16).look && (look % 16 == 4 || look % 16 == 12)
        with_fx :bitcrusher, bits: 8, sample_rate: 8000 do
          with_fx :reverb, mix: 0.6, room: 0.8 do
            sample :sn_dolf, amp: 0.4, rate: 0.9
          end
        end
      end
      
      sleep 0.25
    when 3  # Breakdown - minimal percussion
      # "Kept" breakdown has sparse, echoed percussion
      if one_in(8)
        with_fx :echo, phase: 0.75, decay: 4, mix: 0.7 do
          with_fx :reverb, mix: 0.8, room: 0.9 do
            sample :bd_haus, amp: 0.3, rate: 0.7
          end
        end
      end
      sleep 0.5
    end
  end

  # Dreamy bass ("Kept" has a soft, pulsing bass)
  live_loop :kept_bass, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro - subtle bass swells
      with_fx :reverb, room: 0.8, mix: 0.5 do
        with_fx :lpf, cutoff: 70 do
          with_synth :fm do  # Softer synth than tb303
            play baseline_notes.tick - 12, release: 4, amp: 0.3, depth: 1
            sleep 4
          end
        end
      end
    when 1  # Verse - pulsing bass like in "Kept"
      with_fx :lpf, cutoff: 80 do
        with_fx :bitcrusher, bits: 12, sample_rate: 12000 do  # Subtle lo-fi quality
          with_synth :fm do
            play baseline_notes.tick, release: 0.8, amp: 0.4, depth: 1.5
            sleep 1  # Regular pulse like in "Kept"
          end
        end
      end
    when 2  # Chorus - slightly more present bass
      with_fx :lpf, cutoff: 85 do
        with_fx :bitcrusher, bits: 10, sample_rate: 10000 do
          with_synth :fm do
            play baseline_notes.tick, release: 1, amp: 0.5, depth: 2
            sleep 1
          end
        end
      end
    when 3  # Breakdown - occasional deep bass notes
      if one_in(3)
        with_fx :reverb, room: 0.9, mix: 0.6 do
          with_fx :lpf, cutoff: 60 do
            with_synth :fm do
              play baseline_notes.choose - 12, release: 4, amp: 0.3, depth: 1
              sleep 2
            end
          end
        end
      else
        sleep 2
      end
    end
  end

  # Dreamy pads and atmosphere ("Kept" has lush, ethereal pads)
  live_loop :kept_atmosphere, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro - ambient, dreamy pads
      with_fx :reverb, mix: 0.9, room: 0.95 do
        with_fx :echo, phase: 0.5, decay: 8, mix: 0.4 do
          with_synth :hollow do  # Ethereal pad sound
            play chord(:e3, :minor), release: 8, amp: 0.3, attack: 2
            sleep 8
          end
        end
      end
    when 1  # Verse - subtle atmospheric elements
      with_fx :reverb, mix: 0.8, room: 0.9 do
        with_fx :lpf, cutoff: 90 do
          with_synth :hollow do
            play chord(:e3, :minor), release: 4, amp: 0.25, attack: 1
            sleep 4
          end
        end
      end
      
      # Occasional subtle noise swells like in "Kept"
      if one_in(4)
        with_fx :hpf, cutoff: 80 do
          with_synth :noise do
            play :e4, release: 2, cutoff: 100, amp: 0.15
            sleep 2
          end
        end
      else
        sleep 2
      end
    when 2  # Chorus - fuller pads
      with_fx :reverb, mix: 0.85, room: 0.9 do
        with_fx :echo, phase: 0.75, decay: 4, mix: 0.3 do
          with_synth :hollow do
            play chord(:e3, :minor), release: 4, amp: 0.35, attack: 0.5
            sleep 4
          end
        end
      end
    when 3  # Breakdown - ethereal atmosphere
      with_fx :reverb, mix: 0.95, room: 0.95 do
        with_fx :echo, phase: 0.75, decay: 8, mix: 0.5 do
          with_synth :hollow do
            play chord(:e3, :minor), release: 8, amp: 0.3, attack: 2
            sleep 8
          end
        end
      end
    end
  end

  # Alice Glass-style ethereal vocals ("Kept" features dreamy, processed vocals)
  live_loop :kept_vocals, sync: :clock do
    phase = get(:phase)
    
    case phase
    when 0  # Intro - occasional ethereal vocal hints
      if one_in(4)
        with_fx :reverb, mix: 0.9, room: 0.95 do
          with_fx :echo, phase: 0.5, decay: 8, mix: 0.7 do
            # Simulate Alice Glass's ethereal vocals in "Kept"
            sample :ambi_choir, rate: 0.5, amp: 0.2
            sleep 4
          end
        end
      else
        sleep 4
      end
    when 1  # Verse - subtle vocal elements
      if one_in(3)
        with_fx :reverb, mix: 0.8, room: 0.9 do
          with_fx :echo, phase: 0.25, decay: 4, mix: 0.6 do
            # "Kept" has dreamy, floating vocals
            sample :ambi_choir, rate: [0.5, 0.6, 0.7].choose, amp: 0.25
            sleep 2
          end
        end
      else
        sleep 2
      end
    when 2  # Chorus - more prominent vocals like in "Kept"
      if one_in(2)  # More frequent
        with_fx :reverb, mix: 0.85, room: 0.9 do
          with_fx :bitcrusher, bits: 12, sample_rate: 16000 do  # Subtle lo-fi quality
            # "Kept" has layered, processed vocals
            sample :ambi_choir, rate: [0.5, 0.6, 0.7, 0.8].choose, amp: 0.3
            
            # Occasionally play a note from the vocal_notes scale
            if one_in(3)
              with_synth :pretty_bell do  # Bell-like quality similar to "Kept"
                play vocal_notes.choose, release: 2, amp: 0.2
              end
            end
            
            sleep 2
          end
        end
      else
        sleep 2
      end
    when 3  # Breakdown - sparse, ethereal vocals
      if one_in(3)
        with_fx :reverb, mix: 0.95, room: 0.95 do
          with_fx :echo, phase: 0.75, decay: 8, mix: 0.8 do
            sample :ambi_choir, rate: 0.4, amp: 0.2
            sleep 4
          end
        end
      else
        sleep 4
      end
    end
  end
end

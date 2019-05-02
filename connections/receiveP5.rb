
##| run this after setting up visuals and Serial
##| command-r: start, commend-s: stop
##| sometimes you probably need to restart the program for refreshing OSC input

set_sched_ahead_time! 0.0001
use_debug false

##| change path to your local files (need to be complete paths)
amb = "/Users/yanwendong/Desktop/CoreLab/final/test/connections/amb.wav"
bird = "/Users/yanwendong/Desktop/CoreLab/final/test/connections/bird.wav"
cricket1 = "/Users/yanwendong/Desktop/CoreLab/final/test/connections/cricket.wav"
cricket2 = "/Users/yanwendong/Desktop/CoreLab/final/test/connections/cricket2.wav"

am = 0 ##| global var for pot amplitude
am2 = 0

##| ----------- potentiometer events -----------
##| contol amplitude of p1_1/2, p2_1
live_loop :p1 do
  po_1 = sync "/osc/toPi"
  am = po_1[3]*0.001
end

live_loop :p2 do
  po_2 = sync "/osc/toPi"
  am2 = po_2[4]*0.001
end

##| pot 1: play cricket sounds
live_loop :p1_1 do
  sample cricket1, amp: am
  sleep 1
end
live_loop :p1_2 do
  sample cricket2, amp: am
  sleep 1.5
end

##| pot 2: play generative ambient sounds
with_fx :reverb, room: 1 do
  live_loop :p2_1 do
    use_synth :dark_ambience
    play_chord (chord_degree rrand_i(1,5), :c, :minor_pentatonic, rrand_i(1,5)),
      attack: 1, release: 6, amp: am2
    sleep 2
  end
end


##| ----------- button events -----------
##| play specific short sounds when triggered

##| chord degree (d), which note (cdefgab), scale (minor, major, _pentatonic),
##| octaves, how much to invert (lower/higher i num of octave)

live_loop :b1 do
  bu_1 = sync "/osc/toPi"
  if (bu_1[0] == 1)
    use_synth :growl
    [1, 2].each do |d|
      (range -1, 1).each do |i|
        play_chord (chord_degree d, :c, :major_pentatonic, 2, invert: i),
          release: 3, amp: 5
        sleep 0.25
      end
    end
  end
end

live_loop :b2 do
  bu_2 = sync "/osc/toPi"
  if (bu_2[1] == 1)
    use_synth :sine
    [3, 4].each do |d|
      (range -1, 1).each do |i|
        play_chord (chord_degree d, :c, :major_pentatonic, 2, invert: i),
          release: 0.5, amp: 5
        sleep 0.25
      end
    end
  end
end

live_loop :b3 do
  bu_3 = sync "/osc/toPi"
  if (bu_3[2] == 1)
    use_synth :hollow
    [5, 6].each do |d|
      (range -1, 1).each do |i|
        play_chord (chord_degree d, :c, :major_pentatonic, 2, invert: i),
          release: 3, amp: 5
        sleep 0.25
      end
    end
  end
end





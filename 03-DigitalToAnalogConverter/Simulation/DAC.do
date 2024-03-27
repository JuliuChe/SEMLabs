onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dac_tb/reset
add wave -noupdate /dac_tb/clock
add wave -noupdate -divider {parallel to serial}
add wave -noupdate -format Analog-Step -height 100 -max 66000.0 -radix unsigned /dac_tb/parallelIn
add wave -noupdate /dac_tb/serialOut
add wave -noupdate -divider {serial to parallel}
add wave -noupdate -format Analog-Step -height 100 -max 65500.000000000007 -radix unsigned /dac_tb/lowpassOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88797414 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 175
configure wave -valuecolwidth 63
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ps} {105 us}

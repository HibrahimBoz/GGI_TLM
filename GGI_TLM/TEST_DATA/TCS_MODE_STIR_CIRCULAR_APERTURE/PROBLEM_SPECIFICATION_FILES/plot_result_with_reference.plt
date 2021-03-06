#JPG set term jpeg

#OUTPUT_TO_FILE set output "Test_case_40_TCS_MODE_STIR_field_ref.jpg"
set xlabel "Frequency (Hz)"
set ylabel "V/m"
plot "PROBLEM_SPECIFICATION_FILES/E_cavity.fout_ref" u 1:5 title "Cavity E field: GGI_TLM reference" w p ,\
"E_cavity.fout" u 1:5 title "Cavity E field: GGI_TLM" w l
#PAUSE pause -1

#OUTPUT_TO_FILE set output "Test_case_40_TCS_MODE_STIR_power_ref.jpg"
set xlabel "Frequency (Hz)"
set ylabel "W"
plot "PROBLEM_SPECIFICATION_FILES/TCS_mode_stir.frequency_domain_power_surface.fout_ref" u 1:7 title "Transmitted Power: GGI_TLM reference" w p ,\
"TCS_mode_stir.frequency_domain_power_surface.fout" u 1:7 title "Transmitted Power: GGI_TLM" w l
#PAUSE pause -1

#OUTPUT_TO_FILE set output "Test_case_40_TCS_MODE_STIR_TCS_ref.jpg"
set xlabel "Frequency (Hz)"
set ylabel "Transmission Cross Section dB square metres"
plot "PROBLEM_SPECIFICATION_FILES/TCS.fout_ref" u 1:7 title "Cavity E field: GGI_TLM reference" w p,\
"TCS.fout" u 1:7 title "Cavity E field: GGI_TLM" w l

#PAUSE pause -1

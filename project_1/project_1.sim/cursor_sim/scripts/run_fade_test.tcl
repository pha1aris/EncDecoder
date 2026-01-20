######################################################################
# run_fade_test.tcl
# 衰落信道下的同步系统测试脚本
# 使用改进版本的 framer/deframer/bit_aligner
######################################################################

# 设置工作目录
set script_dir [file dirname [file normalize [info script]]]
set project_root [file normalize [file join $script_dir .. .. ..]]
set cursor_sim_dir [file normalize [file join $script_dir ..]]

# 设置输出目录
set work_dir [file join $cursor_sim_dir work_fade_test]
set log_dir [file join $cursor_sim_dir logs]
file mkdir $work_dir
file mkdir $log_dir

# 设置日志文件
set log_file [file join $log_dir run_fade_test.log]
set compile_log [file join $log_dir compile_fade_test.log]
set elaborate_log [file join $log_dir elaborate_fade_test.log]
set simulate_log [file join $log_dir simulate_fade_test.log]

# 打开日志
set log_fp [open $log_file w]
puts $log_fp "=========================================="
puts $log_fp "Fade Test Simulation Run Started"
puts $log_fp "Time: [clock format [clock seconds]]"
puts $log_fp "=========================================="
close $log_fp

# 清理之前的运行
if {[file exists [file join $work_dir xsim.dir]]} {
    file delete -force [file join $work_dir xsim.dir]
}

# 切换到工作目录
cd $work_dir

# ============================================================
# Step 1: 编译 Verilog 源文件
# ============================================================
puts "Compiling Verilog sources (with improved modules)..."

# 设置包含路径
set incdirs [list \
    [file join $project_root project_1.srcs sources_1 new] \
    [file join $project_root project_1.srcs sim_1 new] \
    [file join $project_root project_1.gen sources_1 bd design_1 ipshared ec67 hdl] \
    [file join $project_root project_1.gen sources_1 bd design_1 ipshared 6f8f hdl] \
    [file join $project_root project_1.gen sources_1 bd design_1 ipshared f0b6 hdl verilog] \
    [file join $project_root project_1.gen sources_1 bd design_1 ipshared 0127 hdl verilog] \
    [file join $project_root project_1.gen sources_1 ip ddr4_0 ip_1 rtl map] \
    [file join $project_root project_1.gen sources_1 ip ddr4_0 rtl ip_top] \
    [file join $project_root project_1.gen sources_1 ip ddr4_0 rtl cal] \
    [file join $project_root project_1.ip_user_files ipstatic] \
    [file join $project_root project_1.ip_user_files ipstatic hdl] \
]

# 构建 xvlog 命令列表
set xvlog_cmd [list xvlog --relax -work xil_defaultlib]
foreach incdir $incdirs {
    if {[file exists $incdir]} {
        lappend xvlog_cmd -i $incdir
    }
}

# 添加全局定义文件
set global_defines [file join $project_root project_1.srcs sources_1 new global_defines.vh]
if {[file exists $global_defines]} {
    lappend xvlog_cmd $global_defines
}

# IP 仿真文件（Verilog）
set ip_files [list \
    [file join $project_root project_1.gen sources_1 ip async_fifo_32w_32r sim async_fifo_32w_32r.v] \
    [file join $project_root project_1.gen sources_1 ip gtwizard_ultrascale_0 sim gtwizard_ultrascale_v1_7_gthe4_channel.v] \
    [file join $project_root project_1.gen sources_1 ip gtwizard_ultrascale_0 sim gtwizard_ultrascale_0_gthe4_channel_wrapper.v] \
    [file join $project_root project_1.gen sources_1 ip gtwizard_ultrascale_0 sim gtwizard_ultrascale_v1_7_gthe4_common.v] \
    [file join $project_root project_1.gen sources_1 ip gtwizard_ultrascale_0 sim gtwizard_ultrascale_0_gthe4_common_wrapper.v] \
    [file join $project_root project_1.gen sources_1 ip gtwizard_ultrascale_0 sim gtwizard_ultrascale_0_gtwizard_gthe4.v] \
    [file join $project_root project_1.gen sources_1 ip gtwizard_ultrascale_0 sim gtwizard_ultrascale_0_gtwizard_top.v] \
    [file join $project_root project_1.gen sources_1 ip gtwizard_ultrascale_0 sim gtwizard_ultrascale_0.v] \
    [file join $project_root project_1.gen sources_1 ip clk_wiz_sys clk_wiz_sys_clk_wiz.v] \
    [file join $project_root project_1.gen sources_1 ip clk_wiz_sys clk_wiz_sys.v] \
]

# ============================================================
# RTL 源文件（使用改进版本）
# ============================================================
# 先编译改进版本的实现模块
set improved_impl_files [list \
    [file join $cursor_sim_dir src fso_framer_improved.v] \
    [file join $cursor_sim_dir src fso_deframer_improved.v] \
    [file join $cursor_sim_dir src bit_aligner_ind_improved.v] \
]

# RTL 源文件（使用包装模块替换原始模块）
set rtl_files [list \
    [file join $project_root project_1.srcs sim_1 new AdditiveScrambler.v] \
    [file join $project_root project_1.srcs sources_1 new axis_fifo_sync.v] \
    [file join $cursor_sim_dir src bit_aligner_ind_wrapper.v] \
    [file join $project_root project_1.srcs sources_1 new crc32.v] \
    [file join $project_root project_1.srcs sources_1 new fec_gth_loopback_top_s1.v] \
    [file join $project_root project_1.srcs sim_1 new fso_channel_ge_serial.v] \
    [file join $cursor_sim_dir src fso_deframer_wrapper.v] \
    [file join $cursor_sim_dir src fso_framer_wrapper.v] \
    [file join $project_root project_1.srcs sources_1 new gearbox_32to8.v] \
    [file join $project_root project_1.srcs sources_1 new gearbox_8to32_bs.v] \
    [file join $project_root project_1.srcs sources_1 new gth_raw_top.v] \
    [file join $project_root project_1.srcs sources_1 imports imports gtwizard_ultrascale_0_prbs_any.v] \
    [file join $project_root project_1.srcs sources_1 new rx_deframer_only_s1.v] \
    [file join $project_root project_1.srcs sources_1 new tx_framer_only_s1.v] \
    [file join $cursor_sim_dir tb tb_sync_fade_test.v] \
]

# 添加所有文件到编译命令
foreach file $ip_files {
    if {[file exists $file]} {
        lappend xvlog_cmd $file
    }
}

# 先编译改进版本的实现模块
foreach file $improved_impl_files {
    if {[file exists $file]} {
        lappend xvlog_cmd $file
    }
}

# 然后编译 RTL 文件（包含包装模块）
foreach file $rtl_files {
    if {[file exists $file]} {
        lappend xvlog_cmd $file
    }
}

# 编译 glbl 模块
set glbl_candidates [list \
    [file normalize [file join $project_root project_1.sim sim_1 behav xsim glbl.v]] \
    [file normalize [file join $project_root project_1.ip_user_files sim_scripts clk_wiz_sys xsim glbl.v]] \
    [file normalize [file join $project_root project_1.ip_user_files sim_scripts design_1 xsim glbl.v]] \
]

puts "Searching for glbl.v in:"
foreach candidate $glbl_candidates {
    puts "  - $candidate"
}

set glbl_file ""
foreach candidate $glbl_candidates {
    if {[file exists $candidate]} {
        set glbl_file $candidate
        puts "Found glbl.v at: $glbl_file"
        break
    }
}

if {[string length $glbl_file] == 0} {
    if {[info exists ::env(XILINX_VIVADO)]} {
        set vivado_path $::env(XILINX_VIVADO)
        set glbl_file [file join $vivado_path data verilog src glbl.v]
        if {![file exists $glbl_file]} {
            set glbl_file ""
        }
    }
}

set glbl_work [file normalize [file join $work_dir glbl.v]]
if {[string length $glbl_file] > 0 && [file exists $glbl_file]} {
    if {![file exists $glbl_work]} {
        file copy -force $glbl_file $glbl_work
    end
    lappend xvlog_cmd $glbl_work
    puts "Using glbl.v from: $glbl_file"
} else {
    puts "ERROR: glbl.v not found"
    exit 1
}

# 执行 Verilog 编译
set compile_result [catch {
    set compile_fp [open $compile_log w]
    puts $compile_fp "Executing: [join $xvlog_cmd { }]"
    flush $compile_fp
    exec {*}$xvlog_cmd >@ $compile_fp 2>@ $compile_fp
    close $compile_fp
} compile_error]
if {$compile_result != 0} {
    set log_fp [open $log_file a]
    puts $log_fp "ERROR: Verilog Compilation failed!"
    puts $log_fp $compile_error
    close $log_fp
    exit 1
}

# ============================================================
# Step 2: 综合设计
# ============================================================
puts "Elaborating design..."

set xelab_cmd [list xelab --debug typical --relax --mt 32 -L xil_defaultlib -L fifo_generator_v13_2_11 -L gtwizard_ultrascale_v1_7_19 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot tb_sync_fade_test_behav xil_defaultlib.tb_sync_fade_test xil_defaultlib.glbl]

set elaborate_result [catch {
    set elaborate_fp [open $elaborate_log w]
    exec {*}$xelab_cmd >@ $elaborate_fp 2>@ $elaborate_fp
    close $elaborate_fp
} elaborate_error]
if {$elaborate_result != 0} {
    set log_fp [open $log_file a]
    puts $log_fp "ERROR: Elaboration failed!"
    puts $log_fp $elaborate_error
    close $log_fp
    exit 1
}

# ============================================================
# Step 3: 运行仿真（5ms，包含多个衰落周期）
# ============================================================
puts "Running simulation (5ms fade test)..."

set sim_cmd_file [file join $work_dir sim_cmd.tcl]
set sim_cmd_fp [open $sim_cmd_file w]
puts $sim_cmd_fp "run 5ms"
puts $sim_cmd_fp "quit"
close $sim_cmd_fp

set xsim_cmd [list xsim tb_sync_fade_test_behav -t sim_cmd.tcl -log $simulate_log]

set simulate_result [catch {
    exec {*}$xsim_cmd
} simulate_error]
if {$simulate_result != 0} {
    set log_fp [open $log_file a]
    puts $log_fp "ERROR: Simulation failed!"
    puts $log_fp $simulate_error
    close $log_fp
    exit 1
}

# 合并日志
set log_fp [open $log_file a]
puts $log_fp "\n=========================================="
puts $log_fp "Compilation Log:"
puts $log_fp "=========================================="
if {[file exists $compile_log]} {
    set compile_fp [open $compile_log r]
    puts $log_fp [read $compile_fp]
    close $compile_fp
}

puts $log_fp "\n=========================================="
puts $log_fp "Elaboration Log:"
puts $log_fp "=========================================="
if {[file exists $elaborate_log]} {
    set elaborate_fp [open $elaborate_log r]
    puts $log_fp [read $elaborate_fp]
    close $elaborate_fp
}

puts $log_fp "\n=========================================="
puts $log_fp "Simulation Log:"
puts $log_fp "=========================================="
if {[file exists $simulate_log]} {
    set simulate_fp [open $simulate_log r]
    puts $log_fp [read $simulate_fp]
    close $simulate_fp
}

puts $log_fp "\n=========================================="
puts $log_fp "Fade Test Simulation Run Completed"
puts $log_fp "Time: [clock format [clock seconds]]"
puts $log_fp "=========================================="
close $log_fp

puts "Simulation completed. Logs saved to $log_file"
exit 0

######################################################################
# run.do
# ModelSim 仿真脚本
# 用法：在 ModelSim 中执行：do run.do [test_name]
# 可选参数：[s2|s3|s4|prbs_link|fade_test]
# 默认：prbs_link（使用改进模块的测试）
# s2: 使用修复后的 fec_gth_loopback_top_s2（PRBS 同步修复）
######################################################################

# 设置参数
if {[llength $argv] == 0} {
    set TEST_NAME "prbs_link"
} else {
    set TEST_NAME [lindex $argv 0]
}

# 设置路径（使用更可靠的方法）
# ModelSim 的 info script 可能返回不正确路径，使用环境变量或硬编码路径
set script_file [info script]

# 尝试从脚本文件名推断路径
# 如果脚本在正确位置，应该能找到 project_1.sim/cursor_sim/scripts/run.do
# 尝试多种方法找到正确的项目根目录

# 方法1: 从当前工作目录查找
set current_dir [pwd]
set found_project 0

# 检查当前目录是否在项目内
if {[file exists [file join $current_dir project_1.sim cursor_sim scripts run.do]]} {
    set project_root $current_dir
    set found_project 1
} else {
    # 方法2: 向上查找项目根目录
    set search_dir $current_dir
    for {set i 0} {$i < 5} {incr i} {
        if {[file exists [file join $search_dir project_1.sim cursor_sim scripts run.do]]} {
            set project_root $search_dir
            set found_project 1
            break
        }
        set search_dir [file dirname $search_dir]
    }
}

# 方法3: 如果还是找不到，使用硬编码路径（基于常见项目结构）
if {!$found_project} {
    # 尝试从脚本文件路径推断
    if {[string match "*project_1*" $script_file] || [string match "*cursor_sim*" $script_file]} {
        # 从脚本路径中提取项目根目录
        set script_path [file normalize $script_file]
        set parts [file split $script_path]
        set idx -1
        for {set i 0} {$i < [llength $parts]} {incr i} {
            if {[lindex $parts $i] == "project_1"} {
                set idx $i
                break
            }
        }
        if {$idx >= 0} {
            set project_root [file join {*}[lrange $parts 0 $idx]]
            set found_project 1
        }
    }
}

# 如果还是找不到，使用默认路径（用户需要手动设置）
if {!$found_project} {
    # 使用环境变量或默认路径
    if {[info exists ::env(PROJECT_ROOT)]} {
        set project_root $::env(PROJECT_ROOT)
    } else {
        # 默认路径（用户需要根据实际情况修改）
        set project_root "C:/Users/PC/Desktop/fps/EnDec/project_1"
        puts "WARNING: Using default project root: $project_root"
        puts "If this is incorrect, set PROJECT_ROOT environment variable or modify run.do"
    }
}

# 设置其他路径
set cursor_sim_dir [file normalize [file join $project_root project_1.sim cursor_sim]]
set script_dir [file normalize [file join $cursor_sim_dir scripts]]
set work_dir [file normalize [file join $cursor_sim_dir work_modelsim]]

# 显示路径信息（用于调试）
puts "Script file: $script_file"
puts "Current directory: [pwd]"
puts "Project root: $project_root"
puts "Cursor sim dir: $cursor_sim_dir"
puts "Script directory: $script_dir"
puts "Work directory: $work_dir"

# 确保工作目录存在（使用 catch 处理错误）
if {![file exists $work_dir]} {
    set work_parent [file dirname $work_dir]
    if {![file exists $work_parent]} {
        if {[catch {file mkdir $work_parent} err]} {
            puts "ERROR: Cannot create parent directory $work_parent: $err"
            puts "Please create the directory manually and try again."
            return -code error
        }
    }
    if {[catch {file mkdir $work_dir} err]} {
        puts "ERROR: Cannot create work directory $work_dir: $err"
        puts "Please create the directory manually:"
        puts "  mkdir \"$work_dir\""
        return -code error
    }
}

# 切换到工作目录
if {[catch {cd $work_dir} err]} {
    puts "ERROR: Cannot change to work directory $work_dir: $err"
    puts "Current directory: [pwd]"
    return -code error
}

puts "Successfully changed to work directory: [pwd]"

# 创建库
vlib work
vmap work work

# 设置日志
set log_file [file join $cursor_sim_dir logs modelsim_${TEST_NAME}.log]
set log_fp [open $log_file w]
puts $log_fp "=========================================="
puts $log_fp "ModelSim Simulation: $TEST_NAME"
puts $log_fp "Time: [clock format [clock seconds]]"
puts $log_fp "=========================================="
close $log_fp

puts "=========================================="
puts "ModelSim Simulation: $TEST_NAME"
puts "Working directory: $work_dir"
puts "=========================================="

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

# 构建包含路径参数
set inc_opt ""
foreach incdir $incdirs {
    if {[file exists $incdir]} {
        append inc_opt " +incdir+[file normalize $incdir]"
    }
}

# ============================================================
# 全局定义文件
# ============================================================
set global_defines [file join $project_root project_1.srcs sources_1 new global_defines.vh]
if {[file exists $global_defines]} {
    append inc_opt " +incdir+[file dirname $global_defines]"
}

# ============================================================
# 编译 IP 仿真文件（Verilog）
# ============================================================
# fault_tolerant_ms 测试不需要这些 IP 文件，跳过
if {$TEST_NAME != "fault_tolerant_ms"} {
    puts "\nCompiling IP Verilog files..."

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

    if {$TEST_NAME == "s2" || $TEST_NAME == "s4"} {
        lappend ip_files [file join $project_root project_1.gen sources_1 ip fifo_0 sim fifo_0.v]
    }

    foreach file $ip_files {
        if {[file exists $file]} {
            puts "  Compiling: [file tail $file]"
            if {[catch {vlog -work work $inc_opt $file} err]} {
                puts "ERROR compiling $file: $err"
                return -code error
            }
        }
    }
} else {
    puts "\nSkipping IP files compilation for fault_tolerant_ms test..."
}

# ============================================================
# 编译改进版本的实现模块（必须先编译）
# ============================================================
if {$TEST_NAME == "prbs_link" || $TEST_NAME == "fade_test" || $TEST_NAME == "interrupt_test" || $TEST_NAME == "fault_tolerant_ms"} {
    puts "\nCompiling improved implementation modules..."
    
    set improved_impl_files [list \
        [file join $cursor_sim_dir src fso_framer_improved.v] \
        [file join $cursor_sim_dir src fso_deframer_improved.v] \
        [file join $cursor_sim_dir src bit_aligner_ind_improved.v] \
    ]
    
    foreach file $improved_impl_files {
        if {[file exists $file]} {
            puts "  Compiling: [file tail $file]"
            if {[catch {vlog -work work $inc_opt +define+SIM $file} err]} {
                puts "ERROR compiling $file: $err"
                return -code error
            }
        }
    }
}

# ============================================================
# 编译 RTL 源文件
# ============================================================
puts "\nCompiling RTL source files..."

# 基础 RTL 文件（根据测试选择）
if {$TEST_NAME == "fault_tolerant_ms"} {
    # fault_tolerant_ms 测试只需要 PRBS 模块（如果需要）
    set rtl_base_files [list \
        [file join $project_root project_1.srcs sources_1 imports imports gtwizard_ultrascale_0_prbs_any.v] \
    ]
} else {
    # 其他测试需要完整的基础文件
    set rtl_base_files [list \
        [file join $project_root project_1.srcs sim_1 new AdditiveScrambler.v] \
        [file join $project_root project_1.srcs sources_1 new axis_fifo_sync.v] \
        [file join $project_root project_1.srcs sources_1 new crc32.v] \
        [file join $project_root project_1.srcs sources_1 new gearbox_32to8.v] \
        [file join $project_root project_1.srcs sources_1 new gearbox_8to32_bs.v] \
        [file join $project_root project_1.srcs sources_1 new gth_raw_top.v] \
        [file join $project_root project_1.srcs sources_1 imports imports gtwizard_ultrascale_0_prbs_any.v] \
    ]
}

# 根据测试选择不同的模块版本
if {$TEST_NAME == "prbs_link" || $TEST_NAME == "fade_test" || $TEST_NAME == "interrupt_test"} {
    # 使用改进版本（通过 wrapper）
    set rtl_test_files [list \
        [file join $cursor_sim_dir src bit_aligner_ind_wrapper.v] \
        [file join $cursor_sim_dir src fso_deframer_wrapper.v] \
        [file join $cursor_sim_dir src fso_framer_wrapper.v] \
    ]
    
    # 测试平台
    if {$TEST_NAME == "prbs_link"} {
        lappend rtl_test_files [file join $project_root project_1.srcs sources_1 new fec_gth_loopback_top_s1.v] \
                                [file join $project_root project_1.srcs sim_1 new fso_channel_ge_serial.v] \
                                [file join $project_root project_1.srcs sources_1 new rx_deframer_only_s1.v] \
                                [file join $project_root project_1.srcs sources_1 new tx_framer_only_s1.v] \
                                [file join $cursor_sim_dir tb tb_prbs_link_establishment.v]
        set TB_TOP "tb_prbs_link_establishment"
    } elseif {$TEST_NAME == "fade_test"} {
        lappend rtl_test_files [file join $project_root project_1.srcs sources_1 new fec_gth_loopback_top_s1.v] \
                                [file join $project_root project_1.srcs sim_1 new fso_channel_ge_serial.v] \
                                [file join $project_root project_1.srcs sources_1 new rx_deframer_only_s1.v] \
                                [file join $project_root project_1.srcs sources_1 new tx_framer_only_s1.v] \
                                [file join $cursor_sim_dir tb tb_sync_fade_test.v]
        set TB_TOP "tb_sync_fade_test"
    } elseif {$TEST_NAME == "interrupt_test"} {
        # 中断恢复测试：只需要 bit_aligner 和 deframer
        lappend rtl_test_files [file join $project_root project_1.srcs sim_1 new AdditiveScrambler.v] \
                                [file join $project_root project_1.srcs sources_1 new crc32.v] \
                                [file join $cursor_sim_dir tb tb_data_interrupt_recovery.v]
        set TB_TOP "tb_data_interrupt_recovery"
    } elseif {$TEST_NAME == "fault_tolerant_ms"} {
        # 容错同步系统验证测试（几毫秒级衰落）
        lappend rtl_test_files [file join $cursor_sim_dir src bit_aligner_ind_fault_tolerant_ms.v] \
                                [file join $cursor_sim_dir tb tb_fault_tolerant_ms_validation.v]
        set TB_TOP "tb_fault_tolerant_ms_validation"
    }
} elseif {$TEST_NAME == "s2"} {
    # S2: bit align + frame sync + RS(255,229) + PRBS（使用修复后的模块）
    set rtl_test_files [list \
        [file join $project_root project_1.srcs sources_1 new bit_aligner_ind.v] \
        [file join $project_root project_1.srcs sources_1 new fso_deframer.v] \
        [file join $project_root project_1.srcs sources_1 new fso_framer.v] \
        [file join $project_root project_1.srcs sources_1 new fec_gth_loopback_top_s2.v] \
        [file join $project_root project_1.srcs sim_1 new fso_channel_ge_serial.v] \
        [file join $project_root project_1.srcs sources_1 new rs_encode_frontend.v] \
        [file join $project_root project_1.srcs sources_1 new rs_decode_backend.v] \
        [file join $project_root project_1.srcs sources_1 new rs_interleaver_xpm.v] \
        [file join $project_root project_1.srcs sim_1 new rs_Deinterleaver_xpm.v] \
        [file join $project_root project_1.srcs sources_1 new fifo_8b_flag_sync.v] \
        [file join $project_root project_1.srcs sources_1 new fec_tx.v] \
        [file join $project_root project_1.srcs sources_1 new fec_rx.v] \
        [file join $project_root project_1.srcs sources_1 new fec_tx_s2.v] \
        [file join $project_root project_1.srcs sources_1 new fec_rx_s2.v] \
        [file join $cursor_sim_dir tb tb_fec_gth_loopback_top_s2.v] \
    ]
    set TB_TOP "tb_fec_gth_loopback_top_s2"
} elseif {$TEST_NAME == "s3"} {
    # S3: 交织/解交织测试
    set rtl_test_files [list \
        [file join $project_root project_1.srcs sources_1 new rs_interleaver_xpm.v] \
        [file join $project_root project_1.srcs sim_1 new rs_Deinterleaver_xpm.v] \
        [file join $project_root project_1.srcs sources_1 new fifo_8b_flag_sync.v] \
        [file join $cursor_sim_dir tb tb_intlv_deintlv_s3.v] \
    ]
    set TB_TOP "tb_intlv_deintlv_s3"
} elseif {$TEST_NAME == "s4"} {
    # S4: 完整系统测试（使用原始模块）
    set rtl_test_files [list \
        [file join $project_root project_1.srcs sources_1 new bit_aligner_ind.v] \
        [file join $project_root project_1.srcs sources_1 new fso_deframer.v] \
        [file join $project_root project_1.srcs sources_1 new fso_framer.v] \
        [file join $project_root project_1.srcs sources_1 new fec_gth_loopback_top_s2.v] \
        [file join $project_root project_1.srcs sim_1 new fso_channel_ge_serial.v] \
        [file join $project_root project_1.srcs sources_1 new rs_encode_frontend.v] \
        [file join $project_root project_1.srcs sources_1 new rs_decode_backend.v] \
        [file join $project_root project_1.srcs sources_1 new rs_interleaver_xpm.v] \
        [file join $project_root project_1.srcs sim_1 new rs_Deinterleaver_xpm.v] \
        [file join $project_root project_1.srcs sources_1 new fifo_8b_flag_sync.v] \
        [file join $project_root project_1.srcs sources_1 new fec_tx.v] \
        [file join $project_root project_1.srcs sources_1 new fec_rx.v] \
        [file join $project_root project_1.srcs sources_1 new fec_tx_s2.v] \
        [file join $project_root project_1.srcs sources_1 new fec_rx_s2.v] \
        [file join $cursor_sim_dir tb tb_fec_loopback_s4.v] \
    ]
    set TB_TOP "tb_fec_loopback_s4"
} elseif {$TEST_NAME == "interrupt_test"} {
    set SIM_TIME "50us"
} elseif {$TEST_NAME == "fault_tolerant_ms"} {
    set SIM_TIME "60ms"  # 确保覆盖所有衰落测试（最长15ms + 恢复时间）
} else {
    puts "ERROR: Unknown test name: $TEST_NAME"
    puts "Available tests: s2, s3, s4, prbs_link, fade_test, interrupt_test, fault_tolerant_ms"
    return -code error
}

# 编译所有 RTL 文件
foreach file $rtl_base_files {
    if {[file exists $file]} {
        puts "  Compiling: [file tail $file]"
        if {[catch {vlog -work work $inc_opt +define+SIM $file} err]} {
            puts "ERROR compiling $file: $err"
            return -code error
        }
    }
}

foreach file $rtl_test_files {
    if {[file exists $file]} {
        puts "  Compiling: [file tail $file]"
        if {[catch {vlog -work work $inc_opt +define+SIM $file} err]} {
            puts "ERROR compiling $file: $err"
            return -code error
        }
    }
}

# ============================================================
# 编译 VHDL IP 文件（如果需要）
# ============================================================
if {$TEST_NAME == "s2" || $TEST_NAME == "s4"} {
    puts "\nCompiling VHDL IP files..."
    
    set vhdl_ip_files [list \
        [file join $project_root project_1.gen sources_1 ip rs_encoder_0 sim rs_encoder_0.vhd] \
        [file join $project_root project_1.gen sources_1 ip rs_decoder_0 sim rs_decoder_0.vhd] \
    ]
    
    foreach file $vhdl_ip_files {
        if {[file exists $file]} {
            puts "  Compiling: [file tail $file]"
            if {[catch {vcom -work work -2008 $file} err]} {
                puts "ERROR compiling $file: $err"
                return -code error
            }
        }
    }
}

# ============================================================
# 查找并编译 glbl 模块（fault_tolerant_ms 测试不需要）
# ============================================================
if {$TEST_NAME != "fault_tolerant_ms"} {
    puts "\nCompiling glbl module..."

    set glbl_candidates [list \
        [file normalize [file join $project_root project_1.sim sim_1 behav xsim glbl.v]] \
        [file normalize [file join $project_root project_1.ip_user_files sim_scripts clk_wiz_sys xsim glbl.v]] \
        [file normalize [file join $project_root project_1.ip_user_files sim_scripts design_1 xsim glbl.v]] \
    ]

    set glbl_file ""
    foreach candidate $glbl_candidates {
        if {[file exists $candidate]} {
            set glbl_file $candidate
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

    if {[string length $glbl_file] > 0 && [file exists $glbl_file]} {
        puts "  Found glbl.v at: $glbl_file"
        if {[catch {vlog -work work $glbl_file} err]} {
            puts "ERROR compiling glbl.v: $err"
            return -code error
        }
    } else {
        puts "WARNING: glbl.v not found, simulation may fail"
    }
} else {
    puts "\nSkipping glbl.v compilation for fault_tolerant_ms test..."
}

# ============================================================
# 启动仿真
# ============================================================
puts "\n=========================================="
puts "Starting simulation: $TB_TOP"
puts "=========================================="

# 根据测试设置仿真时间
if {$TEST_NAME == "prbs_link"} {
    set SIM_TIME "100us"
} elseif {$TEST_NAME == "fade_test"} {
    set SIM_TIME "5ms"
} elseif {$TEST_NAME == "s2"} {
    set SIM_TIME "1ms"
} elseif {$TEST_NAME == "s3"} {
    set SIM_TIME "100us"
} elseif {$TEST_NAME == "s4"} {
    set SIM_TIME "10ms"
} elseif {$TEST_NAME == "fault_tolerant_ms"} {
    set SIM_TIME "60ms"  # 确保覆盖所有衰落测试（最长15ms + 恢复时间）
} else {
    set SIM_TIME "10us"
}

# 启动仿真（交互式模式，不自动运行）
if {[catch {
    if {$TEST_NAME == "fault_tolerant_ms"} {
        vsim -voptargs="+acc" -t ps work.${TB_TOP}
    } else {
        vsim -voptargs="+acc" -t ps work.${TB_TOP} work.glbl
    }
    
    # 显示提示信息
    puts "\n=========================================="
    puts "ModelSim simulation loaded successfully!"
    puts "Test: $TEST_NAME"
    puts "Top module: $TB_TOP"
    puts "=========================================="
    puts "\nYou can now control the simulation:"
    puts "  - run 10us        : Run simulation for 10us"
    puts "  - run -all         : Run until $finish"
    puts "  - add wave *       : Add all signals to waveform"
    puts "  - view wave        : Open waveform window"
    puts "  - restart -f       : Restart simulation"
    puts "  - quit -sim        : Quit simulation"
    puts "\nSuggested commands:"
    puts "  add wave -radix hex /${TB_TOP}/dut/*"
    puts "  add wave /${TB_TOP}/dut/bit_locked_core"
    puts "  add wave /${TB_TOP}/dut/frame_locked_core"
    puts "  add wave /${TB_TOP}/dut/prbs_err_vec"
    puts "  view wave"
    puts "  run $SIM_TIME"
    puts "\n=========================================="
    
    # 不自动运行，让用户控制
    # run $SIM_TIME
    
} err]} {
    puts "ERROR starting simulation: $err"
    return -code error
}

puts "\nSimulation ready. You are now in control!"

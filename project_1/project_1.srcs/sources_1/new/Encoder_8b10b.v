`timescale 1ns / 1ps

module Encoder_8b10b(
    input  wire       clk,
    input  wire       rst,

    input  wire [7:0] data_i,
    input  wire       data_valid_i,
    input  wire       k_i,
    output wire [9:0] data_o,
    output wire       data_valid_o
);

parameter RD_NEG = 1'b0;
parameter RD_POS = 1'b1;

reg [9:0] data_o_reg;
reg       data_valid_o_reg;
reg       current_rd;
reg [9:0] next_code;
wire       next_rd;

assign data_o = data_o_reg;
assign data_valid_o = data_valid_o_reg;


always @(*) begin
    if (current_rd == RD_POS) begin
        next_code = Encode_lut_pos_rd(data_i, k_i);
    end else begin // current_rd == RD_NEG
        next_code = Encode_lut_neg_rd(data_i, k_i);
    end
end


assign next_rd = get_next_rd(next_code, current_rd);


always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_o_reg       <= 10'h1BC;
        data_valid_o_reg <= 1'b0;
        current_rd       <= RD_NEG;
    end else begin
        data_valid_o_reg <= data_valid_i;

        if (data_valid_i) begin
            data_o_reg <= next_code; // 从组合逻辑获取结果并寄存
            current_rd <= next_rd;     // 从组合逻辑获取结果并寄存
        end
    end
end


    // 计算下一个RD状态的函数
    function get_next_rd; 
        input [9:0] code_10b;
        input       current_rd;
        integer i;
        integer ones_count;
        begin
            ones_count = 0;
            for (i=0; i<10; i=i+1) begin
                if (code_10b[i] == 1'b1) begin
                    ones_count = ones_count + 1;
                end
            end

            if (ones_count > 5)      get_next_rd = RD_POS;
            else if (ones_count < 5) get_next_rd = RD_NEG;
            else                     get_next_rd = current_rd;
        end
    endfunction

//==================================================================
// 8b10b encode LUT for RD+ (Running Disparity is Positive)
// 当RD为正时调用此函数
//==================================================================
    function [9:0] Encode_lut_pos_rd;
        input [7:0] data;
        input       k;
        begin
            if (k == 1'b0) begin // 仅处理数据码
                case(data)
                    8'h00: Encode_lut_pos_rd = 10'h346;
                    8'h01: Encode_lut_pos_rd = 10'h351;
                    8'h02: Encode_lut_pos_rd = 10'h352;
                    8'h03: Encode_lut_pos_rd = 10'h0A3;
                    8'h04: Encode_lut_pos_rd = 10'h354;
                    8'h05: Encode_lut_pos_rd = 10'h0A5;
                    8'h06: Encode_lut_pos_rd = 10'h0A6;
                    8'h07: Encode_lut_pos_rd = 10'h0B8;
                    8'h08: Encode_lut_pos_rd = 10'h358;
                    8'h09: Encode_lut_pos_rd = 10'h0A9;
                    8'h0A: Encode_lut_pos_rd = 10'h0AA;
                    8'h0B: Encode_lut_pos_rd = 10'h08B;
                    8'h0C: Encode_lut_pos_rd = 10'h0AC;
                    8'h0D: Encode_lut_pos_rd = 10'h08D;
                    8'h0E: Encode_lut_pos_rd = 10'h08E;
                    8'h0F: Encode_lut_pos_rd = 10'h345;
                    8'h10: Encode_lut_pos_rd = 10'h349;
                    8'h11: Encode_lut_pos_rd = 10'h0B1;
                    8'h12: Encode_lut_pos_rd = 10'h0B2;
                    8'h13: Encode_lut_pos_rd = 10'h093;
                    8'h14: Encode_lut_pos_rd = 10'h0B4;
                    8'h15: Encode_lut_pos_rd = 10'h095;
                    8'h16: Encode_lut_pos_rd = 10'h096;
                    8'h17: Encode_lut_pos_rd = 10'h368;
                    8'h18: Encode_lut_pos_rd = 10'h34C;
                    8'h19: Encode_lut_pos_rd = 10'h099;
                    8'h1A: Encode_lut_pos_rd = 10'h09A;
                    8'h1B: Encode_lut_pos_rd = 10'h364;
                    8'h1C: Encode_lut_pos_rd = 10'h09C;
                    8'h1D: Encode_lut_pos_rd = 10'h362;
                    8'h1E: Encode_lut_pos_rd = 10'h361;
                    8'h1F: Encode_lut_pos_rd = 10'h34A;
                    8'h20: Encode_lut_pos_rd = 10'h246;
                    8'h21: Encode_lut_pos_rd = 10'h251;
                    8'h22: Encode_lut_pos_rd = 10'h252;
                    8'h23: Encode_lut_pos_rd = 10'h263;
                    8'h24: Encode_lut_pos_rd = 10'h254;
                    8'h25: Encode_lut_pos_rd = 10'h265;
                    8'h26: Encode_lut_pos_rd = 10'h266;
                    8'h27: Encode_lut_pos_rd = 10'h278;
                    8'h28: Encode_lut_pos_rd = 10'h258;
                    8'h29: Encode_lut_pos_rd = 10'h269;
                    8'h2A: Encode_lut_pos_rd = 10'h26A;
                    8'h2B: Encode_lut_pos_rd = 10'h24B;
                    8'h2C: Encode_lut_pos_rd = 10'h26C;
                    8'h2D: Encode_lut_pos_rd = 10'h24D;
                    8'h2E: Encode_lut_pos_rd = 10'h24E;
                    8'h2F: Encode_lut_pos_rd = 10'h245;
                    8'h30: Encode_lut_pos_rd = 10'h249;
                    8'h31: Encode_lut_pos_rd = 10'h271;
                    8'h32: Encode_lut_pos_rd = 10'h272;
                    8'h33: Encode_lut_pos_rd = 10'h253;
                    8'h34: Encode_lut_pos_rd = 10'h274;
                    8'h35: Encode_lut_pos_rd = 10'h255;
                    8'h36: Encode_lut_pos_rd = 10'h256;
                    8'h37: Encode_lut_pos_rd = 10'h268;
                    8'h38: Encode_lut_pos_rd = 10'h24C;
                    8'h39: Encode_lut_pos_rd = 10'h259;
                    8'h3A: Encode_lut_pos_rd = 10'h25A;
                    8'h3B: Encode_lut_pos_rd = 10'h264;
                    8'h3C: Encode_lut_pos_rd = 10'h25C;
                    8'h3D: Encode_lut_pos_rd = 10'h262;
                    8'h3E: Encode_lut_pos_rd = 10'h261;
                    8'h3F: Encode_lut_pos_rd = 10'h24A;
                    8'h40: Encode_lut_pos_rd = 10'h286;
                    8'h41: Encode_lut_pos_rd = 10'h291;
                    8'h42: Encode_lut_pos_rd = 10'h292;
                    8'h43: Encode_lut_pos_rd = 10'h2A3;
                    8'h44: Encode_lut_pos_rd = 10'h294;
                    8'h45: Encode_lut_pos_rd = 10'h2A5;
                    8'h46: Encode_lut_pos_rd = 10'h2A6;
                    8'h47: Encode_lut_pos_rd = 10'h2B8;
                    8'h48: Encode_lut_pos_rd = 10'h298;
                    8'h49: Encode_lut_pos_rd = 10'h2A9;
                    8'h4A: Encode_lut_pos_rd = 10'h2AA;
                    8'h4B: Encode_lut_pos_rd = 10'h28B;
                    8'h4C: Encode_lut_pos_rd = 10'h2AC;
                    8'h4D: Encode_lut_pos_rd = 10'h28D;
                    8'h4E: Encode_lut_pos_rd = 10'h28E;
                    8'h4F: Encode_lut_pos_rd = 10'h285;
                    8'h50: Encode_lut_pos_rd = 10'h289;
                    8'h51: Encode_lut_pos_rd = 10'h2B1;
                    8'h52: Encode_lut_pos_rd = 10'h2B2;
                    8'h53: Encode_lut_pos_rd = 10'h293;
                    8'h54: Encode_lut_pos_rd = 10'h2B4;
                    8'h55: Encode_lut_pos_rd = 10'h295;
                    8'h56: Encode_lut_pos_rd = 10'h296;
                    8'h57: Encode_lut_pos_rd = 10'h2A8;
                    8'h58: Encode_lut_pos_rd = 10'h28C;
                    8'h59: Encode_lut_pos_rd = 10'h299;
                    8'h5A: Encode_lut_pos_rd = 10'h29A;
                    8'h5B: Encode_lut_pos_rd = 10'h2A4;
                    8'h5C: Encode_lut_pos_rd = 10'h29C;
                    8'h5D: Encode_lut_pos_rd = 10'h2A2;
                    8'h5E: Encode_lut_pos_rd = 10'h2A1;
                    8'h5F: Encode_lut_pos_rd = 10'h28A;
                    8'h60: Encode_lut_pos_rd = 10'h0C6;
                    8'h61: Encode_lut_pos_rd = 10'h0D1;
                    8'h62: Encode_lut_pos_rd = 10'h0D2;
                    8'h63: Encode_lut_pos_rd = 10'h323;
                    8'h64: Encode_lut_pos_rd = 10'h0D4;
                    8'h65: Encode_lut_pos_rd = 10'h325;
                    8'h66: Encode_lut_pos_rd = 10'h326;
                    8'h67: Encode_lut_pos_rd = 10'h338;
                    8'h68: Encode_lut_pos_rd = 10'h0D8;
                    8'h69: Encode_lut_pos_rd = 10'h329;
                    8'h6A: Encode_lut_pos_rd = 10'h32A;
                    8'h6B: Encode_lut_pos_rd = 10'h30B;
                    8'h6C: Encode_lut_pos_rd = 10'h32C;
                    8'h6D: Encode_lut_pos_rd = 10'h30D;
                    8'h6E: Encode_lut_pos_rd = 10'h30E;
                    8'h6F: Encode_lut_pos_rd = 10'h0C5;
                    8'h70: Encode_lut_pos_rd = 10'h0C9;
                    8'h71: Encode_lut_pos_rd = 10'h331;
                    8'h72: Encode_lut_pos_rd = 10'h332;
                    8'h73: Encode_lut_pos_rd = 10'h313;
                    8'h74: Encode_lut_pos_rd = 10'h334;
                    8'h75: Encode_lut_pos_rd = 10'h315;
                    8'h76: Encode_lut_pos_rd = 10'h316;
                    8'h77: Encode_lut_pos_rd = 10'h0E8;
                    8'h78: Encode_lut_pos_rd = 10'h0CC;
                    8'h79: Encode_lut_pos_rd = 10'h319;
                    8'h7A: Encode_lut_pos_rd = 10'h31A;
                    8'h7B: Encode_lut_pos_rd = 10'h0E4;
                    8'h7C: Encode_lut_pos_rd = 10'h31C;
                    8'h7D: Encode_lut_pos_rd = 10'h0E2;
                    8'h7E: Encode_lut_pos_rd = 10'h0E1;
                    8'h7F: Encode_lut_pos_rd = 10'h0CA;
                    8'h80: Encode_lut_pos_rd = 10'h2C6;
                    8'h81: Encode_lut_pos_rd = 10'h2D1;
                    8'h82: Encode_lut_pos_rd = 10'h2D2;
                    8'h83: Encode_lut_pos_rd = 10'h123;
                    8'h84: Encode_lut_pos_rd = 10'h2D4;
                    8'h85: Encode_lut_pos_rd = 10'h125;
                    8'h86: Encode_lut_pos_rd = 10'h126;
                    8'h87: Encode_lut_pos_rd = 10'h138;
                    8'h88: Encode_lut_pos_rd = 10'h2D8;
                    8'h89: Encode_lut_pos_rd = 10'h129;
                    8'h8A: Encode_lut_pos_rd = 10'h12A;
                    8'h8B: Encode_lut_pos_rd = 10'h10B;
                    8'h8C: Encode_lut_pos_rd = 10'h12C;
                    8'h8D: Encode_lut_pos_rd = 10'h10D;
                    8'h8E: Encode_lut_pos_rd = 10'h10E;
                    8'h8F: Encode_lut_pos_rd = 10'h2C5;
                    8'h90: Encode_lut_pos_rd = 10'h2C9;
                    8'h91: Encode_lut_pos_rd = 10'h131;
                    8'h92: Encode_lut_pos_rd = 10'h132;
                    8'h93: Encode_lut_pos_rd = 10'h113;
                    8'h94: Encode_lut_pos_rd = 10'h134;
                    8'h95: Encode_lut_pos_rd = 10'h115;
                    8'h96: Encode_lut_pos_rd = 10'h116;
                    8'h97: Encode_lut_pos_rd = 10'h2E8;
                    8'h98: Encode_lut_pos_rd = 10'h2CC;
                    8'h99: Encode_lut_pos_rd = 10'h119;
                    8'h9A: Encode_lut_pos_rd = 10'h11A;
                    8'h9B: Encode_lut_pos_rd = 10'h2E4;
                    8'h9C: Encode_lut_pos_rd = 10'h11C;
                    8'h9D: Encode_lut_pos_rd = 10'h2E2;
                    8'h9E: Encode_lut_pos_rd = 10'h2E1;
                    8'h9F: Encode_lut_pos_rd = 10'h2CA;
                    8'hA0: Encode_lut_pos_rd = 10'h146;
                    8'hA1: Encode_lut_pos_rd = 10'h151;
                    8'hA2: Encode_lut_pos_rd = 10'h152;
                    8'hA3: Encode_lut_pos_rd = 10'h163;
                    8'hA4: Encode_lut_pos_rd = 10'h154;
                    8'hA5: Encode_lut_pos_rd = 10'h165;
                    8'hA6: Encode_lut_pos_rd = 10'h166;
                    8'hA7: Encode_lut_pos_rd = 10'h178;
                    8'hA8: Encode_lut_pos_rd = 10'h158;
                    8'hA9: Encode_lut_pos_rd = 10'h169;
                    8'hAA: Encode_lut_pos_rd = 10'h16A;
                    8'hAB: Encode_lut_pos_rd = 10'h14B;
                    8'hAC: Encode_lut_pos_rd = 10'h16C;
                    8'hAD: Encode_lut_pos_rd = 10'h14D;
                    8'hAE: Encode_lut_pos_rd = 10'h14E;
                    8'hAF: Encode_lut_pos_rd = 10'h145;
                    8'hB0: Encode_lut_pos_rd = 10'h149;
                    8'hB1: Encode_lut_pos_rd = 10'h171;
                    8'hB2: Encode_lut_pos_rd = 10'h172;
                    8'hB3: Encode_lut_pos_rd = 10'h153;
                    8'hB4: Encode_lut_pos_rd = 10'h174;
                    8'hB5: Encode_lut_pos_rd = 10'h155;
                    8'hB6: Encode_lut_pos_rd = 10'h156;
                    8'hB7: Encode_lut_pos_rd = 10'h168;
                    8'hB8: Encode_lut_pos_rd = 10'h14C;
                    8'hB9: Encode_lut_pos_rd = 10'h159;
                    8'hBA: Encode_lut_pos_rd = 10'h15A;
                    8'hBB: Encode_lut_pos_rd = 10'h164;
                    8'hBC: Encode_lut_pos_rd = 10'h15C;
                    8'hBD: Encode_lut_pos_rd = 10'h162;
                    8'hBE: Encode_lut_pos_rd = 10'h161;
                    8'hBF: Encode_lut_pos_rd = 10'h14A;
                    8'hC0: Encode_lut_pos_rd = 10'h186;
                    8'hC1: Encode_lut_pos_rd = 10'h191;
                    8'hC2: Encode_lut_pos_rd = 10'h192;
                    8'hC3: Encode_lut_pos_rd = 10'h1A3;
                    8'hC4: Encode_lut_pos_rd = 10'h194;
                    8'hC5: Encode_lut_pos_rd = 10'h1A5;
                    8'hC6: Encode_lut_pos_rd = 10'h1A6;
                    8'hC7: Encode_lut_pos_rd = 10'h1B8;
                    8'hC8: Encode_lut_pos_rd = 10'h198;
                    8'hC9: Encode_lut_pos_rd = 10'h1A9;
                    8'hCA: Encode_lut_pos_rd = 10'h1AA;
                    8'hCB: Encode_lut_pos_rd = 10'h18B;
                    8'hCC: Encode_lut_pos_rd = 10'h1AC;
                    8'hCD: Encode_lut_pos_rd = 10'h18D;
                    8'hCE: Encode_lut_pos_rd = 10'h18E;
                    8'hCF: Encode_lut_pos_rd = 10'h185;
                    8'hD0: Encode_lut_pos_rd = 10'h189;
                    8'hD1: Encode_lut_pos_rd = 10'h1B1;
                    8'hD2: Encode_lut_pos_rd = 10'h1B2;
                    8'hD3: Encode_lut_pos_rd = 10'h193;
                    8'hD4: Encode_lut_pos_rd = 10'h1B4;
                    8'hD5: Encode_lut_pos_rd = 10'h195;
                    8'hD6: Encode_lut_pos_rd = 10'h196;
                    8'hD7: Encode_lut_pos_rd = 10'h1A8;
                    8'hD8: Encode_lut_pos_rd = 10'h18C;
                    8'hD9: Encode_lut_pos_rd = 10'h199;
                    8'hDA: Encode_lut_pos_rd = 10'h19A;
                    8'hDB: Encode_lut_pos_rd = 10'h1A4;
                    8'hDC: Encode_lut_pos_rd = 10'h19C;
                    8'hDD: Encode_lut_pos_rd = 10'h1A2;
                    8'hDE: Encode_lut_pos_rd = 10'h1A1;
                    8'hDF: Encode_lut_pos_rd = 10'h18A;
                    8'hE0: Encode_lut_pos_rd = 10'h1C6;
                    8'hE1: Encode_lut_pos_rd = 10'h1D1;
                    8'hE2: Encode_lut_pos_rd = 10'h1D2;
                    8'hE3: Encode_lut_pos_rd = 10'h223;
                    8'hE4: Encode_lut_pos_rd = 10'h1D4;
                    8'hE5: Encode_lut_pos_rd = 10'h225;
                    8'hE6: Encode_lut_pos_rd = 10'h226;
                    8'hE7: Encode_lut_pos_rd = 10'h238;
                    8'hE8: Encode_lut_pos_rd = 10'h1D8;
                    8'hE9: Encode_lut_pos_rd = 10'h229;
                    8'hEA: Encode_lut_pos_rd = 10'h22A;
                    8'hEB: Encode_lut_pos_rd = 10'h04B;
                    8'hEC: Encode_lut_pos_rd = 10'h22C;
                    8'hED: Encode_lut_pos_rd = 10'h04D;
                    8'hEE: Encode_lut_pos_rd = 10'h04E;
                    8'hEF: Encode_lut_pos_rd = 10'h1C5;
                    8'hF0: Encode_lut_pos_rd = 10'h1C9;
                    8'hF1: Encode_lut_pos_rd = 10'h231;
                    8'hF2: Encode_lut_pos_rd = 10'h232;
                    8'hF3: Encode_lut_pos_rd = 10'h213;
                    8'hF4: Encode_lut_pos_rd = 10'h234;
                    8'hF5: Encode_lut_pos_rd = 10'h215;
                    8'hF6: Encode_lut_pos_rd = 10'h216;
                    8'hF7: Encode_lut_pos_rd = 10'h1E8;
                    8'hF8: Encode_lut_pos_rd = 10'h1CC;
                    8'hF9: Encode_lut_pos_rd = 10'h219;
                    8'hFA: Encode_lut_pos_rd = 10'h21A;
                    8'hFB: Encode_lut_pos_rd = 10'h1E4;
                    8'hFC: Encode_lut_pos_rd = 10'h21C;
                    8'hFD: Encode_lut_pos_rd = 10'h1E2;
                    8'hFE: Encode_lut_pos_rd = 10'h1E1;
                    8'hFF: Encode_lut_pos_rd = 10'h1CA;
                    default: Encode_lut_pos_rd = 10'h1BC; // 默认值
                endcase
            end else begin // k = 1时
                // K码的RD+情况
                case(data)
                    8'h1C: Encode_lut_pos_rd = 10'h343; // K28.0
                    8'h3C: Encode_lut_pos_rd = 10'h183; // K28.1
                    8'h5C: Encode_lut_pos_rd = 10'h143; // K28.2
                    8'h7C: Encode_lut_pos_rd = 10'h0C3; // K28.3
                    8'h9C: Encode_lut_pos_rd = 10'h2C3; // K28.4
                    8'hBC: Encode_lut_pos_rd = 10'h283; // K28.5 (Comma)
                    8'hDC: Encode_lut_pos_rd = 10'h243; // K28.6
                    8'hFC: Encode_lut_pos_rd = 10'h383; // K28.7
                    8'hF7: Encode_lut_pos_rd = 10'h3A8; // K23.7
                    8'hFB: Encode_lut_pos_rd = 10'h3A4; // K27.7
                    8'hFD: Encode_lut_pos_rd = 10'h3A2; // K29.7
                    8'hFE: Encode_lut_pos_rd = 10'h3A1; // K30.7
                    default : Encode_lut_pos_rd = 10'h1BC;
                endcase
            end
        end
    endfunction

//==================================================================
// 8b10b encode LUT for RD- (Running Disparity is Negative)
// 当RD为负时调用此函数
//==================================================================
function [9:0] Encode_lut_neg_rd;
    input [7:0] data;
    input       k;
    begin
        if (k == 1'b0) begin // 仅处理数据码
            case(data)
                8'h00: Encode_lut_neg_rd = 10'h0B9;
                8'h01: Encode_lut_neg_rd = 10'h0AE;
                8'h02: Encode_lut_neg_rd = 10'h0AD;
                8'h03: Encode_lut_neg_rd = 10'h363;
                8'h04: Encode_lut_neg_rd = 10'h0AB;
                8'h05: Encode_lut_neg_rd = 10'h365;
                8'h06: Encode_lut_neg_rd = 10'h366;
                8'h07: Encode_lut_neg_rd = 10'h347;
                8'h08: Encode_lut_neg_rd = 10'h0A7;
                8'h09: Encode_lut_neg_rd = 10'h369;
                8'h0A: Encode_lut_neg_rd = 10'h36A;
                8'h0B: Encode_lut_neg_rd = 10'h34B;
                8'h0C: Encode_lut_neg_rd = 10'h36C;
                8'h0D: Encode_lut_neg_rd = 10'h34D;
                8'h0E: Encode_lut_neg_rd = 10'h34E;
                8'h0F: Encode_lut_neg_rd = 10'h0BA;
                8'h10: Encode_lut_neg_rd = 10'h0B6;
                8'h11: Encode_lut_neg_rd = 10'h371;
                8'h12: Encode_lut_neg_rd = 10'h372;
                8'h13: Encode_lut_neg_rd = 10'h353;
                8'h14: Encode_lut_neg_rd = 10'h374;
                8'h15: Encode_lut_neg_rd = 10'h355;
                8'h16: Encode_lut_neg_rd = 10'h356;
                8'h17: Encode_lut_neg_rd = 10'h097;
                8'h18: Encode_lut_neg_rd = 10'h0B3;
                8'h19: Encode_lut_neg_rd = 10'h359;
                8'h1A: Encode_lut_neg_rd = 10'h35A;
                8'h1B: Encode_lut_neg_rd = 10'h09B;
                8'h1C: Encode_lut_neg_rd = 10'h35C;
                8'h1D: Encode_lut_neg_rd = 10'h09D;
                8'h1E: Encode_lut_neg_rd = 10'h09E;
                8'h1F: Encode_lut_neg_rd = 10'h0B5;
                8'h20: Encode_lut_neg_rd = 10'h279;
                8'h21: Encode_lut_neg_rd = 10'h26E;
                8'h22: Encode_lut_neg_rd = 10'h26D;
                8'h23: Encode_lut_neg_rd = 10'h263;
                8'h24: Encode_lut_neg_rd = 10'h26B;
                8'h25: Encode_lut_neg_rd = 10'h265;
                8'h26: Encode_lut_neg_rd = 10'h266;
                8'h27: Encode_lut_neg_rd = 10'h247;
                8'h28: Encode_lut_neg_rd = 10'h267;
                8'h29: Encode_lut_neg_rd = 10'h269;
                8'h2A: Encode_lut_neg_rd = 10'h26A;
                8'h2B: Encode_lut_neg_rd = 10'h24B;
                8'h2C: Encode_lut_neg_rd = 10'h26C;
                8'h2D: Encode_lut_neg_rd = 10'h24D;
                8'h2E: Encode_lut_neg_rd = 10'h24E;
                8'h2F: Encode_lut_neg_rd = 10'h27A;
                8'h30: Encode_lut_neg_rd = 10'h276;
                8'h31: Encode_lut_neg_rd = 10'h271;
                8'h32: Encode_lut_neg_rd = 10'h272;
                8'h33: Encode_lut_neg_rd = 10'h253;
                8'h34: Encode_lut_neg_rd = 10'h274;
                8'h35: Encode_lut_neg_rd = 10'h255;
                8'h36: Encode_lut_neg_rd = 10'h256;
                8'h37: Encode_lut_neg_rd = 10'h257;
                8'h38: Encode_lut_neg_rd = 10'h273;
                8'h39: Encode_lut_neg_rd = 10'h259;
                8'h3A: Encode_lut_neg_rd = 10'h25A;
                8'h3B: Encode_lut_neg_rd = 10'h25B;
                8'h3C: Encode_lut_neg_rd = 10'h25C;
                8'h3D: Encode_lut_neg_rd = 10'h25D;
                8'h3E: Encode_lut_neg_rd = 10'h25E;
                8'h3F: Encode_lut_neg_rd = 10'h275;
                8'h40: Encode_lut_neg_rd = 10'h2B9;
                8'h41: Encode_lut_neg_rd = 10'h2AE;
                8'h42: Encode_lut_neg_rd = 10'h2AD;
                8'h43: Encode_lut_neg_rd = 10'h2A3;
                8'h44: Encode_lut_neg_rd = 10'h2AB;
                8'h45: Encode_lut_neg_rd = 10'h2A5;
                8'h46: Encode_lut_neg_rd = 10'h2A6;
                8'h47: Encode_lut_neg_rd = 10'h287;
                8'h48: Encode_lut_neg_rd = 10'h2A7;
                8'h49: Encode_lut_neg_rd = 10'h2A9;
                8'h4A: Encode_lut_neg_rd = 10'h2AA;
                8'h4B: Encode_lut_neg_rd = 10'h28B;
                8'h4C: Encode_lut_neg_rd = 10'h2AC;
                8'h4D: Encode_lut_neg_rd = 10'h28D;
                8'h4E: Encode_lut_neg_rd = 10'h28E;
                8'h4F: Encode_lut_neg_rd = 10'h2BA;
                8'h50: Encode_lut_neg_rd = 10'h2B6;
                8'h51: Encode_lut_neg_rd = 10'h2B1;
                8'h52: Encode_lut_neg_rd = 10'h2B2;
                8'h53: Encode_lut_neg_rd = 10'h293;
                8'h54: Encode_lut_neg_rd = 10'h2B4;
                8'h55: Encode_lut_neg_rd = 10'h295;
                8'h56: Encode_lut_neg_rd = 10'h296;
                8'h57: Encode_lut_neg_rd = 10'h297;
                8'h58: Encode_lut_neg_rd = 10'h2B3;
                8'h59: Encode_lut_neg_rd = 10'h299;
                8'h5A: Encode_lut_neg_rd = 10'h29A;
                8'h5B: Encode_lut_neg_rd = 10'h29B;
                8'h5C: Encode_lut_neg_rd = 10'h29C;
                8'h5D: Encode_lut_neg_rd = 10'h29D;
                8'h5E: Encode_lut_neg_rd = 10'h29E;
                8'h5F: Encode_lut_neg_rd = 10'h2B5;
                8'h60: Encode_lut_neg_rd = 10'h339;
                8'h61: Encode_lut_neg_rd = 10'h32E;
                8'h62: Encode_lut_neg_rd = 10'h32D;
                8'h63: Encode_lut_neg_rd = 10'h0E3;
                8'h64: Encode_lut_neg_rd = 10'h32B;
                8'h65: Encode_lut_neg_rd = 10'h0E5;
                8'h66: Encode_lut_neg_rd = 10'h0E6;
                8'h67: Encode_lut_neg_rd = 10'h0C7;
                8'h68: Encode_lut_neg_rd = 10'h327;
                8'h69: Encode_lut_neg_rd = 10'h0E9;
                8'h6A: Encode_lut_neg_rd = 10'h0EA;
                8'h6B: Encode_lut_neg_rd = 10'h0CB;
                8'h6C: Encode_lut_neg_rd = 10'h0EC;
                8'h6D: Encode_lut_neg_rd = 10'h0CD;
                8'h6E: Encode_lut_neg_rd = 10'h0CE;
                8'h6F: Encode_lut_neg_rd = 10'h33A;
                8'h70: Encode_lut_neg_rd = 10'h336;
                8'h71: Encode_lut_neg_rd = 10'h0F1;
                8'h72: Encode_lut_neg_rd = 10'h0F2;
                8'h73: Encode_lut_neg_rd = 10'h0D3;
                8'h74: Encode_lut_neg_rd = 10'h0F4;
                8'h75: Encode_lut_neg_rd = 10'h0D5;
                8'h76: Encode_lut_neg_rd = 10'h0D6;
                8'h77: Encode_lut_neg_rd = 10'h317;
                8'h78: Encode_lut_neg_rd = 10'h333;
                8'h79: Encode_lut_neg_rd = 10'h0D9;
                8'h7A: Encode_lut_neg_rd = 10'h0DA;
                8'h7B: Encode_lut_neg_rd = 10'h31B;
                8'h7C: Encode_lut_neg_rd = 10'h0DC;
                8'h7D: Encode_lut_neg_rd = 10'h31D;
                8'h7E: Encode_lut_neg_rd = 10'h31E;
                8'h7F: Encode_lut_neg_rd = 10'h335;
                8'h80: Encode_lut_neg_rd = 10'h139;
                8'h81: Encode_lut_neg_rd = 10'h12E;
                8'h82: Encode_lut_neg_rd = 10'h12D;
                8'h83: Encode_lut_neg_rd = 10'h2E3;
                8'h84: Encode_lut_neg_rd = 10'h12B;
                8'h85: Encode_lut_neg_rd = 10'h2E5;
                8'h86: Encode_lut_neg_rd = 10'h2E6;
                8'h87: Encode_lut_neg_rd = 10'h2C7;
                8'h88: Encode_lut_neg_rd = 10'h127;
                8'h89: Encode_lut_neg_rd = 10'h2E9;
                8'h8A: Encode_lut_neg_rd = 10'h2EA;
                8'h8B: Encode_lut_neg_rd = 10'h2CB;
                8'h8C: Encode_lut_neg_rd = 10'h2EC;
                8'h8D: Encode_lut_neg_rd = 10'h2CD;
                8'h8E: Encode_lut_neg_rd = 10'h2CE;
                8'h8F: Encode_lut_neg_rd = 10'h13A;
                8'h90: Encode_lut_neg_rd = 10'h136;
                8'h91: Encode_lut_neg_rd = 10'h2F1;
                8'h92: Encode_lut_neg_rd = 10'h2F2;
                8'h93: Encode_lut_neg_rd = 10'h2D3;
                8'h94: Encode_lut_neg_rd = 10'h2F4;
                8'h95: Encode_lut_neg_rd = 10'h2D5;
                8'h96: Encode_lut_neg_rd = 10'h2D6;
                8'h97: Encode_lut_neg_rd = 10'h117;
                8'h98: Encode_lut_neg_rd = 10'h133;
                8'h99: Encode_lut_neg_rd = 10'h2D9;
                8'h9A: Encode_lut_neg_rd = 10'h2DA;
                8'h9B: Encode_lut_neg_rd = 10'h11B;
                8'h9C: Encode_lut_neg_rd = 10'h2DC;
                8'h9D: Encode_lut_neg_rd = 10'h11D;
                8'h9E: Encode_lut_neg_rd = 10'h11E;
                8'h9F: Encode_lut_neg_rd = 10'h135;
                8'hA0: Encode_lut_neg_rd = 10'h179;
                8'hA1: Encode_lut_neg_rd = 10'h16E;
                8'hA2: Encode_lut_neg_rd = 10'h16D;
                8'hA3: Encode_lut_neg_rd = 10'h163;
                8'hA4: Encode_lut_neg_rd = 10'h16B;
                8'hA5: Encode_lut_neg_rd = 10'h165;
                8'hA6: Encode_lut_neg_rd = 10'h166;
                8'hA7: Encode_lut_neg_rd = 10'h147;
                8'hA8: Encode_lut_neg_rd = 10'h167;
                8'hA9: Encode_lut_neg_rd = 10'h169;
                8'hAA: Encode_lut_neg_rd = 10'h16A;
                8'hAB: Encode_lut_neg_rd = 10'h14B;
                8'hAC: Encode_lut_neg_rd = 10'h16C;
                8'hAD: Encode_lut_neg_rd = 10'h14D;
                8'hAE: Encode_lut_neg_rd = 10'h14E;
                8'hAF: Encode_lut_neg_rd = 10'h17A;
                8'hB0: Encode_lut_neg_rd = 10'h176;
                8'hB1: Encode_lut_neg_rd = 10'h171;
                8'hB2: Encode_lut_neg_rd = 10'h172;
                8'hB3: Encode_lut_neg_rd = 10'h153;
                8'hB4: Encode_lut_neg_rd = 10'h174;
                8'hB5: Encode_lut_neg_rd = 10'h155;
                8'hB6: Encode_lut_neg_rd = 10'h156;
                8'hB7: Encode_lut_neg_rd = 10'h157;
                8'hB8: Encode_lut_neg_rd = 10'h173;
                8'hB9: Encode_lut_neg_rd = 10'h159;
                8'hBA: Encode_lut_neg_rd = 10'h15A;
                8'hBB: Encode_lut_neg_rd = 10'h15B;
                8'hBC: Encode_lut_neg_rd = 10'h15C;
                8'hBD: Encode_lut_neg_rd = 10'h15D;
                8'hBE: Encode_lut_neg_rd = 10'h15E;
                8'hBF: Encode_lut_neg_rd = 10'h175;
                8'hC0: Encode_lut_neg_rd = 10'h1B9;
                8'hC1: Encode_lut_neg_rd = 10'h1AE;
                8'hC2: Encode_lut_neg_rd = 10'h1AD;
                8'hC3: Encode_lut_neg_rd = 10'h1A3;
                8'hC4: Encode_lut_neg_rd = 10'h1AB;
                8'hC5: Encode_lut_neg_rd = 10'h1A5;
                8'hC6: Encode_lut_neg_rd = 10'h1A6;
                8'hC7: Encode_lut_neg_rd = 10'h187;
                8'hC8: Encode_lut_neg_rd = 10'h1A7;
                8'hC9: Encode_lut_neg_rd = 10'h1A9;
                8'hCA: Encode_lut_neg_rd = 10'h1AA;
                8'hCB: Encode_lut_neg_rd = 10'h18B;
                8'hCC: Encode_lut_neg_rd = 10'h1AC;
                8'hCD: Encode_lut_neg_rd = 10'h18D;
                8'hCE: Encode_lut_neg_rd = 10'h18E;
                8'hCF: Encode_lut_neg_rd = 10'h1BA;
                8'hD0: Encode_lut_neg_rd = 10'h1B6;
                8'hD1: Encode_lut_neg_rd = 10'h1B1;
                8'hD2: Encode_lut_neg_rd = 10'h1B2;
                8'hD3: Encode_lut_neg_rd = 10'h193;
                8'hD4: Encode_lut_neg_rd = 10'h1B4;
                8'hD5: Encode_lut_neg_rd = 10'h195;
                8'hD6: Encode_lut_neg_rd = 10'h196;
                8'hD7: Encode_lut_neg_rd = 10'h197;
                8'hD8: Encode_lut_neg_rd = 10'h1B3;
                8'hD9: Encode_lut_neg_rd = 10'h199;
                8'hDA: Encode_lut_neg_rd = 10'h19A;
                8'hDB: Encode_lut_neg_rd = 10'h19B;
                8'hDC: Encode_lut_neg_rd = 10'h19C;
                8'hDD: Encode_lut_neg_rd = 10'h19D;
                8'hDE: Encode_lut_neg_rd = 10'h19E;
                8'hDF: Encode_lut_neg_rd = 10'h1B5;
                8'hE0: Encode_lut_neg_rd = 10'h239;
                8'hE1: Encode_lut_neg_rd = 10'h22E;
                8'hE2: Encode_lut_neg_rd = 10'h22D;
                8'hE3: Encode_lut_neg_rd = 10'h1E3;
                8'hE4: Encode_lut_neg_rd = 10'h22B;
                8'hE5: Encode_lut_neg_rd = 10'h1E5;
                8'hE6: Encode_lut_neg_rd = 10'h1E6;
                8'hE7: Encode_lut_neg_rd = 10'h1C7;
                8'hE8: Encode_lut_neg_rd = 10'h227;
                8'hE9: Encode_lut_neg_rd = 10'h1E9;
                8'hEA: Encode_lut_neg_rd = 10'h1EA;
                8'hEB: Encode_lut_neg_rd = 10'h1CB;
                8'hEC: Encode_lut_neg_rd = 10'h1EC;
                8'hED: Encode_lut_neg_rd = 10'h1CD;
                8'hEE: Encode_lut_neg_rd = 10'h1CE;
                8'hEF: Encode_lut_neg_rd = 10'h23A;
                8'hF0: Encode_lut_neg_rd = 10'h236;
                8'hF1: Encode_lut_neg_rd = 10'h3B1;
                8'hF2: Encode_lut_neg_rd = 10'h3B2;
                8'hF3: Encode_lut_neg_rd = 10'h1D3;
                8'hF4: Encode_lut_neg_rd = 10'h3B4;
                8'hF5: Encode_lut_neg_rd = 10'h1D5;
                8'hF6: Encode_lut_neg_rd = 10'h1D6;
                8'hF7: Encode_lut_neg_rd = 10'h217;
                8'hF8: Encode_lut_neg_rd = 10'h233;
                8'hF9: Encode_lut_neg_rd = 10'h1D9;
                8'hFA: Encode_lut_neg_rd = 10'h1DA;
                8'hFB: Encode_lut_neg_rd = 10'h21B;
                8'hFC: Encode_lut_neg_rd = 10'h1DC;
                8'hFD: Encode_lut_neg_rd = 10'h21D;
                8'hFE: Encode_lut_neg_rd = 10'h21E;
                8'hFF: Encode_lut_neg_rd = 10'h235;
                default: Encode_lut_neg_rd = 10'h1BC; // 默认值
            endcase
        end else begin // k = 1时
            case(data)
                8'h1C: Encode_lut_neg_rd = 10'h0BC; // K28.0
                8'h3C: Encode_lut_neg_rd = 10'h27C; // K28.1
                8'h5C: Encode_lut_neg_rd = 10'h2BC; // K28.2
                8'h7C: Encode_lut_neg_rd = 10'h33C; // K28.3
                8'h9C: Encode_lut_neg_rd = 10'h13C; // K28.4
                8'hBC: Encode_lut_neg_rd = 10'h17C; // K28.5 (Comma)
                8'hDC: Encode_lut_neg_rd = 10'h1BC; // K28.6
                8'hFC: Encode_lut_neg_rd = 10'h07C; // K28.7
                8'hF7: Encode_lut_neg_rd = 10'h057; // K23.7
                8'hFB: Encode_lut_neg_rd = 10'h05B; // K27.7
                8'hFD: Encode_lut_neg_rd = 10'h05D; // K29.7
                8'hFE: Encode_lut_neg_rd = 10'h05E; // K30.7
                default : Encode_lut_neg_rd = 10'h1BC;
            endcase
        end
    end
endfunction

endmodule

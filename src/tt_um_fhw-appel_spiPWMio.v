/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_fhw_appel_spiPWMio (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);


  pwm_inout_top top_inst
    (
    .clk(clk),
    .rst_n(rst_n),
    // SPI Interface
    .spi_cs_n(uio_in[4]),
    .spi_sck(uio_in[7]),
    .spi_mosi(uio_in[5]),
    .spi_miso(uio_out[6]),
    // Inputs
    .ipins(ui_in[6:0]),
    .pwm_in(ui_in[7]),
    // Outputs
    .opins(uo_out[6:0]),
    .pwm_sig(uo_out[7])
  );


  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out[5:0] = 0;
  assign uio_out[7] = 0;
  assign uio_oe[5:0]  = 0;
  assign uio_oe[7]  = 0;
  assign uio_oe[6]  = 1;  // spi_miso is an output

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in[6], uio_in[3:0], 1'b0};

endmodule

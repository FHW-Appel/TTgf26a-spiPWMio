`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  // SPI IF
  reg spi_cs_n;
  reg spi_sck;
  reg spi_mosi;
  wire spi_miso;
  // Dedicated inputs and outputs
  reg [6:0] ipins;
  reg pwm_in;
  wire [6:0] opins;
  wire pwm_sig; 

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // unused connections:
  wire [7:0] uio_oe;
  wire [5:0] uio_outa;
  wire uio_outb;

  // Replace tt_um_example with your module name:
  tt_um_fhw_appel_spiPWMio user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  ({pwm_in, ipins}),    // Dedicated inputs
      .uo_out ({pwm_sig, opins}),   // Dedicated outputs
      .uio_in ({spi_sck, 1'b0, spi_mosi, spi_cs_n, 4'b1}),   // IOs: Input path
      .uio_out({uio_outb, spi_miso, uio_outa}),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (1'b1),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  wire _unused = &{uio_oe[7:0], uio_outa[5:0], uio_outb, 1'b0};

endmodule

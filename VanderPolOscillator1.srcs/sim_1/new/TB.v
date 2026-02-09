`timescale 1ns / 1ps

module VanDerPolTB;


    // Testbench signals
    reg clk;
    reg reset;
    wire signed [31:0] y_out;

    // DUT
    VanDerPol DUT (
        .clk   (clk),
        .reset (reset),
        .y_out (y_out)
    );


    // Clock generation (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;


    // File handling
    integer file;
    integer last_t;
    real y_real;


    initial begin
        file = $fopen("vanderpol_results_real.txt", "w");
        if (file == 0) begin
            $display("ERROR: Could not open file");
            $finish;
        end

        $fwrite(file, "Van der Pol Oscillator – Simulation Results\n");
        $fwrite(file, "-----------------------------------------\n");
        $fwrite(file, "mu = 1, dt = 0.01, final time = 20\n\n");
        $fwrite(file, "t\t y(real)\n");
        $fwrite(file, "-------------------------\n");

        last_t = -1;

        reset = 1'b1;
        #20;
        reset = 1'b0;
    end

    // Log REAL y(t) once per Euler step
    always @(posedge clk) begin
        if (!reset) begin
            if (DUT.t != last_t) begin
                y_real = DUT.y / 65536.0;
                $fwrite(file, "%0d\t %f\n", DUT.t, y_real);
                last_t = DUT.t;   
            end
        end
    end


    initial begin
        #60000;
        $fwrite(file, "\nSimulation finished.\n");
        $fclose(file);
        $display("Simulation complete. Results written to vanderpol_results_real.txt");
        $finish;
    end

endmodule

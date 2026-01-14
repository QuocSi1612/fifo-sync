`timescale 1ns/1ps

module tb;

    localparam W = 8;
    localparam H = 8;

    logic clk;
    logic rst_n;
    logic r;
    logic wr;
    logic [W-1:0] wr_data;

    wire full;
    wire empty;
    wire [W-1:0] r_data;

    sfifo #(W, H) dut (
        .clk(clk),
        .rst_n(rst_n),
        .r(r),
        .wr(wr),
        .wr_data(wr_data),
        .full(full),
        .empty(empty),
        .r_data(r_data)
    );

    // Clock 10ns
    always #5 clk = ~clk;

    initial begin
        integer i;
        integer write_count;

        // Init
        clk = 0;
        rst_n = 0;
        r = 0;
        wr = 0;
        wr_data = 0;

        // Reset
        repeat(2) @(posedge clk);
        rst_n = 1;

        $display("=== READ/WRITE ĐỒNG THỜI ===");

        i = 0;
        write_count = 0;

        // Lặp 15 chu kỳ để minh họa read/write đồng thời
        repeat(15) @(posedge clk) begin

            // Ghi khi FIFO chưa đầy và chưa ghi đủ 5 giá trị
            if (!full && write_count < 5) begin
                wr <= 1;
                wr_data <= i;
                i = i + 1;
                write_count = write_count + 1;
            end else begin
                wr <= 0;
            end

            // Đọc khi FIFO chưa trống
            if (!empty) begin
                r <= 1;
            end else begin
                r <= 0;
            end

            $display("[%0t] wr=%b wr_data=%0d | r=%b r_data=%0d | full=%b empty=%b",
                     $time, wr, wr_data, r, r_data, full, empty);
        end

        // Dừng mọi hoạt động
        wr <= 0;
        r <= 0;
        $display("[%0t] Kết thúc read/write đồng thời", $time);

        repeat(2) @(posedge clk);
        $finish;
    end

endmodule

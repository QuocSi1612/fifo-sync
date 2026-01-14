
//! Case 1: Ghi đến khi đầy
//!{"signal": [
//!  { "name": "clk",      "wave": "p................" },
//!  { "name": "rst_n",    "wave": "lh.............." },
//! { "name": "wr",       "wave": "lh.........l...." },
//! { "name": "wr_data",  "wave": "x.=========0.",
//!   "data": ["00","01","02","03","04","05","06","07","08"] },
//! { "name": "full",     "wave": "l.........h.." },
//! { "name": "empty",    "wave": "h.l.........." },
//!{ "name": "r_data",   "wave": "x................" }
//! ]}

//! Case 2: Đọc đến khi trống

//! {"signal": [
//!  { "name": "clk",      "wave": "p.................." },
//!  { "name": "rst_n",    "wave": "lh.............." },
//!   { "name": "wr",       "wave": "l................" },  
//!  { "name": "r",        "wave": "lh.............." },  
//!  { "name": "wr_data",  "wave": "x................" },
//!  { "name": "full",     "wave": "hl............." },  
//!  { "name": "empty",    "wave": "l........h...." }, 
//!  { "name": "r_data",   "wave": "x.========0." ,
//!    "data": ["00","01","02","03","04","05","06","07"] }
//!]}

//! Case 3: Đọc ghi đồng thời
//! {"signal": [
//!  { "name": "clk",      "wave": "p..................." },
//! { "name": "rst_n",    "wave": "lh.............." },
//!{ "name": "wr",       "wave": "lh.....l........." },
//!   { "name": "wr_data",  "wave": "x.=====0.........",
//!  	"data": ["0","1","2","3","4"]},
//! { "name": "r",        "wave": "l...h....l....." }, 
//!{ "name": "full",     "wave": "l................" },
//!{ "name": "empty",    "wave": "h.l......h......." }, 
//!{ "name": "r_data",   "wave": "x....=====0....." ,
//! "data": ["0","1","2","3","4"] }
//!]}









module sfifo
    #(parameter W=8,H=8)
    (
    input logic clk,
    input logic rst_n,
    input logic r,
    input logic wr,
    input logic [W-1:0] wr_data,

    output logic full,
    output logic empty,
    output logic [W-1:0] r_data

    );

    reg [W-1:0] memory [0:H-1];

    logic [W-1:0] data_tmp;
    logic [$clog2(W)-1:0] r_ptn,wr_ptn;
    logic [$clog2(W)-1:0] r_ptn_next,wr_ptn_next;
    logic r_en,wr_en,empty_reg,full_reg;

    assign r_ptn_next=r_ptn+1;
    assign wr_ptn_next=wr_ptn+1;
    assign r_data=data_tmp;
    assign full=full_reg;
    assign empty=empty_reg;
    assign r_en=r & !empty;
    assign wr_en=wr & !full;

    always_ff @(posedge clk ) begin
        if(!rst_n) 
            begin
                r_ptn<=0;
                wr_ptn<=0;
                full_reg<=0;
                empty_reg<=1;
             //   data_tmp <= 0;
            end

        if(r_en)
            begin
                data_tmp<=memory[r_ptn];
                r_ptn<=(r_ptn==(H-1))?0:r_ptn_next;
            end
        if(wr_en)
            begin
                memory[wr_ptn]<=wr_data;
                wr_ptn<=(wr_ptn==(H-1))?0:wr_ptn_next;
            end

        if (wr_en && !r_en) 
            begin
                empty_reg <= 0;
                if (wr_ptn_next == r_ptn)
                    full_reg <= 1;
            end

            
        if (r_en && !wr_en) 
            begin
                full_reg <= 0;
                if (r_ptn_next == wr_ptn)
                        empty_reg <= 1;
            end
    end

endmodule
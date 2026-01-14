# fifo-sync
`fifo-sync` is a synchronous FIFO (First-In-First-Out) buffer designed for digital systems. It supports simultaneous read and write operations synchronized to a common clock. The module includes status flags (`full`, `empty`) and provides reliable data flow between producer and consumer logic. Features: - Parameterizable data width and depth - Synchronous read/write interface - Full and empty indicators
# Architecture Diagram

<div align="center"> <img src="https://github.com/user-attachments/assets/674d8e9b-a453-44e0-b28d-45d8dc509804" width="700"/> </div>

# Description
Case 1: Ghi đến khi đầy

<img width="984" height="269" alt="image" src="https://github.com/user-attachments/assets/13bd407e-805f-4c6b-9608-44908a829722" />

Case 2: Đọc đến khi trống

<img width="1074" height="326" alt="image" src="https://github.com/user-attachments/assets/1d21344f-f4fd-49b7-8908-b4b05062e83d" />

Case 3: Đọc ghi đồng thời

<img width="1106" height="330" alt="image" src="https://github.com/user-attachments/assets/952ddb4f-e75b-4019-9937-65958598f022" />

# Signals

| Name           | Type                    | Description |
|----------------|-------------------------|-------------|
| memory [0:H-1] | reg [W-1:0]             |             |
| data_tmp       | logic [W-1:0]           |             |
| r_ptn          | logic [clog2(W)-1:0]    |             |
| wr_ptn         | logic [clog2(W)-1:0]    |             |
| r_ptn_next     | logic [clog2(W)-1:0]    |             |
| wr_ptn_next    | logic [clog2(W)-1:0]    |             |
| r_en           | logic                   |             |
| wr_en          | logic                   |             |
| empty_reg      | logic                   |             |
| full_reg       | logic                   |             |

# Simulation on ModelSim

<img width="1817" height="157" alt="docday" src="https://github.com/user-attachments/assets/371f8403-7b6d-49fd-884d-b6991226d506" />

<img width="1393" height="249" alt="ghiday" src="https://github.com/user-attachments/assets/dae44fef-b13e-4511-843c-a312af9850d2" />



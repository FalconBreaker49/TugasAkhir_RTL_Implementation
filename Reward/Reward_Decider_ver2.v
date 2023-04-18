// Ini adalah Reward Decider version 2 menggunakan algoritma tersendiri 
// Inti dari pemberian rewardnya adalah dilihat setelah memberikan action ke current state, di state tersebut 
// Adalah lanes yang level kmeacetannya bernilai 0 atau tidak. Jika ada yang bernilai 0, dibeirkan + reward
// Lane yang tidak nol menjadi negative reward. 
// Cuma ada dua reward. Soalnya dia cuma ngeliat ada yang 0 -> positive reward kalau gak 0 --> negative reward. 
// Outputnya 1 saja karena reward untuk A dan B digabung jadi 1.
// Dari module State Decider, S_A dan S_B ukurannya 12 bit. 3 bit masing-masing untuk setiap lane (4 lane)
module RD (
  //----------
  input wire clk, rst, 
  input wire [31:0] R0, R1,
  input wire [11:0] S_A, S_B,
  output reg  [31:0] R0,
  output wire [31:0] R
);
  
// Flownya adalah dari State_A dan State_B --> Partisi jadi Lane_0 sampai Lane_3 --> Bandingkan setiap lane berapa banyak 1 atau 0 nya
// Setiap kali ada 0 --> +Reward . Setiap kali ada 1 --> -Reward. 

# DSD RV32I Universal Labs — 7 Weeks

Bộ lab này giữ độ rộng của bộ mẫu cũ nhưng được thiết kế lại theo một contract RV32I duy nhất. Lộ trình chủ động dồn kiến thức vào đúng 7 tuần:

1. HDL và self-checking verification.
2. Các khối xây dựng RV32I.
3. Single-cycle datapath.
4. Single-cycle memory/branch và FPGA.
5. Multi-cycle RV32I và control FSM.
6. Pipeline 5 tầng chưa có hazard.
7. Hazard-aware pipeline và capstone FPGA.

## Cấu trúc

- `STUDENT/Week_01` … `STUDENT/Week_07`: manual riêng cho từng tuần.
- `STUDENT/COMMON`: QSF/SDC chung và template báo cáo/testbench.
- `INSTRUCTOR`: hướng dẫn triển khai, migration note, 7 answer key nội bộ và `REFERENCE_RTL/Week_01` … `Week_07` chứa code lời giải.
- `figures`: hình toàn datapath và hình cắt theo module từ ảnh người dùng cung cấp.
- `sources`: ảnh nguồn được giữ nguyên để đối chiếu.

## Contract nền

- Baseline: `add`, `sub`, `and`, `or`, `slt`, `addi`, `lw`, `sw`, `beq`.
- Giai đoạn nền tảng dùng Verilog-2001 (`.v`, `wire/reg`, `always @(*)`); chưa yêu cầu SystemVerilog.
- `jal` là extension, không nằm trong gate tối thiểu.
- `posedge clk`, `reset_n` active-low.
- PC tuần tự tăng 4; memory index theo word.
- Hậu tố tín hiệu: F/D/E/M/W.
- Test tự kiểm tra phải có `PASS/FAIL` và timeout.
- Sau mỗi experiment, sinh viên nộp code RTL, testbench, log và ảnh waveform chụp bằng ModelSim hoặc Questa ngay trong phần minh chứng của experiment.
- Mỗi manual có sẵn trường Họ tên, MSSV, môn DSD, Group/Lớp, ngày nộp và giảng viên để dùng như form báo cáo.
- FPGA: Cyclone V `5CSXFC6D6F31C6`, clock 50 MHz.

Đây là bộ manual, contract và reference RTL để pilot. Trước phát hành chính thức vẫn cần khóa starter RTL dành cho sinh viên, chạy public/hidden regression và đối chiếu golden signatures giữa ba kiến trúc.

## Answer key nội bộ

Mỗi file trong `INSTRUCTOR/ANSWERS` gồm đáp án cốt lõi, code Verilog-2001 hoàn chỉnh theo từng experiment, kết quả mong đợi, lỗi thường gặp, hidden tests, đáp án vấn đáp và gate chấm. Code pipeline tái sử dụng cấu trúc/tên tín hiệu từ các bộ RISC-V người dùng cung cấp và đã sửa các lỗi x0, signed SLT, load-use, forwarding priority, clock edge và unsafe defaults. Không phát các file này trong student package.

## Về file mẫu Lab 3

File mẫu Lab 3 được dùng để tham khảo bố cục báo cáo và cách tổ chức nội dung. Các hình MIPS, bảng thanh ghi `$s0/$s1`, opcode MIPS, format jump MIPS và phần “Complete Processor 16 bit” không được chèn trực tiếp vào bộ mới vì sẽ mâu thuẫn với ISA RV32I 32-bit, tên tín hiệu F/D/E/M/W và contract branch-at-EX của khóa học này.

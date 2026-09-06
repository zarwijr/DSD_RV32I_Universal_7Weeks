# Self-checking testbench checklist

- [ ] Clock có chu kỳ xác định và chỉ được tạo tại testbench.
- [ ] Reset được assert/deassert theo đúng `reset_n` active-low.
- [ ] Mọi expected value đến từ oracle độc lập với DUT.
- [ ] Có directed corner cases trước random tests.
- [ ] Có error counter.
- [ ] Có timeout hữu hạn.
- [ ] Dòng cuối là duy nhất: `TEST_PASS` hoặc `TEST_FAIL`.
- [ ] Log ghi seed và cycle kết thúc.
- [ ] Waveform chỉ là bằng chứng debug, không thay thế assertion/check.
- [ ] Test cố ý trên mutant phải báo FAIL.

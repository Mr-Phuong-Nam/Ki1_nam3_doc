---==================================== Quản lý thông tin thanh toán ==================================

---------------------------------------------------------------------------
-- Thêm thanh toán
create or alter proc Them_HoaDon
	@LoaiHoaDon int, -- 1: Hóa đơn thuốc, 2: Hóa đơn liệu trình
	@LoaiThanhToan nvarchar(30),
	@TienTra int,
    	@TienThoi int = null,
    	@GhiChu nvarchar(50),
	@MaDonThuoc int = null,
	@MaKeHoach int = null
as
begin
	declare @MaHoaDon int = coalesce((select max(MaHoaDon) + 1 from HoaDon),100000000)

	if @LoaiHoaDon = 1 and LEN(ISNULL(@MaDonThuoc,'')) != 0
		begin
			set @TienThoi = (select TongGia from DonThuoc where MaDonThuoc = @MaDonThuoc) - @TienTra
			-- thêm hóa đơn
			insert into HoaDon
			values (@MaHoaDon, GETDATE(), @LoaiThanhToan, @TienTra, @TienThoi, @GhiChu)
			-- cập nhật liên quan
			update DonThuoc
			set MaHoaDon = @MaHoaDon
			where MaDonThuoc = @MaDonThuoc
		end

	else if @LoaiHoaDon = 2 and LEN(ISNULL(@MaKeHoach,'')) != 0
		begin
			set @TienThoi = (select TongTien from KeHoachDieuTri where MaKeHoach = @MaKeHoach) - @TienTra
			-- thêm hóa đơn
			insert into HoaDon
			values (@MaHoaDon, GETDATE(), @LoaiThanhToan, @TienTra, @TienThoi, @GhiChu)
			-- cập nhật liên quan
			update KeHoachDieuTri
			set MaHoaDon = @MaHoaDon
			where MaKeHoach = @MaKeHoach
		end

	else    
		begin
		        print N'Loại hóa đơn không hợp lệ'
		        return
	    	end
end
go
--exec Them_HoaDon 2, N'Chuyển khoản', 4000000, null, null, null, 16
--select * from KeHoachDieuTri kh join HoaDon hd 
--on kh.MaHoaDon = hd.MaHoaDon where MaKeHoach = 16

---------------------------------------------------------------------------
-- Xem lịch sử thanh toán của bệnh nhân
create or alter proc Xem_ThanhToan
	@MaBN int
as
begin
	if (dbo.TonTai_BenhNhan(@MaBN) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return 
		end
	
	select NhaSiKham, TroKham, TongTien, NgayGiaoDich
	from HoaDon hd join KeHoachDieuTri kh on hd.MaHoaDon = kh.MaHoaDon
			join LichHen lh on kh.MaLichHen = lh.MaLichHen
	where kh.MaBenhNhan = @MaBN and kh.TinhTrang = N'Đã hoàn thành'
end
go

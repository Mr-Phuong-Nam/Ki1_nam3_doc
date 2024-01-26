---==================================== Quản lý thông tin đơn thuốc ==================================

---- Tạo danh sách thuốc trong đơn thuốc
--CREATE TYPE medicine_list AS TABLE (
--	STT int,
--    MaThuoc int,
--    LieuLuong int
--);
--go

---------------------------------------------------------------------------
-- Thêm chi tiết đơn thuốc
create or alter proc Them_ChiTietDonThuoc
	@MaDonThuoc int,
	@MaThuoc int,
	@LieuLuong int
as
begin
	--kiểm tra đơn thuốc
	if not exists (select * from DonThuoc where MaDonThuoc = @MaDonThuoc)
		begin
			print N'Không tìm thấy đơn thuốc'
			return
		end
	--kiểm tra thuốc
	if dbo.TonTai_Thuoc(@MaThuoc) = 0
		begin
			print N'Không tìm thấy thuốc'
			return
		end
	--kiểm tra liều lượng
	if @LieuLuong <= 0 or @LieuLuong is null
		begin
			print N'Thêm chi tiết không hợp lệ'
			return
		end
	
	-- kiểm tra HSD thuốc
	declare @hsd date = (select HSD from Thuoc where MaThuoc = @MaThuoc)
	if DATEDIFF(day, GETDATE(), @hsd) < 7
		begin
			print N'Hạn sử dụng thuốc không đảm bảo'
			return
		end

	-- thêm chi tiết
	insert into ChiTietDonThuoc
	values (@MaDonThuoc, @MaThuoc, @LieuLuong)
	--Cập nhật đơn thuốc
	update DonThuoc
	set NgayLap = GETDATE()
	where MaDonThuoc = @MaDonThuoc

end
go

---------------------------------------------------------------------------
-- Thêm đơn thuốc
-- (khởi tạo đơn thuốc trống, thêm chi tiết đơn thuốc sau)
create or alter proc Them_DonThuoc
	@GhiChu nvarchar(100),
	@MaBenhAn int,
    	@MaBenhNhan int
as
begin
	-- kiểm tra bệnh nhân
	if (dbo.TonTai_BenhNhan(@MaBenhNhan) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return
		end
	-- kiểm tra bệnh án
	if (dbo.TonTai_BenhAn(@MaBenhNhan, @MaBenhAn) = 0)
		begin
			print N'Không tìm thấy bệnh án của bệnh nhân này'
			return 
		end

	declare @MaDonThuoc int = coalesce((select max(MaDonThuoc) + 1 from DonThuoc),1)
	
	-- thêm đơn thuốc
	insert into DonThuoc (MaDonThuoc, NgayLap, GhiChu, MaBenhAn, MaBenhNhan)
	values(@MaDonThuoc, GETDATE(), @GhiChu, @MaBenhAn, @MaBenhNhan)

end
go

---------------------------------------------------------------------------
-- Cập nhật chi tiết đơn thuốc
create or alter proc CapNhat_ChiTietDonThuoc
	@MaDonThuoc int,
	@MaThuoc int,
	@LieuLuong int
as
begin
	--kiểm tra đơn thuốc
	if not exists (select * from DonThuoc where MaDonThuoc = @MaDonThuoc)
		begin
			print N'Không tìm thấy đơn thuốc'
			return
		end
	--kiểm tra thuốc
	if dbo.TonTai_Thuoc(@MaThuoc) = 0
		begin
			print N'Không tìm thấy thuốc'
			return
		end
	--kiểm tra chi tiết 
	if not exists (select * from ChiTietDonThuoc where MaDonThuoc = @MaDonThuoc and MaThuoc = @MaThuoc)
		begin
			print N'Không tìm thấy chi tiết tương ứng'
			return
		end

	--xóa chi tiết
	if @LieuLuong <= 0 or @LieuLuong is null
		delete ChiTietDonThuoc where MaDonThuoc = @MaDonThuoc and MaThuoc = @MaThuoc

	-- thay đổi chi tiết
	update ChiTietDonThuoc
	set LieuLuong = @LieuLuong
	where MaDonThuoc = @MaDonThuoc and MaThuoc = @MaThuoc

end
go

---------------------------------------------------------------------------
-- Cập nhật đơn thuốc
create or alter proc CapNhat_DonThuoc
	@MaDonThuoc int,
	@GhiChu nvarchar(100)
as
begin
	--kiểm tra đơn thuốc
	if not exists (select * from DonThuoc where MaDonThuoc = @MaDonThuoc)
		begin
			print N'Không tìm thấy đơn thuốc'
			return
		end
	
	declare @TongTien int = (select sum(t.DonGia * ct.LieuLuong) from ChiTietDonThuoc ct join Thuoc t
									on ct.MaThuoc = t.MaThuoc
									where ct.MaDonThuoc = @MaDonThuoc)
	update DonThuoc
	set TongGia = @TongTien, GhiChu = @GhiChu
	where MaDonThuoc = @MaDonThuoc

end
go

---==================================== Quản lý thông tin điều trị ==================================

-- Kiểm tra kế hoạch có tồn tại
create or alter function TonTai_KeHoach (@maKH int)
returns int
as
begin
	declare @kq int
	if exists (select MaKeHoach from KeHoachDieuTri where MaKeHoach = @maKH)
		set @kq = 1
	else
		set @kq = 0

	return @kq
end
go

-- Kiểm tra điều trị có tồn tại
create or alter function TonTai_DieuTri	(@DieuTri nvarchar(100))
returns int
as
begin
	declare @kq int
	if exists (select LoaiDieuTri from DanhMucDieuTri where LoaiDieuTri = @DieuTri)
		set @kq = 1
	else
		set @kq = 0

	return @kq
end
go

---------------------------------------------------------------------------
-- Xem thông tin liệu trình
create or alter proc Xem_LieuTrinh 
	@maKH int
as
begin
	-- kiểm tra liệu trình
	if (dbo.TonTai_KeHoach(@maKH) = 0)
		begin
			print N'Không tìm thấy liệu trình'
			return
		end
	
	-- xem thông tin liệu trình
	select MaKeHoach, MoTa, NgayDieuTri = NgayGioHen, NhaSiKham, TroKham, GhiChu
	from KeHoachDieuTri kh join LichHen lh 
	on kh.MaLichHen = lh.MaLichHen where MaKeHoach = @maKH

	-- xem danh sách răng điều trị
	select SoRang, MatRang from KeHoachDieuTri kh join ChiTietKeHoach ct
	on kh.MaKeHoach = ct.MaKeHoach where kh.MaKeHoach = @maKH
end
go


---- Tạo danh sách răng chữa trị
--CREATE TYPE tooth_list AS TABLE (
--	STT int primary key,
--    SoRang int,
--    MatRang char(5)
--);
--go

---------------------------------------------------------------------------
-- Thêm mới chi tiết liệu trình
-- Giả sử: mọi liệu trình có thể áp dụng trên tất cả số răng và mặt răng
create or alter proc Them_ChiTietLieuTrinh
	@maKH int,
	@SoRang int,
	@MatRang char(5)
as
begin
	--Kiểm tra liệu trình
	if (dbo.TonTai_KeHoach(@maKH) = 0)
		begin
			print N'Không tìm thấy liệu trình'
			return
		end
	--Kiểm tra số răng
	if @SoRang not in (select SoRang from Rang)
	begin
		print N'Số răng điều trị không có trong hệ thống'
		return
	end
	--Kiểm tra mặt răng
	if @MatRang not in (select MatRang from MatRang)
	begin
		print N'Mặt răng điều trị không có trong hệ thống'
		return
	end

	-- thêm chi tiết
	declare @stt int = coalesce((select max(SoThuTu) + 1 from ChiTietKeHoach where MaKeHoach = @maKH), 1)
	insert into ChiTietKeHoach
	values (@maKH, @stt, @SoRang, @MatRang)

end
go

---------------------------------------------------------------------------
-- Thêm mới liệu trình
create or alter proc Them_LieuTrinh 
    @MoTa nvarchar(100) = null,
    @LoaiDieuTri nvarchar(50),
    @MaLichHen int,
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
	-- kiểm tra điều trị
	if (dbo.TonTai_DieuTri(@LoaiDieuTri) = 0)
		begin
			print N'Không tìm thấy loại trị liệu này'
			return 
		end
	-- kiểm tra lịch hẹn
	if not exists (select * from LichHen where MaLichHen = @MaLichHen and MaBenhNhan = @MaBenhNhan)
		begin
			print N'Không tìm thấy lịch hẹn cho bệnh nhân này'
			return 
		end

	-- Thêm kế hoạch
	declare @TinhTrang nvarchar(50) = N'Kế hoạch',
		@MaDieuTri int = (select MaDieuTri from DanhMucDieuTri where LoaiDieuTri = @LoaiDieuTri),
		@MaKeHoach int = coalesce((select max(MaKeHoach) + 1 from KeHoachDieuTri 
						where MaBenhNhan = @MaBenhNhan and MaBenhAn = @MaBenhAn ), 1)
	
	insert into KeHoachDieuTri (MaKeHoach, MoTa, TinhTrang, MaDieuTri, MaLichHen, MaBenhAn, MaBenhNhan)
	values (@MaKeHoach, @MoTa, @TinhTrang, @MaDieuTri, @MaLichHen, @MaBenhAn, @MaBenhNhan)
	
end
go

---------------------------------------------------------------------------
-- Cập nhật liệu trình
-- Giả sử: Lịch hẹn đã được thêm trước
create or alter proc CapNhat_LieuTrinh 
	@MaKeHoach int,
    	@MoTa nvarchar(100) = null,
    	@TinhTrang nvarchar(50) = null
	-- Kế hoạch (màu xanh dương), đã hoàn thành (màu xanh lá), đã hủy (màu vàng).
as
begin
	-- Kiểm tra kế hoạch
	if (dbo.TonTai_KeHoach(@MaKeHoach) = 0)
		begin
			print N'Liệu trình không tồn tại'
			return
		end

	-- kiểm tra tình trạng
	if ((select TinhTrang from KeHoachDieuTri where MaKeHoach = @MaKeHoach) <> N'Kế hoạch')
		begin
	        	print N'Thay đổi không hợp lệ'
	        	return
    		end
	if(LEN(ISNULL(@TinhTrang,'')) = 0 )
		begin
			set @TinhTrang = N'Kế hoạch'
		end

	-- if (@TinhTrang = N'Đã hủy')
	-- Xóa cuộc hẹn, set MaLichHen trong KeHoachDieuTri = null, MaHoaDon = null

	declare @TongTien int
	if (select DonVi from KeHoachDieuTri kh join DanhMucDieuTri dt 
			on kh.MaDieuTri = dt.MaDieuTri where kh.MaKeHoach = @MaKeHoach) = N'Hàm'
		set @TongTien = (select DonGia from KeHoachDieuTri kh join DanhMucDieuTri dt 
						on kh.MaDieuTri = dt.MaDieuTri where kh.MaKeHoach = @MaKeHoach)
	else
		begin
			set @TongTien = (select DonGia from KeHoachDieuTri kh join DanhMucDieuTri dt 
							on kh.MaDieuTri = dt.MaDieuTri where kh.MaKeHoach = @MaKeHoach)
					* (select count(*) from KeHoachDieuTri kh join ChiTietKeHoach ct 
										on kh.MaKeHoach = ct.MaKeHoach where kh.MaKeHoach = @MaKeHoach)
		end

	update KeHoachDieuTri
	set MoTa = @MoTa, TinhTrang = @TinhTrang, TongTien = @TongTien
	where MaKeHoach = @MaKeHoach

end
go

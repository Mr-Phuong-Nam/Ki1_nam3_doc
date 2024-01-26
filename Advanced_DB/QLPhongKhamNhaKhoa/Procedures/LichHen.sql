﻿-- Xem danh sách các cuộc hẹn trong từng ngày
-- bao gồm thông tin thời gian, tên bệnh nhân, nha sĩ, trợ khám, phòng, tình trạng.

CREATE OR ALTER PROCEDURE sp_XemLichHen
	
AS
BEGIN
	SELECT lh.NgayGioHen, bn.TenBenhNhan, 
			lh.Phong, lh.TinhTrang,
			ns.TenNhaSi AS NhaSi, 
			tk.TenNhaSi AS TroKham
	FROM LichHen lh
			JOIN BenhNhan bn ON lh.MaBenhNhan = bn.MaBenhNhan
			JOIN NhaSi ns ON lh.NhaSiKham = ns.MaNhaSi
			JOIN NhaSi tk ON lh.TroKham = tk.MaNhaSi
	ORDER BY lh.ThoiGianYeuCau
	
END
go
--exec sp_XemLichHen
go

---------------------------------------------------------------------------------------------

-- Lọc danh sách lịch hẹn
-- theo Tên bệnh nhân/ Tên Nha sĩ phụ trách/ Phòng

CREATE OR ALTER PROCEDURE sp_TimLichHen
	@TenBenhNhan nvarchar(50) = null,
	@PhongKham nvarchar(30) = null,
	@TenNhaSi nvarchar(50) = null
	
AS
BEGIN
	if @TenBenhNhan is not null and 
		not exists(select * from BenhNhan where TenBenhNhan = @TenBenhNhan)
			begin
				print 'Ten benh nhan khong ton tai'
				return 0
			end

	if @PhongKham is not null and 
		not exists(select * from LichHen where Phong = @PhongKham)
			begin
				print 'Phong kham khong ton tai'
				return 0
			end

	if @TenNhaSi is not null and 
		not exists(select * from NhaSi where TenNhaSi = @TenNhaSi)
			begin
				print 'Ten nha si khong ton tai'
				return 0
			end

	SELECT lh.MaLichHen, lh.NgayGioHen, lh.Phong, lh.TinhTrang,
			bn.TenBenhNhan, 
			ns.TenNhaSi AS NhaSi, 
			tk.TenNhaSi AS TroKham
	FROM LichHen lh 
			JOIN BenhNhan bn ON lh.MaBenhNhan = bn.MaBenhNhan
			JOIN NhaSi ns ON lh.NhaSiKham = ns.MaNhaSi
			JOIN NhaSi tk ON lh.TroKham = tk.MaNhaSi
	WHERE (@TenBenhNhan IS NULL OR bn.TenBenhNhan = @TenBenhNhan)
			AND (@PhongKham IS NULL OR lh.Phong = @PhongKham)
			AND (@TenNhaSi IS NULL OR ns.TenNhaSi = @TenNhaSi)
END
go
--exec sp_TimLichHen @TenNhaSi = N'Vũ Phương Linh'
go

---------------------------------------------------------------------------------------------

-- Xem chi tiết yêu cầu hẹn khám trong từng ngày
-- bao gồm thông tin tên bệnh nhân, ngày hẹn yêu cầu, ghi chú, thời gian yêu cầu.

CREATE OR ALTER PROCEDURE sp_XemChiTietYeuCauHenKham

AS
BEGIN
	SELECT bn.TenBenhNhan, lh.NgayGioHen, lh.ThoiGianYeuCau, lh.GhiChu
    FROM LichHen lh
			JOIN BenhNhan bn ON lh.MaBenhNhan = bn.MaBenhNhan
END
go
--exec sp_XemChiTietYeuCauHenKham
go

---------------------------------------------------------------------------------------------

-- Xóa các chi tiết yêu cầu hẹn khám trong từng ngày
-- bao gồm thông tin tên bệnh nhân, ngày hẹn yêu cầu, ghi chú, thời gian yêu cầu.

CREATE OR ALTER PROCEDURE sp_XoaChiTietYeuCauHenKham
	@Ngay date

AS
BEGIN
    DELETE FROM LichHen
    WHERE ThoiGianYeuCau = @Ngay
END
go

---------------------------------------------------------------------------------------------

-- Xem danh sách tái khám: ngày chỉ định, mã, ghi chú.

CREATE OR ALTER PROCEDURE sp_XemDanhSachTaiKham
	@TenBenhNhan nvarchar(50) = null,
	@NgayChiDinh date = null

AS
BEGIN	
	if @TenBenhNhan is not null and 
		not exists(select * from BenhNhan where @TenBenhNhan = TenBenhNhan)
			begin
				print 'Ten benh nhan khong ton tai'
				return 0
			end

    select lh.NgayGioHen as NgayChiDinh, lh.MaLichHen, lh.GhiChu
	from LichHen lh
		join BenhNhan bn on lh.MaBenhNhan = bn.MaBenhNhan
	where lh.LoaiLichHen = N'Tái khám' 
		and (@TenBenhNhan is null or @TenBenhNhan = bn.TenBenhNhan)
		and (@NgayChiDinh is null or @NgayChiDinh = lh.ThoiGianYeuCau)
END
go
--exec sp_XemDanhSachTaiKham
go

---------------------------------------------------------------------------------------------

-- Nếu bệnh nhân tới tái khám thì cần xác nhận liên kết tái khám

CREATE OR ALTER PROCEDURE sp_XacNhanTaiKham
	@TenBN nvarchar(50),
	@Ngay date

AS
BEGIN	
	if not exists(select * from BenhNhan where @TenBN = TenBenhNhan)
		begin
			print 'Ten benh nhan khong ton tai'
			return 0
		end

	DECLARE @Result TABLE (
		NgayChiDinh date,
		MaLichHen int,
		GhiChu nvarchar(50)
	);

	INSERT INTO @Result
	exec sp_XemDanhSachTaiKham @TenBenhNhan = @TenBN, @NgayChiDinh = @Ngay;
	
	IF EXISTS (SELECT 1 FROM @Result)
	BEGIN
		PRINT 'Xac nhan tai kham thanh cong';
	END
	ELSE
	BEGIN
		PRINT 'Khong tim thay thong tin hen kham';
	END
END
go
--exec sp_XacNhanTaiKham @TenBN = N'Bùi Hoàng Mai', @Ngay = '2022-10-12'
go

---------------------------------------------------------------------------------------------

-- Thêm mới cuộc hẹn *(quản trị, nhân viên)*:
-- Nếu là bệnh nhân mới:
----- Tạo hồ sơ bệnh nhân bao gồm thông tin ID, họ tên, số điện thoại, địa chỉ, ngày sinh.
----- Sau đó hiển thị danh sách nha sĩ có thời gian làm việc trong thời gian hẹn để bệnh nhân chọn.
-- Nếu là bệnh nhân cũ:
----- Có thể lựa chọn nha sĩ mặc định của bệnh nhân (nếu nha sĩ rảnh vào thời điểm đó).
----- Hệ thống hỗ trợ tự động tìm kiếm ngày làm việc gần nhất của nha sĩ mặc định của bệnh nhân.
----- Nếu không thì sẽ lựa chọn dựa trên danh sách nha sĩ được hiển thị như bệnh nhân mới.
-- Tiếp theo sẽ lựa chọn phòng và thứ tự khám (thời gian vào khám).
-- Khi có thay đổi ngày hẹn → danh sách ca làm việc của nha sĩ tự cập nhật.

-- hàm quy đổi ngày tháng sang thứ
CREATE OR ALTER FUNCTION fn_GetDay (@Ngay date)
RETURNS NVARCHAR(10)
AS
BEGIN
	declare @Thu int = DATEPART(dw, @Ngay)
	if (@Thu = 1) 
		return N'Chủ nhật'
	if (@Thu = 2) 
		return N'Thứ hai'
	if (@Thu = 3) 
		return N'Thứ ba'
	if (@Thu = 4) 
		return N'Thứ tư'
	if (@Thu = 5) 
		return N'Thứ năm'
	if (@Thu = 6) 
		return N'Thứ sáu'
	if (@Thu = 7) 
		return N'Thứ bảy'
	return null
END

GO

-- hàm chọn ngày giờ datetime hẹn
CREATE OR ALTER FUNCTION fn_ChonNgayGioHenKham (@NgayHen date, @MaNhaSi int)
returns datetime
as
begin
	declare @Thu nvarchar(10) = dbo.fn_GetDay(@NgayHen)
	declare @ThoiGianHen datetime

	SELECT TOP 1 @ThoiGianHen = MIN(CAST(@NgayHen AS datetime) + CAST(GioBatDau AS datetime))
    FROM ChiTietCaLamViec
    WHERE MaNhaSi = @MaNhaSi
		AND Ngay = @Thu
        AND NOT EXISTS (
            SELECT 1
            FROM LichHen
            WHERE NhaSiKham = @MaNhaSi
                AND (
                    (NgayGioHen BETWEEN CAST(@NgayHen AS datetime) + CAST(GioBatDau AS datetime) AND CAST(@NgayHen AS datetime) + CAST(GioKetThuc AS datetime))
                    OR
                    (CAST(@NgayHen AS datetime) + CAST(GioBatDau AS datetime) BETWEEN NgayGioHen AND DATEADD(MINUTE, 15, NgayGioHen))
                    OR
                    (CAST(@NgayHen AS datetime) + CAST(GioKetThuc AS datetime) BETWEEN DATEADD(MINUTE, -15, NgayGioHen) AND NgayGioHen)
                )
        )
	
    RETURN @ThoiGianHen
end
go

-- xem danh sách nha sĩ trống lịch
CREATE OR ALTER PROCEDURE sp_XemDanhSachNhaSiTrongLich
@NgayHen date

as
begin
	declare @Thu nvarchar(10) = dbo.fn_GetDay(@NgayHen)
	select distinct ns.MaNhaSi, ns.TenNhaSi, ct.GioBatDau, ct.GioKetThuc, ct.MaChiNhanh
	from NhaSi ns join ChiTietCaLamViec ct on ns.MaNhaSi = ct.MaNhaSi
	where @Thu = ct.Ngay 
			and ns.MaNhaSi not in ( select NhaSiKham from LichHen where @NgayHen = ThoiGianYeuCau )
end
go

-- hàm chọn nha sĩ
CREATE OR ALTER FUNCTION fn_ChonNhaSi (@Ngay date)
RETURNS INT
AS
BEGIN
	declare @Thu nvarchar(10) = dbo.fn_GetDay(@Ngay)
	declare @NhaSi int
	select top 1 @NhaSi = NhaSiKham
	from LichHen lh join ChiTietCaLamViec ct on @Thu = ct.Ngay
	where dbo.fn_ChonNgayGioHenKham(@Ngay, NhaSiKham) != null
	return @NhaSi
END
go

CREATE OR ALTER PROCEDURE sp_ThemLichHen
	@NhaSiKham int = null,
	@TroKham int = null,
	@MaBenhNhan int,
	@NgayHen date,
	@Phong nvarchar(30),
	@LoaiLH nvarchar(20),
	@MaChiNhanh int

AS
BEGIN
	if (dbo.TonTai_BenhNhan(@MaBenhNhan) = 0)
	begin
		print N'Không tìm thấy bệnh nhân'
		return 
	end

	if @NhaSiKham not in (select MaNhaSi from NhaSi)
	begin
		print N'Không tìm thấy nha sĩ'
		return
	end
		
	if (@NgayHen is null OR @Phong is null OR @LoaiLH is null OR @MaChiNhanh is null)
	begin
		print 'Khong du thong tin de them lich hen'
		return 0
	end

	-- nếu là bệnh nhân mới, và đã được thêm hồ sơ bệnh nhân trước rồi
	if (@LoaiLH = N'Khám mới')
		-- nếu bệnh nhân không chọn nha sĩ, thì hệ thống tự chọn một nha sĩ trống lịch
		if (@NhaSiKham is null)
			set @NhaSiKham = dbo.fn_ChonNhaSi(@NgayHen)

	set @TroKham = dbo.fn_ChonNhaSi(@NgayHen)

	-- tạo mã lịch hẹn
	declare @MaLH int
	select @MaLH = max(MaLichHen) + 1 from LichHen

	declare @GioHen datetime = dbo.fn_ChonNgayGioHenKham(@NgayHen, @NhaSiKham)

	INSERT INTO LichHen (MaLichHen, NgayGioHen, Phong, LoaiLichHen, ThoiGianYeuCau, NhaSiKham, TroKham, MaBenhNhan, MaChiNhanh)
			VALUES (@MaLH, @GioHen, @Phong, @LoaiLH, @NgayHen, @NhaSiKham, @TroKham, @MaBenhNhan, @MaChiNhanh)
end
go
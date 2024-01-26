
---------------------------------------------------------------------------
-- Xem danh sách bệnh nhân
create or alter procedure DanhSach_BenhNhan
    @TenBenhNhan nvarchar(50) = null
as
begin
    -- If the parameter value is null, then return all records
    if @TenBenhNhan is null
        select * from BenhNhan
    else
        select * from BenhNhan where TenBenhNhan like '%' + @TenBenhNhan + '%'
end
go 
--exec DanhSach_BenhNhan N'Nguyễn'

-- Kiểm tra tồn tại thuốc
create or alter function TonTai_Thuoc (@MaThuoc int)
returns int
as
begin
	declare @kq int
	if @MaThuoc in (select MaThuoc from Thuoc)
		set @kq = 1
	else
		set @kq = 0

	return @kq
end
go

-- Kiểm tra tồn tại bệnh nhân
create or alter function TonTai_BenhNhan (@MaBN int)
returns int
as
begin
	declare @kq int
	if @MaBN in (select MaBenhNhan from BenhNhan)
		set @kq = 1
	else
		set @kq = 0
	
	return @kq
end
go

-- Kiểm tra số điện thoại
create or alter function KiemTra_SoDT (@soDT varchar(15))
returns int
as
begin
	declare @kq int
	if((select LEN(@soDT)) = 13 or (select LEN(@soDT)) = 14)
		set @kq = 1
	else
		set @kq = 0

	return @kq
end
go


---==================================== Quản lý thông tin hồ sơ ==================================

---------------------------------------------------------------------------
-- Xem hồ sơ chi tiết 1 bệnh nhân
-- Lưu ý: có thể chỉ lấy thông tin cập nhật mới nhất hoặc không
create or alter proc ChiTiet_BenhNhan 
	@MaBN int
as
begin
	if (dbo.TonTai_BenhNhan(@MaBN) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return 
		end

	-- xem thông tin cơ bản
	select * from BenhNhan where MaBenhNhan = @MaBN
	-- xem chống chỉ định thuốc
	select TenThuoc, GhiChu
	from ChongChiDinh cd join Thuoc t on cd.MaThuoc = t.MaThuoc
	where cd.MaBenhNhan = @MaBN
	-- xem tình trạng răng
	select TinhTrangRang, TongTienDieuTri, TongTienThanhToan 
	from BenhAn where MaBenhNhan = @MaBN
	order by MaBenhAn desc

	if (@@ERROR <> 0)
		begin
			print N'Lỗi lấy thông tin hồ sơ bệnh nhân'
			return
		end
end
go
--exec ChiTiet_BenhNhan 162177

---------------------------------------------------------------------------
-- Thêm mới mã bệnh nhân
create or alter function fn_GenerateMaBenhNhan()
returns int 
as 
begin 
	return coalesce((select max(MaBenhNhan) + 1 
                     from BenhNhan) 
					, 100000)
end
go

---------------------------------------------------------------------------
-- Thêm mới hồ sơ bệnh nhân
create or alter proc Them_BenhNhan
	@ten nvarchar(50),
	@gioitinh nvarchar(5),
	@DiaChi nvarchar(100),
	@Dienthoai varchar(15),
	@NamSinh date,
    	@DiUng nvarchar(100)
as
begin
	-- Kiểm tra sđt
	if(dbo.KiemTra_SoDT(@Dienthoai) = 0)
		begin
			print N'SDT không hợp lệ'
			return
		end

	-- Thêm bệnh nhân mới
	declare @MaBenhNhan int = dbo.fn_GenerateMaBenhNhan()
	insert into BenhNhan
	values (@MaBenhNhan,@ten,@gioitinh,@DiaChi,@Dienthoai,@NamSinh,@DiUng)	

end
go
--exec Them_BenhNhan N'Hồ Mỹ Vy',N'Nữ',N'Long An', '+84 939599499', '1992-10-12', N'Sưng mặt'
--select * from BenhNhan
--where MaBenhNhan = (select max(MaBenhNhan) from BenhNhan)

---------------------------------------------------------------------------
-- Cập nhật thông tin bệnh nhân
create or alter proc CapNhat_BenhNhan
	 @maBN int,
	 @ten nvarchar(50) = null ,
	 @gioitinh nchar(5) = null,
	 @DiaChi nvarchar(100) = null,
	 @Dienthoai varchar(15) = null,
	 @namsinh date = null,
	 @DiUng nvarchar(100) = null
	 -- trường hợp bao quát tùy thuộc tính muốn thay đổi
as
begin 
	-- Kiem tra ton tai 
	if (dbo.TonTai_BenhNhan(@maBN) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return
		end
	
	-- kiểm tra dữ liệu cập nhật
	if (coalesce(@ten, @gioitinh, @DiaChi, @Dienthoai, @namsinh, @DiUng) is NULL)
		begin
        		print N'Thay đổi không hợp lệ'
        	return
    end

	---kiem tra so dien thoai co hop le hay khong
	if(LEN(ISNULL(@Dienthoai,'')) <> 0 )
		begin
			if(dbo.KiemTra_SoDT(@Dienthoai) = 0)
				begin
					print N'SDT không hợp lệ'
					return
				end
		end
		
	-- kiem tra du lieu nhap vao co null hay khong
	if(LEN(ISNULL(@ten,'')) = 0 )
		begin
			set @ten = (Select TenBenhNhan from BenhNhan where MaBenhNhan = @maBN  )
		end
	if(LEN(ISNULL(@gioitinh,'')) = 0 )
		begin
			set @gioitinh = (Select GioiTinh from BenhNhan where MaBenhNhan = @maBN)
		end
	if(LEN(ISNULL(@DiaChi,'')) = 0 )
		begin
			set @DiaChi = (Select DiaChi from BenhNhan where MaBenhNhan = @maBN)
		end
	if(LEN(ISNULL(@Dienthoai,'')) = 0 )
		begin
			set @Dienthoai = (Select SDT from BenhNhan where MaBenhNhan = @maBN)
		end
	if(LEN(ISNULL(CAST(@namsinh as varchar),'')) = 0 )
		begin
			set @namsinh = (Select NamSinh from BenhNhan where MaBenhNhan = @maBN)
		end
	if(LEN(ISNULL(@DiUng,'')) = 0 )
		begin
			set @DiUng = (Select TinhTrangDiUng from BenhNhan where MaBenhNhan = @maBN)
		end

	-- Set giá trị mới vào hồ sơ bệnh nhân
	Update BenhNhan 
	set TenBenhNhan = @ten, GioiTinh = @gioitinh, DiaChi = @DiaChi, 
		SDT = @Dienthoai, NamSinh = @namsinh, TinhTrangDiUng = @DiUng
	where MaBenhNhan = @maBN	
	
end
go
--exec CapNhat_BenhNhan 737414,'','',N'Quảng Nam'
--select * from BenhNhan where MaBenhNhan = 737414


---==================================== Quản lý thông tin chống chỉ định ==================================

---------------------------------------------------------------------------
-- Thêm chống chỉ định thuốc
create or alter proc Them_ChongChiDinh
	@maBN int,
	@maThuoc int,
	@ghichu nvarchar(100)
as
begin 
	-- kiểm tra bệnh nhân
	if (dbo.TonTai_BenhNhan(@maBN) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return
		end
	-- kiểm tra thuốc
	if (dbo.TonTai_Thuoc(@maThuoc) = 0)
		begin
			print N'Không tìm thấy thuốc'
			return
		end

	-- kiểm tra chống chỉ định
	if (@maThuoc in (select MaThuoc from ChongChiDinh where MaBenhNhan = @maBN))
		begin
			update ChongChiDinh
			set GhiChu = @ghichu
			where MaBenhNhan = @maBN and MaThuoc = @maThuoc
		end
	else
		begin
			-- Thêm chống chỉ định
			insert into ChongChiDinh
			values (@maBN,@maThuoc,@ghichu)	
		end
end
go
--exec Them_ChongChiDinh 593745, 87678, N'Có thể là triệu chứng của nhiều vấn đề khác nhau, liên hệ ngay với bác sĩ.'
--select * from ChongChiDinh where MaBenhNhan = 593745

---------------------------------------------------------------------------
-- Cập nhật chống chỉ định thuốc
create or alter proc CapNhat_ChongChiDinh
	@maBN int,
	@maThuoc int,
	@ghichu nvarchar(100) = null
as
begin
	-- kiểm tra dữ liệu cập nhật
	if (@ghichu is null)
	begin
		print N'Thay đổi không hợp lệ'
		return
	end

	-- kiểm tra bệnh nhân
	if (dbo.TonTai_BenhNhan(@maBN) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return
		end
	-- kiểm tra thuốc
	if (dbo.TonTai_Thuoc(@maThuoc) = 0)
		begin
			print N'Không tìm thấy thuốc'
			return
		end

	-- kiểm tra chống chỉ định
	if (@maThuoc not in (select MaThuoc from ChongChiDinh where MaBenhNhan = @maBN))
		begin
			print N'Bệnh nhân không có chống chỉ định đối với thuốc này'
			return 
		end

	-- Cập nhật chống chỉ định
	update ChongChiDinh
	set GhiChu = @ghichu
	where MaBenhNhan = @maBN and MaThuoc = @maThuoc

end
go

---------------------------------------------------------------------------
-- Xóa chống chỉ định thuốc
create or alter proc Xoa_ChongChiDinh
	@maBN int,
	@maThuoc int
as
begin
	-- kiểm tra bệnh nhân
	if (dbo.TonTai_BenhNhan(@maBN) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return
		end
	-- kiểm tra thuốc
	if (dbo.TonTai_Thuoc(@maThuoc) = 0)
		begin
			print N'Không tìm thấy thuốc'
			return
		end

	-- kiểm tra chống chỉ định
	if (@maThuoc not in (select MaThuoc from ChongChiDinh where MaBenhNhan = @maBN))
		begin
			print N'Bệnh nhân không có chống chỉ định đối với thuốc này'
			return 
		end

	-- Xóa chống chỉ định
	delete ChongChiDinh where MaBenhNhan = @maBN and MaThuoc = @maThuoc

end
go
--exec Xoa_ChongChiDinh 797095, 96440
--select * from ChongChiDinh where MaBenhNhan = 797095 and MaThuoc = 96440


---==================================== Quản lý thông tin sức khỏe răng ==================================

--Kiểm tra bệnh án có tồn tại
create or alter function TonTai_BenhAn (@maBN int, @maBA int)
returns int 
as 
begin 
	declare @kq int
	if @maBA in (select MaBenhAn from BenhAn where MaBenhNhan = @maBN)
		set @kq = 1
	else
		set @kq = 0

	return @kq
end
go

---------------------------------------------------------------------------
-- Cập nhật sức khỏe răng miệng
create or alter proc CapNhat_SucKhoe
	@maBN int,
	@maBA int,
	@tinhtrang nvarchar(100) = null
as
begin
	-- kiểm tra bệnh nhân
	if (dbo.TonTai_BenhNhan(@maBN) = 0)
		begin
			print N'Không tìm thấy bệnh nhân'
			return
		end
	-- kiểm tra bệnh án
	if (dbo.TonTai_BenhAn(@maBN, @maBA) = 0)
		begin
			print N'Không tìm thấy bệnh án của bệnh nhân này'
			return 
		end

	declare @TongDieuTri int = (select sum(TongTien) from KeHoachDieuTri where MaBenhNhan = @maBN and MaBenhAn = @maBA),
		@TongThanhToan int = (select sum(TienTra) from HoaDon hd join KeHoachDieuTri kh
									on hd.MaHoaDon = kh.MaHoaDon
									where MaBenhNhan = @maBN and MaBenhAn = @maBA)

	-- Cập nhật sức khỏe răng
	update BenhAn
	set TinhTrangRang = @tinhtrang, TongTienDieuTri = @TongDieuTri, TongTienThanhToan = @TongThanhToan
	where MaBenhNhan = @maBN and MaBenhAn = @maBA

end
go

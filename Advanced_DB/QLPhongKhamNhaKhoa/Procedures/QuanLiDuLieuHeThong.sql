-- 6. **QUẢN LÝ DỮ LIỆU HỆ THỐNG**
create proc sp_XemDanhSach
    @LoaiNguoiDung int
-- 1: Quản trị viên, 2: Nhân viên, 3: Nha Sĩ
as
begin
    if @LoaiNguoiDung=1 
    begin
        select MaQTV, TenQTV, NgaySinh, GioiTinh, DiaChi, SDT
        from QuanTriVien
        order by TenQTV
        return 0
    end
    ELSE if @LoaiNguoiDung=2
    begin
        select MaNV, TenNV, NgaySinh, GioiTinh, DiaChi, SDT, ViTri
        from NhanVien
        order by TenNV
        return 0
    end
    else if @LoaiNguoiDung=3
    begin
        SELECT MaNhaSi, TenNhaSi, NgaySinh, GioiTinh, DiaChi, SDT, HocVan
        from NhaSi
        order by TenNhaSi
        return 0
    end
    else 
    begin
        RAISERROR(N'Loại người dùng không hợp lệ',16,1)
        return -1
    end
end
go
-- - Xem danh sách nha sĩ *(quản trị, nhân viên, nha sĩ)*
create proc sp_XemDanhSachNhaSi
as
begin
    EXECUTE sp_XemDanhSach 3
end
-- - Thêm/ cập nhật thông tin nha sĩ *(quản trị)*
go
create proc sp_ThemCapNhatThongTinNhaSi
    @MaNS int,
    @TenNhaSi nvarchar(50)=null,
    @NgaySinh date =null,
    @GioiTinh nvarchar(5)=null,
    @DiaChi nvarchar(100)=null,
    @SDT varchar(15)=null,
    @TaiKhoan varchar(20)=null,
    @MatKhau varchar(20)=null,
    @HocVan nvarchar(30) = null
as
begin
    if @MaNS not in (select MaNhaSi
    from NhaSi)
    begin
        RAISERROR(N'Mã nha sĩ không tồn tại',16,1)
        return -1
    end
    if @TenNhaSi is not null 
    begin
        update NhaSi set TenNhaSi=@TenNhaSi
        where MaNhaSi=@MaNS
    end
    if @NgaySinh is not null 
    begin
        update NhaSi set NgaySinh=@NgaySinh
        where MaNhaSi=@MaNS
    end
    if @GioiTinh is not null 
    begin
        if @GioiTinh not in (N'Nam',N'Nữ')
        begin
            RAISERROR(N'Giới tính không đúng cú pháp',16,1)
            return -1
        end
        update NhaSi set GioiTinh=@GioiTinh
        where MaNhaSi=@MaNS
    end
    if @DiaChi is not NULL
    BEGIN
        update NhaSi set DiaChi=@DiaChi
        where MaNhaSi=@MaNS
    end
    if @SDT is not NULL
    begin
        update NhaSi set SDT=@SDT
        where MaNhaSi=@MaNS
    end
    if @TaiKhoan is not NULL
    begin
        if @TaiKhoan in (select taikhoan
        from NhaSi)
        begin
            RAISERROR(N'Tài khoản đã tồn tại',16,1)
            return -1
        end
        update nhASI set taikhoan=@TaiKhoan
        where MaNhaSi=@MaNS
    end
    if @MatKhau is not null 
    begin
        update nhASI set MatKhau=@MatKhau
        where MaNhaSi=@MaNS
    end
    if @HocVan is not NULL
    begin
        update nhasi set HocVan=@HocVan
        where MaNhaSi=@MaNS
    end
    return 0
end
go
-- - Xem danh sách nhân viên *(quản trị, nhân viên, nha sĩ)*
create proc sp_XemDanhSachNhanVien
as 
begin 
    EXECUTE sp_XemDanhSach 2
end
go
create proc sp_ThemCapNhatThongTinNhanVien
    @MaNV int,
    @TenNV nvarchar(50)=null,
    @NgaySinh date =null,
    @GioiTinh nvarchar(5)=null,
    @DiaChi nvarchar(100)=null,
    @SDT varchar(15)=null,
    @TaiKhoan varchar(20)=null,
    @MatKhau varchar(20)=null,
    @ViTri NVARCHAR(30)=Null
as 
begin
    if @MaNV not in (select manv from NhanVien)
    begin
        RAISERROR(N'Mã nhân viên không tồn tại',16,1)
        return -1
    end
    if @TenNV is not null 
    begin
        update NhanVien set TenNV=@TenNV
        where MaNV=@MaNV
    end
    if @NgaySinh is not null 
    begin
          update NhanVien set NgaySinh=@NgaySinh
        where MaNV=@MaNV
    end
    if @GioiTinh is not null 
    begin
        if @GioiTinh not in (N'Nam',N'Nữ')
        begin
            RAISERROR(N'Giới tính không đúng cú pháp',16,1)
            return -1
        end
        update NhanVien set GioiTinh=@GioiTinh
        where MaNV=@MaNV
    end
    if @DiaChi is not NULL
    BEGIN
        update NhanVien set DiaChi=@DiaChi
        where MaNV=@MaNV
    end
    if @SDT is not NULL
    begin
        update NhanVien set SDT=@SDT
        where MaNV=@MaNV
    end
    if @TaiKhoan is not NULL
    begin
        if @TaiKhoan in (select taikhoan
        from NhanVien)
        begin
            RAISERROR(N'Tài khoản đã tồn tại',16,1)
            return -1
        end
        update NhanVien set taikhoan=@TaiKhoan
        where MaNV=@MaNV
    end
    if @MatKhau is not null 
    begin
        update NhanVien set MatKhau=@MatKhau
        where MaNV=@MaNv
    end
    if @ViTri is not NULL
    begin
        update NhanVien set ViTri=@ViTri
        where MaNV=@MaNV
    end
    return 0
end
go

-- Hàm chuyển đổi ngày trong tuần dạng số sang dạng chữ
create function fn_NgayTrongTuan (@ngay date)
returns nvarchar(10) 
as 
begin   
    DECLARE @dayweek int =DATEPART(WEEKDAY,@ngay),
            @result NVARCHAR(10)
    if @dayweek=2 
        set @result=N'Thứ hai'
    else if @dayweek=3
        set @result=N'Thứ ba'
    else if @dayweek=4
        set @result=N'Thứ tư'
    else if @dayweek=5
        set @result=N'Thứ năm'
    else if @dayweek=6
        set @result=N'Thứ sáu'
    else if @dayweek=7
        set @result=N'Thứ bảy'
    else if @dayweek=8
        set @result=N'Chủ nhật'
    return @result
end
GO

-- Hàm trả về các giờ làm việc trong ngày theo ngày trong tuần
create function fn_GioLamViecTrongNgay(@mans int,@dayweek nvarchar(10))
returns NVARCHAR(max)
as 
begin 
    declare @giolamviec NVARCHAR(max)
    select @giolamviec=string_agg('('+CAST(GioBatDau AS NVARCHAR(8)) +' - ' 
                                    +CAST(GioKetThuc AS NVARCHAR(8))+ ' - '
                                    +CAST(MaChiNhanh AS VARCHAR(2))+ ' )'
                                    ,', ')
    from chitietcalamviec
    where MaNhaSi=@mans and ngay=@dayweek
    return @giolamviec
end
GO

-- Hàm trả về các ngày làm việc trong tuần (dạng thứ trong tuần)
create function fn_NgayLamViecTrongTuan(@mans int)
returns NVARCHAR(max)
as 
begin 
    declare @thulamviec NVARCHAR(max)
    ;WITH MY_CTE AS ( SELECT Distinct(ngay) FROM ChiTietCaLamViec where MaNhaSi=@mans )
    select @thulamviec=string_agg(ngay,', ') 
    from MY_CTE
    return @thulamviec
end
go 

-- Hàm trả về các ngày làm việc trong tháng
create function fn_NgayLamViecTrongThang(@mans int,@thang int)
returns NVARCHAR(max)
as 
begin 
    declare @giolamviec NVARCHAR(max),
    @dayinmonth int ,
    @nam int=datepart(YEAR,getdate())
    -- Tinh day in month
    if @thang=2 
        begin   
            if (@nam %400 =0) or (@nam %4=0 and @nam %100!=0)
                set @dayinmonth=29
            else    
                set @dayinmonth=28
        end
    else if @thang=4 or @thang=6 or @thang=9 or @thang=11
        set @dayinmonth=30
    else set @dayinmonth=31

    declare @day_i int =1,@result NVARCHAR(max)=''
    while @day_i<=@dayinmonth
    begin 
        DECLARE @date date=cast(@nam as char(4))+'-'+cast(@thang as char(2))+'-'+cast(@day_i as char(2))
        if dbo.fn_NgayTrongTuan(@date) in (
            select ngay 
            from ChiTietCaLamViec
            where MaNhaSi=@mans
        )
        set @result=concat(@result,', ',cast(@day_i as varchar(2)))
        set @day_i+=1
    end
    return substring(@result,2,len(@result))
end
go



-- - Xem danh sách nha sĩ kèm lịch làm việc *(quản trị, nhân viên, nha sĩ)*
--     - Level theo tháng: các ngày trong tháng có thể làm việc.
--     - Level theo tuần: mỗi thứ trong tuần có thể làm việc.
--     - Level theo ngày:
--         - Những giờ có thể khám
--         - Những giờ không thể khám.

create proc sp_XemDanhSachNhaSiKemLLViec
    @level INT,  --0 theo ngay,1 theo tuan ,2 theo thang
    @ngay date=null,-- yyyy-mm-dd (theo ngay )
    @thang int=null -- (1,2,3,4,..12) (theo thang)
as 
BEGIN
    if @level not in (0,1,2)
    begin 
        RAISERROR(N'Kiểu lịch xem không phù hợp',16,1)
        return -1
    end
    else if @level=0 
    begin 
        if @ngay is null 
            set @ngay=GETDATE()
        declare @ngaytrongtuan NVARCHAR(10)=dbo.fn_NgayTrongTuan(@ngay)

        select MaNhaSi,TenNhaSi,NgaySinh,GioiTinh,DiaChi,SDT,HocVan,
                dbo.fn_GioLamViecTrongNgay(MaNhaSi,@ngaytrongtuan) as GioLamViec
        from NhaSi
    end
    else if @level=1
    begin 
        select MaNhaSi,TenNhaSi,NgaySinh,GioiTinh,DiaChi,SDT,HocVan,dbo.fn_NgayLamViecTrongTuan(MaNhaSi) as NgayLamViec
        from NhaSi     
    end
    else 
    begin 
        if @thang is null 
            set @thang=DATEPART(Month,getdate())
        select MaNhaSi,TenNhaSi,NgaySinh,GioiTinh,DiaChi,SDT,HocVan,dbo.fn_NgayLamViecTrongThang(MaNhaSi,@thang) as NgayLamViec
        from NhaSi     
    end
    return 0
end

go

-- Thêm lịch làm việc cho nha sĩ 
create proc sp_ThemLichLamViecNhaSi
    @mans int,
    @ngay nvarchar(10),
    @giobatdau time,
    @gioketthuc time,
    @machinhanh int
as 
begin 
    if @mans not in (select manhasi from nhasi)
    begin 
        RAISERROR(N'Mã nha sĩ không tồn tại',16,1)
        return -1
    end
    if @machinhanh not in (select machinhanh from ChiNhanh)
    begin 
        RAISERROR(N'Mã chi nhánh không tồn tại',16,1)
        return -1
    end
    if exists (select * from chitietcalamviec where manhasi=@mans and @ngay=ngay and @giobatdau=giobatdau
                                                        and gioketthuc=@gioketthuc and machinhanh=@machinhanh )
    begin 
        RAISERROR(N'Lịch làm việc đã tồn tại',16,1)
        return -1
    end
    if not exists (select * from CaLamViec where  @ngay=ngay and @giobatdau=giobatdau
                                                        and gioketthuc=@gioketthuc and machinhanh=@machinhanh )
    begin   -- Thêm mới ca làm việc trước khi thêm vào chi tiết ca làm việc
        insert into CaLamViec
        VALUES 
            (@ngay,@giobatdau,@gioketthuc,@machinhanh)
    end

    insert into ChiTietCaLamViec
    VALUES
        (@mans,@ngay,@giobatdau,@gioketthuc,@machinhanh)
    return 0
end

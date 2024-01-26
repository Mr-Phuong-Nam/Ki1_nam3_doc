create or alter function fn_GenerateMaNguoiDung(@LoaiNguoiDung int)
returns int 
as 
begin 
    declare @MaNguoiDung int = 0
    -- Using coalesce to handle empty (the value after comma is default value)
    -- 1: Quản trị viên
    if @LoaiNguoiDung = 1
    begin
        set @MaNguoiDung = coalesce((select top 1 MaQTV + 1 
                                    from QuanTriVien 
                                    where MaQTV + 1 not in (select MaQTV 
                                                            from QuanTriVien) 
                                ), 
                                10000)
    end
    -- 2: Nhân viên
    if @LoaiNguoiDung = 2
    begin
        set @MaNguoiDung = coalesce((select top 1 MaNV + 1 
                                    from NhanVien 
                                    where MaNV + 1 not in (select MaNV 
                                                            from NhanVien) 
                                ), 
                                20000)
	end
    -- 3: Nha Sĩ
    if @LoaiNguoiDung = 3
    begin
        set @MaNguoiDung = coalesce((select top 1 MaNhaSi + 1 
                                    from NhaSi 
                                    where MaNhaSi + 1 not in (select MaNhaSi 
                                                                from NhaSi) 
                                ), 
                                30000)
    end
   
    return @MaNguoiDung
end
go


CREATE or alter PROCEDURE sp_ThemNguoiDung
    @LoaiNguoiDung int, -- 1: Quản trị viên, 2: Nhân viên, 3: Nha Sĩ
    @TenNguoiDung nvarchar(50),
    @NgaySinh date,
    @GioiTinh nchar(5),
    @DiaChi nvarchar(100),
    @SDT char(15),
    @TaiKhoan varchar(20),
    @MatKhau varchar(20),
    @ViTri nvarchar(30) = null,
    @HocVan nvarchar(30) = null
as 
begin
    declare @MaNguoiDung int = dbo.fn_GenerateMaNguoiDung(@LoaiNguoiDung)
    
    if @GioiTinh not in ('Nam', 'Nữ')
        set @GioiTinh = null

    if @LoaiNguoiDung = 1
    begin
        -- Check if @TaiKhoan exists
        if exists(select 1 from QuanTriVien where TaiKhoan = @TaiKhoan)
        begin
            print 'Tài khoản đã tồn tại'
            return 0
        end

        insert into QuanTriVien(MaQTV, TenQTV, NgaySinh, GioiTinh, DiaChi, SDT, TaiKhoan, MatKhau)
        values(@MaNguoiDung, @TenNguoiDung, @NgaySinh, @GioiTinh, @DiaChi, @SDT, @TaiKhoan, @MatKhau)
    end
    if @LoaiNguoiDung = 2
    begin
        -- Check if @TaiKhoan exists
        if exists(select 1 from NhanVien where TaiKhoan = @TaiKhoan)
        begin
            print 'Tài khoản đã tồn tại'
            return 0
        end

        insert into NhanVien(MaNV, TenNV, NgaySinh, GioiTinh, DiaChi, SDT, TaiKhoan, MatKhau, ViTri)
        values(@MaNguoiDung, @TenNguoiDung, @NgaySinh, @GioiTinh, @DiaChi, @SDT, @TaiKhoan, @MatKhau, @ViTri)
    end
    if @LoaiNguoiDung = 3
    begin
        -- Check if @TaiKhoan exists
        if exists(select 1 from NhaSi where TaiKhoan = @TaiKhoan)
        begin
            print 'Tài khoản đã tồn tại'
            return 0
        end

        insert into NhaSi(MaNhaSi, TenNhaSi, NgaySinh, GioiTinh, DiaChi, SDT, TaiKhoan, MatKhau, HocVan)
        values(@MaNguoiDung, @TenNguoiDung, @NgaySinh, @GioiTinh, @DiaChi, @SDT, @TaiKhoan, @MatKhau, @HocVan)
    end

    if @LoaiNguoiDung != 1 and @LoaiNguoiDung != 2 and @LoaiNguoiDung != 3
    begin
        print 'LoaiNguoiDung khong hop le'
        return 0
    end
end
go


create or alter procedure sp_KiemTraDangNhap
    @TaiKhoan varchar(20),
    @MatKhau varchar(20),
    @LoaiNguoiDung int output
as
begin
    if exists(select 1 from QuanTriVien where TaiKhoan = @TaiKhoan and MatKhau = @MatKhau)
        set @LoaiNguoiDung = 1
    else if exists(select 1 from NhanVien where TaiKhoan = @TaiKhoan and MatKhau = @MatKhau)
        set @LoaiNguoiDung = 2
    else if exists(select 1 from NhaSi where TaiKhoan = @TaiKhoan and MatKhau = @MatKhau)
        set @LoaiNguoiDung = 3
    else
        set @LoaiNguoiDung = 0
end
go


create or alter procedure sp_DoiMatKhau
    @TaiKhoan varchar(20),
    @MatKhauCu varchar(20),
    @MatKhauMoi varchar(20)
as
begin
    declare @LoaiNguoiDung int
    exec sp_KiemTraDangNhap @TaiKhoan, @MatKhauCu, @LoaiNguoiDung output

    if @LoaiNguoiDung = 0
    begin
        print 'Tài khoản hoặc mật khẩu không đúng'
        return 0
    end

    if @LoaiNguoiDung = 1
        update QuanTriVien set MatKhau = @MatKhauMoi where TaiKhoan = @TaiKhoan
    else if @LoaiNguoiDung = 2
        update NhanVien set MatKhau = @MatKhauMoi where TaiKhoan = @TaiKhoan
    else if @LoaiNguoiDung = 3
        update NhaSi set MatKhau = @MatKhauMoi where TaiKhoan = @TaiKhoan
end
go






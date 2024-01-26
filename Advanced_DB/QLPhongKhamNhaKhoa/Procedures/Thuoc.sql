create or alter procedure sp_XemDanhSachThuoc
    @TenThuoc nvarchar(50) = null
as
begin
    -- If the parameter value is null, then return all records
    if @TenThuoc is null
        select * from Thuoc
    else
        select * from Thuoc where TenThuoc like '%' + @TenThuoc + '%'
end
go 

create or alter procedure sp_ThemThuoc
    @TenThuoc nvarchar(50),
    @SoLuong int,
    @DonVi nvarchar(15),
    @HSD date,
    @DonGia int
as
begin 
    -- TenThuoc and HSD cannot be null and (TenThuoc, HSD) must be unique
    if @TenThuoc is null or @HSD is null
    Begin
        print 'TenThuoc and HSD cannot be null'
        return 0 
    end
    if exists(select * from Thuoc where TenThuoc = @TenThuoc and HSD = @HSD)
    BEGIN
        -- Add soluong to TonKho
        update Thuoc 
        set TonKho = TonKho + @SoLuong 
        where TenThuoc = @TenThuoc and HSD = @HSD
    end 
    else
    begin
        -- Generate MaThuoc
        declare @MaThuoc int
        select @MaThuoc = max(MaThuoc) + 1 from Thuoc
        
        -- Insert into Thuoc
        insert into Thuoc(MaThuoc, TenThuoc, TonKho, DonVi, HSD, DonGia)
        values(@MaThuoc, @TenThuoc, @SoLuong, @DonVi, @HSD, @DonGia)
    end 
    return 1
end 
go 


create or alter procedure sp_SuaThuoc
    @MaThuoc int,
    @TenThuoc nvarchar(50) = null,
    @SoLuong int = null,
    @DonVi nvarchar(15) = null,
    @HSD date = null,
    @DonGia int = null
as
begin 
    -- If the parameter value is null, then ignore it
    if @TenThuoc is null and @SoLuong is null and @DonVi is null and @HSD is null and @DonGia is null
    begin
        print 'No parameter is specified'
        return 0
    end

    -- Check if the record exists
    if not exists(select * from Thuoc where MaThuoc = @MaThuoc)
    begin
        print 'The record does not exist'
        return 0
    end

    -- Update the record
    -- isnull(expression, value) returns value if expression is null otherwise returns expression
    update Thuoc
    set TenThuoc = isnull(@TenThuoc, TenThuoc),
        TonKho = isnull(@SoLuong, TonKho),
        DonVi = isnull(@DonVi, DonVi),
        HSD = isnull(@HSD, HSD),
        DonGia = isnull(@DonGia, DonGia)
    where MaThuoc = @MaThuoc
    return 1
end
go 

-- Sample using procedures. If you want to change the value of a parameter, you must specify all the parameters before it to NULL
-- exec sp_SuaThuoc 11527, NULL, 100

create function fn_VaiTroTrongLichHen(@manhasi int ,@nhasikham int, @trokham int)
returns NVARCHAR(20)
begin 
    declare @vaitro NVARCHAR(20)
    if @manhasi=@nhasikham
        set @vaitro=N'Khám chính'
    else    
        set @vaitro=N'Trợ khám'
    return @vaitro
end
go

-- - Thống kê các báo cáo theo từng bác sĩ trong ngày
create proc sp_ThongKeBacSi
    @manhasi int,
    @ngay date=null
as 
begin 
    if @manhasi not in (select manhasi from NhaSi)
    begin 
        RAISERROR(N'Mã nha sĩ không tồn tại',16,1)
        return -1
    end
    if @ngay is null 
        set @ngay=getdate()
    select TenNhaSi,MaLichHen,NgayGioHen,Phong,LoaiLichHen,TinhTrang,MaBenhNhan,MaChiNhanh,
            dbo.fn_VaiTroTrongLichHen(ns.manhasi,lh.NhaSiKham,lh.trokham) as VaiTro
    from nhasi ns  join lichhen lh on ns.MaNhaSi=lh.NhaSiKham or ns.MaNhaSi=lh.TroKham
    where datediff(day,ngaygiohen,@ngay)=0 and ns.MaNhaSi=@manhasi
end
go 

-- - Thống kê các cuộc hẹn từ ngày đến ngày theo từng bác sĩ.
create proc sp_ThongKeBacSiTuNgayDenNgay
    @manhasi int,
    @ngay1 date,
    @ngay2 date =null
as 
begin 
    if @manhasi not in (select manhasi from NhaSi)
    begin 
        RAISERROR(N'Mã nha sĩ không tồn tại',16,1)
        return -1
    end
    if datediff(day,@ngay1,@ngay2) >0 
    begin 
        RAISERROR(N'Các ngày không hợp lệ',16,1)
        return -1
    end
    if @ngay2 is null 
        set @ngay2=getdate()
    select TenNhaSi,MaLichHen,NgayGioHen,Phong,LoaiLichHen,TinhTrang,MaBenhNhan,MaChiNhanh,
            dbo.fn_VaiTroTrongLichHen(ns.manhasi,lh.NhaSiKham,lh.trokham) as VaiTro
    from nhasi ns  join lichhen lh on ns.MaNhaSi=lh.NhaSiKham or ns.MaNhaSi=lh.TroKham
    where  ns.MaNhaSi=@manhasi and datediff(day,@ngay1,lh.NgayGioHen)>=0 and datediff(day,lh.NgayGioHen,@ngay2)>=0
end

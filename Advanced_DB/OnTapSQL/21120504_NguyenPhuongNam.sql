-- Mssv: 21120504
-- Ho Ten: Nguyen Phuong Nam
-- Lop: 21_1

-- 1. Cài đặt trigger kiểm tra các ràng buộc sau:
-- “Mỗi đơn hàng, nhà cung cấp có thể giao hàng tối đa 3 lần”
-- Bang tam anh huong 
--           | Them | Xoa | Sua
-- Giao_Hang |  +   | -   | + (SoDatHang)

go
create or alter trigger tg_CheckSoLanGiaoHang
on GIAO_Hang
for insert, update 
as 
if update(SoDatHang)
begin 
    if exists(
        select * 
        from inserted
        where (select COUNT(*)
                from GIAO_HANG
                where SoDatHang = inserted.SoDatHang) > 3
    ) BEGIN
        RAISERROR(N'Số lần giao hàng vượt quá 3 lần', 16, 1)
        ROLLBACK
    end 
end 
go

select * from GIAO_HANG

INSERT into GIAO_HANG
values ('GH005', null, 'DH001'),
 ('GH006', null, 'DH001')

-- 2. Viết Store Procedure thêm chi tiết giao hàng như sau:
-- -Kiểm tra mặt hàng giao có thuộc các mặt hàng đặt trong đơn đó hay không
-- -Tổng số lượng giao của mặt hàng này không được vượt quá số lượng đặt
-- -Mỗi mặt hàng trong 1 đơn hàng chỉ được giao tối đa 3 lần.

go
create procedure sp_ThemChiTietGiaoHang
    @SoGH char(6), @MaMH char(6), @SLGiao int 
as 
    declare @SoDH char(6) = (select SoDatHang from GIAO_HANG where So = @SoGH)

    if not exists(
        select *
        from CHI_TIET_DAT_HANG
        where SoDatHang = @SoDH and MaMatHang = @MaMH
    ) BEGIN
        RAISERROR(N'Mat Hang chua duoc Dat', 16, 1)
        return 
    end 


    declare @TongSLGiao int = (
        select sum(CTGH.SoLuongGiao)
        from CHI_TIET_GIAO_HANG CTGH 
        join GIAO_HANG GH on CTGH.SoGiaoHang = GH.So
        where GH.SoDatHang = @SoDH and CTGH.MaMatHang = @MaMH
    )

    set @TongSLGiao = @TongSLGiao + @SLGiao

    if @TongSLGiao > (select SoLuongDat from CHI_TIET_DAT_HANG where SoDatHang = @SoDH and MaMatHang = @MaMH)
    begin 
        RAISERROR(N'So Luong Giao vuot qua so luong dat', 16, 1)
        RETURN
    end 


    declare @TongLanGiao int = (
        select count(*)
        from CHI_TIET_GIAO_HANG CTGH 
        join GIAO_HANG GH on CTGH.SoGiaoHang = GH.So
        where GH.SoDatHang = @SoDH and CTGH.MaMatHang = @MaMH
    )

    if @TongLanGiao > 3 
    BEGIN
            RAISERROR(N'So Lan Giao vuot qua 3', 16, 1)
        RETURN
    end 

    insert into CHI_TIET_GIAO_HANG
    values(@SOGH, @MaMH, @SLGiao)

go
select * from MAT_HANG

EXEC sp_ThemChiTietGiaoHang 'GH001', 'MH001', 2

-- 3. Viết stored xuất danh sách (số đặt hàng, tổng số lượng đặt, tổng số lượng giao, còn
-- lại) của những đơn hàng đặt từ 2 tháng trước và chưa giao xong.

go
create procedure sp_XuatDSDonDat
as 
    select DH.So, sum(CTDH.SoLuongDat) as SLD, sum(CTGH.SoLuongGiao) as SLG, sum(CTDH.SoLuongDat) - sum(CTGH.SoLuongGiao) as ConLai
    FROM DAT_HANG DH
    JOIN CHI_TIET_DAT_HANG CTDH on DH.So = CTDH.SoDatHang
    JOIn GIAO_HANG GH on GH.SoDatHang = DH.So
    join CHI_TIET_GIAO_HANG CTGH on CTGH.SoGiaoHang = GH.So
    where DATEDIFF(MONTH, DH.Ngay,GETDATE()) > 2 
    GROUP by DH.So
    having sum(CTDH.SoLuongDat) > sum(CTGH.SoLuongGiao)

go

EXEC sp_XuatDSDonDat
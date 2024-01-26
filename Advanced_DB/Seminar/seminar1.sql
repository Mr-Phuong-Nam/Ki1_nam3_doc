

--Kiểm tra thông báo
-- Trigger: Số công việc của giáo viên < 5
GO
CREATE
--ALTER
TRIGGER Utr_RB1
ON ThamGiaDT
FOR INSERT
AS
    -- Điều kiện kiêm tra vi phạm
    IF EXISTS (SELECT * from THAMGIADT TG 
                JOIN inserted I on I.MaGV = TG.MAGV
                where TG.KETQUA is null
                having count(*) >= 5)
    begin 
        raiserror('Thong Bao', 16, 1)
        ROLLBACK
    end 

--Kiểm tra xử lý
-- Trigger: Số công việc của giáo viên >= 5 => Phân công cv đó cho gv khác
GO
--CREATE
ALTER
TRIGGER Utr_RB2
ON ThamGiaDT
FOR INSERT
AS
    -- Điều kiện kiêm tra vi phạm
    IF EXISTS (SELECT * from THAMGIADT TG 
                JOIN inserted I on I.MaGV = TG.MAGV
                where TG.KETQUA is null
                having count(*) >= 5)
    begin 
        -- Tìm gv được phép tham gia
        Delete THAMGIADT
        from inserted I
        where THAMGIADT.STT = I.STT
            and THAMGIADT.madt = i.MADT
            and I.MAGV = THAMGIADT.MAGV

        declare @MaGV char(5) = (select top 1 MaGV
                                from GIAOVIEN GV 
                                where MaGV not in(
                                    select magv from thamgiadt
                                    where KETQUA is null
                                    group by magv 
                                    having COUNT(*) >= 4
                                ))
        Insert THAMGIADT
        SELECT @MaGV, I.MADT, I.STT, I.PHUCAP, I.KETQUA  
        from inserted I
    end 

--proc: Gom truy vấn thành chương trình con --> thực hiện mục đích nào đó
go 
create 
--alter
proc SP_1
    @MaGV char(5),
    @MaDT char(5),
    @STT int
as 
    if exists(select * from THAMGIADT 
                where MAGV = @MaGV and MADT = @MaDT and STT = @STT)
    begin
        print 'Loi'
        return  
    end 

    insert THAMGIADT(MAGV, MADT, STT)
    VALUES(@MaGV, @MaDT, @STT)
go 

EXEC SP_1 '001', '001', 1

-- Function
-- Loai tra ve gia tri
go 
create function F_1 ()
returns char(5)
as 
begin 
    return (
        select top 1 MaGV
        from GIAOVIEN GV 
        where MaGV not in(
            select magv from thamgiadt
            where KETQUA is null
            group by magv 
            having COUNT(*) >= 4
        )
    )
end 
go 

select DBO.F_1()
-- Loai tra ve bang

go 
create function F_2()
returns table 
as 
    return (
        select *
        from GIAOVIEN GV 
        where MaGV not in(
            select magv from thamgiadt
            where KETQUA is null
            group by magv 
            having COUNT(*) >= 4
        )  
    )
go
select * from F_2()
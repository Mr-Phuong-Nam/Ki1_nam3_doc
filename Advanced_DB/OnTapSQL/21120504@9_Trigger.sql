-- T1. Tên đề tài phải duy nhất
go 
create trigger tg_checkTenDeTai
on DeTai
for insert, update
as 
if update (TenDT)
begin 
    if exists(select * from DETAI
                join inserted on DETAI.TenDT = inserted.TenDT
                where DETAI.TenDT = inserted.TenDT
                having count(*) > 1)
    begin
        rollback tran
        raiserror('Ten de tai phai duy nhat', 16, 1)
    end
end 
go

-- T2. Trưởng bộ môn phải sinh sau trước 1975
go 
create trigger tg_checkTruongBoMon_GV
on GiaoVien
for update 
as 
if update (NGSINH)
begin 
    if exists(select * from  inserted 
                where inserted.MAGV in (select TRUONGBM from BOMON)
                and inserted.NGSINH > '1975-01-01')
    begin
        rollback tran
        raiserror('Truong bo mon phai sinh truoc 1975', 16, 1)
    end
end

select * from GIAOVIEN

update GiaoVien
set NGSINH = '1974-01-01'
where MAGV = '001'

go
create TRIGGER tg_checkTruongBoMon_BM
on BoMon
for update, insert 
as
if update (TRUONGBM)
BEGIN
    if exists(select * from inserted
                where truongBM is not null 
                    and '1975-01-01' > (select NGSINH 
                                        from GIAOVIEN 
                                        where MAGV = inserted.TRUONGBM)
                                        ) 
    begin
        rollback tran
        raiserror('Truong bo mon phai sinh sau 1975', 16, 1)
    end
end

select * from BOMON
SELECT * from GiaoVien
update BOMON
set TRUONGBM = '001'
where MABM = 'CNTT'

-- T3. Một bộ môn có tối thiểu 1 giáo viên nữ
go
alter trigger tg_checkGiaoVienNu
on GiaoVien
for update, delete 
as 
begin 
    if exists(
        select * from deleted
        where PHAI = N'Nữ'
            and (select count(*) from GiaoVien where MABM = deleted.MABM and PHAI = N'Nữ') = 0
    ) BEGIN
        rollback tran
        raiserror('Mot bo mon phai co it nhat 1 giao vien nu', 16, 1)
    end
end 

select * from GIAOVIEN where mabm= 'MMT'
insert into GIAOVIEN(MAGV, HOTEN, PHAI, MABM) values ('012', 'Nguyen Van F', N'Nữ','MMT')
DELETE from GIAOVIEN
where MAGV = '012'
-- T4. Một giáo viên phải có ít nhất 1 số điện thoại
-- T5. Một giáo viên có tối đa 3 số điện thoại
-- T6. Một bộ môn phải có tối thiểu 4 giáo viên
-- T7. Trưởng bộ môn phải là người lớn tuổi nhất trong bộ môn.
-- T8. Nếu một giáo viên đã là trưởng bộ môn thì giáo viên đó không làm người quản lý chuyên
-- môn.
-- T9. Giáo viên và giáo viên quản lý chuyên môn của giáo viên đó phải thuộc về 1 bộ môn.
-- T10. Mỗi giáo viên chỉ có tối đa 1 vợ chồng
-- T11. Giáo viên là Nam thì chỉ có vợ là Nữ hoặc ngược lại.
-- T12. Nếu thân nhân có quan hệ là “con gái” hoặc “con trai” với giáo viên thì năm sinh của giáo
-- viên phải nhỏ hơn năm sinh của thân nhân.
-- T13. Một giáo viên chỉ làm chủ nhiệm tối đa 3 đề tài.
-- T14. Một đề tài phải có ít nhất một công việc
-- T15. Lương của giáo viên phải nhỏ hơn lương người quản lý của giáo viên đó.
-- T16. Lương của trưởng bộ môn phải lớn hơn lương của các giáo viên trong bộ môn.
-- T17. Bộ môn ban nào cũng phải có trưởng bộ môn và trưởng bộ môn phải là một giáo viên trong
-- trường.
-- T18. Một giáo viên chỉ quản lý tối đa 3 giáo viên khác.
-- T19. Giáo viên chỉ tham gia những đề tài mà giáo viên chủ nhiệm đề tài là người cùng bộ môn với
-- giáo viên đó.
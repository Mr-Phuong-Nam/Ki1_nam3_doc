
-- Truy van --

----Q1---
select HOTEN, LUONG
from GIAOVIEN
where PHAI = N'Nữ'

----Q2----
select HOTEN, LUONG*1.1 as LUONGSAU
from GIAOVIEN

----Q3----
select MAGV
from GIAOVIEN
where HOTEN LIKE N'Nguyễn%' and LUONG > 2000
union
select TRUONGBM
from BOMON
where TRUONGBM is not null and year(NGAYNHANCHUC) > 1995

----Q4----
select GV.HOTEN
from GIAOVIEN as GV 
join BOMON as BM on GV.MABM = BM.MABM
join KHOA as K on BM.MAKHOA = K.MAKHOA
where K.MAKHOA = 'CNTT'

----Q5----
select*
from BOMON as BM
left join GIAOVIEN as GV on BM.TRUONGBM = GV.MAGV

----Q6----
select* 
from GIAOVIEN as GV
join BOMON as BM
on GV.MABM = BM.MABM

----Q7----
select TENDT, GVCNDT
from DETAI

----Q8----
select*
from KHOA as K
join GIAOVIEN as GV
on K.TRUONGKHOA = GV.MAGV

----Q9----
select distinct GV.MAGV
from THAMGIADT as TGDT
join GIAOVIEN as GV on TGDT.MAGV = GV.MaGV
join BOMON as BM on GV.MABM = BM.MABM
where BM.TENBM = 'Vi sinh' and TGDT.MADT = '006'

----Q10----
select DT.MADT, CD.TENCD, GV.HOTEN, GV.NGSINH, GV.DIACHI
from DETAI as DT
join CHUDE as CD on DT.MACD = CD.MACD
join GIAOVIEN as GV on DT.GVCNDT= GV.MaGV
where DT.CAPQL = N'Thành phố'

----Q11: Tìm họ tên của từng giáo viên và người phụ trách chuyên môn trực tiếp của giáo viên đó.
select GV.HOTEN, GVQL.*
from GIAOVIEN as GV
join GIAOVIEN as GVQL on GV.GVQLCM = GVQL.MAGV

----Q12. Tìm họ tên của những giáo viên được “Nguyễn Thanh Tùng” phụ trách trực tiếp.
select GV.HOTEN
from GIAOVIEN as GV
join GIAOVIEN as GVQL on GV.GVQLCM = GVQL.MAGV
where GVQL.HOTEN = N'Nguyễn Thanh Tùng'

----Q13. Cho biết tên giáo viên là trưởng bộ môn “Hệ thống thông tin”.
select GV.HOTEN
from BOMON as BM 
join GIAOVIEN as GV on BM.TRUONGBM = GV.MAGV 
where BM.TENBM = N'Hệ thống thông tin'


----Q14. Cho biết tên người chủ nhiệm đề tài của những đề tài thuộc chủ đề Quản lý giáo dục.
select distinct GV.HOTEN
from DETAI  as DT 
join GIAOVIEN as GV on DT.GVCNDT = GV.MaGV
join CHUDE as CD on DT.MACD = CD.MACD
where CD.TENCD = N'Quản lý giáo dục'

----Q15. Cho biết tên các công việc của đề tài HTTT quản lý các trường ĐH có thời gian bắt đầu trong tháng 3/2008.
select CV.TENCV
from CONGVIEC as CV 
join DETAI as DT on CV.MADT = DT.MADT
where DT.TENDT = (N'HTTT quản lý các trường ĐH') and (CV.NGAYBD between '2008/3/1' and '2008/3/31')

----Q16. Cho biết tên giáo viên và tên người quản lý chuyên môn của giáo viên đó.
select GV.HOTEN, GVQL.HOTEN
from GIAOVIEN as GV
join GIAOVIEN as GVQL on GV.GVQLCM = GVQL.MAGV

----Q17. Cho biết các công việc bắt đầu trong khoảng từ 01/01/2007 đến 01/08/2007.
select *
from CONGVIEC
where NGAYBD between '2007/01/01' and '2007/08/01'

----Q18. Cho biết họ tên các giáo viên cùng bộ môn với giáo viên “Trần Trà Hương”.
select HOTEN
from GIAOVIEN
where HOTEN != N'Trần Trà Hương' and MABM = (
                                                select MABM
                                                from GIAOVIEN
                                                where HOTEN = N'Trần Trà Hương'
                                            )

----Q19. Tìm những giáo viên vừa là trưởng bộ môn vừa chủ nhiệm đề tài.
select GV.*
from BOMON as BM
join GIAOVIEN as GV on BM.TRUONGBM = GV.MaGV
intersect 
select GV.*
from DETAI as DT
join GIAOVIEN as GV on DT.GVCNDT = GV.MaGV

----Q20. Cho biết tên những giáo viên vừa là trưởng khoa và vừa là trưởng bộ môn.
select GV.HOTEN
from BOMON as BM
join GIAOVIEN as GV on BM.TRUONGBM = GV.MaGV
intersect 
select GV.HOTEN
from KHOA as K
join GIAOVIEN as GV on K.TRUONGKHOA = GV.MaGV

----Q21. Cho biết tên những trưởng bộ môn mà vừa chủ nhiệm đề tài.
select GV.HOTEN
from BOMON as BM
join GIAOVIEN as GV on BM.TRUONGBM = GV.MaGV
intersect 
select GV.HOTEN
from DETAI as DT
join GIAOVIEN as GV on DT.GVCNDT = GV.MaGV

----Q22. Cho biết mã số các trưởng khoa có chủ nhiệm đề tài.
select GVCNDT
from DETAI
intersect 
select TRUONGKHOA
from KHOA 

----Q23. Cho biết mã số các giáo viên thuộc bộ môn “HTTT” hoặc có tham gia đề tài mã “001”.
select MAGV
from GIAOVIEN
where MABM = 'HTTT'
union
select MAGV 
from THAMGIADT
where MADT = '001'

----Q24. Cho biết giáo viên làm việc cùng bộ môn với giáo viên 002.
select *
from GIAOVIEN
where MAGV != '002' and MABM = (
                select MaBM
                from GIAOVIEN
                where MAGV = '002'
)

----Q25. Tìm những giáo viên là trưởng bộ môn.
select GV.*
from BOMON as BM
join GIAOVIEN as GV on BM.TRUONGBM = GV.MAGV

----Q26. Cho biết họ tên và mức lương của các giáo viên.
select HOTEN, LUONG 
from GIAOVIEN
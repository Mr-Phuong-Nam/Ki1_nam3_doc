

----Q27. Cho biết số lượng giáo viên viên và tổng lương của họ.
select COUNT(MAGV) as SLGV, SUM(LUONG) as TONGLUONG
from GIAOVIEN


----Q28. Cho biết số lượng giáo viên và lương trung bình của từng bộ môn.
select MABM, COUNT(*), AVG(LUONG)
from GIAOVIEN
group by MABM


----Q29. Cho biết tên chủ đề và số lượng đề tài thuộc về chủ đề đó
select CD.TENCD, COUNT(DT.MADT) as SLDT
from DETAI as DT
join CHUDE as CD on DT.MACD = CD.MACD
group by CD.MACD, CD.TENCD


----Q30. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó tham gia.
select GV.HOTEN, COUNT(distinct TGDT.MADT) as SLDT
from THAMGIADT as TGDT
join GIAOVIEN as GV on TGDT.MAGV = GV.MAGV
group by GV.MAGV, GV.HOTEN


----Q31. Cho biết tên giáo viên và số lượng đề tài mà giáo viên đó làm chủ nhiệm.
select GV.HOTEN, COUNT(DT.MADT) as SLDT
from GIAOVIEN as GV
left join DETAI as DT on GV.MAGV = DT.GVCNDT
group by GV.MAGV, GV.HOTEN


----Q32. Với mỗi giáo viên cho tên giáo viên và số người thân của giáo viên đó.
select GV.HOTEN, COUNT(*)
from NGUOITHAN as NT
join GIAOVIEN as GV on NT.MAGV = GV.MAGV
group by GV.MAGV, GV.HOTEN


----Q33. Cho biết tên những giáo viên đã tham gia từ 3 đề tài trở lên.
select GV.HOTEN
from THAMGIADT as TGDT
join GIAOVIEN as GV on TGDT.MAGV = GV.MAGV
group by GV.MAGV, GV.HOTEN
having COUNT(distinct TGDT.MADT) >= 3


----Q34. Cho biết số lượng giáo viên đã tham gia vào đề tài Ứng dụng hóa học xanh.
select COUNT(distinct TGDT.MAGV) as SLGV
from THAMGIADT as TGDT
join DETAI as DT on DT.MADT = TGDT.MADT
where DT.TENDT = N'Ứng dụng hóa học xanh'

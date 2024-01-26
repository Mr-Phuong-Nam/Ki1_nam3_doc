-- Bài tập Quản lý ĐỀ TÀI:
-- Q35. Cho biết mức lương cao nhất của các giảng viên.
select MAX(LUONG)
from GIAOVIEN

-- Q36. Cho biết những giáo viên có lương lớn nhất.
select *
from GIAOVIEN
where LUONG = (select MAX(LUONG) from GIAOVIEN)

-- Q37. Cho biết lương cao nhất trong bộ môn “HTTT”.
select MAX(LUONG)
from GIAOVIEN
where MABM = 'HTTT'

-- Q38. Cho biết tên giáo viên lớn tuổi nhất của bộ môn Hệ thống thông tin.
select HOTEN 
from GIAOVIEN as GV 
join BOMON as BM on GV.MABM = BM.MABM
where BM.TENBM = N'Hệ thống thông tin'
    and YEAR(NGSINH) <=all(
        select year(NGSINH)
        from GIAOVIEN as GV 
        join BOMON as BM on GV.MABM = BM.MABM
        where BM.TENBM = N'Hệ thống thông tin'
    )

-- Q39. Cho biết tên giáo viên nhỏ tuổi nhất khoa Công nghệ thông tin.
select HOTEN 
from GIAOVIEN as GV 
join BOMON as BM on GV.MABM = BM.MABM
join KHOA as K on BM.MAKHOA = K.MAKHOA
where K.TENKHOA = N'Công nghệ thông tin'
    and YEAR(NGSINH) >=all(
        select year(NGSINH)
        from GIAOVIEN as GV 
        join BOMON as BM on GV.MABM = BM.MABM
        join KHOA as K on BM.MAKHOA = K.MAKHOA
        where K.TENKHOA = N'Công nghệ thông tin'
    )

-- Q40. Cho biết tên giáo viên và tên khoa của giáo viên có lương cao nhất.
select HOTEN, TENKHOA
from GIAOVIEN as GV 
join BOMON as BM on GV.MABM = BM.MABM
join KHOA as K on BM.MAKHOA = K.MAKHOA
where LUONG = (select MAX(LUONG) from GIAOVIEN)

-- Q41. Cho biết những giáo viên có lương lớn nhất trong bộ môn của họ.
select *
from GIAOVIEN as GV1
where LUONG >=all(
    select LUONG
    from GIAOVIEN
    where MABM = GV1.MABM
)

-- Q42. Cho biết tên những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia.
select TENDT
from DETAI
where MADT not in (
    select distinct MADT
    from THAMGIADT as TGDT
    join GIAOVIEN as GV on TGDT.MAGV = GV.MAGV
    where GV.HOTEN = N'Nguyễn Hoài An')

-- Q43. Cho biết những đề tài mà giáo viên Nguyễn Hoài An chưa tham gia. Xuất ra tên đề tài, tên người chủ nhiệm đề tài.
select TENDT, HOTEN
from DETAI 
join GIAOVIEN on GVCNDT = MAGV
where MADT not in (
    select distinct MADT
    from THAMGIADT as TGDT
    join GIAOVIEN as GV on TGDT.MAGV = GV.MAGV
    where GV.HOTEN = N'Nguyễn Hoài An')

-- Q44. Cho biết tên những giáo viên khoa Công nghệ thông tin mà chưa tham gia đề tài nào.
select GV.HOTEN 
from GIAOVIEN as GV
join BOMON as BM on GV.MABM =BM.MABM
join KHOA as K on BM.MAKHOA = K.MAKHOA
where K.TENKHOA = N'Công nghệ thông tin'
    and MAGV not in(select MAGV from THAMGIADT)

-- Q45. Tìm những giáo viên không tham gia bất kỳ đề tài nào
select *
from GIAOVIEN
where MAGV not in (select MAGV from THAMGIADT)

-- Q46. Cho biết giáo viên có lương lớn hơn lương của giáo viên “Nguyễn Hoài An”
select *
from GIAOVIEN
where LUONG >all (select LUONG from GIAOVIEN where HOTEN = N'Nguyễn Hoài An')

-- Q47. Tìm những trưởng bộ môn tham gia tối thiểu 1 đề tài
select TRUONGBM
from BOMON
where TRUONGBM in (
    select MAGV
    from THAMGIADT
)

-- Q48. Tìm giáo viên trùng tên và cùng giới tính với giáo viên khác trong cùng bộ môn
select *
from GIAOVIEN as GV2
where EXISTS (
    select*
    from GIAOVIEN as GV1
    where  GV1.MAGV != GV2.MAGV and
            GV1.PHAI = GV2.PHAI and
            substring(REVERSE(GV1.HOTEN),  0, CHARINDEX(' ', REVERSE(GV1.HOTEN))) =  
            substring(REVERSE(GV2.HOTEN),  0, CHARINDEX(' ', REVERSE(GV2.HOTEN)))
)

-- Q49. Tìm những giáo viên có lương lớn hơn lương của ít nhất một giáo viên bộ môn “Công nghệ phần mềm”
select *
from GIAOVIEN as GV
join BOMON as BM on GV.MABM = BM.MABM
where BM.TENBM != N'Công nghệ phần mềm'
    and GV.LUONG >any (
        select LUONG
        from GIAOVIEN as GV
        join BOMON as BM on GV.MABM = BM.MABM
        where BM.TENBM = N'Công nghệ phần mềm'
    )

-- Q50. Tìm những giáo viên có lương lớn hơn lương của tất cả giáo viên thuộc bộ môn “Hệ thống thông tin”
select *
from GIAOVIEN
where LUONG >all(
    select LUONG
    from GIAOVIEN as GV
    join BOMON as BM on GV.MABM = BM.MABM
    where BM.TENBM = N'Hệ thống thông tin'
)

-- Q51. Cho biết tên khoa có đông giáo viên nhất
select K.TENKHOA 
from GIAOVIEN as GV
join BOMON as BM on GV.MABM = BM.MABM
join KHOA as K on BM.MAKHOA = K.MAKHOA
group by K.MAKHOA, K.TENKHOA
having count(MAGV) >=all (
    select count(MAGV)
    from GIAOVIEN as GV
    join BOMON as BM on GV.MABM = BM.MABM
    join KHOA as K on BM.MAKHOA = K.MAKHOA
    group by K.MAKHOA, K.TENKHOA
)
-- Q52. Cho biết họ tên giáo viên chủ nhiệm nhiều đề tài nhất
select GV.HOTEN
from DETAI as DT
join GIAOVIEN as GV on DT.GVCNDT = GV.MAGV
group by DT.GVCNDT, GV.HOTEN
having COUNT(DT.MADT) >= all(
    select COUNT(DT.MADT)
    from DETAI as DT
    join GIAOVIEN as GV on DT.GVCNDT = GV.MAGV
    group by DT.GVCNDT
)

-- Q53. Cho biết mã bộ môn có nhiều giáo viên nhất
select MABM
from GIAOVIEN
group by MABM
having count(MAGV) >= all(
    select count(MAGV)
    from GIAOVIEN
    group by MABM
)

-- Q54. Cho biết tên giáo viên và tên bộ môn của giáo viên tham gia nhiều đề tài nhất.
select GV.HOTEN, BM.TENBM
from THAMGIADT as TGDT
join GIAOVIEN as GV on TGDT.MAGV = GV.MAGV
join BOMON as BM on GV.MABM = BM.MABM
group by TGDT.MAGV, GV.HOTEN, BM.TENBM
having count(distinct TGDT.MADT) >=all(
    select count(distinct MADT)
    from THAMGIADT 
    group by MAGV
)

-- Q55. Cho biết tên giáo viên tham gia nhiều đề tài nhất của bộ môn HTTT.
SELECT GV.HOTEN
From THAMGIADT as TGDT
join GIAOVIEN as GV
on TGDT.MAGV = GV.MAGV
where GV.MABM = 'HTTT'
group by GV.MAGV, GV.HOTEN
having count(distinct TGDT.MADT) >=all(
    SELECT count(distinct TGDT.MADT)
    From THAMGIADT as TGDT
    join GIAOVIEN as GV
    on TGDT.MAGV = GV.MAGV
    where GV.MABM = 'HTTT'
    group by GV.MAGV
)
-- Q56. Cho biết tên giáo viên và tên bộ môn của giáo viên có nhiều người thân nhất.
select GV.HOTEN, BM.TENBM
from GIAOVIEN as GV
left join BOMON as BM on GV.MABM = BM.MABM
left join NGUOITHAN as NT on GV.MAGV = NT.MAGV
group by GV.MAGV, GV.HOTEN, BM.TENBM
having COUNT(NT.TEN) >= all(
    select COUNT(NT.TEN)
    from GIAOVIEN as GV
    left join NGUOITHAN as NT on GV.MAGV = NT.MAGV
    group by GV.MAGV
)
-- Q57. Cho biết tên trưởng bộ môn mà chủ nhiệm nhiều đề tài nhất.
select GV.HOTEN
from DETAI as DT 
join (select distinct TRUONGBM from BOMON where TRUONGBM is not null) as TBM
on DT.GVCNDT = TBM.TRUONGBM
join GIAOVIEN as GV on DT.GVCNDT = GV.MAGV
group by DT.GVCNDT, GV.HOTEN
having count(DT.MADT) >= all(
    select count(DT.MADT)
    from DETAI as DT 
    join (select distinct TRUONGBM from BOMON where TRUONGBM is not null) as TBM
    on DT.GVCNDT = TBM.TRUONGBM
    group by DT.GVCNDT
)
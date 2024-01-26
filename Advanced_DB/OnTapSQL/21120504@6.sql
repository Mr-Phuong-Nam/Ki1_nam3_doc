-- Q58. Cho biết tên giáo viên nào mà tham gia đề tài đủ tất cả các chủ đề.
select distinct GV.HOTEN
from GIAOVIEN as GV
join THAMGIADT as TGDT on GV.MAGV = TGDT.MAGV
join DETAI as DT on TGDT.MADT = DT.MADT
where not exists(
    select MACD
    from CHUDE
    except 
    select C.MACD
    from DETAI as C
    join THAMGIADT as TG on C.MADT = TG.MADT
    where TG.MAGV = TGDT.MAGV
) 

select distinct GV.HOTEN
from GIAOVIEN as GV
join THAMGIADT as TGDT on GV.MAGV = TGDT.MAGV
join DETAI as DT on TGDT.MADT = DT.MADT
where not exists(
    select S.MACD
    from CHUDE as S
    where not exists(
        select *
        from THAMGIADT A
        join DETAI B on A.MADT = B.MADT
        where A.MAGV = GV.MAGV and B.MACD = S.MACD
    )
) 

select distinct GV.HOTEN
from GIAOVIEN as GV
join THAMGIADT as TGDT on GV.MAGV = TGDT.MAGV
join DETAI as DT on TGDT.MADT = DT.MADT
group by GV.MAGV, GV.HOTEN
having count(distinct DT.MACD) = (
    select count(*)
    from CHUDE
)
-- Q59. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn HTTT tham gia.
select distinct DT.TENDT
from DETAI DT 
where not exists(
    select MAGV 
    from GIAOVIEN where MABM = 'HTTT'
    except 
    select MAGV
    from THAMGIADT 
    where MADT = DT.MADT
)

select distinct DT.TENDT
from DETAI DT 
join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists(
    select S.MAGV 
    from GIAOVIEN S 
    where S.MABM = 'HTTT'
    and not EXISTS(
        select *
        from THAMGIADT
        where MADT = DT.MADT and MAGV = S.MAGV
    )
)

select distinct DT.TENDT
from DETAI DT 
join THAMGIADT TGDT on DT.MADT = TGDT.MADT
join GIAOVIEN as GV on GV.MAGV = TGDT.MAGV
WHERE GV.MABM = 'HTTT'
group by DT.MADT, DT.TENDT
having count(distinct TGDT.MAGV) = (
    select count(*)
    from GIAOVIEN S 
    where S.MABM = 'HTTT'
)

-- Q60. Cho biết tên đề tài có tất cả giảng viên bộ môn “Hệ thống thông tin” tham gia

select distinct DT.TENDT
from DETAI DT 
join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists(
    select MAGV 
    from GIAOVIEN as GV
    join BOMON as BM on BM.MABM = GV.MABM 
    where BM.TENBM = N'Hệ thống thông tin'
    except 
    select MAGV
    from THAMGIADT 
    where MADT = TGDT.MADT
)

select distinct DT.TENDT
from DETAI DT 
join THAMGIADT TGDT on DT.MADT = TGDT.MADT
where not exists(
    select MAGV 
    from GIAOVIEN as GV
    join BOMON as BM on BM.MABM = GV.MABM 
    where BM.TENBM = N'Hệ thống thông tin'
    and not EXISTS(
        select *
        from THAMGIADT
        where MADT = DT.MADT and MAGV = GV.MAGV
    )
)

select distinct DT.TENDT
from DETAI DT 
join THAMGIADT TGDT on DT.MADT = TGDT.MADT
join GIAOVIEN as GV on GV.MAGV = TGDT.MAGV
join BOMON as BM on GV.MABM = BM.MABM
WHERE BM.TENBM = N'Hệ thống thông tin'
group by DT.MADT, DT.TENDT
having count(distinct TGDT.MAGV) = (
    select count(*)
    from GIAOVIEN A
    join BOMON B on A.MABM = B.MABM 
    where B.TENBM = N'Hệ thống thông tin'
)

-- Q61. Cho biết giáo viên nào đã tham gia tất cả các đề tài có mã chủ đề là QLGD.
select distinct TGDT.MAGV 
from THAMGIADT as TGDT
join DETAI as DT on TGDT.MADT = DT.MADT
where not exists(
    select MADT 
    from DETAI
    where MACD = 'QLGD'
    EXCEPT
    select MADT
    from THAMGIADT 
    where MAGV = TGDT.MAGV
)

select distinct TGDT.MAGV 
from THAMGIADT as TGDT
join DETAI as DT on TGDT.MADT = DT.MADT
where not exists(
    select MADT 
    from DETAI S
    where MACD = 'QLGD'
    and not exists(
        select *
        from THAMGIADT
        where MADT = S.MADT and MAGV = TGDT.MAGV
    )
)

select distinct TGDT.MAGV 
from THAMGIADT as TGDT
join DETAI as DT on TGDT.MADT = DT.MADT
where DT.MACD = 'QLGD'
group by TGDT.MAGV
having count(distinct TGDT.MADT) = (
    select count(*)
    from DETAI
    where MACD = 'QLGD'
)



-- Q62. Cho biết tên giáo viên nào tham gia tất cả các đề tài mà giáo viên Trần Trà Hương đã tham gia.
select distinct GV.HOTEN    
from THAMGIADT as TGDT
join GIAOVIEN as GV on TGDT.MAGV = GV.MAGV   
where GV.HOTEN != N'Trần Trà Hương' and not exists(
    select distinct MADT 
    from THAMGIADT as A 
    join GIAOVIEN as B on A.MAGV = B.MAGV
    where B.HOTEN = N'Trần Trà Hương'
    except
    select MADT 
    from THAMGIADT
    where MAGV = TGDT.MAGV)

select distinct GV.HOTEN    
from THAMGIADT as TGDT
join GIAOVIEN as GV on TGDT.MAGV = GV.MAGV   
where GV.HOTEN != N'Trần Trà Hương' and not exists(
    select distinct MADT 
    from THAMGIADT as A 
    join GIAOVIEN as B on A.MAGV = B.MAGV
    where B.HOTEN = N'Trần Trà Hương'
        and not exists(
            select * from THAMGIADT
            where MAGV = GV.MAGV and A.MADT = MADT
        ))
-- Khong the su dung count

-- Q63. Cho biết tên đề tài nào mà được tất cả các giáo viên của bộ môn Hóa Hữu Cơ tham gia.
select TENDT
from DETAI as DT
where not exists(
    select A.MAGV
    from GIAOVIEN A
    join BOMON B on A.MABM = B.MABM
    where B.TENBM = N'Hóa Hữu Cơ'
    except
    select MAGV
    from THAMGIADT
    where MADT = DT.MADT
)

select DT.TENDT
from DETAI as DT
where not exists(
    select A.MAGV
    from GIAOVIEN A
    join BOMON B on A.MABM = B.MABM
    where B.TENBM = N'Hóa Hữu Cơ'
    and not exists(
        select *
        from THAMGIADT
        where MADT = DT.MADT and MAGV = A.MAGV
    )
)

select DT.TENDT
from THAMGIADT as TGDT
join GIAOVIEN as GV on GV.MAGV = TGDT.MAGV
join DETAI as DT on DT.MADT = TGDT.MADT 
join BOMON as BM on GV.MABM = BM.MABM 
where BM.TENBM = N'Hóa Hữu Cơ'
group by DT.MADT, DT.TENDT
having count(distinct GV.MAGV) = (
    select count(MAGV)
    from GIAOVIEN as GV1
    join BOMON as BM1 on GV1.MABM = BM1.MABM
    where BM1.TENBM = N'Hóa Hữu Cơ'
)


-- Q64. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài 006.

select GV.HOTEN
from GIAOVIEN as GV
where not exists(
    select SOTT
    from CONGVIEC
    where MADT = '006'
    except
    select STT 
    from THAMGIADT
    where MAGV = GV.MAGV and MADT = '006'
)

select GV.HOTEN
from GIAOVIEN as GV
where not exists(
    select SOTT
    from CONGVIEC
    where MADT = '006'
    and not exists(
        select * 
        from THAMGIADT
        where MADT = '006' and MAGV = GV.MAGV and STT = SOTT 
    )
)

select GV.HOTEN
from GIAOVIEN as GV 
join THAMGIADT as TGDT on TGDT.MAGV = GV.MAGV
where TGDT.MADT = '006'
group by GV.MAGV, GV.HOTEN
HAVING count(TGDT.STT) = (
    select count(SOTT)
    from CONGVIEC
    where MADT = '006'
)


-- Q65. Cho biết giáo viên nào đã tham gia tất cả các đề tài của chủ đề Ứng dụng công nghệ.
select *
from GIAOVIEN as GV
where not exists(
    select DT.MADT 
    from DETAI as DT 
    join CHUDE as CD on DT.MACD = CD.MACD
    where CD.TENCD = N'Ứng dụng công nghệ'
    except
    select MADT 
    from THAMGIADT
    where MAGV = GV.MAGV
)

select *
from GIAOVIEN as GV
where not exists(
    select DT.MADT 
    from DETAI as DT 
    join CHUDE as CD on DT.MACD = CD.MACD
    where CD.TENCD = N'Ứng dụng công nghệ'
        and not exists(
            select *
            from THAMGIADT
            where DT.MADT = MADT and GV.MAGV = magv
        )
)

select GV.MAGV
from GIAOVIEN as GV
join THAMGIADT as TGDT on GV.MAGV = TGDT.MAGV
join DETAI as DT on TGDT.MADT = DT.MADT
join CHUDE as CD on DT.MACD = CD.MACD
where CD.TENCD = N'Ứng dụng công nghệ'
group by GV.MAGV
HAVING count(DT.MADT) = (
    select count(MADT)
    from DETAI 
    join CHUDE on DETAI.MACD = CHUDE.MACD
    where CHUDE.TENCD = N'Ứng dụng công nghệ'
)



-- Q66. Cho biết tên giáo viên nào đã tham gia tất cả các đề tài của do Trần Trà Hương làm chủ
-- nhiệm.
select GV.HOTEN
from GIAOVIEN as GV
where not exists(
    select DT.MADT 
    from DETAI as DT 
    join GIAOVIEN as GVCN on DT.GVCNDT = GVCN.MAGV
    where GVCN.HOTEN = N'Trần Trà Hương'
    except
    select MADT 
    from THAMGIADT
    where MAGV = GV.MAGV
)

select GV.HOTEN
from GIAOVIEN as GV
where not exists(
    select DT.MADT 
    from DETAI as DT 
    join GIAOVIEN as GVCN on DT.GVCNDT = GVCN.MAGV
    where GVCN.HOTEN = N'Trần Trà Hương'
        and not exists(
            select *
            from THAMGIADT
            where DT.MADT = MADT and GV.MAGV = magv
        )
)

select GV.HOTEN
from GIAOVIEN as GV
join THAMGIADT as TGDT on GV.MAGV = TGDT.MAGV
join DETAI as DT on TGDT.MADT = DT.MADT
join GIAOVIEN as GVCN on DT.GVCNDT = GVCN.MAGV
where GVCN.HOTEN = N'Trần Trà Hương'
group by GV.MAGV, GV.HOTEN
HAVING count(distinct DT.MADT) = (
    select count(MADT)
    from DETAI 
    join GIAOVIEN on DETAI.GVCNDT = GIAOVIEN.MAGV
    where GIAOVIEN.HOTEN = N'Trần Trà Hương'
)

-- Q67. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa CNTT tham gia.
select TENDT 
from DETAI 
where not exists(
    select gv.magv
    from giaovien as gv
    join bomon as bm on bm.mabm = gv.mabm 
    where bm.makhoa = 'CNTT'
    except 
    select magv
    from thamgiadt 
    where madt = detai.madt
)

select distinct TENDT 
from DETAI 
where not exists(
    select gv.magv
    from giaovien as gv
    join bomon as bm on bm.mabm = gv.mabm 
    where bm.makhoa = 'CNTT'
        and not exists(
            select *
            from THAMGIADT
            where magv = gv.magv and madt = detai.madt
        )
)

select dt.tendt 
from thamgiadt as tgdt
join detai as dt on tgdt.madt = dt.madt 
join giaovien as gv on tgdt.magv = gv.magv 
join bomon as bm on gv.mabm = bm.mabm 
where bm.makhoa = 'CNTT'
group by dt.madt, dt.tendt 
having count(distinct gv.magv) = (
    select count(*)
    from giaovien as gv
    join bomon as bm on bm.mabm = gv.mabm 
    where bm.makhoa = 'CNTT'
)



-- Q68. Cho biết tên giáo viên nào mà tham gia tất cả các công việc của đề tài Nghiên cứu tế bào gốc.

select gv.hoten 
from giaovien as gv
where not exists(
    select cv.sott 
    from congviec as cv
    join detai as dt on cv.madt = dt.madt 
    where dt.tendt = N'Nghiên cứu tế bào gốc'
    except 
    select tgdt.stt 
    from thamgiadt as tgdt 
    join detai as dt on tgdt.MADT = dt.madt 
    where dt.tendt = N'Nghiên cứu tế bào gốc' and tgdt.magv = gv.magv
)

select gv.hoten 
from giaovien as gv
where not exists(
    select cv.sott 
    from congviec as cv
    join detai as dt on cv.madt = dt.madt 
    where dt.tendt = N'Nghiên cứu tế bào gốc'
    and not exists(
        select tgdt.stt 
        from thamgiadt as tgdt 
        join detai as dt on tgdt.MADT = dt.madt 
        where dt.tendt = N'Nghiên cứu tế bào gốc' and tgdt.magv = gv.magv and tgdt.stt = cv.sott
    )
)

select gv.hoten
from thamgiadt as tgdt 
join detai as dt on tgdt.MADT = dt.madt 
join giaovien as gv on gv.magv = tgdt.magv
where dt.tendt = N'Nghiên cứu tế bào gốc'
group by gv.magv, gv.hoten 
having count(distinct tgdt.stt) = (
    select count(cv.sott)
    from congviec as cv
    join detai as dt on cv.madt = dt.madt 
    where dt.tendt = N'Nghiên cứu tế bào gốc'
)



-- Q69. Tìm tên các giáo viên được phân công làm tất cả các đề tài có kinh phí trên 100 triệu?
select gv.hoten 
from giaovien as gv 
where not exists(
    select madt 
    from detai 
    where kinhphi > 100
    except
    select madt
    from THAMGIADT
    where MAGV = gv.MAGV
)

select gv.hoten 
from giaovien as gv 
where not exists(
    select madt 
    from detai 
    where kinhphi > 100
        and not exists(
            select madt
            from THAMGIADT
            where MAGV = gv.MAGV and madt = detai.madt
        )
)

select gv.hoten 
from giaovien as gv 
join thamgiadt as tgdt on gv.magv = tgdt.magv 
join detai as dt on tgdt.MADT = dt.madt 
where dt.kinhphi > 100 
group by gv.magv, gv.hoten 
having count(distinct dt.madt) = (
    select count(madt) 
    from detai 
    where kinhphi > 100
)


-- Q70. Cho biết tên đề tài nào mà được tất cả các giáo viên của khoa Sinh Học tham gia.

select dt.tendt 
from detai as dt 
where not exists(
    select gv.magv 
    from giaovien as gv 
    join bomon as bm on gv.mabm = bm.mabm 
    join khoa as k on bm.makhoa = k.makhoa 
    where k.tenkhoa = N'Sinh Học'
    except 
    select gv.magv 
    from giaovien as gv 
    join thamgiadt as tgdt on tgdt.magv = gv.magv 
    join bomon as bm on gv.mabm = bm.mabm 
    join khoa as k on bm.makhoa = k.makhoa 
    where k.tenkhoa = N'Sinh Học' and tgdt.madt = dt.madt
)

select dt.tendt 
from detai as dt 
where not exists(
    select gv.magv 
    from giaovien as gv 
    join bomon as bm on gv.mabm = bm.mabm 
    join khoa as k on bm.makhoa = k.makhoa 
    where k.tenkhoa = N'Sinh Học'
    and not exists(
        select *
        from thamgiadt 
        where magv = gv.magv and madt = dt.madt
    )
)

select dt.tendt
from giaovien as gv 
join thamgiadt as tgdt on tgdt.magv = gv.magv
join detai as dt on tgdt.madt = dt.madt 
join bomon as bm on gv.mabm = bm.mabm 
join khoa as k on bm.makhoa = k.makhoa 
where k.tenkhoa = N'Sinh Học'
group by dt.madt, dt.tendt 
having count(distinct gv.magv) = (
    select count(gv.magv)
    from giaovien as gv 
    join bomon as bm on gv.mabm = bm.mabm 
    join khoa as k on bm.makhoa = k.makhoa 
    where k.tenkhoa = N'Sinh Học'
)

-- Q71. Cho biết mã số, họ tên, ngày sinh của giáo viên tham gia tất cả các công việc của đề tài “Ứng dụng hóa học xanh”.

select distinct gv.magv, gv.hoten, gv.ngsinh
from giaovien as gv
where not exists(
    select cv.sott 
    from congviec as cv
    join detai as dt on cv.madt = dt.madt 
    where dt.tendt = N'Ứng dụng hóa học xanh'
    except 
    select tgdt.stt 
    from thamgiadt as tgdt 
    join detai as dt on tgdt.MADT = dt.madt 
    where dt.tendt = N'Ứng dụng hóa học xanh' and tgdt.magv = gv.magv
)

select distinct gv.magv, gv.hoten, gv.ngsinh
from giaovien as gv
where not exists(
    select cv.sott 
    from congviec as cv
    join detai as dt on cv.madt = dt.madt 
    where dt.tendt = N'Ứng dụng hóa học xanh'
    and not exists(
        select tgdt.stt 
        from thamgiadt as tgdt 
        join detai as dt on tgdt.MADT = dt.madt 
        where dt.tendt = N'Ứng dụng hóa học xanh' and tgdt.magv = gv.magv and tgdt.stt = cv.sott
    )
)

select gv.magv, gv.hoten , gv.ngsinh
from thamgiadt as tgdt 
join detai as dt on tgdt.MADT = dt.madt 
join giaovien as gv on gv.magv = tgdt.magv
where dt.tendt = N'Ứng dụng hóa học xanh'
group by gv.magv, gv.hoten , gv.ngsinh
having count(distinct tgdt.stt) = (
    select count(cv.sott)
    from congviec as cv
    join detai as dt on cv.madt = dt.madt 
    where dt.tendt = N'Ứng dụng hóa học xanh'
)

-- Q72. Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên tham gia tất cả các đề tài thuộc chủ đề “Nghiên cứu phát triển”.


select gv.magv, gv.hoten, nql.hoten
from GIAOVIEN as GV
join bomon as bm on gv.mabm = gv.mabm 
left join giaovien as nql on gv.gvqlcm = nql.magv 
where not exists(
    select DT.MADT 
    from DETAI as DT 
    join CHUDE as CD on DT.MACD = CD.MACD
    where CD.TENCD = N'Nghiên cứu phát triển'
    except
    select MADT 
    from THAMGIADT
    where MAGV = GV.MAGV
)

select gv.magv, gv.hoten, nql.hoten
from GIAOVIEN as GV
join bomon as bm on gv.mabm = gv.mabm 
left join giaovien as nql on gv.gvqlcm = nql.magv 
where not exists(
    select DT.MADT 
    from DETAI as DT 
    join CHUDE as CD on DT.MACD = CD.MACD
    where CD.TENCD = N'Nghiên cứu phát triển'
        and not exists(
            select *
            from THAMGIADT
            where DT.MADT = MADT and GV.MAGV = magv
        )
)

select gv.magv, gv.hoten, nql.hoten
from GIAOVIEN as GV
join bomon as bm on gv.mabm = gv.mabm 
left join giaovien as nql on gv.gvqlcm = nql.magv 
join THAMGIADT as TGDT on GV.MAGV = TGDT.MAGV
join DETAI as DT on TGDT.MADT = DT.MADT
join CHUDE as CD on DT.MACD = CD.MACD
where CD.TENCD = N'Nghiên cứu phát triển'
group by GV.MAGV, gv.hoten, nql.hoten
HAVING count(DT.MADT) = (
    select count(MADT)
    from DETAI 
    join CHUDE on DETAI.MACD = CHUDE.MACD
    where CHUDE.TENCD = N'Nghiên cứu phát triển'
)
-- Q75. Cho biết họ tên giáo viên và tên bộ môn họ làm trưởng bộ môn nếu có
select gv.hoten, bm.tenbm 
from giaovien as gv 
left join bomon as bm on gv.magv = bm.truongbm
-- Q76. Cho danh sách tên bộ môn và họ tên trưởng bộ môn đó nếu có
select bm.tenbm, gv.hoten
from giaovien as gv 
right join bomon as bm on gv.magv = bm.truongbm
-- Q77. Cho danh sách tên giáo viên và các đề tài giáo viên đó chủ nhiệm nếu có
select gv.hoten, dt.madt 
from giaovien as gv 
left join detai as dt on gv.magv = dt.GVCNDT
order by gv.magv
-- Q78. Xuất ra thông tin của giáo viên (MAGV, HOTEN) và mức lương của giáo viên. Mức
-- lương được xếp theo quy tắc: Lương của giáo viên < $1800 : “THẤP” ; Từ $1800 đến
-- $2200: TRUNG BÌNH; Lương > $2200: “CAO”
select magv, hoten, (case 
                        when luong < 1800 then N'THẤP'
                        when luong <= 2200 then N'TRUNG BÌNH'
                        else 'CAO'
                    end ) as mucluong
from giaovien 

-- Q79. Xuất ra thông tin giáo viên (MAGV, HOTEN) và xếp hạng dựa vào mức lương. Nếu giáo
-- viên có lương cao nhất thì hạng là 1.
select magv, hoten, (select count(*) + 1
                     from giaovien as gv 
                     where gv.luong > giaovien.luong) as hang
from giaovien
order by hang
-- Q80. Xuất ra thông tin thu nhập của giáo viên. Thu nhập của giáo viên được tính bằng
-- LƯƠNG + PHỤ CẤP. Nếu giáo viên là trưởng bộ môn thì PHỤ CẤP là 300, và giáo viên là
-- trưởng khoa thì PHỤ CẤP là 600.
select gv.magv,  gv.luong + (
    case 
        when exists(select * from khoa where truongkhoa = gv.magv) and exists(select * from bomon where truongbm = gv.magv)
            then 600 + 300
        when exists(select * from bomon where truongbm = gv.magv)
            then 300
        when exists(select * from khoa where truongkhoa = gv.magv)
            then 600
        else 0
    end
) as thunhap
from giaovien as gv

-- Q81. Xuất ra năm mà giáo viên dự kiến sẽ nghĩ hưu với quy định: Tuổi nghỉ hưu của Nam là
-- 60, của Nữ là 55.
select magv, year(ngsinh) + (
    case
        when phai = N'Nam' then 60
        else 55
    end
)
from giaovien




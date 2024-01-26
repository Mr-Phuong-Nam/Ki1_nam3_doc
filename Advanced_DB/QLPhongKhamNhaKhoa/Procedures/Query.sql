-- Cho biết tổng số kế hoạch điều trị ứng với tổng thu của kế hoạch điều trị tại mỗi chi nhánh ở TP HCM, kết quả sắp xếp theo tổng thu.
select count(*) as 'Tong so ke hoach', sum(k.TongTien) as 'Tong thu', c.TenChiNhanh
from KeHoachDieuTri k 
join LichHen l on k.MaLichHen = l.MaLichHen
JOIN ChiNhanh c on l.MaChiNhanh = c.MaChiNhanh
where c.DiaChi like '%Hồ Chí Minh%'
group by c.MaChiNhanh, c.TenChiNhanh 




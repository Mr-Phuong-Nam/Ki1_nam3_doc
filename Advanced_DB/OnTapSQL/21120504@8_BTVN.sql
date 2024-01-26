-- 1. Tên stored procedure: spDatPhong
-- Nội dung: ghi nhận thông tin đặt phòng của khách hàng xuống cơ sở dữ liệu.
-- Tham số yêu cầu: mã khách hàng (@makh), mã phòng (@maphong), ngày đặt phòng
-- (@ngaydat).
-- Lưu ý: Mã đặt phòng là số nguyên và phải phát sinh tự động theo cách sau: mã đặt phòng phát
-- sinh = mã đặt phòng lớn nhất + 1.
-- Các yêu cầu và kiểm tra và tính toán:
--      - Kiểm tra mã khách hàng phải hợp lệ (phải xuất hiện trong bảng KHÁCH HÀNG)
--      - Kiểm tra mã phòng hợp lệ (phải xuất hiện trong bảng PHÒNG)
--      - Chỉ được đặt phòng khi tình trạng của phòng là “Rảnh”
--      - Nếu các kiểm tra hợp lệ thì ghi nhận thông tin đặt phòng xuống CSDL (Ngày trả và thành tiền của khi đặt phòng là NULL)
--      - Sau khi đặt phòng thành công thì phải cập nhật tình trạng của phòng là “Bận”
go
create function f_genarateMa()
returns int 
as  
    begin 
        if((select count(*) from DATPHONG) = 0) return 1
        return (select max(ma) + 1 from DATPHONG)
    end 
go 
create procedure sp_DatPhong
    @makh char(5), @maphong char(5), @ngaydat date 
as 
    if(not exists(select makh from KHACH where makh = @makh)) raiserror(N'Không tồn tại mã khách hàng', 16, 1)
    else if(not exists(select maphong from phong where @maphong = maphong)) raiserror(N'Không tồn tại mã phòng', 16, 1)
    else if((select tinhtrang from PHONG where maphong = @maphong) != N'Rảnh') raiserror(N'Phòng bận', 16, 1)
    else begin
        insert into DATPHONG
        values(dbo.f_genarateMa(), @makh, @maphong, @ngaydat, NULL, NULL)

        update PHONG
        set tinhtrang = N'Bận'
        where maphong = @maphong
    end 
go 


-- 2. Tên stored procedure: spTraPhong
-- Nội dung: ghi nhận thông tin trả phòng của khách hàng xuống cơ sở dữ liệu.
-- Tham số yêu cầu: mã đặt phòng (@madp), mã khách hàng (@makh)
-- Các yêu cầu về kiểm tra và tính toán:
--      - Kiểm tra tính hợp lệ của mã đặt phòng, mã khách hàng: Hợp lệ nếu khách hàng có thực hiện việc đặt phòng.
--      - Ngày trả phòng chính là ngày hiện hành.
--      - Tiền thanh toán được tính theo công thức: Tien = Số ngày mượn x đơn giá của phòng.
--      - Phải thực hiện việc cập nhật tình trạng của phòng là “Rảnh” sau khi ghi nhận thông tin trả phòng
go 
create procedure sp_TraPhong 
    @madp int, @makh char(5)
as 
    if(not exists(select * from DATPHONG where ma = @madp and makh = @makh)) raiserror(N'Mã đặt phòng, mã khách hàng không hợp lệ', 16, 1)
    else begin 
        update DATPHONG
        set ngaytra = getdate()
        where ma = @madp

        update DATPHONG 
        set thanhtien = (select datediff(day, ngaybd, ngaytra)*(select dongia from phong where maphong = DATPHONG.maphong) from DATPHONG where ma = @madp)
        where ma = @madp

        update PHONG
        set trinhtrang = N'Rảnh'
        where maphong = (select maphong from datphong where ma = @madp)
    end
go 
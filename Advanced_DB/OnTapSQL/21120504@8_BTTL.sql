

-- a. In ra câu chào “Hello World !!!”.
create procedure sp_Hello
as 
    print 'Hello World'
go

exec sp_Hello

-- b. In ra tổng 2 số.
go
create procedure sp_PrintSum2
    @num1 int, @num2 int 
as 
    print @num1 + @num2
go 

exec sp_PrintSum2 1, 4

-- c. Tính tổng 2 số (sử dụng biến output để lưu kết quả trả về).
go
create procedure sp_ReturnSum2
    @num1 int, @num2 int, 
    @res int out
as 
    set @res = @num1 + @num2
go 

declare @res int 
exec sp_ReturnSum2 4, 2, @res out
print @res

-- d. In ra tổng 3 số (Sử dụng lại stored procedure Tính tổng 2 số).
go 
create procedure sp_PrintSum3
    @num1 int, @num2 int, @num3 int 
as 
    declare @res int 
    exec sp_ReturnSum2 @num1, @num2, @res out 
    exec sp_ReturnSum2 @num3, @res, @res out 
    print @res
go 

exec sp_PrintSum3 1, 2, 3

-- e. In ra tổng các số nguyên từ m đến n.
go 
create procedure sp_PrintSumMN
    @m int, @n int 
as 
    declare @i int, @res int 
    set @i = @m
    set @res = 0

    while(@i <= @n)
    begin
        set @res = @res + @i
        set @i = @i + 1 
    end 
    print @res
go

exec sp_PrintSumMN 1, 10



-- f. Kiểm tra 1 số nguyên có phải là số nguyên tố hay không.
go
create procedure sp_LaSoNguyenTo
    @num int 
as 
    if(@num < 2) return 0

    declare @i int
    set @i = 2

    while(@i <= sqrt(@num)) begin 
        if(@num % @i = 0) return 0
        set @i = @i + 1
    end 

    return 1
go 

declare @res int 
EXEC @res = sp_LaSoNguyenTo 11
print @res




-- g. In ra tổng các số nguyên tố trong đoạn m, n.
go
create procedure sp_SumPrimesMN
    @m int, @n int 
as 
    declare @res int 
    set @res = 0
    declare @check int 

    declare @i int 
    set @i = @m

    while(@i <= @n) begin 
        exec @check = sp_LaSoNguyenTo @i
        if(@check = 1) 
            set @res = @res + @i
        
        set @i = @i + 1
    end 

    print @res
go 

exec sp_SumPrimesMN 10, 20


-- h. Tính ước chung lớn nhất của 2 số nguyên.
go
create procedure sp_GCD
    @a int, @b int 
as 
    while(@b != 0) begin 
        declare @r int 
        set @r = @a % @b
        set @a = @b
        set @b = @r
    end 
    return @a
go 
declare @r int
exec @r = sp_GCD 10, 25
print @r


-- i. Tính bội chung nhỏ nhất của 2 số nguyên.
go
create procedure sp_LCM
    @a int, @b int 
as
    declare @gcd int
    exec @gcd  = sp_GCD @a, @b
    return @a*@b/@gcd
go 

declare @r int
exec @r = sp_LCM 10, 25
print @r


-- j. Xuất ra toàn bộ danh sách giáo viên.

go
create procedure sp_PrintDSGV
as 
    select * from GIAOVIEN
go 
exec sp_PrintDSGV

go 
create function fn_PrintDSGV()
returns table
as 
    return (select * from GIAOVIEN)
go 
select * from dbo.fn_PrintDSGV()

-- k. Tính số lượng đề tài mà một giáo viên đang thực hiện.
go 
create procedure sp_CountDTGV
    @magv char(5), @res int OUT
as 
    set @res = (
        select count(distinct MADT)
        from Thamgiadt
        where magv = @magv
    )
go

go 
create function fn_CountDTGV(@magv char(5))
returns int 
as BEGIN
    return (
        select count(distinct MADT)
        from Thamgiadt
        where magv = @magv
    )
end 
go 

print dbo.fn_CountDTGV('003')

declare @n int
exec sp_CountDTGV '003', @n out 
print @n


-- l. In thông tin chi tiết của một giáo viên(sử dụng lệnh print): Thông tin cá
-- nhân, Số lượng đề tài tham gia, Số lượng thân nhân của giáo viên đó.
go
create procedure sp_PrintInforGV
    @magv char(5)
as 
    declare @thongtinct xml = (select * from giaovien where magv = @magv for xml auto)
    declare @soluongdt int = (select count(distinct madt) from Thamgiadt where magv = @magv)
    declare @soluongnhanthan int = (select count(*) from NGUOITHAN where magv = @magv)

    print convert(nvarchar(max), @thongtinct)
    print N'Số lượng đề tài tham gia: ' + cast(@soluongdt as varchar)
    print N'Số lượng nhân thân: ' + cast(@soluongnhanthan as varchar)
go 

exec sp_PrintInforGV '003'

go 
create procedure sp_PrintInformationGV
    @magv char(5)
as 
    select * from giaovien where magv = @magv
    select count(distinct madt) from Thamgiadt where magv = @magv
    select count(*) from NGUOITHAN where magv = @magv

exec sp_PrintInformationGV '003'

-- m. Kiểm tra xem một giáo viên có tồn tại hay không (dựa vào MAGV).
go 
create procedure sp_CheckGVExists 
    @magv char(5)
as 
    if(exists(select magv from giaovien where magv = @magv)) print N'Giáo viên tồn tại'
    else print N'Giáo viên không tồn tại'
go

exec sp_CheckGVExists '015'


-- n. Kiểm tra quy định của một giáo viên: Chỉ được thực hiện các đề tài mà bộ
-- môn của giáo viên đó làm chủ nhiệm.
go
create procedure sp_GVThucHienDT
    @magv char(5), @madt char(5)
as 
    if(  
        (select mabm from giaovien where magv = @magv) 
            =
        (select mabm from giaovien where magv = (select gvcndt from detai where madt = @madt) )
    )
         return 1
    else return 0 
go

declare @check int
exec @check = sp_GVThucHienDT '003', '002'
print @check


-- o. Thực hiện thêm một phân công cho giáo viên thực hiện một công việc của đề tài:
--      Kiểm tra thông tin đầu vào hợp lệ: giáo viên phải tồn tại, công việc phải tồn tại, thời gian tham gia phải >0
--      Kiểm tra quy định ở câu n.
go
create procedure sp_PhanCong
    @magv char(5), @madt char(5), @sott int, @phucap int = 0
as 
    declare @check int
    exec @check = sp_GVThucHienDT @magv, @madt

    if(not exists(select magv from giaovien where magv = @magv))
        raiserror(N'Giáo viên không tồn tại!', 16, 1)

    else if(not exists(select * from congviec where madt = @madt and sott = @sott)) 
        raiserror(N'Công viêc không tồn tại!', 16, 1)

    else if(@check = 0)
        raiserror(N'Đề tài đươc chủ nhiệm bởi giáo viên khác bộ môn', 16, 1)

    else begin 
        insert into THAMGIADT
        values (@magv, @madt, @sott, @phucap, NULL)
    end 
   
go

exec sp_PhanCong '001', '007', 1



-- p. Thực hiện xoá một giáo viên theo mã. Nếu giáo viên có thông tin liên quan
-- (Có thân nhân, có làm đề tài, ...) thì báo lỗi.

go
create procedure sp_DeleteGV
    @magv char(5)
as 
    if(exists(select magv from nguoithan where magv = @magv))
        raiserror(N'Tồn tại người thân', 16, 1)

    else if(exists(select magv from thamgiadt where magv = @magv))
        raiserror(N'Giáo viên còn làm đề tài', 16, 1)

    else
        delete from GIAOVIEN where magv = @magv
go 

exec sp_DeleteGV '002'


-- q. In ra danh sách giáo viên của một phòng ban nào đó cùng với số lượng đề
-- tài mà giáo viên tham gia, số thân nhân, số giáo viên mà giáo viên đó quản
-- lý nếu có, ...

go
alter procedure sp_PrintDSGVKhoa
    @makhoa char(5)
as 
    declare @temp table (
        magv char(5),
        hoten nvarchar(50),
        luong int,
        phai nvarchar(3),
        ngaysinh date,
        diachi nvarchar(50),
        gvqlcm char(5),
        mabm char(5),
        sodt int,
        sothannhan int,
        sogvql int
    )
    insert into @temp
    select gv.*, (select count(distinct madt) from THAMGIADT where magv = gv.magv) as sodt, 
    (select count(ten) from nguoithan where magv = gv.magv) as sothannhan,
    (select count(*) from giaovien where GVQLCM = gv.magv) as sogvql
    from giaovien as gv
    join bomon as bm on gv.mabm = bm.MABM
    where bm.makhoa = @makhoa

    declare @magv char(5), @hoten nvarchar(50), @luong int, @phai nvarchar(3), @ngaysinh date, @diachi nvarchar(50), @gvqlcm char(5), @mabm char(5), @sodt int, @sothannhan int, @sogvql int
    select * from @temp
    while exists(select * from @temp) begin 
        select top 1 @magv = magv, @hoten = hoten, @luong = luong, @phai = phai, @ngaysinh = ngaysinh, @diachi = diachi, @gvqlcm = gvqlcm, @mabm = mabm, @sodt = sodt, @sothannhan = sothannhan, @sogvql = sogvql from @temp
        print @magv + ' ' + @hoten + ' ' + cast(@luong as nvarchar(10)) + ' ' + @phai + ' ' + cast(@ngaysinh as nvarchar(20)) + ' ' + @diachi + ' ' + @gvqlcm + ' ' + @mabm + ' ' + cast(@sodt as nvarchar(10)) + ' ' + cast(@sothannhan as nvarchar(10)) + ' ' + cast(@sogvql as nvarchar(10))
        delete from @temp where magv = @magv
    end 
go

exec sp_PrintDSGVKhoa 'CNTT'

-- r. Kiểm tra quy định của 2 giáo viên a, b: Nếu a là trưởng bộ môn c của b thì
-- lương của a phải cao hơn lương của b. (a, b: mã giáo viên)
go
create procedure sp_CheckLuong
    @a char(5), @b char(5)
as 
    declare @bma char(5) = (select mabm from giaovien where magv = @a)
    declare @bmb char(5) = (select mabm from giaovien where magv = @b)
    if( @bma = @bmb and 
        (select truongbm from bomon where mabm = @bma) = @a and 
        (select luong from GIAOVIEN where magv = @a) > (select luong from GIAOVIEN where magv = @b))
        return 1
    else return 0
go 

-- s. Thêm một giáo viên: Kiểm tra các quy định: Không trùng tên, tuổi > 18,
-- lương > 0
create procedure sp_AddGV
    @magv char(5), 
    @hoten nvarchar(50), 
    @luong float, 
    @phai nvarchar(3),
    @ngsinh date, 
    @diachi nvarchar(100),
    @gvqlcm char(5) = null,
    @mabm char(5) = null 
as 
    if(exists(select* from giaovien where hoten = @hoten))
        raiserror(N'Trung ten', 16, 1)
    else if(year(GETDATE()) - year(@ngsinh) <= 18)
        raiserror(N'Chua du tuoi', 16, 1)
    else if(@luong <= 0)
        raiserror(N'chua du luong', 16, 1)
    else BEGIN
        insert into GIAOVIEN
        VALUES(@magv, @hoten, @luong, @phai, @ngsinh, @diachi, @gvqlcm, @mabm)
    end 
go

exec sp_AddGV '010', N'Nguyễn Thái Tân', 2000, 'Nam', '2000-01-01', N'Nha Trang Việt Nam'

-- t. Mã giáo viên được xác định tự động theo quy tắc: Nếu đã có giáo viên 001,
-- 002, 003 thì MAGV của giáo viên mới sẽ là 004. Nếu đã có giáo viên 001,
-- 002, 005 thì MAGV của giáo viên mới là 003.
go
create function fn_convertIntToMaGV(@i int)
returns char(5)
as begin 
    declare @magv char(5)
    set @magv = cast(@i as char(5))
    while len(@magv) < 3 begin 
        set @magv = '0' + @magv
    end
    return @magv
end
go
create function fn_GenerateMaGV()
returns char(5)
as begin 
    declare @magv char(5)
    declare @i int = 1
    while exists(select * from giaovien where magv = dbo.fn_convertIntToMaGV(@i)) begin 
        set @i = @i + 1
    end
    set @magv = dbo.fn_convertIntToMaGV(@i)
    return @magv
end
go 

alter procedure sp_AddGV
    @hoten nvarchar(50), 
    @luong float, 
    @phai nvarchar(3),
    @ngsinh date, 
    @diachi nvarchar(100),
    @gvqlcm char(5) = null,
    @mabm char(5) = null
as 
    declare @magv char(5) = dbo.fn_GenerateMaGV()
    raiserror(N'Thích lỗi á', 16, 1)
    insert into GIAOVIEN
    VALUES(@magv, @hoten, @luong, @phai, @ngsinh, @diachi, @gvqlcm, @mabm)
go

exec sp_AddGV N'Nguyễn Thái Tân', 2000, 'Nam', '2000-01-01', N'Nha Trang Việt Nam'

select * from giaovien


delete from giaovien where magv = '011'

---------------------------------C1---------------------------------------------
/*
# Creating database
*/

create database QL_DETAI
go

use QL_DETAI
go

/*
# Create table
*/

create table GIAOVIEN(
    MAGV char(5),
    HOTEN nvarchar(50),
    LUONG float,
    PHAI nvarchar(3) check(PHAI in ('Nam', N'Nữ')),
    NGSINH date, 
    DIACHI nvarchar(100),
    GVQLCM char(5),
    MABM nchar(5),
    constraint PK_GV primary key(MAGV)
)

create table GV_DT(
    MAGV char(5),
    DIENTHOAI varchar(15),
    constraint PK_GV_DT primary key(MAGV, DIENTHOAI)
)

create table BOMON (
    MABM nchar(5), 
    TENBM nvarchar(50), 
    PHONG char(5), 
    DIENTHOAI varchar(15), 
    TRUONGBM char(5), 
    MAKHOA char(5), 
    NGAYNHANCHUC date,
    constraint PK_BOMON primary key(MABM)
)

create table KHOA (
    MAKHOA char(5), 
    TENKHOA nvarchar(50), 
    NAMTL int,
    PHONG char(5), 
    DIENTHOAI varchar(15), 
    TRUONGKHOA char(5), 
    NGAYNHANCHUC date,
    constraint PK_KHOA primary key(MAKHOA)
)

create table DETAI (
    MADT char(5), 
    TENDT nvarchar(50), 
    KINHPHI float, 
    CAPQL nvarchar(50), 
    NGAYBD date, 
    NGAYKT date, 
    MACD char(5), 
    GVCNDT char(5),
    constraint PK_DETAI primary key(MADT)
)


create table CHUDE (
    MACD char(5), 
    TENCD nvarchar(50)
    constraint PK_CHUDE primary key(MACD)
)

create table CONGVIEC (
    MADT char(5), 
    STT int, 
    TENCV nvarchar(50), 
    NGAYBD date, 
    NGAYKT date,
    constraint PK_CONGVIEC primary key(MADT, STT)    
)

create table THAMGIADT(
    MAGV char(5), 
    MADT char(5), 
    STT int, 
    PHUCAP float, 
    KETQUA nvarchar(10),
    constraint PK_THAMGIADT primary key (MAGV, MADT, STT)    
)

create table NGUOITHAN (
    MAGV char(5), 
    TEN nvarchar(50), 
    NGSINH date, 
    PHAI nvarchar(3) check(PHAI in ('Nam', N'Nữ')),
    constraint PK_NGUOI_THAN primary key(MAGV, TEN)
)

/*
# Create foreigh key
*/

/*
### **GIAOVIEN** table
*/

--FK_GIAOVIEN_GIAOVIEN
--GIAOVIEN(GVQLCM) --> GIAOVIEN(MAGV)
alter table GIAOVIEN
add constraint FK_GIAOVIEN_GIAOVIEN
foreign key (GVQLCM)
references GIAOVIEN(MAGV)
--FK_GIAOVIEN_BOMON
--GIAOVIEN(MABM) --> BOMON(MABM)
alter table GIAOVIEN
add constraint FK_GIAOVIEN_BOMON
foreign key (MABM)
references BOMON(MABM)

/*
### **GV_DT** table
*/

-- FK_GV_DT_GIAOVIEN
-- GV_DT(MAGV) --> GIAOVIEN(MAGV)
alter table GV_DT
add constraint FK_GV_DT_GIAOVIEN
foreign key (MAGV)
references GIAOVIEN(MAGV)

/*
### **BOMON** table
*/

-- FK_BOMON_GIAOVIEN
-- BOMON(TRUONGBM) --> GIAOVIEN(MAGV)
alter table BOMON
add constraint FK_BOMON_GIAOVIEN
foreign key (TRUONGBM)
references GIAOVIEN(MAGV)
-- FK_BOMON_KHOA
-- BOMON(MAKHOA) --> KHOA(MAKHOA)
alter table BOMON
add constraint FK_BOMON_KHOA
foreign key (MAKHOA)
references KHOA(MAKHOA)

/*
### **KHOA** table
*/

-- FK_KHOA_GIAOVIEN
-- KHOA(TRUONGKHOA) --> GIAOVIEN(MAGV)
alter table KHOA
add constraint FK_KHOA_GIAOVIEN
foreign key (TRUONGKHOA)
references GIAOVIEN(MAGV)

/*
### **NGUOITHAN** table
*/

-- FK_NGUOITHAN_GIAOVIEN
-- NGUOITHAN(MAGV) --> GIAOVIEN(MAGV)
alter table NGUOITHAN
add constraint FK_NGUOITHAN_GIAOVIEN
foreign key (MAGV)
references GIAOVIEN(MAGV)

/*
### **DETAI** table
*/

-- FK_DETAI_CHUDE
-- DETAI(MACD) --> CHUDE(MACD)
alter table DETAI
add constraint FK_DETAI_CHUDE
foreign key (MACD)
references CHUDE(MACD)
-- FK_DETAI_GIAOVIEN
-- DETAI(GVCNDT) --> GIAOVIEN(MAGV)
alter table DETAI
add constraint FK_DETAI_GIAOVIEN
foreign key (GVCNDT)
references GIAOVIEN(MAGV)

/*
### **CONGVIEC** table
*/

-- FK_CONGVIEC_DETAI
-- CONGVIEC(MADT) --> DETAI(MADT)
alter table CONGVIEC
add constraint FK_CONGVIEC_DETAI
foreign key (MADT)
references DETAI(MADT)

/*
### **THAMGIADT** table
*/

-- FK_THAMGIADT_GIAOVIEN
-- THAMGIADT(MAGV) --> GIAOVIEN(MAGV)
alter table THAMGIADT
add constraint FK_THAMGIADT_GIAOVIEN
foreign key (MAGV)
references GIAOVIEN(MAGV)
-- FK_THAMGIADT_CONGVIEC
-- THAMGIADT(MADT, STT) --> CONGVIEC(MADT, SOTT)
alter table THAMGIADT
add constraint FK_THAMGIADT_CONGVIEC
foreign key (MADT, STT) 
references CONGVIEC(MADT, STT)

------------------------------------------C2---------------------------------------------

/*
# Nhap lieu
*/

/*
### **GIAOVIEN**
*/

insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('001', N'Nguyễn Hoài An', 2000.0, N'Nam', '1973-02-15', N'25/3 Lac Long Quân, Q.10, TP HCM')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('002', N'Trần Trà Hương', 2500.0, N'Nữ', '1960-06-20', N'125 Trần Hưng Đạo, Q.1, TP HCM')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('003', N'Nguyễn Ngọc Ánh',2200.0,N'Nữ','1975-05-11', N'12/21 Võ Văn Ngân ,Thủ Đức, TP HCM')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('004',N'Trương Nam Sơn',23000.0,N'Nam','1959-6-20',N'215 Lý Thường Kiệt, TP Biên Hoà')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('005',N'Lý Hoàng Hà',25000.0,N'Nam','1954-10-23',N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('006',N'Trần Bạch Tuyết',1500.0,N'Nữ','1980-05-20',N'127 Hùng Vương, TP Mỹ Tho')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('007',N'Nguyễn An Trung',2100.0,N'Nam','1976-06-05',N'234 3/2, TP Biên Hoà')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('008',N'Trần Trung Hiếu',1800.0,N'Nam','1977-08-06',N'22/11 Lý Thường Kiệt, TP Mỹ Tho')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('009',N'Trần Hoàng Nam',2000.0,N'Nam','1975-11-22',N'234 Trần Não, An Phú, TP HCM')
insert into GIAOVIEN(MaGV, HOTEN, LUONG, PHAI, NGSINH, DIACHI)
values ('010',N'Phạm Nam Thanh',1500.0,N'Nam','1980-12-12',N'221 Hùng Vương, Q.5, TP HCM')

/*
### **KHOA**
*/

insert into KHOA (MAKHOA, TENKHOA, NAMTL, PHONG, DIENTHOAI, TRUONGKHOA, NGAYNHANCHUC)
values ('CNTT',N'Công nghệ thông tin',1995,'B11','0838123456','002','2005-02-20')
insert into KHOA (MAKHOA, TENKHOA, NAMTL, PHONG, DIENTHOAI, TRUONGKHOA, NGAYNHANCHUC)
values ('HH',N'Hoá học',1980,'B41','0838456456','007','2001-10-15')
insert into KHOA (MAKHOA, TENKHOA, NAMTL, PHONG, DIENTHOAI, TRUONGKHOA, NGAYNHANCHUC)
values ('SH',N'Sinh học',1980,'B31','0838454454','004','2000-10-11')
insert into KHOA (MAKHOA, TENKHOA, NAMTL, PHONG, DIENTHOAI, TRUONGKHOA, NGAYNHANCHUC)
values ('VL',N'Vật lý',1976,'B21','0838223223','005','2003-09-18')


/*
### **BOMON**
*/

insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('CNTT',N'Công nghệ tri thức','B15','0838126126',NULL,'CNTT',NULL)
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('HHC',N'Hoá hữu cơ','B44','838222222',NULL,'HH',NULL)
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('HL',N'Hoá lý','B42','0838878787',NULL,'HH',NULL)
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('HPT',N'Hoá phân tích','B43','0838777777','007','HH','2007-10-15')
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('HTTT',N'Hệ thống thông tin','B13','0838125125','002','CNTT','2004-09-20')
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('MMT',N'Mạng máy tính','B16','0838676767','001','CNTT','2005-05-15')
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('SH',N'Sinh hoá','B33','0838898989',NULL,'SH',NULL)
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('VLĐT',N'Vật lý điện tử','B23','0838234234',NULL,'VL',NULL)
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('VLƯD',N'Vật lý ứng dụng','B24','0838454545','005','VL','2006-02-18')
insert into BOMON(MABM, TENBM, PHONG, DIENTHOAI, TRUONGBM, MAKHOA, NGAYNHANCHUC)
values ('VS',N'Vi sinh','B32','0838909090','004','SH','2007-01-01')

/*
### **GV_DT**
*/

insert into  GV_DT(MAGV, DIENTHOAI)
values ('001','0838912112')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '001','0903123123')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '002','0913454545')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '003','0838121212')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '003','0903656565')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '003','0937125125')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '006','0937888888')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '008','0653717171')
insert into  GV_DT(MAGV, DIENTHOAI)
values ( '008','0913232323')

/*
### **NGUOITHAN**
*/

insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('001',N'Hùng','1990-01-14',N'Nam')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('001',N'Thuỷ','1998-09-03',N'Nữ')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('003',N'Hà','1998-09-03',N'Nữ')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('003',N'Thu','1998-09-03',N'Nữ')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('007',N'Mai','2003-03-26',N'Nữ')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('007',N'Vy','2000-02-14',N'Nữ')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('008',N'Nam','1991-05-06',N'Nam')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('009',N'An','1996-08-19',N'Nam')
insert into NGUOITHAN(MAGV, TEN, NGSINH, PHAI)
values ('010',N'Nguyệt','2006-01-14',N'Nữ')

/*
### **CHUDE**
*/

insert into CHUDE(MACD,TENCD)
values ('NCPT',N'Nghiên cứu phát triển')
insert into CHUDE(MACD,TENCD)
values ('QLGD',N'Quản lý giáo dục')
insert into CHUDE(MACD,TENCD)
values ('UDCN',N'Ứng dụng công nghệ')

/*
### **DETAI**
*/

insert into DETAI(MADT,TENDT,CAPQL,KINHPHI,NGAYBD,NGAYKT,GVCNDT, MACD)
values ('001',N'HTTT quản lý các trường ĐH',N'ĐHQG',20.0 ,'2007-10-20','2008-10-20','002','QLGD')
insert into DETAI(MADT,TENDT,CAPQL,KINHPHI,NGAYBD,NGAYKT,GVCNDT, MACD)
values ('002',N'HTTT quản lý giáo vụ cho một khoa',N'Trường', 20.0,'2000-10-12','2001-10-12','002','QLGD')
insert into DETAI(MADT,TENDT,CAPQL,KINHPHI,NGAYBD,NGAYKT,GVCNDT, MACD)
values ('003',N'Nghiên cứu chế tạo sợi Nanô Platin',N'ĐHQG', 300.0,'2008-05-15','2010-05-15','005','NCPT')
insert into DETAI(MADT,TENDT,CAPQL,KINHPHI,NGAYBD,NGAYKT,GVCNDT, MACD)
values ('004',N'Tạo vật liệu sinh học bằng mảng ối người',N'Nhà nước',100.0 ,'2007-01-01','2009-12-31','004','NCPT')
insert into DETAI(MADT,TENDT,CAPQL,KINHPHI,NGAYBD,NGAYKT,GVCNDT, MACD)
values ('005',N'Ứng dụng hoá học xanh',N'Trường',200.0 ,'2003-10-10','2004-12-10','007','UDCN')
insert into DETAI(MADT,TENDT,CAPQL,KINHPHI,NGAYBD,NGAYKT,GVCNDT, MACD)
values ('006',N'Nghiên cứu tế bào gốc',N'Nhà nước',4000.0 ,'2006-10-20','2009-10-20','004','NCPT')
insert into DETAI(MADT,TENDT,CAPQL,KINHPHI,NGAYBD,NGAYKT,GVCNDT, MACD)
values ('007',N'HTTT quản lý thư viện ở các trường ĐH',N'Trường', 20.0,'2009-05-10','2010-05-10','001','QLGD')

/*
### **CONGVIEC**
*/

insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('001',1,N'Khởi tạo và lập kế hoạch','2007-10-20','2008-12-20')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('001',2,N'Xác định yêu cầu','2008-12-21','2008-03-21')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('001',3,N'Phân tích hệ thống','2008-03-23','2008-05-22')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('001',4,N'Thiết kế hệ thống','2008-05-23','2008-06-23')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('001',5,N'Cài đặt thử nghiệm','2008-06-24','2008-10-20')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('002',1,N'Khởi tạo và lập kế hoạch','2009-05-10','2009-10-11')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('002',2,N'Xác định yêu cầu','2009-07-11','2009-12-20')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('002',3,N'Phân tích hệ thống','2009-12-21','2009-12-20')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('002',4,N'Thiết kế hệ thống','2009-12-21','2010-03-22')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('002',5,N'Cài đặt thử nghiệm','2010-03-23','2010-05-10')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('006',1,N'Lấy mẫu','2006-10-20','2007-02-20')
insert into CONGVIEC(MADT,STT,TENCV,NGAYBD,NGAYKT)
values ('006',2,N'Nuôi cấy','2007-01-21','2008-08-21')

/*
### **THAMGIADT**
*/

insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('001','002',1,0.0 ,NULL)
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('001','002', 2, 2.0,NULL)
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('002','001',4 ,2.0 ,N'Đạt')
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('003','001',1 , 1.0,N'Đạt')
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('003','001', 2, 0.0,N'Đạt')
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('003','001', 4, 1.0,N'Đạt')
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('003','002', 2, 0.0,NULL)
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('004','006', 1, 0.0,N'Đạt')
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('004','006',2 ,1.0 ,N'Đạt')
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('006','006', 2, 1.5,N'Đạt')
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('009','002',3 , 0.5,NULL)
insert into THAMGIADT(MAGV,MADT,STT,PHUCAP,KETQUA)
values ('009','002', 4, 1.5,NULL)

/*
# Cap nhap du lieu khoa ngoai
*/

/*
### Bang **GIAOVIEN**
*/

update GIAOVIEN
set MABM = 'MMT'
where MAGV in ('001', '009')

update GIAOVIEN
set MABM = 'HTTT'
where MAGV in ('002', '003')

update GIAOVIEN
set MABM = 'VS'
where MAGV in ('004', '006')

update GIAOVIEN
set MABM = 'VLĐT'
where MAGV in ('005')

update GIAOVIEN
set MABM = 'HPT'
where MAGV in ('007', '008', '010')

update GIAOVIEN
set GVQLCM = '002'
where MAGV in ('003')

update GIAOVIEN
set GVQLCM = '004'
where MAGV in ('006')

update GIAOVIEN
set GVQLCM = '007'
where MAGV in ('008', '010')

update GIAOVIEN
set GVQLCM = '001'
where MAGV in ('009')

select* from GIAOVIEN
select* from BOMON
select* from KHOA
select* from GV_DT
select* from CHUDE
select* from DETAI
select* from CONGVIEC
select* from NGUOITHAN
select* from THAMGIADT
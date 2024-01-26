-- use master
-- go
-- drop database QLPhongKhamNhaKhoa
-- go
create database QLPhongKhamNhaKhoa
go 

use QLPhongKhamNhaKhoa
go
-- QuanTriVien(MaQTV, TenQTV, NgaySinh, GioiTinh, DiaChi, SĐT, TaiKhoan, MatKhau)
-- Foreign Key:
create table QuanTriVien(
    MaQTV int primary key,
    TenQTV nvarchar(50) not null,
    NgaySinh date,
    GioiTinh nvarchar(5),
    DiaChi nvarchar(100),
    SDT varchar(15),
    TaiKhoan varchar(20) unique,
    MatKhau varchar(20)
)
-- NhanVien(MaNV, TenNV, NgaySinh, GioiTinh, DiaChi, SĐT, TaiKhoan, MatKhau, ViTri)
-- Foreign Key:
create table NhanVien(
    MaNV int primary key,
    TenNV nvarchar(50) not null,
    NgaySinh date,
    GioiTinh nvarchar(5),
    DiaChi nvarchar(100),
    SDT varchar(15),
    TaiKhoan varchar(20) unique,
    MatKhau varchar(20),
    ViTri nvarchar(30)
)
-- NhaSi(MaNhaSi, TenNhaSi, NgaySinh, GioiTinh, DiaChi, SĐT, TaiKhoan, MatKhau, HocVan)
-- Foreign Key:
create table NhaSi(
    MaNhaSi int primary key,
    TenNhaSi nvarchar(50) not null,
    NgaySinh date,
    GioiTinh nvarchar(5),
    DiaChi nvarchar(100),
    SDT varchar(15),
    TaiKhoan varchar(20) unique,
    MatKhau varchar(20),
    HocVan nvarchar(30)
)
-- ChiNhanh(MaChiNhanh,TenChiNhanh, DiaChi, SDT)
-- Foreign Key:
create table ChiNhanh(
    MaChiNhanh int primary key,
    TenChiNhanh nvarchar(50),
    DiaChi nvarchar(100),
    SDT char(15)
)
-- -- CaLamViec(Ngay, GioBatDau, GioKetThuc)
-- Foreign Key:(MaChiNhanh)
create table CaLamViec(
    Ngay nvarchar(10),
    GioBatDau time,
    GioKetThuc time,
    MaChiNhanh int,
    primary key(Ngay, GioBatDau, GioKetThuc,MaChiNhanh)
)
-- FK_CaLamViec: CaLamViec(MaChiNhanh) --> ChiNhanh(MaChiNhanh)
alter table CaLamViec add constraint FK_CaLamViec_ChiNhanh foreign key(MaChiNhanh) references ChiNhanh(MaChiNhanh)
-- ChiTietCaLamViec(MaNhaSi, Ngay, GioBatDau, GioKetThuc,MaChiNhanh)
-- Foreign Key: (MaNhaSi), (Ngay, GioBatDau, GioKetThuc,MaChiNhanh)
create table ChiTietCaLamViec(
    MaNhaSi int,
    Ngay nvarchar(10),
    GioBatDau time,
    GioKetThuc time,
    MaChiNhanh int
    primary key(MaNhaSi, Ngay, GioBatDau, GioKetThuc,MaChiNhanh)
)
-- FK_ChiTietCaLamViec_NhaSi: ChiTietCaLamViec(MaNhaSi) --> NhaSi(MaNhaSi)
alter table ChiTietCaLamViec add constraint FK_ChiTietCaLamViec_NhaSi foreign key(MaNhaSi) references NhaSi(MaNhaSi)
-- FK_ChiTietCaLamViec_CaLamViec: ChiTietCaLamViec(Ngay, GioBatDau, GioKetThuc,MaChiNhanh) --> CaLamViec(Ngay, GioBatDau, GioKetThuc,MaChiNhanh)
alter table ChiTietCaLamViec add constraint FK_ChiTietCaLamViec_CaLamViec foreign key(Ngay, GioBatDau, GioKetThuc,MaChiNhanh) references CaLamViec(Ngay, GioBatDau, GioKetThuc,MaChiNhanh)

-- BenhNhan(MaBenhNhan, TenBenhNhan, GioiTinh, DiaChi, SDT, NamSinh, TinhTrangDiUng)
-- -- Foreign Key:
create table BenhNhan(
    MaBenhNhan int primary key,
    TenBenhNhan nvarchar(50) not null,
    GioiTinh nvarchar(5),
    DiaChi nvarchar(100),
    SDT varchar(15),
    NamSinh date,
    TinhTrangDiUng nvarchar(100)
)
-- Thuoc(MaThuoc, TenThuoc, TonKho, DonVi, HSD, DonGia)
-- Foreign Key:
create table Thuoc(
    MaThuoc int primary key,
    TenThuoc nvarchar(50) not null,
    TonKho int,
    DonVi nvarchar(15),
    HSD date not null,
    DonGia int
)
-- ChongChiDinh(MaBenhNhan, MaThuoc, GhiChu)
-- Foreign Key: (MaBenhNhan), (MaThuoc)

create table ChongChiDinh(
    MaBenhNhan int,
    MaThuoc int,
    GhiChu nvarchar(200),
    primary key(MaBenhNhan, MaThuoc)
)

-- FK_ChongChiDinh_BenhNhan: ChongChiDinh(MaBenhNhan) --> BenhNhan(MaBenhNhan)
alter table ChongChiDinh add constraint FK_ChongChiDinh_BenhNhan foreign key(MaBenhNhan) references BenhNhan(MaBenhNhan)
-- FK_ChongChiDinh_Thuoc: ChongChiDinh(MaThuoc) --> Thuoc(MaThuoc)
alter table ChongChiDinh add constraint FK_ChongChiDinh_Thuoc foreign key(MaThuoc) references Thuoc(MaThuoc)

-- BenhAn(MaBenhNhan, MaBenhAn, TinhTrangRang, TongTienDieuTri, TongTienThanhToan)
-- Foreign Key: (MaBenhNhan)
create table BenhAn(
    MaBenhNhan int, 
    MaBenhAn int,
    TinhTrangRang nvarchar(100),
    TongTienDieuTri int,
    TongTienThanhToan int,
    primary key(MaBenhNhan, MaBenhAn)
)
-- FK_BenhAn_BenhNhan: BenhAn(MaBenhNhan) --> BenhNhan(MaBenhNhan)
alter table BenhAn add constraint FK_BenhAn_BenhNhan foreign key(MaBenhNhan) references BenhNhan(MaBenhNhan)

-- HoaDon(MaHoaDon, NgayGiaoDich, LoaiThanhToan, TienTra, TienThoi, GhiChu)
-- Foreign Key:
create table HoaDon(
    MaHoaDon int primary key,
    NgayGiaoDich date,
    LoaiThanhToan nvarchar(30),
    TienTra int,
    TienThoi int,
    GhiChu nvarchar(50)
)
-- DonThuoc(MaDonThuoc, NgayLap, GhiChu, TongGia, MaBenhAn, MaBenhNhan, MaHoaDon)
-- Foreign Key: (MaBenhNhan, MaBenhAn), (MaHoaDon)
create table DonThuoc(
    MaDonThuoc int primary key,
    NgayLap date,
    GhiChu nvarchar(100),
    TongGia int,
    MaBenhAn int,
    MaBenhNhan int,
    MaHoaDon int,
)
-- FK_DonThuoc_BenhAn: DonThuoc(MaBenhNhan, MaBenhAn) --> BenhAn(MaBenhNhan, MaBenhAn)
alter table DonThuoc add constraint FK_DonThuoc_BenhAn foreign key(MaBenhNhan, MaBenhAn) references BenhAn(MaBenhNhan, MaBenhAn)
-- FK_DonThuoc_HoaDon: DonThuoc(MaHoaDon) --> HoaDon(MaHoaDon)
alter table DonThuoc add constraint FK_DonThuoc_HoaDon foreign key(MaHoaDon) references HoaDon(MaHoaDon)

-- ChiTietDonThuoc(MaDonThuoc, MaThuoc, LieuLuong)
-- Foreign Key: (MaDonThuoc), (MaThuoc)
create table ChiTietDonThuoc(
    MaDonThuoc int,
    MaThuoc int,
    LieuLuong int,
    primary key(MaDonThuoc, MaThuoc)
)
-- FK_ChiTietDonThuoc_DonThuoc: ChiTietDonThuoc(MaDonThuoc) --> DonThuoc(MaDonThuoc)
alter table ChiTietDonThuoc add constraint FK_ChiTietDonThuoc_DonThuoc foreign key(MaDonThuoc) references DonThuoc(MaDonThuoc)
-- FK_ChiTietDonThuoc_Thuoc: ChiTietDonThuoc(MaThuoc) --> Thuoc(MaThuoc)
alter table ChiTietDonThuoc add constraint FK_ChiTietDonThuoc_Thuoc foreign key(MaThuoc) references Thuoc(MaThuoc)
-- LichHen(MaLichHen, NgayGioHen, Phong, TinhTrang, GhiChu, ThoiGianYeuCau, NhaSiKham, TroKham, MaBenhNhan, MaChiNhanh)
-- Foreign Key: (NhaSiKham), (TroKham), (MaBenhNhan), (MaChiNhanh)
create table LichHen(
    MaLichHen int primary key,
    NgayGioHen datetime,
    Phong nvarchar(30),
    LoaiLichHen nvarchar(20) ,
    GhiChu nvarchar(50),
    ThoiGianYeuCau datetime,
    TinhTrang nvarchar(20),
    NhaSiKham int,
    TroKham int,
    MaBenhNhan int,
    MaChiNhanh int,
)
-- FK_LichHen_NhaSi: LichHen(NhaSiKham) --> NhaSi(MaNhaSi)
alter table LichHen add constraint FK_LichHen_NhaSi foreign key(NhaSiKham) references NhaSi(MaNhaSi)
-- FK_LichHen_TroKham: LichHen(TroKham) --> NhaSi(MaNhaSi)
alter table LichHen add constraint FK_LichHen_TroKham foreign key(TroKham) references NhaSi(MaNhaSi)
-- FK_LichHen_BenhNhan: LichHen(MaBenhNhan) --> BenhNhan(MaBenhNhan)
alter table LichHen add constraint FK_LichHen_BenhNhan foreign key(MaBenhNhan) references BenhNhan(MaBenhNhan)
-- FK_LichHen_PhongKham: LichHen(MaChiNhanh) --> ChiNhanh(MaChiNhanh)
alter table LichHen add constraint FK_LichHen_ChiNhanh foreign key(MaChiNhanh) references ChiNhanh(MaChiNhanh)

-- DanhMucDieuTri(MaDieuTri, LoaiDieuTri, PhuongPhap, DonVi, DonGia, ThoiGianBaoHanh)
-- Foreign Key:

create table DanhMucDieuTri(
    MaDieuTri int primary key,
    LoaiDieuTri nvarchar(100),
    PhuongPhap nvarchar(100),
    DonVi nvarchar(15),
    DonGia int,
    ThoiGianBaoHanh nvarchar(20)
)

-- KeHoachDieuTri(MaKeHoach, MoTa, TinhTrang, TongTien, MaDieuTri, MaLichHen, MaHoaDon, MaBenhAn, MaBenhNhan)
-- Foreign Key: (MaDieuTri), (MaLichHen), (MaHoaDon), (MaBenhNhan, MaBenhAn)
create table KeHoachDieuTri(
    MaKeHoach int primary key,
    MoTa nvarchar(100),
    TinhTrang nvarchar(50),
    TongTien int,
    MaDieuTri int,
    MaLichHen int,
    MaHoaDon int,
    MaBenhAn int,
    MaBenhNhan int
)
-- FK_KeHoachDieuTri_DanhMucDieuTri: KeHoachDieuTri(MaDieuTri) --> DanhMucDieuTri(MaDieuTri)
alter table KeHoachDieuTri add constraint FK_KeHoachDieuTri_DanhMucDieuTri foreign key(MaDieuTri) references DanhMucDieuTri(MaDieuTri)
-- FK_KeHoachDieuTri_LichHen: KeHoachDieuTri(MaLichHen) --> LichHen(MaLichHen)
alter table KeHoachDieuTri add constraint FK_KeHoachDieuTri_LichHen foreign key(MaLichHen) references LichHen(MaLichHen)
-- FK_KeHoachDieuTri_HoaDon: KeHoachDieuTri(MaHoaDon) --> HoaDon(MaHoaDon)
alter table KeHoachDieuTri add constraint FK_KeHoachDieuTri_HoaDon foreign key(MaHoaDon) references HoaDon(MaHoaDon)
-- FK_KeHoachDieuTri_BenhAn: KeHoachDieuTri(MaBenhNhan, MaBenhAn) --> BenhAn(MaBenhNhan, MaBenhAm)
alter table KeHoachDieuTri add constraint FK_KeHoachDieuTri_BenhAn foreign key(MaBenhNhan, MaBenhAn) references BenhAn(MaBenhNhan, MaBenhAn)

-- Rang(SoRang, TenRang, MoTa)
-- Foreign Key:
create table Rang(
    SoRang int primary key,
    TenRang nvarchar(50),
    MoTa nvarchar(100)
)


-- MatRang(MatRang, ChiTiet)
-- Foreign Key:
create table MatRang(
    MatRang char(5) primary key,
    ChiTiet nvarchar(200)
)

-- ChiTietKeHoach(MaKeHoach, SoThuTu, SoRang, MatRang)
-- Foreign Key: (MaKeHoach), (SoRang), (MatRang)
create table ChiTietKeHoach(
    MaKeHoach int,
    SoThuTu int,
    SoRang int,
    MatRang char(5),
    primary key(MaKeHoach, SoThuTu)
)
-- FK_ChiTietKeHoach_KeHoachDieuTri: ChiTietKeHoach(MaKeHoach) --> KeHoachDieuTri(MaKeHoach)
alter table ChiTietKeHoach add constraint FK_ChiTietKeHoach_KeHoachDieuTri foreign key(MaKeHoach) references KeHoachDieuTri(MaKeHoach)
-- FK_ChiTietKeHoach_Rang: ChiTietKeHoach(SoRang) --> Rang(SoRang)
alter table ChiTietKeHoach add constraint FK_ChiTietKeHoach_Rang foreign key(SoRang) references Rang(SoRang)
-- FK_ChiTietKeHoach_MatRang: ChiTietKeHoach(MatRang) --> MatRang(MatRang)
alter table ChiTietKeHoach add constraint FK_ChiTietKeHoach_MatRang foreign key(MatRang) references MatRang(MatRang)





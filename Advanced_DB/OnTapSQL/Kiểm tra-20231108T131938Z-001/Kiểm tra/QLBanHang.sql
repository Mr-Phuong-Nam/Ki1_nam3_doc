IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CUNG_UNG_MAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CUNG_UNG]'))
ALTER TABLE [dbo].[CUNG_UNG] DROP CONSTRAINT [FK_CUNG_UNG_MAT_HANG]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CUNG_UNG_NHA_CUNG_CAP]') AND parent_object_id = OBJECT_ID(N'[dbo].[CUNG_UNG]'))
ALTER TABLE [dbo].[CUNG_UNG] DROP CONSTRAINT [FK_CUNG_UNG_NHA_CUNG_CAP]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_GIAO_HANG_GIAO_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_GIAO_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_GIAO_HANG] DROP CONSTRAINT [FK_CHI_TIET_GIAO_HANG_GIAO_HANG]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_GIAO_HANG_MAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_GIAO_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_GIAO_HANG] DROP CONSTRAINT [FK_CHI_TIET_GIAO_HANG_MAT_HANG]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_DAT_HANG_DAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_DAT_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_DAT_HANG] DROP CONSTRAINT [FK_CHI_TIET_DAT_HANG_DAT_HANG]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_DAT_HANG_MAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_DAT_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_DAT_HANG] DROP CONSTRAINT [FK_CHI_TIET_DAT_HANG_MAT_HANG]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GIAO_HANG_DAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[GIAO_HANG]'))
ALTER TABLE [dbo].[GIAO_HANG] DROP CONSTRAINT [FK_GIAO_HANG_DAT_HANG]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DAT_HANG_NHA_CUNG_CAP]') AND parent_object_id = OBJECT_ID(N'[dbo].[DAT_HANG]'))
ALTER TABLE [dbo].[DAT_HANG] DROP CONSTRAINT [FK_DAT_HANG_NHA_CUNG_CAP]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CUNG_UNG]') AND type in (N'U'))
DROP TABLE [dbo].[CUNG_UNG]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CHI_TIET_GIAO_HANG]') AND type in (N'U'))
DROP TABLE [dbo].[CHI_TIET_GIAO_HANG]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CHI_TIET_DAT_HANG]') AND type in (N'U'))
DROP TABLE [dbo].[CHI_TIET_DAT_HANG]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NHA_CUNG_CAP]') AND type in (N'U'))
DROP TABLE [dbo].[NHA_CUNG_CAP]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAT_HANG]') AND type in (N'U'))
DROP TABLE [dbo].[MAT_HANG]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GIAO_HANG]') AND type in (N'U'))
DROP TABLE [dbo].[GIAO_HANG]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DAT_HANG]') AND type in (N'U'))
DROP TABLE [dbo].[DAT_HANG]

create database QLBANHANG_1
GO
USE QLBANHANG_1
go
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MAT_HANG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MAT_HANG](
	[Ma] [char](6) NOT NULL,
	[Ten] [nvarchar](50) NULL,
	[DonViTinh] [nvarchar](50) NULL,
	[QuiCach] [nvarchar](50) NULL,
	[SoLuongTon] [int] NULL,
 CONSTRAINT [PK_MAT_HANG] PRIMARY KEY CLUSTERED 
(
	[Ma] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NHA_CUNG_CAP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[NHA_CUNG_CAP](
	[Ma] [char](6) NOT NULL,
	[Ten] [nvarchar](50) NULL,
	[DiaChi] [nvarchar](50) NULL,
	[DienThoai] [varchar](15) NULL,
 CONSTRAINT [PK_NHA_CUNG_CAP] PRIMARY KEY CLUSTERED 
(
	[Ma] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CHI_TIET_GIAO_HANG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CHI_TIET_GIAO_HANG](
	[SoGiaoHang] [char](6) NOT NULL,
	[MaMatHang] [char](6) NOT NULL,
	[SoLuongGiao] [int] NULL,
 CONSTRAINT [PK_CHI_TIET_GIAO_HANG] PRIMARY KEY CLUSTERED 
(
	[SoGiaoHang] ASC,
	[MaMatHang] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CUNG_UNG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CUNG_UNG](
	[MaNhaCungCap] [char](6) NOT NULL,
	[MaMatHang] [char](6) NOT NULL,
 CONSTRAINT [PK_CUNG_UNG] PRIMARY KEY CLUSTERED 
(
	[MaNhaCungCap] ASC,
	[MaMatHang] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CHI_TIET_DAT_HANG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CHI_TIET_DAT_HANG](
	[SoDatHang] [char](6) NOT NULL,
	[MaMatHang] [char](6) NOT NULL,
	[SoLuongDat] [int] NULL,
	[DonGiaDat] [decimal](10, 2) NULL,
 CONSTRAINT [PK_CHI_TIET_DAT_HANG] PRIMARY KEY CLUSTERED 
(
	[SoDatHang] ASC,
	[MaMatHang] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GIAO_HANG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GIAO_HANG](
	[So] [char](6) NOT NULL,
	[Ngay] [datetime] NULL,
	[SoDatHang] [char](6) NULL,
 CONSTRAINT [PK_GIAO_HANG] PRIMARY KEY CLUSTERED 
(
	[So] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DAT_HANG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[DAT_HANG](
	[So] [char](6) NOT NULL,
	[Ngay] [datetime] NULL,
	[MaNhaCungCap] [char](6) NULL,
	[GhiChu] [nvarchar](50) NULL,
	[SoMatHang] [int] NULL,
	[ThanhTien] [decimal](10, 2) NULL,
 CONSTRAINT [PK_DAT_HANG] PRIMARY KEY CLUSTERED 
(
	[So] ASC
)WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_GIAO_HANG_GIAO_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_GIAO_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_GIAO_HANG]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_GIAO_HANG_GIAO_HANG] FOREIGN KEY([SoGiaoHang])
REFERENCES [dbo].[GIAO_HANG] ([So])
GO
ALTER TABLE [dbo].[CHI_TIET_GIAO_HANG] CHECK CONSTRAINT [FK_CHI_TIET_GIAO_HANG_GIAO_HANG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_GIAO_HANG_MAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_GIAO_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_GIAO_HANG]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_GIAO_HANG_MAT_HANG] FOREIGN KEY([MaMatHang])
REFERENCES [dbo].[MAT_HANG] ([Ma])
GO
ALTER TABLE [dbo].[CHI_TIET_GIAO_HANG] CHECK CONSTRAINT [FK_CHI_TIET_GIAO_HANG_MAT_HANG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CUNG_UNG_MAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CUNG_UNG]'))
ALTER TABLE [dbo].[CUNG_UNG]  WITH CHECK ADD  CONSTRAINT [FK_CUNG_UNG_MAT_HANG] FOREIGN KEY([MaMatHang])
REFERENCES [dbo].[MAT_HANG] ([Ma])
GO
ALTER TABLE [dbo].[CUNG_UNG] CHECK CONSTRAINT [FK_CUNG_UNG_MAT_HANG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CUNG_UNG_NHA_CUNG_CAP]') AND parent_object_id = OBJECT_ID(N'[dbo].[CUNG_UNG]'))
ALTER TABLE [dbo].[CUNG_UNG]  WITH CHECK ADD  CONSTRAINT [FK_CUNG_UNG_NHA_CUNG_CAP] FOREIGN KEY([MaNhaCungCap])
REFERENCES [dbo].[NHA_CUNG_CAP] ([Ma])
GO
ALTER TABLE [dbo].[CUNG_UNG] CHECK CONSTRAINT [FK_CUNG_UNG_NHA_CUNG_CAP]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_DAT_HANG_DAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_DAT_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_DAT_HANG]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_DAT_HANG_DAT_HANG] FOREIGN KEY([SoDatHang])
REFERENCES [dbo].[DAT_HANG] ([So])
GO
ALTER TABLE [dbo].[CHI_TIET_DAT_HANG] CHECK CONSTRAINT [FK_CHI_TIET_DAT_HANG_DAT_HANG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CHI_TIET_DAT_HANG_MAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[CHI_TIET_DAT_HANG]'))
ALTER TABLE [dbo].[CHI_TIET_DAT_HANG]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_DAT_HANG_MAT_HANG] FOREIGN KEY([MaMatHang])
REFERENCES [dbo].[MAT_HANG] ([Ma])
GO
ALTER TABLE [dbo].[CHI_TIET_DAT_HANG] CHECK CONSTRAINT [FK_CHI_TIET_DAT_HANG_MAT_HANG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_GIAO_HANG_DAT_HANG]') AND parent_object_id = OBJECT_ID(N'[dbo].[GIAO_HANG]'))
ALTER TABLE [dbo].[GIAO_HANG]  WITH CHECK ADD  CONSTRAINT [FK_GIAO_HANG_DAT_HANG] FOREIGN KEY([SoDatHang])
REFERENCES [dbo].[DAT_HANG] ([So])
GO
ALTER TABLE [dbo].[GIAO_HANG] CHECK CONSTRAINT [FK_GIAO_HANG_DAT_HANG]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_DAT_HANG_NHA_CUNG_CAP]') AND parent_object_id = OBJECT_ID(N'[dbo].[DAT_HANG]'))
ALTER TABLE [dbo].[DAT_HANG]  WITH CHECK ADD  CONSTRAINT [FK_DAT_HANG_NHA_CUNG_CAP] FOREIGN KEY([MaNhaCungCap])
REFERENCES [dbo].[NHA_CUNG_CAP] ([Ma])
GO
ALTER TABLE [dbo].[DAT_HANG] CHECK CONSTRAINT [FK_DAT_HANG_NHA_CUNG_CAP]



insert into nha_cung_cap(ma, ten, diachi, dienthoai)
values ('NCC001', N'Tổng công ty xi măng A1', N'59/2 Quốc lộ 1A','(08)38123456')
insert into nha_cung_cap(ma, ten, diachi, dienthoai)
values ('NCC002', N'Xí nghiệp may M2', N'13/2 Nguyễn Trọng Tuyển', '(08)38123456')

insert into mat_hang(ma, ten, donvitinh, quicach, soluongton)
values ('MH0001', N'Áo thể thao', N'Cái', N'Đóng bao', 100)
insert into mat_hang(ma, ten, donvitinh, quicach, soluongton)
values ('MH0002', N'Quần thể thao', N'Cái', N'Đóng bao', 100)
insert into mat_hang(ma, ten, donvitinh, quicach, soluongton)
values ('MH0003', N'Xi măng', N'Bao', N'Đóng bao', 100)
insert into mat_hang(ma, ten, donvitinh, quicach, soluongton)
values ('MH0004', N'Xi măng trắng', N'Bao', N'Đóng bao', 100)

insert into cung_ung(manhacungcap, MaMatHang)
values ('NCC001', 'MH0001')
insert into cung_ung(manhacungcap, MaMatHang)
values ('NCC001', 'MH0002')
insert into cung_ung(manhacungcap, MaMatHang)
values ('NCC002', 'MH0003')
insert into cung_ung(manhacungcap, MaMatHang)
values ('NCC002', 'MH0004')

insert into dat_hang(so, ngay, MaNhaCungCap, ghichu, SoMatHang, thanhtien)
values ('DH0001', '2010/01/02', 'NCC002', N'Giao tận nhà', 10, 900000)
insert into dat_hang(so, ngay, MaNhaCungCap, ghichu, SoMatHang, thanhtien)
values ('DH0002', '2010/04/05', 'NCC001', N'Giao tận nhà', 5, 100000)
insert into dat_hang(so, ngay, MaNhaCungCap, ghichu, SoMatHang, thanhtien)
values ('DH0003', '2010/01/12', 'NCC001', NULL, 5, 1500000)

insert into chi_tiet_dat_hang(SoDatHang, MaMatHang, soluongdat, DonGiaDat)
values ('DH0001', 'MH0001', 5, 100000)
insert into chi_tiet_dat_hang(SoDatHang, MaMatHang, soluongdat, DonGiaDat)
values ('DH0001', 'MH0002', 5, 80000)
insert into chi_tiet_dat_hang(SoDatHang, MaMatHang, soluongdat, DonGiaDat)
values ('DH0002', 'MH0003', 5, 200000)
insert into chi_tiet_dat_hang(SoDatHang, MaMatHang, soluongdat, DonGiaDat)
values ('DH0003', 'MH0004', 5, 300000)

insert into giao_hang(so, ngay, SoDatHang)
values ('GH0001', '2010/01/05', 'DH0001')
insert into giao_hang(so, ngay, SoDatHang)
values ('GH0002', '2010/04/01', 'DH0002')

insert into chi_tiet_giao_hang(sogiaohang, MaMatHang, soluonggiao)
values ('GH0001', 'MH0001', 5)
insert into chi_tiet_giao_hang(sogiaohang, MaMatHang, soluonggiao)
values ('GH0001', 'MH0002', 5)
insert into chi_tiet_giao_hang(sogiaohang, MaMatHang, soluonggiao)
values ('GH0002', 'MH0003', 5)
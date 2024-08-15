use QLGiaoVienThamGiaDeTai;
go

--Q27
select count(*) as N'Số GV', sum(LUONG) as N'Tổng lương'
from GIAOVIEN;

--Q28
SELECT MABM, COUNT(*) as N'Số GV', AVG(LUONG) as N'Lương trung bình'
FROM GIAOVIEN GROUP BY MABM;

--Q29
SELECT CD.TENCD AS N'Chủ đề', COUNT(DT.MACD) AS N'Số Đề tài'
FROM CHUDE CD JOIN DETAI DT on CD.MACD = DT.MACD
group by CD.TENCD;


--Q30
SELECT GV.HOTEN AS N'Giáo viên', COUNT(DISTINCT MADT) AS N'Số đề tài'
FROM THAMGIADT TG JOIN GIAOVIEN GV on TG.MAGV = GV.MAGV
GROUP BY GV.HOTEN;

--Q31
SELECT GV.HOTEN AS N'Giáo viên', COUNT(DISTINCT DT.MADT) AS N'Số lượng đề tài'
FROM DETAI DT join GIAOVIEN GV on DT.GVCNDT = GV.MAGV
GROUP BY GV.HOTEN;

--Q32
SELECT GV.HOTEN AS GIAOVIEN , COUNT(NT.MAGV) AS N'Số người thân'
FROM NGUOITHAN NT join GIAOVIEN GV on NT.MAGV = GV.MAGV
GROUP BY GV.HOTEN;

--Q33
SELECT GV.HOTEN as N'Giáo viên' , COUNT(DISTINCT DT.MADT) AS N'Số lượng đề tài'
FROM DETAI DT join GIAOVIEN GV on DT.GVCNDT = GV.MAGV
GROUP BY GV.HOTEN
HAVING COUNT(DISTINCT DT.MADT) >=3;
--VÌ KHÔNG CÓ AI NÊN EM XIN TEST THÊM CÓ 2 ĐTÀI TRỞ LÊN
SELECT GV.HOTEN as N'Giáo viên', COUNT(DISTINCT DT.MADT) AS N'Số lượng đề tài'
FROM DETAI DT join GIAOVIEN GV on DT.GVCNDT = GV.MAGV
GROUP BY GV.HOTEN
HAVING COUNT(DISTINCT DT.MADT) >=2;

--Q34
SELECT DT.TENDT as N'Tên đề tài', COUNT(DISTINCT TG.MAGV) AS N'Số GV tham gia'
FROM THAMGIADT TG JOIN DETAI DT ON TG.MADT = DT.MADT
WHERE DT.TENDT = N'Ứng dụng hóa học xanh'
GROUP BY DT.TENDT ;
-- vì không có ai tham gia đề tài Ứng dụng hóa học xanh nên em xin phép test bằng đề tài "HTTT quản lý giáo vụ cho một Khoa"
SELECT DT.TENDT, COUNT(DISTINCT TG.MAGV) AS N'Số GV tham gia'
FROM THAMGIADT TG JOIN DETAI DT ON TG.MADT = DT.MADT
WHERE DT.TENDT = N'HTTT quản lý giáo vụ cho một Khoa'
GROUP BY DT.TENDT ;

---------- PRACTISE 
-- Đề 31
CREATE DATABASE HieuSach;
GO

USE HieuSach;
GO

CREATE TABLE KHACHHANG (
	MaLoai CHAR(10),
	STT INT,
	primary key (MaLoai, STT),
	HoTen NCHAR(100),
	DiaChi NCHAR(100)
)

CREATE TABLE SACH (
	MaSach char(10) primary key,
	TenSach nchar(100),
	SoLuong int,
	DonGia decimal (18,2),
	MaLoai char(10),
	KHTieuBieu int,
	foreign key (MaLoai, KHTieuBieu) references KHACHHANG(MaLoai, STT)
)

create table MUAHANG (
	LoaiKH char(10),
	SoTT int,
	MaSach char(10),
	NgayMua date,
	SoLuong int,
	DonGia decimal(18,2),
	primary key (LoaiKH, SoTT, MaSach),
	foreign key (LoaiKH, SoTT) references KHACHHANG(MaLoai, STT),
	foreign key (MaSach) references SACH(MaSach)
)

insert into KHACHHANG values ('L1', 1, N'Nguyễn Thị Minh', N'123 Vườn Lài, Tân Phú');
insert into KHACHHANG values ('L1', 2, N'Trần Trung Nghĩa', N'45 Phú Thọ Hòa, Tân Phú');
insert into KHACHHANG values ('L2', 1, N'Vũ Ánh Nguyệt', N'11 Võ Văn Ngân, Thủ Đức');
GO

insert into SACH values ('S001', N'Đồi thỏ', 1000, 97000, 'L1', 1);
insert into SACH values ('S002', N'Bài giảng cuối cùng', 24, 102000, 'L2', 1 );
go

insert into MUAHANG values ('L1', 1, 'S001', '02/12/2009', 30, 90000);
insert into MUAHANG values ('L1', 2, 'S001', '12/30/2019', 20, 87000);
insert into MUAHANG values ('L2', 1, 'S002', '06/06/2016', 10, 100000);
insert into MUAHANG values ('L1', 2, 'S002', '03/07/2018', 5, 120000);
go

select HoTen as KhachHang
from KHACHHANG;

select sum(DonGia*SoLuong) as N'Tổng giá trị đơn hàng'
from MUAHANG;

select KH.MaLoai, KH.STT, KH.HoTen, KH.DiaChi, MH.MaSach, MH.SoLuong, MH.NgayMua
from KHACHHANG KH join MUAHANG MH on (KH.MaLoai = MH.LoaiKH and KH.STT = MH.SoTT)
where (KH.HoTen like N'Nguyễn%' and MH.SoLuong > 10)


-- ĐỀ 33
use master
CREATE DATABASE GacThi;
GO
USE GacThi;
GO

create table GIAOVIEN (
	MaGV char(10) primary key,
	TenGV nchar(100),
	DiaChi nchar(100),
	VaiTro nchar(50)
)

create table PHONGTHI (
	IDPhong char(10),
	IDDiemThi char(10),
	primary key( IDPhong, IDDiemThi),
	CanBo char(10),
	SoBan int,
	ThietBi nchar(50),
	foreign key (CanBo) references GIAOVIEN(MaGV)
)

create table THISINH (
	SBD char(10) primary key,
	DiemThi char(10),
	HoTen nchar(100),
	DiaChi nchar(100),
	NgaySinh date,
	PhongThi char(10)
)
ALTER TABLE THISINH 
ADD FOREIGN KEY (PhongThi, DiemThi) REFERENCES PHONGTHI(IDPhong, IDDiemThi)


insert into GIAOVIEN values ('GV001', N'Trần Thị Bé', N'31 Nguyễn Xí Q.Bình Thạnh', N'Cán bộ');
insert into GIAOVIEN values ('GV002', N'Nguyễn Minh Tâm', N'2 Trần Hưng Đạo Q5', N'Giám sát');
insert into GIAOVIEN values ('GV003', N'Trần Văn Lí', N'30 Hà Tồn Quyền Q5', N'Cán bộ');

insert into PHONGTHI values ('P001', 'DD1', 'GV001', 25, N'Mic – Loa – Tivi');
insert into PHONGTHI values ('P002', 'DD1', 'GV002', 30, N'Mic – Loa – Tivi');
insert into PHONGTHI values ('P001', 'DD2', 'GV003', 15, NULL);

insert into THISINH values ('0231', 'DD1', N'Nguyễn Quan Tùng',  N'TPHCM', '11/30/2000', 'P001');
insert into THISINH values ('0230', 'DD2', N'Lưu Phi Nam', N'Hải Phòng', '02/12/2000', 'P001');
insert into THISINH values ('0234', 'DD1', N'Lê Quang Bảo', N'Hà Nội', '02/13/2000', 'P002');
insert into THISINH values ('0233', 'DD2', N'Hà Ngọc Thúy', N'TPHCM', '04/24/2000', 'P001');

select PT.IDPhong, PT.IDDiemThi, GV.TenGV, count(*) as N'Số lượng thí sinh'
from PHONGTHI PT
	join THISINH TS on PT.IDPhong = TS.PhongThi and PT.IDDiemThi = TS.DiemThi
	join GIAOVIEN GV on PT.CanBo = GV.MaGV
group by PT.IDDiemThi, PT.IDPhong, GV.TenGV;

select PHONGTHI.IDPHONG, PHONGTHI.IDDIEMTHI, TENGV 
from PHONGTHI 
	join THISINH on PHONGTHI.IDPHONG = THISINH.PHONGTHI and PHONGTHI.IDDIEMTHI = THISINH.DIEMTHI 
	join GIAOVIEN on CANBO = MAGV 
where THISINH.DIACHI = N'Hải Phòng' and PHONGTHI.SOBAN >= 15
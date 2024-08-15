use QLGiaoVienThamGiaDeTai;
go

--Q35
select distinct GV.LUONG as MaxLuong from GIAOVIEN GV
where GV.LUONG >= ALL (select LUONG from GIAOVIEN);
select MAX(LUONG) as MaxLuong2 from GIAOVIEN;
go

--Q36
select * from GIAOVIEN GV
where GV.LUONG >= ALL (select LUONG from GIAOVIEN);
go

--Q37
select * from GIAOVIEN GV
where GV.MABM = 'HTTT' AND GV.LUONG >= ALL (select LUONG from GIAOVIEN GV2 where GV2.MABM = 'HTTT');
go

--Q38
select * from GIAOVIEN GV
where GV.MABM = 'HTTT' AND GV.NGAYSINH <= ALL (select NGAYSINH from GIAOVIEN GV2 where GV2.MABM = 'HTTT');
go

--Q39
select MAGV, HOTEN, LUONG, PHAI, NGAYSINH, GV.MABM, MAKHOA from GIAOVIEN GV JOIN BOMON BM on GV.MABM = BM.MABM
where BM.MAKHOA = 'CNTT' AND 
	GV.NGAYSINH = (select max(NGAYSINH) from GIAOVIEN GV2 JOIN BOMON BM on GV2.MABM = BM.MABM
		where BM.MAKHOA = 'CNTT');
go

--Q40
select GV.HOTEN, K.TENKHOA
from BOMON BM join GIAOVIEN GV on GV.MABM = BM.MABM
	join KHOA K on BM.MAKHOA = K.MAKHOA
where GV.LUONG >= ALL (select LUONG from GIAOVIEN);
go

--Q41
select * from GIAOVIEN GV
where GV.LUONG >= ALL (select LUONG from GIAOVIEN GV2 where GV2.MABM = GV.MABM)
order by GV.MABM desc;
go

--Q42
select DT.MADT, DT.TENDT from DETAI DT
where DT.MADT not in
	(select distinct TG.MADT from THAMGIADT TG join GIAOVIEN GV on GV.MAGV = TG.MAGV 
 	where GV.HOTEN = N'Nguyễn Hoài An');
go

--Q43
select DT.MADT, DT.TENDT, GV.HOTEN as GVCNDT
from DETAI DT join GIAOVIEN GV on DT.GVCNDT = GV.MAGV
where DT.MADT not in
	(select distinct TG.MADT from THAMGIADT TG join GIAOVIEN GV on GV.MAGV = TG.MAGV 
		where GV.HOTEN = N'Nguyễn Hoài An');
go

--Q44
select GV.MAGV, GV.HOTEN
from  GIAOVIEN GV join BOMON BM on GV.MABM = BM.MABM
where BM.MAKHOA = 'CNTT' AND GV.MAGV not in
	(select distinct TG.MAGV from THAMGIADT TG);
go

--Q45
select GV.MAGV, GV.HOTEN from  GIAOVIEN GV
where GV.MAGV not in (select distinct TG.MAGV from THAMGIADT TG);
go

--Q46
select HOTEN, LUONG from GIAOVIEN
where LUONG > (select LUONG from GIAOVIEN where HOTEN = N'Nguyễn Hoài An');
go

--Q47
select BM.TRUONGBM as MAGV, GV.HOTEN as TRUONGBM, BM.TENBM
from BOMON BM join GIAOVIEN GV on BM.TRUONGBM = GV.MAGV
where BM.TRUONGBM in (select MAGV from THAMGIADT);
go

--Q48
select HOTEN, PHAI, MABM from GIAOVIEN G1
where exists (select 1 from GIAOVIEN G2 where
				G1.MAGV <> G2.MAGV and
				G1.HOTEN = G2.HOTEN and
				G1.PHAI = G2.PHAI and
				G1.MABM = G2.MABM);
go

--Q49
select HOTEN, LUONG from GIAOVIEN
where LUONG > ANY(select LUONG from GIAOVIEN GV join BOMON BM on BM.MABM = GV.MABM 
					where BM.TENBM = N'Công nghệ phần mềm');
go

--Q50
select HOTEN, LUONG from GIAOVIEN
where LUONG > ALL(select LUONG from GIAOVIEN GV join BOMON BM on BM.MABM = GV.MABM 
					where BM.TENBM = N'Hệ thống thông tin');
go

--Q51
select K.TENKHOA, count(*) as SOLUONGGV from KHOA K
	join BOMON BM on BM.MAKHOA = K.MAKHOA
	join GIAOVIEN GV on GV.MABM = BM.MABM
group by K.TENKHOA having count(*) 
= (select top 1 count(*) as COUNTGV from GIAOVIEN GV 
	join BOMON BM on GV.MABM = BM.MABM
	join KHOA K on BM.MAKHOA = K.MAKHOA
	group by K.TENKHOA
	order by COUNTGV DESC);

--Q52
select GV.HOTEN, count(*) as SOLUONGDT 
from GIAOVIEN GV join DETAI DT on GV.MAGV = DT.GVCNDT 
group by GV.HOTEN having count(*) 
= (select top 1 count(*) as COUNTDT from GIAOVIEN GV 
	join DETAI DT on GV.MAGV = DT.GVCNDT 
	group by GV.HOTEN
	order by COUNTDT DESC);

--Q53
select BM.TENBM, count(*) as SOLUONGGV from BOMON BM
	join GIAOVIEN GV on GV.MABM = BM.MABM
group by BM.TENBM having count(*) 
= (select top 1 count(*) as COUNTGV from GIAOVIEN GV 
	join BOMON BM on GV.MABM = BM.MABM
	group by BM.TENBM
	order by COUNTGV DESC);

--Q54
select GV.HOTEN, BM.TENBM, count(distinct TG.MADT) as SOLUONGDT from THAMGIADT TG
	join GIAOVIEN GV on GV.MAGV = TG.MAGV
	join BOMON BM on GV.MABM = BM.MABM
group by GV.HOTEN, BM.TENBM having count(distinct TG.MADT) 
= (select top 1 count(distinct TG.MADT) as COUNTDT from THAMGIADT TG
	join GIAOVIEN GV on GV.MAGV = TG.MAGV
	group by GV.HOTEN
	order by COUNTDT DESC);
go

--Q55
select GV.HOTEN, count(distinct TG.MADT) as SOLUONGDT from THAMGIADT TG
	join GIAOVIEN GV on GV.MAGV = TG.MAGV
where GV.MABM = 'HTTT'
group by GV.HOTEN having count(distinct TG.MADT) 
= (select top 1 count(distinct TG.MADT) as COUNTDT from THAMGIADT TG
	join GIAOVIEN GV on GV.MAGV = TG.MAGV
	group by GV.HOTEN
	order by COUNTDT DESC);
go

--Q56
select GV.HOTEN, BM.TENBM, count(*) as SOLUONGNT from NGUOITHAN NT
	join GIAOVIEN GV on GV.MAGV = NT.MAGV
	join BOMON BM on GV.MABM = BM.MABM
group by GV.HOTEN, BM.TENBM having count(*) 
= (select top 1 count(*) as COUNTNT from NGUOITHAN NT
	join GIAOVIEN GV on GV.MAGV = NT.MAGV
	group by GV.HOTEN
	order by COUNTNT DESC);
go

--Q57
select GV.HOTEN, count(*) as SOLUONGDT 
from GIAOVIEN GV join DETAI DT on GV.MAGV = DT.GVCNDT 
				join BOMON BM on BM.TRUONGBM = GV.MAGV
group by GV.HOTEN having count(*) 
= (select top 1 count(*) as COUNTDT from GIAOVIEN GV 
	join DETAI DT on GV.MAGV = DT.GVCNDT 
	join BOMON BM on BM.TRUONGBM = GV.MAGV
	group by GV.HOTEN
	order by COUNTDT DESC);

